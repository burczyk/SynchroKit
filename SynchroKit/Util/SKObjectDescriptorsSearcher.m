//
//  SKObjectDescriptorsSearcher.m
//  SynchroKit
//
//  Created by Kamil Burczyk on 17.03.2012.
//  Copyright (c) 2012 Kamil Burczyk. All rights reserved.
//

#import "SKObjectDescriptorsSearcher.h"

@implementation SKObjectDescriptorsSearcher

+ (NSArray*) objectDescriptorsSortedByDate: (NSMutableSet*) objectDescriptors {
    NSArray *result;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastUsedDate" ascending:NO];
    result = [objectDescriptors sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [sortDescriptor release];
    return result;
}

+ (NSArray*) objectDescriptorsSortedByUsedCount: (NSMutableSet*) objectDescriptors {
    NSArray *result;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"usedCount" ascending:NO];
    result = [objectDescriptors sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [sortDescriptor release];
    return result;    
}

+ (SKObjectDescriptor*) findDescriptorByName: (NSString*) name inObjectDescriptors: (NSMutableSet*) objectDescriptors {
    for (SKObjectDescriptor *objectDescriptor in objectDescriptors) {
        if ([objectDescriptor.name isEqualToString:name]) {
            return objectDescriptor;
        }
    }
    return NULL;    
}

+ (SKObjectDescriptor*) findDescriptorByObjectID: (NSManagedObjectID*) objectID inObjectDescriptors: (NSMutableSet*) objectDescriptors {
    for (SKObjectDescriptor *objectDescriptor in objectDescriptors) {
        if ([objectDescriptor.identifier isEqual:objectID]) {
            return objectDescriptor;
        }
    }
    return NULL;
}

@end
