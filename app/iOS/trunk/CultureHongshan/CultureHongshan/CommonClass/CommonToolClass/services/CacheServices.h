//
//  CacheServices.h
//  徐家汇
//
//  Created by 李 兴 on 13-9-21.
//  Copyright (c) 2013年 李 兴. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CacheServices : NSObject


+(CacheServices *) shareInstance;
-(void)addCache:(NSString *)url  content:(NSString *)content;
/** 根据缓存方式获取cache */
-(NSArray *)getCache:(NSString *)url cacheMode:(EnumCacheMode)cacheMode;
/** 根据有效时间获取cache */
-(NSArray *)getCacheByTime:(NSString *)url validTime:(NSTimeInterval)validTime;
-(void)removeCache:(NSString *)url;
-(void)cleanCache;


/**
 清除所有可以清除的缓存数据
 */
+ (void)clearAllCacheData;


/**
 退出登录时的清除缓存数据
 */
+ (void)clearCacheDataWhenLogout;

/**
 *  清除H5页面存储在LocalStorage中的数据
 */
+ (void)clearLocalStorageData;


+ (void)clearWebCache;


@end
