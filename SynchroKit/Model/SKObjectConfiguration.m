//
//  SKObjectConfiguration.m
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-02-27.
//  Copyright (c) 2012 Kamil Burczyk. All rights reserved.
//

#import "SKObjectConfiguration.h"

@implementation SKObjectConfiguration

@synthesize name,
            objectClass,
            downloadPath,
            updateDatePath,
            updatedSinceDatePath,
            conditionUpdatePath,
            updateDateClass,
            delegate,
            isDeletedSelector,
            asynchronous;

- (id) initWithName: (NSString*) _name Class: (Class) _objectClass downloadPath: (NSString*) _downloadPath {
    self = [super init];
    if (self) {
        self.name           = _name;
        self.objectClass    = _objectClass;
        self.downloadPath   = _downloadPath;
    }
    
    return self;
}

- (id) initWithName: (NSString*) _name Class: (Class) _objectClass downloadPath: (NSString*) _downloadPath updateDatePath: (NSString*) _updateDatePath updateDateClass: (Class) _updateDateClass {
    self = [self initWithName:_name Class:_objectClass downloadPath:_downloadPath];
    if (self) {
        self.updateDatePath = _updateDatePath;        
        self.updateDateClass= _updateDateClass;
    }
    
    return self;
}
 

- (id) initWithName: (NSString*) _name Class: (Class) _objectClass downloadPath: (NSString*) _downloadPath updateDatePath: (NSString*) _updateDatePath updateDateClass: (Class) _updateDateClass updatedSinceDatePath: (NSString*) _datePath conditionUpdatePath:(NSString*) _conditionUpdatePath delegate: (id<RKObjectLoaderDelegate>) _delegate asynchronous: (BOOL) async isDeletedSelector: (SEL) selector {
    
    self = [self initWithName:_name Class:_objectClass downloadPath:_downloadPath updateDatePath:_updateDatePath updateDateClass:_updateDateClass];
    if (self) {
        self.updatedSinceDatePath = _datePath;
        self.conditionUpdatePath = _conditionUpdatePath;
        self.isDeletedSelector = selector;
        self.asynchronous = async;
        [self setDelegate:_delegate];
    }
    
    return self;    
}
@end
