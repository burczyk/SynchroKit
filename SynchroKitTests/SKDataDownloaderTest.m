//
//  SKDataDownloaderTest.m
//  SynchroKit
//
//  Created by Kamil Burczyk on 12-02-19.
//  Copyright (c) 2012 Kamil Burczyk. All rights reserved.
//

#import "SKDataDownloaderTest.h"

@implementation SKDataDownloaderTest

- (void) testInit {
    SKDataDownloader *dataDownloader = [[SKDataDownloader alloc] initAsDaemon];
    sleep(1);
    [dataDownloader interrupt];
    [dataDownloader release];
}

@end
