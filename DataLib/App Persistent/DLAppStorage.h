//
//  DLAppStorage.h
//  AppSDK
//
//  Created by PC Nguyen on 10/10/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "DLStorage.h"

@interface DLAppStorage : DLStorage

- (void)saveValue:(id)value forKey:(NSString *)key;

- (id)loadValueForKey:(NSString *)key;

@end
