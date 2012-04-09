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

#pragma mark constructor

- (id) initWithNSManagedObjectContext: (NSManagedObjectContext*) context RKObjectManager: (RKObjectManager*) manager synchronizationStrategy: (enum SKSynchronizationStrategy) strategy synchronizationInterval: (int) seconds{
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
    if (synchronizationStrategy == SynchronizationStrategyCyclic) {
        dataDownloader = [[SKDataDownloader alloc] initAsDaemonWithRegisteredObjects:registeredObjects objectDescriptors:objectDescriptors timeInterval: synchronizationInterval];        
    } else if (synchronizationStrategy == SynchronizationStrategyPerRequest) {
        dataDownloader = [[SKDataDownloader alloc] initWithRegisteredObjects:registeredObjects objectDescriptors:objectDescriptors];
    }
    [dataDownloader setContext:managedObjectContext];
    
    dataLoader = [[SKDataLoader alloc] initWithManagedObjectContext:managedObjectContext];    
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

- (NSMutableArray*) getEntitiesForName: (NSString*) name withPredicate: (NSPredicate*) predicate andSortDescriptor: (NSSortDescriptor*) descriptor {
    if (synchronizationStrategy == SynchronizationStrategyPerRequest) {
        [dataDownloader loadObjectsUpdatedSinceLastDownloadByName:name asynchronous:FALSE delegate:NULL];
    }
    
    NSLog(@"Returning Entities");
    
    return [dataLoader getEntitiesForName:name withPredicate:predicate andSortDescriptor:descriptor];
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
    