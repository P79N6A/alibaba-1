//
//  MYArchivedObject.h
//  WHYFoundationKit
//
//  Created by AndneyJack on 2017/5/18.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 实现 自动归档 和解档 的基类
 */
@interface MYArchivedObject : NSObject <NSCoding>


+ (nullable id)unarchiveObjectForPath:(nonnull NSString *)path;
+ (void)archiveObject:(nonnull MYArchivedObject *)obj forPath:(nonnull NSString *)path;

@end
