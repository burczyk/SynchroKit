//
//  SKSweeper.m
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-03-12.
//  Copyright (c) 2012 Kamil Burczyk. All rights reserved.
//

#import "SKSweeper.h"

@implementation SKSweeper

@synthesize persistentStoreName;
@synthesize managedObjectContext;
@synthesize sweepConfiguration;

- (id) initWithNSManagedObjectContext: (NSManagedObjectContext*) context persistentStoreName: (NSString*) name sweepConfiguration: (SKSweepConfiguration*) configuration {
    self = [super init];
    if (self) {
        persistentStoreName = name;
        managedObjectContext = context;
        sweepConfiguration = configuration;
    }
    return self;
}

- (long long) getPersistentStoreSize {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *persistentStorePath = [documentsDirectory stringByAppendingPathComponent:@"SynchroKitTester.sqlite"];

    NSError *error = nil;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:persistentStorePath error:&error];
    return (long long) [fileAttributes objectForKey:NSFileSize];
}

- (void) removeObject: (NSManagedObject*) object {
    NSError *error;    
    [[self managedObjectContext] deleteObject:object];
    [[self managedObjectContext] save:&error];
    if (error) {
        NSLog(@"SKSweeper error while deleting: %@", error);
    }
}

@end
