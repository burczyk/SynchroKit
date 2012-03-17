//
//  SKSweeper.m
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-03-12.
//  Copyright (c) 2012 Kamil Burczyk. All rights reserved.
//

#import "SKSweeper.h"

@implementation SKSweeper

@synthesize persistentStoreName;
@synthesize managedObjectContext;
@synthesize persistentStoreCoordinator;
@synthesize sweepConfiguration;
@synthesize objectDescriptors;

- (id) initWithNSPersistentStoreCoordinator: (NSPersistentStoreCoordinator*) coordinator persistentStoreName: (NSString*) name sweepConfiguration: (SKSweepConfiguration*) configuration objectDescriptors: (NSMutableSet*) descriptors {
    self = [super init];
    if (self) {
        persistentStoreName = name;
        persistentStoreCoordinator = coordinator;
        sweepConfiguration = configuration;
        objectDescriptors = descriptors;
        interrupted = FALSE;
        
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    }
    return self;
}

- (void) sweepOnce {
    NSAssert(objectDescriptors != NULL, @"ObjectDescriptors in Sweeper cannot be NULL");
    NSMutableArray *objectDescriptorsToRemove = [[NSMutableArray alloc] init];
    NSArray *sortedObjectDescriptors;
    switch ([sweepConfiguration sweepingStrategy]) {
        case SweepingStrategyDate: //remove all objects older than date
            sortedObjectDescriptors = [SKObjectDescriptorsSearcher objectDescriptorsSortedByDate:objectDescriptors];
            for (SKObjectDescriptor *objectDescriptor in sortedObjectDescriptors) {
                NSLog(@"lastUsedDate, minLastUsedDate: %@ %@", [objectDescriptor lastUsedDate], [sweepConfiguration minLastUsedDate]);
                if ([[objectDescriptor lastUsedDate] compare:[sweepConfiguration minLastUsedDate]] < 0) {
                    [objectDescriptorsToRemove addObject:objectDescriptor];
                } else { //array is sorted so we can jump out of for
                    break;
                }
            }
            break;
            
        case SweepingStrategySizeAndDate: //remove objects by date to maintain size
            sortedObjectDescriptors = [SKObjectDescriptorsSearcher objectDescriptorsSortedByDate:objectDescriptors];            
            break;
            
        case SweepingStrategySizeAndUsedCount: //remove objects by usedCount to maintain size
            sortedObjectDescriptors = [SKObjectDescriptorsSearcher objectDescriptorsSortedByUsedCount:objectDescriptors];            
            break;
    }
    
    NSError *error;
    NSLog(@"object descriptors to remove: %@", objectDescriptorsToRemove);
    for (SKObjectDescriptor *objectDescriptor in objectDescriptorsToRemove) {
        if (objectDescriptor == NULL) {
            NSLog(@"OBJECT DESCRIPTOR IS NULL");
        }
        NSManagedObject *object = [self getEntityForId:[objectDescriptor identifier]];
        if (object != NULL) {
            NSLog(@"Search: %@", object);
//            [self removeObject:object];
            [managedObjectContext deleteObject:object];
            [objectDescriptor setLastUpdateDate:NULL];
        } else {
            NSLog(@"Object to remove is NULL");
        }
    }
    [managedObjectContext save:&error];
    if (error) {
        NSLog(@"ERROR: ");
    }
    
    SKDataLoader *loader = [[SKDataLoader alloc] initWithManagedObjectContext:managedObjectContext];
    NSLog(@"Users count after delete: %ld", [loader getEntitiesCountForName:@"User" withPredicate:NULL andSortDescriptor:NULL]);
    
}

- (void) sweepCyclic {
    while (!interrupted) {
        [self sweepOnce];
        sleep([sweepConfiguration sweepTimeInterval]);
    }
}

- (void) startSweepingDaemon {
    interrupted = FALSE;
    sweepingThread = [[NSThread alloc] initWithTarget:self selector:@selector(sweepCyclic) object:nil];
    [sweepingThread start];    
}

- (void) stopSweepingDaemon {
    interrupted = TRUE;
}

#pragma mark PersistentStore methods

- (long long) getPersistentStoreSize {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *persistentStorePath = [documentsDirectory stringByAppendingPathComponent:persistentStoreName];
    
    NSError *error = nil;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:persistentStorePath error:&error];
    return (long long) [fileAttributes objectForKey:NSFileSize];
}

- (void) removeObject: (NSManagedObject*) object {
    NSError *error;    
    [[self managedObjectContext] deleteObject:object];
    [[self managedObjectContext] save:&error];
    if (error) {
        NSLog(@"SKSweeper error while deleting: %@", error);
    }
}

- (NSManagedObject*) getEntityForId: (NSManagedObjectID*) identifier {
    NSError *error;
    NSManagedObject *result = [managedObjectContext existingObjectWithID:identifier error:&error];
    if (error) {
        NSLog(@"Error while getingEntityForId: %@ %@", identifier, error);
    }
    return result;
}

@end
