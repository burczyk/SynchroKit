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

- (id) initWithName: (NSString*) _name Class: (Class) _objectClass downloadPath: (NSString*) _downloadPath updateDatePath: (NSString*) _updateDatePath updateDateClass: (Class) _updateDateClass {
    self = [super init];
    if (self) {
        self.name           = _name;
        self.objectClass    = _objectClass;
        self.downloadPath   = _downloadPath;
        self.updateDatePath = _updateDatePath;        
        self.updateDateClass= _updateDateClass;
    }
    
    return self;
}

@end
