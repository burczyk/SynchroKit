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
#import "Worker/SKDataDownloader.h"
#import "Worker/SKDataLoader.h"
#import "Model/SKSynchronizationStrategy.h"

@interface SKObjectManager : NSObject {
    NSMutableDictionary *registeredObjects;
    NSMutableSet *objectDescriptors;
    
    NSManagedObjectContext *managedObjectContext;
    RKObjectManager *rkObjectManager;
    enum SKSynchronizationStrategy synchronizationStrategy;
    int synchronizationInterval;
    
    SKDataDownloader *dataDownloader;
    SKDataLoader *dataLoader;
}

@property (nonatomic, retain) NSMutableDictionary *registeredObjects;
@property (nonatomic, retain) NSMutableSet *objectDescriptors;
@property (nonatomic, assign) enum SKSynchronizationStrategy synchronizationStrategy;
@property (nonatomic, assign) int synchronizationInterval;

@property (nonatomic, retain) SKDataDownloader *dataDownloader;
@property (nonatomic, retain) SKDataLoader *dataLoader;

- (id) initWithNSManagedObjectContext: (NSManagedObjectContext*) context RKObjectManager: (RKObjectManager*) manager synchronizationStrategy: (enum SKSynchronizationStrategy) strategy synchronizationInterval: (int) seconds;
- (void) addObject: (SKObjectConfiguration*) object;
- (void) run;

- (NSMutableArray*) getEntitiesForName: (NSString*) name withPredicate: (NSPredicate*) predicate andSortDescriptor: (NSSortDescriptor*) descriptor;

@end
