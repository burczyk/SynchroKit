//
//  SKObjectDescriptor.m
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-02-19.
//  Copyright (c) 2012 Kamil Burczyk. All rights reserved.
//

#import "SKObjectDescriptor.h"

@implementation SKObjectDescriptor

@synthesize name,
            identifier,
            lastUsedDate,
            lastUpdateDate,
            usedCount;

- (id) initWithName: (NSString*) _name identifier: (int) _identifier lastUpdateDate: (NSDate*) _lastUpdateDate {
    self = [super init];
    if (self) {
        [self setName:_name];
        [self setIdentifier:_identifier];
        [self setLastUpdateDate:_lastUpdateDate];
        [self setUsedCount:0];
    }
    return self;
}

@end
