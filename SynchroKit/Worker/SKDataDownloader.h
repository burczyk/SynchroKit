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

@interface SKDataDownloader : NSObject<RKObjectLoaderDelegate> {
    NSThread *thread;
    BOOL interrupted;
    NSMutableSet *registeredObjects;
    int seconds;
}

@property (nonatomic, retain) NSMutableSet *registeredObjects;
@property (nonatomic, assign) int seconds;

- (id) init;
- (id) initAsDaemonWithRegisteredObjects: (NSMutableSet*) registeredObjects timeInterval: (int) seconds;

- (void) threadMainMethod;
- (void) interrupt;

- (void) loadObjects;

@end
