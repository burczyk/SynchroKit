//
//  SKDataDownloader.m
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-02-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKDataDownloader.h"

@implementation SKDataDownloader

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id) initAsDaemon {
    self = [super init];
    if (self) {
        thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadMainMethod) object:nil];
        [thread start];
    }
    NSLog(@"KONIEC KONSTRUKTORA");
    return self;
}

- (void) threadMainMethod {
    NSLog(@"Thread wystartowal");
    
    for (int i=0; i<100; ++i) {
        NSLog(@"THREAD działa %d", i);
    }
}

@end
