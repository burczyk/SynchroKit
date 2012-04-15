//
//  SKDataDownloader.m
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-02-19.
//  Copyright (c) 2012 Kamil Burczyk. All rights reserved.
//

#import "SKDataDownloader.h"

@implementation SKDataDownloader

@synthesize registeredObjects;
@synthesize objectDescriptors;
@synthesize seconds;
@synthesize updateDates;

@synthesize context;

@synthesize multipleDelegates;

#pragma mark constructors

- (id) initWithRegisteredObjects: (NSMutableDictionary*) _registeredObjects objectDescriptors: (NSMutableSet*) _objectDescriptors {
    self = [super init];
    if (self) {
        interrupted = FALSE;
        isDaemon = FALSE;
        
        updateDates = [[NSMutableDictionary alloc] init];
        [self setRegisteredObjects:_registeredObjects];
        [self setObjectDescriptors:_objectDescriptors];
        
        multipleDelegates = [[NSMutableArray alloc] init];
        globalDelegate = [[SKObjectLoaderMultipleDelegate alloc] init];        
    }
    return self;
}

- (id) initAsDaemonWithRegisteredObjects: (NSMutableDictionary*) _registeredObjects objectDescriptors: (NSMutableSet*) _objectDescriptors timeInterval: (int) _seconds {
    self = [super init];
    if (self) {
        interrupted = FALSE;
        isDaemon = TRUE;
        
        updateDates = [[NSMutableDictionary alloc] init];
        [self setRegisteredObjects:_registeredObjects];
        [self setObjectDescriptors:_objectDescriptors];
        [self setSeconds:_seconds];
        
        multipleDelegates = [[NSMutableArray alloc] init];        
        globalDelegate = [[SKObjectLoaderMultipleDelegate alloc] init];          
        
        thread = [[NSThread alloc] initWithTarget:self selector:@selector(mainUpdateMethod) object:nil];
        [thread start];
    }
    return self;
}

#pragma mark main download loop

- (void) loadObjectsByName: (NSString*) name asynchronous: (BOOL) async delegate: (id<RKObjectLoaderDelegate>) delegate{
    NSLog(@"loadObjectsByName: %@", delegate);
    
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    SKObjectConfiguration *configuration = [registeredObjects valueForKey:name];
    
    //synchronous call
    if(async == FALSE){
        RKObjectLoader* loader = [objectManager objectLoaderWithResourcePath:[configuration downloadPath] delegate:self];
        loader.objectMapping = [objectManager.mappingProvider objectMappingForClass:[configuration objectClass]];
        [loader sendSynchronously];   
    } else { //asynchronous call with delegate
        [objectManager loadObjectsAtResourcePath:[configuration downloadPath] delegate:delegate block:^(RKObjectLoader* loader) {
            loader.objectMapping = [objectManager.mappingProvider objectMappingForClass:[configuration objectClass]];
        }];        
    }
}

- (void) loadAllObjectsAsynchronous: (BOOL) async delegate: (id<RKObjectLoaderDelegate>) delegate {
    for (NSString *name in [registeredObjects allKeys]) {
        [self loadObjectsByName:name asynchronous:async delegate:delegate];        
    }
}

- (void) loadObjectIfUpdatedOnServerByName: (NSString*) name asynchronous: (BOOL) async delegate: (id<RKObjectLoaderDelegate>) delegate{
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    SKObjectConfiguration *configuration = [registeredObjects valueForKey:name];
    
    if (configuration.updateDatePath != Nil && [configuration.updateDatePath length] > 0) { //updateDate exists
        if(async == TRUE) {            
            [objectManager loadObjectsAtResourcePath:[configuration updateDatePath] delegate:delegate block:^(RKObjectLoader* loader) {
                loader.objectMapping = [objectManager.mappingProvider objectMappingForClass:configuration.updateDateClass];
            }];        
        } else {
            RKObjectLoader* loader = [objectManager objectLoaderWithResourcePath:[configuration updateDatePath] delegate:self];
            loader.objectMapping = [objectManager.mappingProvider objectMappingForClass:[configuration updateDateClass]];
            [loader sendSynchronously];                            
        }
    } else {
        //no synchronization date set - force download
        [self loadObjectsByName:name asynchronous:async delegate:delegate];
    }
}

- (void) loadAllObjectsIfUpdatedOnServerAsynchronous: (BOOL) async delegate: (id<RKObjectLoaderDelegate>) delegate {
    for (NSString *name in [registeredObjects allKeys]) {
        [self loadObjectIfUpdatedOnServerByName:name asynchronous:async delegate:delegate];        
    }
}

