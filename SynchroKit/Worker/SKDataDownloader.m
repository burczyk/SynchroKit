//
//  SKDataDownloader.m
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-02-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKDataDownloader.h"

@implementation SKDataDownloader

@synthesize registeredObjects;
@synthesize seconds;

#pragma mark constructors

- (id) init {
    self = [super init];
    if (self) {
        interrupted = FALSE;
    }
    return self;
}

- (id) initAsDaemonWithRegisteredObjects: (NSMutableSet*) registeredObjects timeInterval: (int) seconds {
    self = [super init];
    if (self) {
        [self setRegisteredObjects:registeredObjects];
        [self setSeconds:seconds];
        thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadMainMethod) object:nil];
        [thread start];
    }
    return self;
}

#pragma mark main download loop

- (void) loadObjects {
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    
    for (SKObjectConfiguration *objectConfiguration in registeredObjects) {
        [objectManager loadObjectsAtResourcePath:[objectConfiguration downloadPath] delegate:self block:^(RKObjectLoader* loader) {
            loader.objectMapping = [objectManager.mappingProvider objectMappingForClass:[objectConfiguration objectClass]];
        }];        
    }
}

- (void) loadObjectsByUpdateDate {
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    
    for (SKObjectConfiguration *objectConfiguration in registeredObjects) {
        if (objectConfiguration.updateDatePath != Nil && [objectConfiguration.updateDatePath length] > 0) { //updateDate exists
            [objectManager loadObjectsAtResourcePath:[objectConfiguration updateDatePath] delegate:self block:^(RKObjectLoader* loader) {
                loader.objectMapping = [objectManager.mappingProvider objectMappingForClass:objectConfiguration.updateDateClass];
            }];                    
        }
    }    
}

#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastUpdatedAt"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	NSLog(@"Loaded objects count: %d", [objects count]);
    NSLog(@"Loaded objects: %@", objects);
    for (NSObject *downloadedObject in objects) {
        if ([downloadedObject conformsToProtocol:@protocol(UpdateDateProtocol)]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = [downloadedObject dateFormat];
            NSDate *objectUpdateDate = [formatter dateFromString:[downloadedObject updateDate]];
            NSLog(@"%@ last update date: %@", [downloadedObject objectClassName], [formatter stringFromDate:objectUpdateDate]);
            
            [formatter release];
        }
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	NSLog(@"Hit error: %@", error);
}

#pragma mark Thread methods

- (void) threadMainMethod {
    NSLog(@"Thread started");
    
    while (!interrupted) {
        [self loadObjectsByUpdateDate];
        sleep(seconds);
    }
}

- (void) interrupt {
    NSLog(@"stopping Thread");
    interrupted = TRUE;
}

@end
