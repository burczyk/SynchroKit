//
//  SKDataLoader.h
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-02-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "../Model/SKSynchronizationStrategy.h"

@interface SKDataLoader : NSObject {
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (id) initWithManagedObjectContext: (NSManagedObjectContext*) managedObjectContext;

- (NSMutableArray*) getEntitiesForName: (NSString*) name withPredicate: (NSPredicate*) predicate andSortDescriptor: (NSSortDescriptor*) descriptor;

- (long) getEntitiesCountForName: (NSString*) name withPredicate: (NSPredicate*) predicate andSortDescriptor: (NSSortDescriptor*) descriptor;

@end
