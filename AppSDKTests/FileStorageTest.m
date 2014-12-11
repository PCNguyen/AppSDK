//
//  FileStorageTest.m
//  AppSDK
//
//  Created by PC Nguyen on 12/11/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DLFileStorage.h"
#import "DLFileManager.h"

@interface FileStorageTest : XCTestCase

@property (nonatomic, strong) DLFileStorage *fileStorage;

@end

@implementation FileStorageTest

- (void)setUp {
    [super setUp];
	self.fileStorage = [[DLFileStorage alloc] init];
	self.fileStorage.enableCache = NO;
}

- (void)tearDown {
	self.fileStorage = nil;
    [super tearDown];
}

- (void)testAdjustDirectoryURL
{
	NSURL *directoryURL = [[DLFileManager sharedManager] urlForDocumentsDirectory];
	directoryURL = [directoryURL URLByAppendingPathComponent:@"testDirectory"];
	[self.fileStorage adjustDirectoryURL:directoryURL];
}

@end
