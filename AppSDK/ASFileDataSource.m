//
//  ASFileDataSource.m
//  AppSDK
//
//  Created by PC Nguyen on 11/14/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ASFileDataSource.h"
#import "DLFileManager.h"
#import "DLFileStorage.h"

#import "UIImage+FileStorage.h"

@interface ASFileDataSource ()

@property (nonatomic, strong) DLFileStorage *fileStorage;

@end

@implementation ASFileDataSource

- (void)loadData
{
	[DLFileManager sharedManager].cleanUpInterval = 3*60;
	
	[self refreshFileList];
}

- (void)refreshFileList
{
	NSURL *documentDirectory = [[DLFileManager sharedManager] urlForDocumentsDirectory];
	NSArray *allFileURLs = [[DLFileManager sharedManager] contentsOfDirectoryAtPath:[documentDirectory path] error:NULL];
	
	self.fileList = allFileURLs;
}

- (void)saveImage:(UIImage *)image
{
	NSString *imageName = [[NSUUID UUID] UUIDString];
	[self.fileStorage saveItem:image toFile:imageName];
	[self refreshFileList];
}

- (UIImage *)imageForName:(NSString *)fileName
{
	UIImage *storedImage = [self.fileStorage loadItemFromFile:fileName parseRawDataBlock:^id(NSData *data) {
		return [UIImage convertFromData:data];
	}];
	
	return storedImage;
}

- (NSDictionary *)selectiveUpdateMap
{
	return @{};
}

#pragma mark - Storage

- (DLFileStorage *)fileStorage
{
	if (!_fileStorage) {
		NSURL *documentDirectory = [[DLFileManager sharedManager] urlForDocumentsDirectory];
		NSCache *cache = [DLFileManager sharedCache];
		_fileStorage = [[DLFileStorage alloc] initWithCache:cache directoryURL:documentDirectory];
		_fileStorage.persistentInterval = 1*60;
	}
	
	return _fileStorage;
}

@end
