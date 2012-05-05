//
//  SKSweeper.h
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-03-12.
//  Copyright (c) 2012 Kamil Burczyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "../Model/SKSweepConfiguration.h"
#import "../Model/SKObjectDescriptor.h"
#import "../Util/SKObjectDescriptorsSearcher.h"
#import "../Worker/SKDataLoader.h"

@interface SKSweeper : NSObject {
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectContext *managedObjectContext;
    NSString *persistentStoreName;
    SKSweepConfiguration *sweepConfiguration;
    BOOL interrupted;
    NSThread *sweepingThread;
    NSMutableSet *objectDescriptors;
}

@property(nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) NSString *persistentStoreName;
@property(nonatomic, retain) SKSweepConfiguration *sweepConfiguration;
@property(nonatomic, retain) NSMutableSet *objectDescriptors;

- (id) initWithNSPersistentStoreCoordinator: (NSPersistentStoreCoordinator*) coordinator persistentStoreName: (NSString*) name sweepConfiguration: (SKSweepConfiguration*) configuration objectDescriptors: (NSMutableSet*) descriptors;

- (long long) getPersistentStoreSize;
- (void) removeObject: (SKObjectDescriptor*) objectDescriptor;
+ (void) removeManagedObject: (NSManagedObject*) object managedObjectContext: (NSManagedObjectContext*) context;
+ (void) removeObject: (SKObjectDescriptor*) objectDescriptor managedObjectContext: (NSManagedObjectContext*) context;
+ (void) removeStoredObjectsNotIn: (NSArray*) objects forName: (NSString*) name managedObjectContext: (NSManagedObjectContext*) context objectDescriptors: (NSMutableSet*) descriptors;
- (NSManagedObject*) getEntityForId: (NSManagedObjectID*) identifier;

- (void) sweepOnce;
- (void) sweepCyclic;
- (void) startSweepingDaemon;
- (void) stopSweepingDaemon;

@end