- (void) loadObjectsUpdatedSinceLastDownloadByName: (NSString*) name asynchronous: (BOOL) async delegate: (id<RKObjectLoaderDelegate>) delegate{
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    SKObjectConfiguration *configuration = [registeredObjects valueForKey:name];
    SKObjectDescriptor *descriptor = [self findDescriptorByName:name];
    NSLog(@"Descriptor: %@", descriptor);
    NSString *dateFormat = @"yyyy-MM-dd";
    NSString *nullDateReplacement = @"1970-01-01";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if ([descriptor lastUpdateDate] != NULL) {
        [params setValue:[formatter stringFromDate:[descriptor lastUpdateDate]] forKey:@"date"];        
    } else {
        [params setValue:nullDateReplacement forKey:@"date"];        
    }

    [params setValue:dateFormat forKey:@"format"];
    
    //synchronous call
    if(async == FALSE){
        RKObjectLoader* loader = [objectManager objectLoaderWithResourcePath:RKPathAppendQueryParams([configuration updatedSinceDatePath], params) delegate:self];
        loader.objectMapping = [objectManager.mappingProvider objectMappingForClass:[configuration objectClass]];
        
        [loader sendSynchronously];
    } else {
        [objectManager loadObjectsAtResourcePath:RKPathAppendQueryParams([configuration updatedSinceDatePath], params) delegate:delegate block:^(RKObjectLoader* loader) {
            loader.objectMapping = [objectManager.mappingProvider objectMappingForClass:configuration.objectClass];
        }];         
    }
    
    [params release];    
    [formatter release];
}

- (void) loadObjectsWithPredicate: (NSPredicate*) predicate byName: (NSString*) name asynchronous: (BOOL) async delegate: (id<RKObjectLoaderDelegate>) delegate{
    NSLog(@"predicate: %@", predicate);
}

#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastUpdatedAt"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	NSLog(@"Loaded objects count: %d", [objects count]);
    NSLog(@"Loaded objects: %@", objects);
    
    for (NSObject *downloadedObject in objects) { //iterate over all objects
        if ([downloadedObject conformsToProtocol:@protocol(UpdateDateProtocol)]) { //if downloaded object is an UpdateDateProtocol
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = [downloadedObject performSelector:@selector(dateFormat)];
            NSDate *objectUpdateDate = [formatter dateFromString:[downloadedObject performSelector:@selector(updateDate)]];
            NSLog(@"%@ last update date: %@", [downloadedObject performSelector:@selector(objectClassName)], [formatter stringFromDate:objectUpdateDate]);
            [updateDates setValue:objectUpdateDate forKey:[downloadedObject performSelector:@selector(objectClassName)]]; //setting update date from UpdateDateProtocol, object downloaded one line below will use it
            
            SKObjectDescriptor *objectDescriptor = [self findDescriptorByName:[downloadedObject performSelector:@selector(objectClassName)]];
            NSLog(@"object descriptor: %@", objectDescriptor);
            NSLog(@"descriptor.date: %@", objectDescriptor.lastUpdateDate);
            if (objectDescriptor == NULL || (objectDescriptor != NULL && objectDescriptor.lastUpdateDate == NULL) || (objectDescriptor != NULL && [objectDescriptor.lastUpdateDate compare: objectUpdateDate] < 0 )) { //there is no such object or object last update date is smaller than last update date on server
                NSLog(@"Changes for %@ on server. Downloading...", [downloadedObject performSelector:@selector(objectClassName)]);
                [self loadObjectsByName:[downloadedObject performSelector:@selector(objectClassName)] asynchronous:TRUE delegate:self];
            } else {
                NSLog(@"Objects %@ synchronized for date: %@", [downloadedObject performSelector:@selector(objectClassName)], objectDescriptor.lastUpdateDate);
            }
            
            [formatter release];
        } else { //downloaded object IS NOT an UpdateDateProtocol
            NSString *name = [[downloadedObject class] description];
            NSLog(@"downloadedObject: %@", [downloadedObject class]);
            NSManagedObjectID *idf = [(NSManagedObject*) downloadedObject objectID]; 
            NSLog(@"szukanie: %@ %@", name, idf);
            SKObjectDescriptor *objectDescriptor = [self findDescriptorByObjectID:idf];
            
            if (objectDescriptor == NULL) { //if there is no object descriptor then create one
                objectDescriptor = [[SKObjectDescriptor alloc] initWithName:name identifier:idf lastUpdateDate:[updateDates valueForKey:name]]; //it should be previously set
                [objectDescriptor setLastUsedDate:[NSDate new]];
                [objectDescriptors addObject:objectDescriptor];
                NSLog(@"Added descriptor: %@ %@ %@", name, idf, [objectDescriptor lastUpdateDate]);
                [objectDescriptor release];
            } else { //update existing object descriptor
                [objectDescriptor setLastUsedDate:[updateDates valueForKey:name]];
                NSLog(@"Updated descriptor: %@ %@ %@", name, idf, [objectDescriptor lastUpdateDate]);
            }
            
            SKObjectConfiguration *configuration = [registeredObjects objectForKey:name];
            if ([downloadedObject performSelector:[configuration isDeletedSelector]]) {
                [SKSweeper removeObject:objectDescriptor managedObjectContext:context];
            }
        }
    }
    NSLog(@"Object descriptors count: %d", [objectDescriptors count]);

}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	NSLog(@"Hit error: %@", error);
}

