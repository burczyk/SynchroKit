//
//  SKObjectConfiguration.m
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-02-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKObjectConfiguration.h"

@implementation SKObjectConfiguration

@synthesize name,
            objectClass,
            downloadPath,
            updateDatePath,
            updateDateClass;

- (id) initWithName: (NSString*) name Class: (Class) objectClass downloadPath: (NSString*) downloadPath updateDatePath: (NSString*) updateDatePath updateDateClass: (Class) updateDateClass {
    self = [super init];
    if (self) {
        self.name           = name;
        self.objectClass    = objectClass;
        self.downloadPath   = downloadPath;
        self.updateDatePath = updateDatePath;        
        self.updateDateClass= updateDateClass;
    }
    
    return self;
}

@end
