//
//  DSFileManager.h
//  DataSDK
//
//  Created by PC Nguyen on 4/30/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLFileManager : NSFileManager

+ (DLFileManager *)sharedManager;

- (NSURL *)urlForDocumentsDirectory;

- (void)applyClassBProtectionForFileAtPath:(NSString *)path;

@end
