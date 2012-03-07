//
//  SKDataDownloader.h
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-02-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "../Model/SKObjectConfiguration.h"
#import "../Model/SKObjectDescriptor.h"
#import "../Protocol/UpdateDateProtocol.h"

@interface SKDataDownloader : NSObject<RKObjectLoaderDelegate> {
    NSThread *thread;
    BOOL interrupted;
    NSMutableDictionary *registeredObjects;
    NSMutableSet *objectDescriptors;
    int seconds;
    
    NSMutableDictionary *updateDates;
}

@property (nonatomic, retain) NSMutableDictionary *registeredObjects;
@property (nonatomic, retain) NSMutableSet *objectDescriptors;
@property (nonatomic, assign) int seconds;

@property (nonatomic, retain) NSMutableDictionary *updateDates;

- (id) init;
- (id) initAsDaemonWithRegisteredObjects: (NSMutableDictionary*) registeredObjects objectDescriptors: (NSMutableSet*) objectDescriptors timeInterval: (int) seconds;

- (void) mainUpdateMethod;
- (void) interrupt;

- (void) loadObjectsByName: (NSString*) name;
- (void) loadAllObjects;
- (void) loadObjectsWhenUpdatedByName: (NSString*) name;
- (void) loadAllObjectsWhenUpdated;

- (SKObjectDescriptor*) findDescriptorByName: (NSString*) name;
- (SKObjectDescriptor*) findDescriptorByName: (NSString*) name identifier: (int) identifier;

@end
