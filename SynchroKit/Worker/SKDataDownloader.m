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

- (id) initAsDaemonWithRegisteredObjects: (NSMutableDictionary*) registeredObjects timeInterval: (int) seconds {
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
    
    for (NSString *path in registeredObjects.keyEnumerator) {
        [objectManager loadObjectsAtResourcePath:path delegate:self block:^(RKObjectLoader* loader) {
            loader.objectMapping = [objectManager.mappingProvider objectMappingForClass:[registeredObjects valueForKey:path]];
        }];        
    }
}

#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastUpdatedAt"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	NSLog(@"Loaded objects count: %d", [objects count]);
    NSLog(@"Loaded objects: %@", objects);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	NSLog(@"Hit error: %@", error);
}

#pragma mark Thread methods

- (void) threadMainMethod {
    NSLog(@"Thread started");
    
    while (!interrupted) {
        [self loadObjects];
        sleep(seconds);
    }
}

- (void) interrupt {
    NSLog(@"stopping Thread");
    interrupted = TRUE;
}

@end
