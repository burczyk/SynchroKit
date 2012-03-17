//
//  SKSweepConfiguration.h
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-03-12.
//  Copyright (c) 2012 Kamil Burczyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Enum/SKSweepingStrategy.h"

@interface SKSweepConfiguration : NSObject {
    int sweepTimeInterval;
    enum SKSweepingStrategy sweepingStrategy;
    long maxPersistentStoreSize;
    NSDate *minLastUsedDate;
}

@property (nonatomic) int sweepTimeInterval;
@property (nonatomic) enum SKSweepingStrategy sweepingStrategy;
@property (nonatomic) long maxPersistentStoreSize;
@property (nonatomic, retain) NSDate *minLastUsedDate;

- (id) initWithTimeInterval: (int) seconds sweepingStrategy: (enum SKSweepingStrategy) strategy maxPersistentStoreSize: (long) size minLastUpdateDate: (NSDate*) date;

@end
