//
//  SKUploader.m
//  SynchroKit
//
//  Created by Kamil Burczyk on 03.05.2012.
//  Copyright (c) 2012 Kamil Burczyk. All rights reserved.
//

#import "SKUploader.h"

@implementation SKUploader

@synthesize context,
            registeredObjects,
            objectDescriptors;

- (id) initWithRegisteredObjects: (NSMutableDictionary*) _registeredObjects objectDescriptors: (NSMutableSet*) _objectDescriptors managedObjectContext: (NSManagedObjectContext*) _context {
    self = [super init];
    if (self) {
        isDeamon = FALSE;
        interrupted = FALSE;
        [self setRegisteredObjects:_registeredObjects];
        [self setObjectDescriptors:_objectDescriptors]; 
        [self setContext:_context];
    }
    return self;
}

- (id) initAsDeamonWithRegisteredObjects: (NSMutableDictionary*) _registeredObjects objectDescriptors: (NSMutableSet*) _objectDescriptors managedObjectContext: (NSManagedObjectContext*) _context synchronizationInterval: (int) seconds {
    self = [super init];
    if (self) {
        isDeamon = TRUE;
        interrupted = FALSE;
        synchronizationInterval = seconds;
        [self setRegisteredObjects:_registeredObjects];
        [self setObjectDescriptors:_objectDescriptors]; 
        [self setContext:_context];
    }
    return self;    
}

- (void) saveObject: (NSManagedObject*) object forName: (NSString*) name {
    NSError *error;
    
    [context insertObject:object];
    
    if (![context save:&error]) {
        NSLog(@"error during save in Uploader %@", [error userInfo]);
    }
    
    SKObjectDescriptor *descriptor = [SKObjectDescriptorsSearcher findDescriptorByObjectID:[object objectID] inObjectDescriptors:self.objectDescriptors];
    if (descriptor == NULL) {
        NSLog(@"descriptor = NULL");
        descriptor = [[SKObjectDescriptor alloc] initWithName:name identifier:[object objectID] lastUpdateDate:[NSDate new]];
        [objectDescriptors addObject:descriptor];
    }
    
    [descriptor setIsSaved:FALSE];

    if (!isDeamon) {
        [self uploadChanges];        
    }
    
}

- (void) uploadChanges {
    for (SKObjectDescriptor *descriptor in objectDescriptors) {
        if (![descriptor isSaved]) {
            NSManagedObject *managedObject = [context objectWithID:[descriptor identifier]];
            [[RKObjectManager sharedManager] postObject:managedObject delegate:self];
        }
    }
}

- (void) uploadCyclic {
    while (!interrupted) {
        [self uploadChanges];
        sleep(synchronizationInterval);
    }
}

- (void) startUploadingDaemon {
    interrupted = FALSE;
    
    if (uploadingThread == NULL) {
        uploadingThread = [[NSThread alloc] initWithTarget:self selector:@selector(uploadCyclic) object:nil];
    }
    
    [uploadingThread start];    
}

- (void) stopUploadingDaemon {
    interrupted = TRUE;
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {  
    NSLog(@"UPLOADED %@", objects);  
    for (NSManagedObject *object in objects) {
        SKObjectDescriptor *descriptor = [SKObjectDescriptorsSearcher findDescriptorByObjectID:[object objectID] inObjectDescriptors:objectDescriptors];
        [descriptor setIsSaved:TRUE];
    }
}  

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {  
    NSLog(@"UPLOADER ERROR: %@", error);  
}  

- (void)objectLoaderDidFinishLoading:(RKObjectLoader*)objectLoader {
     NSLog(@"FINISH UPLOADING"); 
}

@end
