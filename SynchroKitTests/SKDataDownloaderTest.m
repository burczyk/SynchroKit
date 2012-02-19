//
//  SKDataDownloaderTest.m
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-02-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKDataDownloaderTest.h"

@implementation SKDataDownloaderTest

// All code under test must be linked into the Unit Test bundle
- (void)testMath
{
    STAssertTrue((1 + 1) == 2, @"Compiler isn't feeling well today :-(");
}

- (void) testInit {
    SKDataDownloader *dataDownloader = [[SKDataDownloader alloc] initAsDaemon];   
}

@end
