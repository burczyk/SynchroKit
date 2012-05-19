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
    NSArray *sortedObjectDescriptors;
    switch ([sweepConfiguration sweepingStrategy]) {
        case SweepingStrategyDate: //remove all objects older than date
            sortedObjectDescriptors = [SKObjectDescriptorsSearcher objectDescriptorsSortedByDate:objectDescriptors];
            for (SKObjectDescriptor *objectDescriptor in sortedObjectDescriptors) {
                NSLog(@"lastUsedDate, minLastUsedDate: %@ %@", [objectDescriptor lastUsedDate], [sweepConfiguration minLastUsedDate]);
                if ([[objectDescriptor lastUsedDate] compare:[sweepConfiguration minLastUsedDate]] < 0) {
                    [self removeObject:objectDescriptor];
                } else { //array is sorted so we can jump out of for
                    break;
                }
            }
            break;
            
        case SweepingStrategySizeAndDate: //remove objects by date to maintain size
            sortedObjectDescriptors = [SKObjectDescriptorsSearcher objectDescriptorsSortedByDate:objectDescriptors];
            int counter = 0;
            while ([self getPersistentStoreSize] > sweepConfiguration.maxPersistentStoreSize) {
                if (counter < [objectDescriptors count]) {
                    [self removeObject:[sortedObjectDescriptors objectAtIndex:counter]];
                    ++counter;
                }
            }
            break;
            
        case SweepingStrategySizeAndUsedCount: //remove objects by usedCount to maintain size
            sortedObjectDescriptors = [SKObjectDescriptorsSearcher objectDescriptorsSortedByUsedCount:objectDescriptors];            
            int counter2 = 0;
            while ([self getPersistentStoreSize] > sweepConfiguration.maxPersistentStoreSize) {
                if (counter2 < [objectDescriptors count]) {
                    [self removeObject:[sortedObjectDescriptors objectAtIndex:counter]];
                    ++counter2;
                }
            }            
            break;
    }

    SKDataLoader *loader = [[SKDataLoader alloc] initWithManagedObjectContext:managedObjectContext objectDescriptors:objectDescriptors];
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
    
    if (sweepingThread == NULL) {
        sweepingThread = [[NSThread alloc] initWithTarget:self selector:@selector(sweepCyclic) object:nil];
    }
    
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

- (void) removeObject: (SKObjectDescriptor*) objectDescriptor {
    if (objectDescriptor != NULL) {
        NSManagedObject *object = [self getEntityForId:[objectDescriptor identifier]];
        if (object != NULL) {
            NSError *error;    
            [[self managedObjectContext] deleteObject:object];
            [[self managedObjectContext] save:&error];
            if (error) {
                NSLog(@"SKSweeper error while deleting");
            }
            [objectDescriptor setLastUpdateDate:NULL];    
        }
    }
}

+ (void) removeObject: (SKObjectDescriptor*) objectDescriptor managedObjectContext: (NSManagedObjectContext*) context{
    if (objectDescriptor != NULL) {
        NSError *error;        
        NSManagedObject *object = [context existingObjectWithID:[objectDescriptor identifier] error:&error];
        if (error) {
            NSLog(@"Error while static getingEntityForId: %@", [objectDescriptor identifier]);
        }        
        if (object != NULL) {  
            [context deleteObject:object];
            [context save:&error];
            if (error) {
                NSLog(@"SKSweeper error while static deleting");
            }
            [objectDescriptor setLastUpdateDate:NULL];    
        }
    }
}

+ (void) removeStoredObjectsNotIn: (NSArray*) objects forName: (NSString*) name managedObjectContext: (NSManagedObjectContext*) context objectDescriptors: (NSMutableSet*) descriptors {
    NSMutableSet *loadedObjectURIs = [[NSMutableSet alloc] init];
    for (NSManagedObject *object in objects) {
        [loadedObjectURIs addObject:[[object objectID] URIRepresentation]];
    }
    
    SKDataLoader *loader = [[SKDataLoader alloc] initWithManagedObjectContext:context objectDescriptors:descriptors];
    NSArray *storedObjects = [loader getEntitiesForName:name withPredicate:NULL andSortDescriptor:NULL];
    
    NSLog(@"deleting local data not in: %d objects", [objects count]);        
    for (NSManagedObject *object in storedObjects) {
        if (![loadedObjectURIs containsObject:[[object objectID] URIRepresentation]]) {
            SKObjectDescriptor *descriptor = [SKObjectDescriptorsSearcher findDescriptorByObjectID:[object objectID] inObjectDescriptors:descriptors];
            NSLog(@"descriptor: %@", descriptor);
            if (descriptor == NULL || [descriptor isSaved]) {
                NSLog(@"removing object: %@", object);
                [SKSweeper removeManagedObject:object managedObjectContext:context];
            }
        }
    }
    
    [loadedObjectURIs release];
}

+ (void) removeManagedObject: (NSManagedObject*) object managedObjectContext: (NSManagedObjectContext*) context{
    if (object != NULL) {
        NSError *error;    
        [context deleteObject:object];
        [context save:&error];
        if (error) {
            NSLog(@"SKSweeper error while deleting");
        }    
    }
}

- (NSManagedObject*) getEntityForId: (NSManagedObjectID*) identifier {
    NSError *error;
    NSManagedObject *result = [managedObjectContext existingObjectWithID:identifier error:&error];
    if (error) {
        NSLog(@"Error while getingEntityForId: %@", identifier);
    }
    return result;
}



@end
