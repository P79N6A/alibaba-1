//
//  CacheService.h
//  WHYFoundationKit
//
//  Created by JackAndney on 2017/5/14.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 
 缓存的类型：
 1、完全实时，不能使用缓存
 2、先实时请求，失败时再用有效的缓存数据
 3、优先使用有效的缓存数据，没有的情况下再进行请求。
 4、完全使用缓存(只要有了缓存数据，就不再进行请求，用的情况较少)。
 */
typedef NS_ENUM(NSInteger, EnumCacheMode) {
    CACHE_MODE_NOCACHE            = 10, // 实时请求，不使用缓存，也不会缓存数据
    CACHE_MODE_REALTIME           = 20, // 实时请求，请求失败后会使用缓存数据（有效期为10分钟）
    CACHE_MODE_HALFREALTIME_SHORT = 30, // 优先使用有效期为CACHE_VALID_TIME_SHORT的缓存数据，没有的情况下进行网络请求
    CACHE_MODE_HALFREALTIME_LONG  = 40, // 优先使用有效期为CACHE_VALID_TIME_LONG的缓存数据，没有的情况下进行网络请求
    CACHE_MODE_ALLCACHE           = 50, // 不考虑有效性，优先使用缓存数据。在没有缓存数据的情况下才会进行网络请求
};




@interface CacheService : NSObject

+ (CacheService *)shareInstance;

- (void)addCache:(NSString *)url content:(NSString *)content;
/** 根据缓存方式获取cache */
- (NSArray *)getCache:(NSString *)url cacheMode:(EnumCacheMode)cacheMode;

/** 根据有效时间获取cache */
- (NSArray *)getCacheByTime:(NSString *)url validTime:(NSTimeInterval)validTime;

/** 删除指定URL下的缓存数据 */
- (void)removeCache:(NSString *)url;

/** 清空数据库中的所有数据 */
- (void)cleanDBCache;

/** 清空网络请求的缓存数据 */
- (void)cleanNetworkCache;

/** 清除H5页面存储在LocalStorage中的数据 */
+ (void)clearLocalStorageData;

/** 清除浏览器的缓存数据 */
+ (void)clearWebCache;


@end
