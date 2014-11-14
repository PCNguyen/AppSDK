//
//  DSFileManager.h
//  DataSDK
//
//  Created by PC Nguyen on 4/30/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLFileManager : NSFileManager

/**
 *  The time interval that metadata should be persisted
 *	Default to 0 which is immediately
 */
@property (nonatomic, assign) NSTimeInterval metaDataPersistInterval;

/**
 *  Create the shared instance
 *  this should be called in AppDidFinishLaunching
 */
+ (void)configure;

/**
 *  Accessing the share instance
 *
 *  @return the shared instance
 */
+ (DLFileManager *)sharedManager;

/**
 *  Convenient method to access the document directory
 *
 *  @return the url for document dir
 */
- (NSURL *)urlForDocumentsDirectory;

- (void)applyClassBProtectionForFileAtPath:(NSString *)path;

/**
 *  Tracking a file with expiration date. Upon the date reach,
 *	the file will be wiped
 *
 *  @param fileURL        the fileURL to track
 *  @param expirationDate the expiration date
 */
- (void)trackFileURL:(NSURL *)fileURL expirationDate:(NSDate *)expirationDate;

@end
