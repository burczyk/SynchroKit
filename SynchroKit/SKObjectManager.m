//
//  SKObjectManager.m
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-02-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKObjectManager.h"

@implementation SKObjectManager

@synthesize registeredObjects;
@synthesize synchronizationStrategy;
@synthesize synchronizationInterval;

#pragma mark constructors

- (id) init {
    self = [super init];
    if (self) {
        registeredObjects = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id) initWithRKObjectManager: (RKObjectManager*) manager synchronizationStrategy: (enum SKSynchronizationStrategy) strategy synchronizationInterval: (int) seconds{
    self = [super init];
    if (self) {
        registeredObjects = [[NSMutableDictionary alloc] init];
        rkObjectManager = manager;
        synchronizationStrategy = strategy;
        synchronizationInterval = seconds;
    }
    return self;
}

#pragma mark Framework Methods

- (void) addObject: (id) object forKey: (NSString*) key {
    [registeredObjects setObject:object forKey:key];
}

- (void) run {
    if (synchronizationStrategy == cyclic) {
        SKDataDownloader *dataDownloader = [[SKDataDownloader alloc] initAsDaemonWithRegisteredObjects:registeredObjects timeInterval: synchronizationInterval];        
    }
}

#pragma mark dealloc

- (void) dealloc {
    [registeredObjects release];
}

@end
    