//
//  DLFileManager.m
//  DataSDK
//
//  Created by PC Nguyen on 4/30/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "DLFileManager.h"
#import "ALScheduleManager.h"
#import "NSUserDefaults+DL.h"

#define kFMFileMetaDataKey			@"FileMetaDataKey"

NSString *const FMFileMetaDataPersistTaskID			= @"FMFileMetaDataPersistTaskID";
NSString *const FMFileCleanUpTaskID					= @"FMFileCleanUpTaskID";

@interface DLFileManager ()

@property (nonatomic, strong) NSMutableDictionary *fileMetaData;

@end

@implementation DLFileManager

+ (void)configure
{
	[DLFileManager sharedManager];
	
	[DLFileManager sharedManager].fileMetaData = [NSUserDefaults dl_loadValueForKey:kFMFileMetaDataKey];
}

+ (DLFileManager *)sharedManager {
	
	static DLFileManager *fileManager;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		
		fileManager = [[DLFileManager alloc] init];
		
	});
	
	return fileManager;
}

- (instancetype)init
{
	if (self = [super init]) {
		_metaDataPersistInterval = 0;
	}
	
	return self;
}

#pragma mark - Directory Helper

- (NSURL *)urlForDocumentsDirectory
{
    NSURL *appDirectoryURL = [[self URLsForDirectory:NSDocumentDirectory
                                           inDomains:NSUserDomainMask] lastObject];
    return appDirectoryURL;
}

#pragma mark - Security

- (void)applyClassBProtectionForFileAtPath:(NSString *)path
{
    NSError *error = nil;
    NSDictionary *fileProtectionAttributes = [NSDictionary dictionaryWithObject:NSFileProtectionCompleteUntilFirstUserAuthentication forKey:NSFileProtectionKey];
    [self setAttributes:fileProtectionAttributes ofItemAtPath:path error:&error];
}

#pragma mark - File Maintenance

- (void)setMetaDataPersistInterval:(NSTimeInterval)metaDataPersistInterval
{
	_metaDataPersistInterval = metaDataPersistInterval;
	
	[[ALScheduleManager sharedManager] unScheduleTaskID:FMFileMetaDataPersistTaskID];
	
	if (metaDataPersistInterval > 0) {
		__weak DLFileManager *selfPointer = self;
		
		ALScheduledTask *scheduledTask = [[ALScheduledTask alloc] initWithTaskInterval:metaDataPersistInterval taskBlock:^{
			[NSUserDefaults dl_saveValue:selfPointer forKey:kFMFileMetaDataKey];
		}];
		
		scheduledTask.taskID = FMFileMetaDataPersistTaskID;
		
		[[ALScheduleManager sharedManager] scheduleTask:scheduledTask];
	}
}

- (void)setCleanUpInterval:(NSTimeInterval)cleanUpInterval
{
	_cleanUpInterval = cleanUpInterval;
	
	[[ALScheduleManager sharedManager] unScheduleTaskID:FMFileCleanUpTaskID];
	
	if (cleanUpInterval > 0) {
		__weak DLFileManager *selfPointer = self;
		
		ALScheduledTask *scheduledTask = [[ALScheduledTask alloc] initWithTaskInterval:cleanUpInterval taskBlock:^{
			[selfPointer handleFileCleanUp];
		}];
		
		scheduledTask.taskID = FMFileMetaDataPersistTaskID;
		
		[[ALScheduleManager sharedManager] scheduleTask:scheduledTask];
	}
	
}

- (NSMutableDictionary *)fileMetaData
{
	if (!_fileMetaData) {
		_fileMetaData = [NSMutableDictionary dictionary];
	}
	
	return _fileMetaData;
}

- (void)trackFileURL:(NSURL *)fileURL expirationDate:(NSDate *)expirationDate
{
	if (expirationDate && fileURL) {
		[self.fileMetaData setObject:expirationDate forKey:fileURL];
		
		if (self.metaDataPersistInterval == 0) {
			[NSUserDefaults dl_saveValue:self.fileMetaData forKey:kFMFileMetaDataKey];
		}
	}
}

- (void)handleFileCleanUp
{
	NSMutableArray *removedURLs = [NSMutableArray array];
	
	//--clean up the file on disk
	[self.fileMetaData enumerateKeysAndObjectsUsingBlock:^(NSURL *fileURL, NSDate *expiredDate, BOOL *stop) {
		if ([expiredDate timeIntervalSinceNow] <= 0) {
			
			if ([self fileExistsAtPath:[fileURL path]]) {
				NSError *error = nil;
				[self removeItemAtPath:[fileURL path] error:&error];
				if (error) {
					NSLog(@"File Clean Up Error: %@", error);
				} else {
					[removedURLs addObject:fileURL];
				}
			
			} else {
				[removedURLs addObject:fileURL];
			}
		}
	}];
	
	//--clean up the meta data
	for (NSURL *removedURL in removedURLs) {
		[self.fileMetaData removeObjectForKey:removedURL];
	}
}

@end
