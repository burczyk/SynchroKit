//
//  SKDataDownloader.h
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-02-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKDataDownloader : NSThread {
    NSThread *thread;
}

- (id) init;
- (id) initAsDaemon;

- (void) threadMainMethod;

@end
