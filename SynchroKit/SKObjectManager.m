//
//  SKObjectManager.m
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-02-25.
//  Copyright (c) 2012 Kamil Burczyk. All rights reserved.
//

#import "SKObjectManager.h"

@implementation SKObjectManager

@synthesize registeredObjects;
@synthesize objectDescriptors;
@synthesize synchronizationStrategy;
@synthesize synchronizationInterval;

@synthesize dataDownloader;
@synthesize dataLoader;

@synthesize sweeper;
@synthesize uploader;

#pragma mark constructor

- (id) initWithNSManagedObjectContext: (NSManagedObjectContext*) context RKObjectManager: (RKObjectManager*) manager synchronizationStrategy: (enum SKSynchronizationStrategy) strategy synchronizationInterval: (int) seconds {
    self = [super init];
    if (self) {
        registeredObjects = [[NSMutableDictionary alloc] init];
        objectDescriptors = [[NSMutableSet alloc] init];        
        managedObjectContext = context;
        rkObjectManager = manager;
        synchronizationStrategy = strategy;
        synchronizationInterval = seconds;
    }
    return self;
}

#pragma mark Framework Methods

- (void) addObject: (SKObjectConfiguration*) object {
    [registeredObjects setValue:object forKey:object.name];
}

- (void) run {
    if (synchronizationStrategy == SynchronizationStrategyDeamon) {
        dataDownloader = [[SKDataDownloader alloc] initAsDaemonWithRegisteredObjects:registeredObjects objectDescriptors:objectDescriptors timeInterval: synchronizationInterval];        
    } else if (synchronizationStrategy == SynchronizationStrategyRequest) {
        dataDownloader = [[SKDataDownloader alloc] initWithRegisteredObjects:registeredObjects objectDescriptors:objectDescriptors];
    }
    [dataDownloader setContext:managedObjectContext];
    
    dataLoader = [[SKDataLoader alloc] initWithManagedObjectContext:managedObjectContext objectDescriptors:objectDescriptors];
    uploader = [[SKUploader alloc] initWithRegisteredObjects:registeredObjects objectDescriptors:objectDescriptors managedObjectContext:managedObjectContext];
}

- (void) runSweeperWithConfiguration: (SKSweepConfiguration*) configuration persistentStoreCoordinator: (NSPersistentStoreCoordinator*) coordinator {
    sweeper = [[SKSweeper alloc] initWithNSPersistentStoreCoordinator:coordinator persistentStoreName:[[rkObjectManager objectStore] storeFilename] sweepConfiguration:configuration objectDescriptors:objectDescriptors];
    [sweeper startSweepingDaemon];
}

- (void) stopSweeper {
    NSAssert(sweeper != NULL, @"Sweeper cannot be NULL");
    [sweeper stopSweepingDaemon];    
}

#pragma mark Fetching Objects

- (NSMutableArray*) getEntitiesForName: (NSString*) name withPredicate:(NSPredicate *)predicate andSortDescriptor:(NSSortDescriptor *)descriptor {
    if (synchronizationStrategy == SynchronizationStrategyRequest) {
        [dataDownloader matchBestConfigurationAndDownload];
    }
    
    NSLog(@"Returning Entities");
    NSManagedObjectContext *newContext = [[NSManagedObjectContext alloc] init];
    [newContext setPersistentStoreCoordinator:managedObjectContext.persistentStoreCoordinator];
    managedObjectContext = newContext;
    NSLog(@"new context: %@", managedObjectContext);
    [dataLoader setManagedObjectContext:managedObjectContext];
    
    return [dataLoader getEntitiesForName:name withPredicate:predicate andSortDescriptor:descriptor];
}

- (void) saveObject: (NSManagedObject*) object forName:(NSString *)name {
    [uploader saveObject:object forName:name];
}

#pragma mark dealloc

- (void) dealloc {
    [registeredObjects release];
    [objectDescriptors release];
    [dataDownloader release];
    [dataLoader release];
    [super dealloc];
}

@end
    