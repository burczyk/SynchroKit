//
//  SKObjectDescriptorsSearcher.h
//  SynchroKit
//
//  Created by Kamil Burczyk on 17.03.2012.
//  Copyright (c) 2012 Kamil Burczyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKObjectDescriptorsSearcher : NSObject

+ (NSArray*) objectDescriptorsSortedByDate: (NSMutableSet*) objectDescriptors;
+ (NSArray*) objectDescriptorsSortedByUsedCount: (NSMutableSet*) objectDescriptors;

@end
