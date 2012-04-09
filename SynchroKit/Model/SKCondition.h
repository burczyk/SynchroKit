//
//  SKCondition.h
//  SynchroKit
//
//  Created by Kamil Burczyk on 31.03.2012.
//  Copyright (c) 2012 Kamil Burczyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKOperator.h"

@interface SKCondition : NSObject {
    NSString *key;
    enum SKOperator condOperator;
    NSObject *value;
}

@property (nonatomic, retain) NSString *key;
@property (nonatomic) enum SKOperator condOperator;
@property (nonatomic, retain) NSObject *value;

- (id)initWithKey:(NSString*)aKey condOperator:(enum SKOperator)aCondOperator value:(NSObject*)aValue;

@end
