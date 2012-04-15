//
//  SKObjectLoaderMultipleDelegate.h
//  SynchroKit
//
//  Created by Kamil Burczyk on 15.04.2012.
//  Copyright (c) 2012 Kamil Burczyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Restkit/Restkit.h>

@interface SKObjectLoaderMultipleDelegate : NSObject<RKObjectLoaderDelegate> {
    NSMutableArray *delegates;
}

@property (nonatomic, retain) NSMutableArray *delegates;

- (void) addDelegate: (id<RKObjectLoaderDelegate>) delegate;

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error;
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects;
//- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObject:(id)object;
//- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjectDictionary:(NSDictionary*)dictionary;
//- (void)objectLoaderDidFinishLoading:(RKObjectLoader*)objectLoader;
//- (void)objectLoaderDidLoadUnexpectedResponse:(RKObjectLoader*)objectLoader;
//- (void)objectLoader:(RKObjectLoader*)loader willMapData:(inout id *)mappableData;

@end
