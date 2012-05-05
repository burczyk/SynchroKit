//
//  SKDataLoader.h
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-02-25.
//  Copyright (c) 2012 Kamil Burczyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "../Model/SKSynchronizationStrategy.h"
#import "../Model/SKObjectDescriptor.h"
#import "../Util/SKObjectDescriptorsSearcher.h"

@interface SKDataLoader : NSObject {
    NSManagedObjectContext *managedObjectContext;
    NSMutableSet *objectDescriptors;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableSet *objectDescriptors;

- (id) initWithManagedObjectContext: (NSManagedObjectContext*) managedObjectContext objectDescriptors: (NSMutableSet*) objectDescriptors;

- (NSMutableArray*) getEntitiesForName: (NSString*) name withPredicate: (NSPredicate*) predicate andSortDescriptor: (NSSortDescriptor*) descriptor;

- (long) getEntitiesCountForName: (NSString*) name withPredicate: (NSPredicate*) predicate andSortDescriptor: (NSSortDescriptor*) descriptor;

@end