#pragma mark searcher methods

- (SKObjectDescriptor*) findDescriptorByName: (NSString*) name {
    for (SKObjectDescriptor *objectDescriptor in [self objectDescriptors]) {
        if ([objectDescriptor.name isEqualToString:name]) {
            return objectDescriptor;
        }
    }
    return NULL;    
}

- (SKObjectDescriptor*) findDescriptorByObjectID: (NSManagedObjectID*) objectID {
    for (SKObjectDescriptor *objectDescriptor in [self objectDescriptors]) {
        if ([objectDescriptor.identifier isEqual:objectID]) {
            return objectDescriptor;
        }
    }
    return NULL;
}

#pragma mark Thread methods

- (void) mainUpdateMethod {
    NSLog(@"Thread started");
    
//    while (!interrupted) {
        for (SKObjectConfiguration *configuration in [registeredObjects allValues]) {
            NSLog(@"updatedSinceDatePath: %@; updateDatePath: %@; updateDateClass: %@; async: %d; delegate: %@", configuration.updatedSinceDatePath, configuration.updateDatePath, configuration.updateDateClass, configuration.asynchronous, configuration.delegate);
            if (configuration.updatedSinceDatePath != NULL && ![@"" isEqualToString:[configuration updatedSinceDatePath]]) { // only changed Objects since date
                if (configuration.asynchronous && configuration.delegate != NULL) { // response delivered to delegate
                    SKObjectLoaderMultipleDelegate *multipleDelegate = [[SKObjectLoaderMultipleDelegate alloc] init];
                    [multipleDelegate addDelegate:self];
                    [multipleDelegate addDelegate:configuration.delegate];
                    [self loadObjectsUpdatedSinceLastDownloadByName:[configuration name] asynchronous:TRUE delegate:self];
                    [multipleDelegate release];
                } else { //handle response
                    [self loadObjectsUpdatedSinceLastDownloadByName:[configuration name] asynchronous:FALSE delegate:NULL];
                }
            } else if (configuration.updateDatePath != NULL && ![@"" isEqualToString:[configuration updateDatePath]] && configuration.updateDateClass != NULL) {
                if (configuration.asynchronous && configuration.delegate != NULL) { // response delivered to delegate
                    SKObjectLoaderMultipleDelegate *multipleDelegate = [[SKObjectLoaderMultipleDelegate alloc] init];
                    [multipleDelegate addDelegate:self];
                    [multipleDelegate addDelegate:configuration.delegate];
                    [self loadObjectIfUpdatedOnServerByName:[configuration name] asynchronous:TRUE delegate:self];
                    [multipleDelegate release];
                } else { //handle response
                    [self loadObjectIfUpdatedOnServerByName:[configuration name] asynchronous:FALSE delegate:NULL];
                }                
            } else {
                if (configuration.asynchronous && configuration.delegate != NULL) { // response delivered to delegate
                    SKObjectLoaderMultipleDelegate *multipleDelegate = [[SKObjectLoaderMultipleDelegate alloc] init];
                    [multipleDelegate addDelegate:self];
                    [multipleDelegate addDelegate:configuration.delegate];
                    [multipleDelegates addObject:multipleDelegate];
//                    [globalDelegate addDelegate:self];
//                    [globalDelegate addDelegate:configuration.delegate];
                    [self loadObjectsByName:configuration.name asynchronous:TRUE delegate:multipleDelegate];
//                    [multipleDelegate release];
                } else { //handle response
                    [self loadObjectsByName:configuration.name asynchronous:FALSE delegate:NULL];
                }                
            }
        }
        
//        sleep(seconds);
//    }
}

- (void) interrupt {
    NSLog(@"stopping Thread");
    interrupted = TRUE;
}

@end
