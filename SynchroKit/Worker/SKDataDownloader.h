//
//  SKDataDownloader.h
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-02-19.
//  Copyright (c) 2012 Kamil Burczyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "../Model/SKObjectConfiguration.h"
#import "../Model/SKObjectDescriptor.h"
#import "../Protocol/UpdateDateProtocol.h"
#import "SKSweeper.h"

@interface SKDataDownloader : NSObject<RKObjectLoaderDelegate> {
    NSThread *thread;
    NSConditionLock *conditionLock;
    BOOL interrupted;
    NSMutableDictionary *registeredObjects;
    NSMutableSet *objectDescriptors;
    int seconds;
    BOOL isDaemon;
    
    NSMutableDictionary *updateDates;
    NSManagedObjectContext *context;
}

@property (nonatomic, retain) NSMutableDictionary *registeredObjects;
@property (nonatomic, retain) NSMutableSet *objectDescriptors;
@property (nonatomic, assign) int seconds;

@property (nonatomic, retain) NSMutableDictionary *updateDates;

@property (nonatomic, retain) NSManagedObjectContext *context;

- (id) initWithRegisteredObjects: (NSMutableDictionary*) _registeredObjects objectDescriptors: (NSMutableSet*) _objectDescriptors;
- (id) initAsDaemonWithRegisteredObjects: (NSMutableDictionary*) registeredObjects objectDescriptors: (NSMutableSet*) objectDescriptors timeInterval: (int) seconds;

- (void) mainUpdateMethod;
- (void) interrupt;

- (void) loadAllObjectsAsynchronous: (BOOL) async delegate: (id<RKObjectLoaderDelegate>) delegate;
- (void) loadObjectsByName: (NSString*) name asynchronous: (BOOL) async delegate: (id<RKObjectLoaderDelegate>) delegate;
- (void) loadAllObjectsIfUpdatedOnServerAsynchronous: (BOOL) async delegate: (id<RKObjectLoaderDelegate>) delegate;
- (void) loadObjectIfUpdatedOnServerByName: (NSString*) name asynchronous: (BOOL) async delegate: (id<RKObjectLoaderDelegate>) delegate;
- (void) loadObjectsUpdatedSinceLastDownloadByName: (NSString*) name asynchronous: (BOOL) async delegate: (id<RKObjectLoaderDelegate>) delegate;
- (void) loadObjectsWithPredicate: (NSPredicate*) predicate byName: (NSString*) name asynchronous: (BOOL) async delegate: (id<RKObjectLoaderDelegate>) delegate;

- (SKObjectDescriptor*) findDescriptorByName: (NSString*) name;
- (SKObjectDescriptor*) findDescriptorByObjectID: (NSManagedObjectID*) objectID;

@end
