//
//  DLFileManager.m
//  DataSDK
//
//  Created by PC Nguyen on 4/30/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "DLFileManager.h"
#import "AppLibShared.h"
#import "ALScheduleManager.h"
#import "NSUserDefaults+DL.h"

#define kFMFileMetaDataKey			@"FileMetaDataKey"

NSString *const FMFileMetaDataPersistTaskID			= @"FMFileMetaDataPersistTaskID";
NSString *const FMFileCleanUpTaskID					= @"FMFileCleanUpTaskID";

@interface DLFileManager ()

@property (nonatomic, strong) NSMutableDictionary *fileMetaData;
@property (nonatomic, strong) NSCache *cache;

@end

@implementation DLFileManager

+ (void)configure
{
	[DLFileManager sharedManager];
}

+ (instancetype)sharedManager
{
	SHARE_INSTANCE_BLOCK(^{
		return [[self alloc] init];
	});
}

- (instancetype)init
{
	if (self = [super init]) {
		_metaDataPersistInterval = 0;
		_fileMetaData =  [NSUserDefaults dl_loadValueForKey:kFMFileMetaDataKey];
	}
	
	return self;
}

#pragma mark - Caching

+ (NSCache *)sharedCache
{
	return [[DLFileManager sharedManager] cache];
}

- (NSCache *)cache
{
	if (!_cache) {
		_cache = [[NSCache alloc] init];
		_cache.totalCostLimit = 0;
	}
	
	return _cache;
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
		[scheduledTask setTerminationFlags:[ALScheduledTask defaultTerminationFlags]];
		[scheduledTask setResumeFlags:[ALScheduledTask defaultResumeFlags]];
		
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
		NSString *fileName = [fileURL lastPathComponent];
		[self.fileMetaData setValue:expirationDate forKey:fileName];
		
		if (self.metaDataPersistInterval == 0) {
			[self persistMedaData];
		}
	}
}

- (void)handleFileCleanUp
{
	NSMutableArray *removedFiles = [NSMutableArray array];
	
	//--clean up the file on disk
	[self.fileMetaData enumerateKeysAndObjectsUsingBlock:^(NSString *fileName, NSDate *expiredDate, BOOL *stop) {
		if ([expiredDate timeIntervalSinceNow] <= 0) {
			NSURL *fileURL = [[self urlForDocumentsDirectory] URLByAppendingPathComponent:fileName];
			if ([self fileExistsAtPath:[fileURL path]]) {
				NSError *error = nil;
				[self removeItemAtPath:[fileURL path] error:&error];
				if (error) {
					NSLog(@"File Clean Up Error: %@", error);
				} else {
					[removedFiles addObject:fileName];
				}
			} else {
				[removedFiles addObject:fileName];
			}
		}
	}];
	
	//--clean up the meta data
	for (NSString *fileName in removedFiles) {
		[self.fileMetaData setValue:nil forKey:fileName];
	}
	
	//--persist the update meta data
	[self persistMedaData];
}

- (void)persistMedaData
{
	[NSUserDefaults dl_saveValue:self.fileMetaData forKey:kFMFileMetaDataKey];
}

@end
