//
//  DLFileStorage.m
//  AppSDK
//
//  Created by PC Nguyen on 11/13/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "DLFileStorage.h"
#import "DLFileManager.h"

@interface DLFileStorage ()

@property (nonatomic, strong) NSURL *directoryURL;

@end

@implementation DLFileStorage

- (instancetype)initWithCache:(NSCache *)cache
{
	if (self = [super initWithCache:cache]) {
		_persistentInterval = kDLFileStorageUnExpiredInterval;
	}
	
	return self;
}

- (void)saveItem:(id<DLFileStorageProtocol>)item toFile:(NSString *)fileName
{
	if ([fileName length] > 0) {
		//--cache writing
		if (self.enableCache) {
			if (item) {
				[[self cache] setObject:item forKey:fileName];
			} else {
				[[self cache] removeObjectForKey:fileName];
			}
		}
		
		//--persistent writing
		NSURL *fileURL = [self fullURLForFileName:fileName];
		if (item) {
			NSData *storedData = [item dataPresentation];
			[storedData writeToURL:fileURL atomically:YES];
			
			//--set expiredDate so the file can be removed from disk automatically by FileManager
			NSDate *expirationDate = nil;
			if (self.persistentInterval > kDLFileStorageUnExpiredInterval) {
				expirationDate = [[NSDate date] dateByAddingTimeInterval:self.persistentInterval];
				[[DLFileManager sharedManager] trackFileURL:fileURL expirationDate:expirationDate];
			}
			
		} else {
			if ([[DLFileManager sharedManager] fileExistsAtPath:[fileURL path]]) {
				[[DLFileManager sharedManager] removeItemAtURL:fileURL error:NULL];
			}
		}
	}
}

- (id)loadItemFromFile:(NSString *)fileName parseRawDataBlock:(id (^)(NSData *))parseBlock
{
	id storedItem = nil;
	
	if ([fileName length] > 0) {
		//--cache reading
		if (self.enableCache) {
			storedItem = [[self cache] objectForKey:fileName];
		}
		
		//--persistent reading
		if (!storedItem) {
			NSURL *fileURL = [self fullURLForFileName:fileName];
			NSData *fileData = [[DLFileManager sharedManager] contentsAtPath:[fileURL path]];
			if (parseBlock) {
				storedItem = parseBlock(fileData);
			} else {
				storedItem = fileData;
			}
		}
		
	}
	
	return storedItem;
}

- (void)wipeDirectory
{
	NSArray *contents = [[DLFileManager sharedManager] contentsOfDirectoryAtPath:[self.directoryURL path] error:NULL];
	
	[contents enumerateObjectsUsingBlock:^(NSString *removedPath, NSUInteger index, BOOL *stop) {
		[[DLFileManager sharedManager] removeItemAtPath:removedPath error:NULL];
	}];
}

- (void)wipeStorage
{
	if (self.enableCache) {
		[[self cache] removeAllObjects];
	}
	
	[self wipeDirectory];
}

- (NSURL *)directoryURL
{
	if (!_directoryURL) {
		_directoryURL = [[DLFileManager sharedManager] urlForDocumentsDirectory];
	}
	
	return _directoryURL;
}

#pragma mark - Private

- (NSURL *)fullURLForFileName:(NSString *)fileName
{
	return [self.directoryURL URLByAppendingPathComponent:fileName];
}
@end
