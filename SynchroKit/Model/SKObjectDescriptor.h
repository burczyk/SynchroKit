//
//  SKObjectDescriptor.h
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-02-19.
//  Copyright (c) 2012 Kamil Burczyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SKObjectDescriptor : NSObject{
    NSString *name;
    NSManagedObjectID *identifier;
    NSDate *lastUsedDate;
    NSDate *lastUpdateDate;
    int usedCount;
}

@property(nonatomic, retain) NSString* name;
@property(nonatomic, retain) NSManagedObjectID *identifier;
@property(nonatomic, retain) NSDate* lastUsedDate;
@property(nonatomic, retain) NSDate* lastUpdateDate;
@property(nonatomic, assign) int usedCount;

- (id) initWithName: (NSString*) _name identifier: (NSManagedObjectID*) identifier lastUpdateDate: (NSDate*) _lastUpdateDate;

@end
