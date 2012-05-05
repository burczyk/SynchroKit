//
//  SKObjectManager.h
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-02-25.
//  Copyright (c) 2012 Kamil Burczyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

#import "Model/SKObjectConfiguration.h"
#import "Model/SKSynchronizationStrategy.h"

#import "Worker/SKDataDownloader.h"
#import "Worker/SKDataLoader.h"
#import "Worker/SKSweeper.h"
#import "Worker/SKUploader.h"

@interface SKObjectManager : NSObject {
    NSMutableDictionary *registeredObjects;
    NSMutableSet *objectDescriptors;
    
    NSManagedObjectContext *managedObjectContext;
    RKObjectManager *rkObjectManager;
    enum SKSynchronizationStrategy synchronizationStrategy;
    int synchronizationInterval;
    
    SKDataDownloader *dataDownloader;
    SKDataLoader *dataLoader;
    
    SKSweeper *sweeper;
    SKUploader *uploader;
}

@property (nonatomic, retain) NSMutableDictionary *registeredObjects;
@property (nonatomic, retain) NSMutableSet *objectDescriptors;
@property (nonatomic, assign) enum SKSynchronizationStrategy synchronizationStrategy;
@property (nonatomic, assign) int synchronizationInterval;

@property (nonatomic, retain) SKDataDownloader *dataDownloader;
@property (nonatomic, retain) SKDataLoader *dataLoader;

@property (nonatomic, retain) SKSweeper *sweeper;
@property (nonatomic, retain) SKUploader *uploader;

- (id) initWithNSManagedObjectContext: (NSManagedObjectContext*) context RKObjectManager: (RKObjectManager*) manager synchronizationStrategy: (enum SKSynchronizationStrategy) strategy synchronizationInterval: (int) seconds;
- (void) addObject: (SKObjectConfiguration*) object;
- (void) run;
- (void) runSweeperWithConfiguration: (SKSweepConfiguration*) configuration persistentStoreCoordinator: (NSPersistentStoreCoordinator*) coordinator;
- (void) stopSweeper;

- (NSMutableArray*) getEntitiesForName: (NSString*) name withPredicate:(NSPredicate *)predicate andSortDescriptor:(NSSortDescriptor *)descriptor;
- (void) saveObject: (NSManagedObject*) object forName:(NSString *)name;

@end
