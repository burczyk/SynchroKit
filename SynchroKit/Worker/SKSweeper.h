//
//  SKSweeper.h
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-03-12.
//  Copyright (c) 2012 Kamil Burczyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "../Model/SKSweepConfiguration.h"

@interface SKSweeper : NSObject {
    NSManagedObjectContext *managedObjectContext;
    NSString *persistentStoreName;
    SKSweepConfiguration *sweepConfiguration;
}

@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) NSString *persistentStoreName;
@property(nonatomic, retain) SKSweepConfiguration *sweepConfiguration;

- (id) initWithNSManagedObjectContext: (NSManagedObjectContext*) context persistentStoreName: (NSString*) name sweepConfiguration: (SKSweepConfiguration*) configuration;

- (long long) getPersistentStoreSize;
- (void) removeObject: (NSManagedObject*) object;

- (void) sweepOnce;
- (void) startSweepingDaemon;
- (void) stopSweepingDaemon;

@end
