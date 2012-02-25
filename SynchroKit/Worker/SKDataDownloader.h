//
//  SKDataDownloader.h
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-02-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface SKDataDownloader : NSObject<RKObjectLoaderDelegate> {
    NSThread *thread;
    BOOL interrupted;
    NSMutableDictionary *registeredObjects;
    int seconds;
}

@property (nonatomic, retain) NSMutableDictionary *registeredObjects;
@property (nonatomic, assign) int seconds;

- (id) init;
- (id) initAsDaemonWithRegisteredObjects: (NSMutableDictionary*) registeredObjects timeInterval: (int) seconds;

- (void) threadMainMethod;
- (void) interrupt;

- (void) loadObjects;

@end
