//
//  ASFileDataSource.h
//  AppSDK
//
//  Created by PC Nguyen on 11/14/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ULViewDataSource.h"

@interface ASFileDataSource : ULViewDataSource

@property (nonatomic, strong) NSArray *fileList;

- (void)saveImage:(UIImage *)image;

- (UIImage *)imageForName:(NSString *)fileName;

@end
