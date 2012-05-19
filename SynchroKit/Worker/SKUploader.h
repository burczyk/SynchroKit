//
//  SKUploader.h
//  SynchroKit
//
//  Created by Kamil Burczyk on 03.05.2012.
//  Copyright (c) 2012 Kamil Burczyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "../Util/SKObjectDescriptorsSearcher.h"
#import <RestKit/RestKit.h>

@interface SKUploader : NSObject<RKObjectLoaderDelegate> {
    BOOL isDeamon;
    BOOL interrupted;    
    int synchronizationInterval;
    NSThread *uploadingThread;
    NSManagedObjectContext *context;
    NSMutableDictionary *registeredObjects;
    NSMutableSet *objectDescriptors;
}

@property(nonatomic, retain) NSManagedObjectContext *context;
@property(nonatomic, retain) NSMutableDictionary *registeredObjects;
@property(nonatomic, retain) NSMutableSet *objectDescriptors;

- (id) initWithRegisteredObjects: (NSMutableDictionary*) _registeredObjects objectDescriptors: (NSMutableSet*) _objectDescriptors managedObjectContext: (NSManagedObjectContext*) _context;
- (id) initAsDeamonWithRegisteredObjects: (NSMutableDictionary*) _registeredObjects objectDescriptors: (NSMutableSet*) _objectDescriptors managedObjectContext: (NSManagedObjectContext*) _context synchronizationInterval: (int) seconds;
- (void) saveObject: (NSManagedObject*) object forName: (NSString*) name;
- (void) uploadCyclic;
- (void) startUploadingDaemon;
- (void) stopUploadingDaemon;

@end
