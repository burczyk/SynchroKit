//
//  SKObjectLoaderMultipleDelegate.m
//  SynchroKit
//
//  Created by Kamil Burczyk on 15.04.2012.
//  Copyright (c) 2012 Kamil Burczyk. All rights reserved.
//

#import "SKObjectLoaderMultipleDelegate.h"


@implementation SKObjectLoaderMultipleDelegate 

@synthesize delegates;

- (id)init {
    self = [super init];
    if (self) {
        delegates = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addDelegate: (id<RKObjectLoaderDelegate>) delegate {
    [delegates addObject:delegate];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    for (id<RKObjectLoaderDelegate> delegate in delegates) {
        NSLog(@"SKObjectLoaderMultipleDelegate didFailsWithError: %@", delegate);        
        [delegate objectLoader:objectLoader didFailWithError:error];
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    for (id<RKObjectLoaderDelegate> delegate in delegates) {
        NSLog(@"SKObjectLoaderMultipleDelegate didLoadObjects: %@", delegate);
        [delegate objectLoader:objectLoader didLoadObjects:objects];
    }
}

//- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObject:(id)object {
//    for (id<RKObjectLoaderDelegate> delegate in delegates) {
//        NSLog(@"didLoadObject: %@", delegate);        
//        [delegate objectLoader:objectLoader didLoadObject:object];
//    }    
//}
//
//- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjectDictionary:(NSDictionary*)dictionary {
//    for (id<RKObjectLoaderDelegate> delegate in delegates) {
//        NSLog(@"didLoadObjectDictionary: %@", delegate);        
//        [delegate objectLoader:objectLoader didLoadObjectDictionary:dictionary];
//    }    
//}
//
//- (void)objectLoaderDidFinishLoading:(RKObjectLoader*)objectLoader {
//    for (id<RKObjectLoaderDelegate> delegate in delegates) {
//        NSLog(@"didFinishLoading: %@", delegate);        
//        [delegate objectLoaderDidFinishLoading:objectLoader];
//    }
//}
//
//- (void)objectLoaderDidLoadUnexpectedResponse:(RKObjectLoader*)objectLoader {
//    for (id<RKObjectLoaderDelegate> delegate in delegates) {
//        NSLog(@"didLoadUnexpectedResponse: %@", delegate);        
//        [delegate objectLoaderDidLoadUnexpectedResponse:objectLoader];
//    }    
//}
//
//- (void)objectLoader:(RKObjectLoader*)loader willMapData:(inout id *)mappableData {
//    for (id<RKObjectLoaderDelegate> delegate in delegates) {
//        NSLog(@"willMapData: %@", delegate);        
//        [delegate objectLoader:loader willMapData:mappableData];
//    }    
//}

@end
