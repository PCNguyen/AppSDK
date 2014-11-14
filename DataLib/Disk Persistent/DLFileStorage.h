//
//  DLFileStorage.h
//  AppSDK
//
//  Created by PC Nguyen on 11/13/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "DLStorage.h"

@protocol DLFileStorageProtocol <NSObject>

- (NSData *)dataPresentation;

- (id)restoredObjectFromData:(NSData *)storedData;

@end

@interface DLFileStorage : DLStorage

@property (nonatomic, strong) NSString *directoryPath;

@property (nonatomic, assign) NSTimeInterval persistentInterval;

- (instancetype)initWithCache:(NSCache *)cache directoryPath:(NSString *)directoryPath;

- (void)saveItem:(id<DLFileStorageProtocol>)item toPath:(NSString *)relativePath;

- (id)loadItemFromPath:(NSString *)relativePath;

- (void)wipeDirectory;

- (void)wipeStorage;

@end
