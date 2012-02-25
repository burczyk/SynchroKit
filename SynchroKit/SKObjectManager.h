//
//  SKObjectManager.h
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-02-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@class SKDataDownloader;

enum SKSynchronizationStrategy {
    cyclic,
    oneTime
};

@interface SKObjectManager : NSObject {
    NSMutableDictionary *registeredObjects;
    RKObjectManager *rkObjectManager;
    enum SKSynchronizationStrategy synchronizationStrategy;
    int synchronizationInterval;
}

@property (nonatomic, retain) NSMutableDictionary *registeredObjects;
@property (nonatomic, assign) enum SKSynchronizationStrategy synchronizationStrategy;
@property (nonatomic, assign) int synchronizationInterval;

- (id) initWithRKObjectManager: (RKObjectManager*) manager synchronizationStrategy: (enum SKSynchronizationStrategy) strategy synchronizationInterval: (int) seconds;
- (void) addObject: (id) object forKey: (NSString*) key;
- (void) run;

@end
