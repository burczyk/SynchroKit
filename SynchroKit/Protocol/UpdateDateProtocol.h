//
//  UpdateDateProtocol.h
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-03-05.
//  Copyright (c) 2012 Kamil Burczyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UpdateDateProtocol <NSObject>

@required
- (NSString*) objectClassName;
- (NSString*) updateDate;
- (NSString*) dateFormat;

@end
