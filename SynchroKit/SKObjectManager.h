//
//  SKObjectManager.h
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-02-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "Model/SKObjectConfiguration.h"
#import "Worker/SKDataDownloader.h"

enum SKSynchronizationStrategy {
    SKSynchronizationStrategyCyclic,
    SKSynchronizationStrategyOneTime
};

@interface SKObjectManager : NSObject {
    NSMutableDictionary *registeredObjects;
    NSMutableSet *objectDescriptors;
    RKObjectManager *rkObjectManager;
    enum SKSynchronizationStrategy synchronizationStrategy;
    int synchronizationInterval;
}

@property (nonatomic, retain) NSMutableDictionary *registeredObjects;
@property (nonatomic, retain) NSMutableSet *objectDescriptors;
@property (nonatomic, assign) enum SKSynchronizationStrategy synchronizationStrategy;
@property (nonatomic, assign) int synchronizationInterval;

- (id) initWithRKObjectManager: (RKObjectManager*) manager synchronizationStrategy: (enum SKSynchronizationStrategy) strategy synchronizationInterval: (int) seconds;
- (void) addObject: (SKObjectConfiguration*) object;
- (void) run;

@end
