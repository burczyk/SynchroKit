//
//  SKObjectManagerTests.m
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-02-25.
//  Copyright (c) 2012 Kamil Burczyk. All rights reserved.
//

#import "SKObjectManagerTests.h"

@implementation SKObjectManagerTests

- (void) testAddObject{
    SKObjectManager *objectManager = [[SKObjectManager alloc] init];
    [objectManager addObject:@"Test1"];
    [objectManager addObject:@"Test2"];    
    
    STAssertTrue([[objectManager registeredObjects] count] == 2, @"Objects not correctly added");
    
    [objectManager release];
}

@end
