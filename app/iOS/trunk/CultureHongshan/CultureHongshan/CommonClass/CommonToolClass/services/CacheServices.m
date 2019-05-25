//
//  CacheServices.m
//  徐家汇
//
//  Created by 李 兴 on 13-9-21.
//  Copyright (c) 2013年 李 兴. All rights reserved.
//

#import "CacheServices.h"
#import "DBServices.h"
#import "UserDataCacheTool.h"

#define  CACHE_VALID_TIME_FOR_REALTIME 60*10 // http实时请求失败后获取缓存数据的有效生存时间，秒为单位
#define  CACHE_VALID_TIME_LONG         60*30 // http请求数据的短的缓存生存时间，秒为单位


@implementation CacheServices

+(CacheServices *) shareInstance
{
    static CacheServices * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        NSString * sql = @"create table if not exists localcache(id integer primary key autoincrement,rid integer,url varchar(500),content text,crdate TIMESTAMP default (datetime('now', 'localtime')),status integer)";
        [[DBServices shareInstance] exec:sql];
    });
    
    return instance;
}

-(void)addCache:(NSString *)url  content:(NSString *)content
{
    url = [url stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    [self removeCache:url];
    
    content = [content stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    NSString * sql = [NSString stringWithFormat:@"insert into localcache(url,content) values('%@','%@')",url,content];
    [[DBServices shareInstance] exec:sql];
}

-(void)removeCache:(NSString *)url
{
    url = [url stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    NSString * sql = [NSString stringWithFormat:@"delete from localcache where url like '%@%%' ",url];
    [[DBServices shareInstance] exec:sql];
}

-(NSArray *)getCache:(NSString *)url cacheMode:(EnumCacheMode)cacheMode {
    
    if (url.length) {
        NSTimeInterval validTime = 863000;
        switch (cacheMode) {
            case CACHE_MODE_NOCACHE: {
                return nil;
            }
                break;
            case CACHE_MODE_REALTIME: {
                validTime = CACHE_VALID_TIME_FOR_REALTIME;
            }
                break;
            case CACHE_MODE_HALFREALTIME_SHORT: {
                validTime = CACHE_VALID_TIME_SHORT;
            }
                break;
            case CACHE_MODE_HALFREALTIME_LONG: {
                validTime = CACHE_VALID_TIME_LONG;
            }
                break;
            case CACHE_MODE_ALLCACHE: {
                validTime = 0;
            }
                break;
                
            default:
                break;
        }
        
        NSString *sql = nil;
        if (validTime > 0) {
            sql = [NSString stringWithFormat:@"select content from localcache where url='%@' and (strftime('%%s','now','localtime')-strftime('%%s',crdate)) < %f   order by id desc  limit 1",url,validTime];
        }else {
            sql = [NSString stringWithFormat:@"select content from localcache where url='%@' order by id desc  limit 1 ",url];
        }
        return [[DBServices shareInstance] query:sql];
    }
    return nil;
}

-(NSArray *)getCacheByTime:(NSString *)url validTime:(NSTimeInterval)validTime
{
    url = [url stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    NSString * sql = [NSString stringWithFormat:@"select content from localcache where url='%@' and (strftime('%%s','now','localtime')-strftime('%%s',crdate)) < %f   order by id desc  limit 1",url,validTime];
    NSArray * ary =  [[DBServices shareInstance] query:sql];
    return ary;
}

-(void)cleanCache
{
    [[DBServices shareInstance] exec:@"delete  from localcache"];
}

#pragma mark -  ————————————— 清除缓存 ———————————

// 清除所有可以清除的缓存数据
+ (void)clearAllCacheData
{
    [[UserDataCacheTool sharedInstance] deleteAllCacheData];
    
//    [CacheServices clearLocalStorageData];
    [CacheServices clearWebCache];
    [[CacheServices shareInstance] cleanCache];
    
    [[SDImageCache sharedImageCache] clearMemory];
}


// 退出登录时的清除缓存数据
+ (void)clearCacheDataWhenLogout
{
    [UserService removeUser];
    
    [CacheServices clearWebCache];
    [CacheServices clearLocalStorageData];
}


// 清除H5页面存储在LocalStorage中的数据
+ (void)clearLocalStorageData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *localStoragePath = [userDefaults valueForKey:@"WebKitLocalStorageDatabasePathPreferenceKey"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:localStoragePath];
    NSError *error = nil;
    for (NSString *subPath in enumerator.allObjects) {
        if ([subPath.lowercaseString hasSuffix:@".localstorage"] && [subPath rangeOfString:@"/"].location == NSNotFound) {
            NSString *targetPath = [NSString stringWithFormat:@"%@/%@",localStoragePath, subPath];
            [fileManager removeItemAtPath:targetPath error:&error];
            if (error) {
                
            }
        }
    }
}

+ (void)clearWebCache
{
    /*
        在应用处于前台时，清除WebView的缓存不会立即生效，需等到下次应用启动后才可以。
     
     WebDatabaseDirectory
     */
    
    //清除cookies
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] removeCookiesSinceDate:[NSDate distantPast]];
    
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}



@end
