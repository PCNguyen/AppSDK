//
//  ASFileDataSource.m
//  AppSDK
//
//  Created by PC Nguyen on 11/14/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ASFileDataSource.h"
#import "DLFileManager.h"

@implementation ASFileDataSource

- (void)loadData
{
	NSURL *documentDirectory = [[DLFileManager sharedManager] urlForDocumentsDirectory];
	NSArray *allFileURLs = [[DLFileManager sharedManager] contentsOfDirectoryAtPath:[documentDirectory path] error:NULL];
	
	self.fileList = allFileURLs;
}

- (NSDictionary *)selectiveUpdateMap
{
	return @{};
}

@end
