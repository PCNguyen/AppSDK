//
//  DLFileManager.m
//  DataSDK
//
//  Created by PC Nguyen on 4/30/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "DLFileManager.h"

@implementation DLFileManager

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

@end
