//
//  DLFileStorage.h
//  AppSDK
//
//  Created by PC Nguyen on 11/13/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "DLStorage.h"

#define kDLFileStorageUnExpiredInterval        0

@protocol DLFileStorageProtocol <NSObject>

- (NSData *)dataPresentation;

@end

@interface DLFileStorage : DLStorage

/**
 *  The time interval that file should remain persistent on disk
 *	Default to kDLFileStorageUnExpiredInterval, which mean forever
 */
@property (nonatomic, assign) NSTimeInterval persistentInterval;

/**
 *  Save item to particular file name in the directory
 *
 *  @param item     the item that conform to DLFileStorage protocol
 *  @param fileName the file name where item is saved to
 */
- (void)saveItem:(id<DLFileStorageProtocol>)item toFile:(NSString *)fileName;

/**
 *  Load Item that was previously saved
 *
 *  @param fileName   the filename to identify the file
 *  @param parseBlock the mechanism to reconstruct the object from NSData.
 *
 *  @return the stored object
 */
- (id)loadItemFromFile:(NSString *)fileName parseRawDataBlock:(id(^)(NSData *rawData))parseBlock;

/**
 *  Remove only persistent directory, but leave cache items inact
 */
- (void)wipeDirectory;

/**
 *  Remove both persistent directory and cache items
 */
- (void)wipeStorage;

@end
