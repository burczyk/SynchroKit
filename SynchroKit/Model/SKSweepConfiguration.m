//
//  SKSweepConfiguration.m
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-03-12.
//  Copyright (c) 2012 Kamil Burczyk. All rights reserved.
//

#import "SKSweepConfiguration.h"

@implementation SKSweepConfiguration

@synthesize sweepTimeInterval;
@synthesize sweepingStrategy;
@synthesize maxPersistentStoreSize;
@synthesize minLastUsedDate;

- (id) initWithTimeInterval: (int) seconds sweepingStrategy: (enum SKSweepingStrategy) strategy maxPersistentStoreSize: (long) size minLastUpdateDate: (NSDate*) date {
    self = [super init];
    if(self) {
        [self setSweepTimeInterval:seconds];
        [self setSweepingStrategy:strategy];
        [self setMaxPersistentStoreSize:size];
        [self setMinLastUsedDate:date];
    }
    return self;
}

@end
