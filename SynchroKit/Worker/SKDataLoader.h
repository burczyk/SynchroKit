//
//  SKDataLoader.h
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-02-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKDataLoader : NSObject {
    
}

+ (NSArray*) getEntitiesForName: (NSString*) name withPredicate: (NSPredicate*) predicate;

+ (long) getEntitiesCountForName: (NSString*) name withPredicate: (NSPredicate*) predicate;

@end
