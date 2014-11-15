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

- (void)dealloc
{
	[self unRegisterNotification];
}

- (id)init
{
	if (self = [super init]) {
		[self ignoreUpdateProperty:@selector(fileStorage)];
		[self registerNotification];
	}
	
	return self;
}

#pragma mark - ULViewDataSource Override

- (void)loadData
{
	[DLFileManager sharedManager].cleanUpInterval = 1*60;
	
	[self refreshFileList];
}

- (NSDictionary *)selectiveUpdateMap
{
	return @{};
}

#pragma mark - Handle file

- (void)refreshFileList
{
	NSURL *documentDirectory = [[DLFileManager sharedManager] urlForDocumentsDirectory];
	NSArray *allFileURLs = [[DLFileManager sharedManager] contentsOfDirectoryAtPath:[documentDirectory path] error:NULL];
	
	self.fileList = allFileURLs;
}

- (void)saveImage:(UIImage *)image
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
		NSString *imageName = [[NSUUID UUID] UUIDString];
		[self.fileStorage saveItem:image toFile:imageName];
		
		dispatch_sync(dispatch_get_main_queue(), ^{
			[self refreshFileList];
		});
	});
}

- (UIImage *)imageForName:(NSString *)fileName
{
	UIImage *storedImage = [self.fileStorage loadItemFromFile:fileName parseRawDataBlock:^id(NSData *data) {
		return [UIImage convertFromData:data];
	}];
	
	return storedImage;
}

#pragma mark - Storage

- (DLFileStorage *)fileStorage
{
	if (!_fileStorage) {
		NSCache *cache = [DLFileManager sharedCache];
		_fileStorage = [[DLFileStorage alloc] initWithCache:cache];
		_fileStorage.persistentInterval = 0.5*60;
	}
	
	return _fileStorage;
}

#pragma mark - Notification

- (void)registerNotification
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleFileCleanUpCompleteNotification:)
												 name:DLFileManagerCleanUpCompleteNotification
											   object:nil];
}

- (void)unRegisterNotification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:DLFileManagerCleanUpCompleteNotification
												  object:nil];
}

- (void)handleFileCleanUpCompleteNotification:(NSNotification *)notification
{
	[self refreshFileList];
}

@end
