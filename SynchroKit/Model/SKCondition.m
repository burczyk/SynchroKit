//
//  SKCondition.m
//  SynchroKit
//
//  Created by Kamil Burczyk on 31.03.2012.
//  Copyright (c) 2012 Kamil Burczyk. All rights reserved.
//

#import "SKCondition.h"

@implementation SKCondition

@synthesize key;
@synthesize condOperator;
@synthesize value;

- (id)initWithKey:(NSString*)aKey condOperator:(enum SKOperator)aCondOperator value:(NSObject*)aValue 
{
    self = [super init];
    if (self) {
        key = [aKey retain];
        condOperator = aCondOperator;
        value = [aValue retain];
    }
    return self;
}



@end
