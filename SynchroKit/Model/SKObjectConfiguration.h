//
//  SKObjectConfiguration.h
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-02-27.
//  Copyright (c) 2012 Kamil Burczyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKObjectConfiguration : NSObject {
    NSString *name;
    Class objectClass;
    NSString *downloadPath;
    NSString *updateDatePath;
    NSString *updatedSinceDatePath;
    NSString *isDeletedFieldName;
    Class updateDateClass;
    id delegate;
    SEL isDeletedSelector;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) Class objectClass;
@property (nonatomic, retain) NSString *downloadPath;
@property (nonatomic, retain) NSString *updateDatePath;
@property (nonatomic, retain) NSString *updatedSinceDatePath;
@property (nonatomic, retain) NSString *isDeletedFieldName;
@property (nonatomic, retain) Class updateDateClass;
@property (nonatomic, retain) id delegate;
@property (nonatomic, assign) SEL isDeletedSelector;


- (id) initWithName: (NSString*) name Class: (Class) objectClass downloadPath: (NSString*) downloadPath;
- (id) initWithName: (NSString*) name Class: (Class) objectClass downloadPath: (NSString*) downloadPath updateDatePath: (NSString*) updateDatePath updateDateClass: (Class) updateDateClass;
- (id) initWithName: (NSString*) name Class: (Class) objectClass downloadPath: (NSString*) downloadPath updateDatePath: (NSString*) updateDatePath updateDateClass: (Class) updateDateClass updatedSinceDatePath: (NSString*) datePath isDeletedFieldName: (NSString*) fieldName;
- (id) initWithName: (NSString*) name Class: (Class) objectClass downloadPath: (NSString*) downloadPath updateDatePath: (NSString*) updateDatePath updateDateClass: (Class) updateDateClass updatedSinceDatePath: (NSString*) datePath isDeletedSelector: (SEL) selector;
@end
