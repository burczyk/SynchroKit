//
//  SKDataLoader.m
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-02-25.
//  Copyright (c) 2012 Kamil Burczyk. All rights reserved.
//

#import "SKDataLoader.h"

@implementation SKDataLoader

@synthesize managedObjectContext;

- (id) initWithManagedObjectContext: (NSManagedObjectContext*) _managedObjectContext {
    self = [super init];
    if (self) {
        [self setManagedObjectContext:_managedObjectContext];
    }
    return self;
}

- (NSMutableArray*) getEntitiesForName: (NSString*) name withPredicate: (NSPredicate*) predicate andSortDescriptor: (NSSortDescriptor*) descriptor {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:name inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    if (predicate != NULL) {
        [request setPredicate:predicate];
    }
    
    if (descriptor != NULL) {
        [request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    }
    
    NSError *error = nil;
    NSMutableArray *entities = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if (error) {
        NSLog(@"ERROR while fetching objects: %@", name);
    } else {
        NSLog(@"Fetched %@: %d", name, [entities count]);
    }
    
    [request release];
    
    return entities;
}

- (long) getEntitiesCountForName: (NSString*) name withPredicate: (NSPredicate*) predicate andSortDescriptor: (NSSortDescriptor*) descriptor {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:name inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    if (predicate != NULL) {
        [request setPredicate:predicate];
    }
    
    if (descriptor != NULL) {
        [request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    }
    
    NSError *error = nil;
    NSMutableArray *entities = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if (error) {
        NSLog(@"ERROR while fetching objects: %@", name);
    } else {
        NSLog(@"Fetched COUNT for %@: %d", name, [entities count]);
    }
    
    [request release];
    
    return [entities count];    
}

@end
