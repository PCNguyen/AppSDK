//
//  DLFileStorage.m
//  AppSDK
//
//  Created by PC Nguyen on 11/13/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "DLFileStorage.h"

@implementation DLFileStorage

- (instancetype)initWithCache:(NSCache *)cache directoryPath:(NSString *)directoryPath
{
	if (self = [super initWithCache:cache]) {
		_directoryPath = directoryPath;
	}
	
	return self;
}

- (void)saveItem:(id<DLFileStorageProtocol>)item toPath:(NSString *)relativePath
{

}

- (id)loadItemFromPath:(NSString *)relativePath
{
	return nil;
}

- (void)wipeDirectory
{

}

- (void)wipeStorage
{

}

@end
