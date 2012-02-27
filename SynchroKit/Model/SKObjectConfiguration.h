//
//  SKObjectConfiguration.h
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-02-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKObjectConfiguration : NSObject {
    NSString *name;
    Class objectClass;
    NSString *downloadPath;
    NSString *updateDatePath;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) Class objectClass;
@property (nonatomic, retain) NSString *downloadPath;
@property (nonatomic, retain) NSString *updateDatePath;

- (id) initWithName: (NSString*) name Class: (Class) objectClass downloadPath: (NSString*) downloadPath updateDatePath: (NSString*) updateDatePath;

@end
