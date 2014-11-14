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

#define kFMFileMetaDataKey       @"FileMetaDataKey"

@interface DLFileManager ()

@property (nonatomic, strong) NSMutableDictionary *fileMetaData;

@end

@implementation DLFileManager

+ (void)configure
{
	[DLFileManager sharedManager];
}

+ (DLFileManager *)sharedManager {
	
	static DLFileManager *fileManager;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		
		fileManager = [[DLFileManager alloc] init];
		
	});
	
	return fileManager;
}

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

- (NSMutableDictionary *)fileMetaData
{
	if (!_fileMetaData) {
		_fileMetaData = [NSMutableDictionary dictionary];
	}
	
	return _fileMetaData;
}

- (void)setMetaDataPersistInterval:(NSTimeInterval)metaDataPersistInterval
{
	_metaDataPersistInterval = metaDataPersistInterval;
	
	[[ALScheduleManager sharedManager] unScheduleTaskID:kFMFileMetaDataKey];
	
	if (metaDataPersistInterval > 0) {
		__weak DLFileManager *selfPointer = self;
		
		ALScheduledTask *scheduledTask = [[ALScheduledTask alloc] initWithTaskInterval:metaDataPersistInterval taskBlock:^{
			[NSUserDefaults dl_saveValue:selfPointer forKey:kFMFileMetaDataKey];
		}];
		
		scheduledTask.taskID = kFMFileMetaDataKey;
		
		[[ALScheduleManager sharedManager] scheduleTask:scheduledTask];
	}
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

@end
