//
//  UserDataCacheTool.m
//  SearchHistoryTest
//
//  Created by ct on 16/3/8.
//  Copyright © 2016年 ct. All rights reserved.
//

#import "UserDataCacheTool.h"

@interface UserDataCacheTool ()

@property (nonatomic, copy) NSString *cacheDirectory;//缓存路径

@end

@implementation UserDataCacheTool


+ (instancetype)sharedInstance
{
    static UserDataCacheTool *cacheTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheTool = [[UserDataCacheTool alloc] init];
    });
    return cacheTool;
}


#pragma mark -
#pragma mark - 搜索历史

- (NSArray *)getAllSearchHistory
{
    NSString *path = [self getCacheDirectoryWithPath:self.cacheDirectory];
    
    return [NSArray arrayWithContentsOfFile:path];
}


//根据搜索关键词添加一条记录
- (void)addItemByKeyword:(NSString *)keyword
{
    keyword = [keyword stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (keyword.length < 1) {
        return;
    }
    
    NSString *path = [self getCacheDirectoryWithPath:self.cacheDirectory];
    
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:path]];
    
    [tmpArray removeObject:keyword];
    [tmpArray insertObject:keyword atIndex:0];
    
    if (tmpArray.count > 5)
    {
        [tmpArray removeLastObject];
    }
    
    [tmpArray writeToFile:path atomically:YES];
}


- (void)addItemsWithArray:(NSArray *)keywordsArray
{
    NSString *path = [self getCacheDirectoryWithPath:self.cacheDirectory];
    
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:path]];
    
    //删除重复的数据
    for (NSString *keyword in keywordsArray)
    {
        [tmpArray removeObject:keyword];
    }
    
    //添加新数据
    for (int i = (int)keywordsArray.count-1; i > -1 ; i--)
    {
        NSString *keyword = keywordsArray[i];
        [tmpArray insertObject:keyword atIndex:0];
    }
    
    [tmpArray writeToFile:path atomically:YES];
}


//根据搜索关键词删除一条记录
- (void)deleteItemByKeyword:(NSString *)keyword
{
    NSString *path = [self getCacheDirectoryWithPath:self.cacheDirectory];
    
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:path]];

    [tmpArray removeObject:keyword];
    
    [tmpArray writeToFile:path atomically:YES];
}


//删除所有搜索记录
- (void)deleteAllItems
{
    NSString *path = [self getCacheDirectoryWithPath:self.cacheDirectory];
    
    NSArray *emptyArray = [NSArray new];
    [emptyArray writeToFile:path atomically:YES];
}


#pragma mark -
#pragma mark - 区域数据、区域和商圈数据、活动类型标签


//判断是否需要从服务器请求数据
- (BOOL)isDataNeedUpdate
{
    if ([[self getArrayData] count] < 1) {
        return YES;
    }
    
    NSDate *lastDate = [self getLastUpdateDate];
    
    NSString *dateStr = [DateTool dateStringForDate:lastDate formatter:@"yyyy-MM-dd HH:mm:ss"];

    
    if (_cacheType == UserDataCacheToolTypeAppUpdate) {
        if (lastDate && [DateTool dayCompare:[NSDate date] comparedDate:lastDate] != DaySame) {
            return YES;
        }else{
            return NO;
        }
    }
    
    if (lastDate && [DateTool dayCompare:lastDate comparedDate:[NSDate date]] == DaySame)
    {
        FBLOG(@"数据不需要更新……………………………………%@",dateStr);
        return NO;
    }
    return YES;
}

//获取所有活动类型标签
- (NSArray *)getArrayData
{
    NSString *path = [self getCacheDirectoryWithPath:self.cacheDirectory];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    return dict[@"data"];
}

//获取上次保存活动类型标签的日期
- (NSDate *)getLastUpdateDate
{
    NSString *path = [self getCacheDirectoryWithPath:self.cacheDirectory];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSString *dateStr = dict[@"updateDate"];
    
    return [DateTool dateForDateString:dateStr formatter:@"yyyy-MM-dd HH:mm:ss"];
}

//保存数据
- (void)saveDataArrayWithArray:(NSArray *)dataArray
{
    NSString *path = [self getCacheDirectoryWithPath:self.cacheDirectory];
    
    NSDictionary *dict = @{@"updateDate":[self getCurrentDateString], @"data":dataArray};
    [dict writeToFile:path atomically:YES];
}


// 删除数据
- (void)deleteCacheDataForType:(UserDataCacheToolType)type
{
    self.cacheType = type;
    NSString *path = [self getCacheDirectoryWithPath:self.cacheDirectory];
    
    NSArray *emptyArray = [NSArray new];
    [emptyArray writeToFile:path atomically:YES];
}

- (void)deleteAllCacheData
{
    [self deleteCacheDataForType:UserDataCacheToolTypeSearchHistory]; //活动搜索历史
    [self deleteCacheDataForType:UserDataCacheToolTypeSearchHistoryVenue]; //场馆搜索历史
    [self deleteCacheDataForType:UserDataCacheToolTypeHotKeywords]; // 热搜关键词
    [self deleteCacheDataForType:UserDataCacheToolTypeArea];
    [self deleteCacheDataForType:UserDataCacheToolTypeAreaAndBusinessDistrict];
    [self deleteCacheDataForType:UserDataCacheToolTypeActivityTypeTag];
    [self deleteCacheDataForType:UserDataCacheToolTypeVenueSearchTag];
    [self deleteCacheDataForType:UserDataCacheToolTypeNewTagDayCount];
    [self deleteCacheDataForType:UserDataCacheToolTypeActivityHotSearch];
    [self deleteCacheDataForType:UserDataCacheToolTypeVenueHotSearch];
    [self deleteCacheDataForType:UserDataCacheToolTypeCultureSpacingTag];
}




#pragma mark -
#pragma mark - Common Methods

- (NSString *)cacheDirectory
{
    NSArray *directoryArray = @[@"",@"SearchHistory.txt",@"HotKeywords.txt",@"Area.txt",@"AreaAndBusinessDistrict.txt",@"ActivityTypeTag.txt",@"VenueSearchTag.txt",@"NewTagDayCount.txt",@"ActivityHotSearch.data",@"VenueHotSearch.data",@"SearchHistoryVenue.txt",@"UpdateVersion.data",@"CultureSpacingTag.data"];
    return directoryArray[_cacheType];
}

//获取Documents目录
- (NSString *)getDocumentsDirectory
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}


- (NSString *)getCacheDirectoryWithPath:(NSString *)path
{
    NSString *targetPath = [NSString stringWithFormat:@"%@/%@",[self getDocumentsDirectory], path];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:targetPath] == NO)
    {
        [fileManager createFileAtPath:targetPath contents:nil attributes:nil];
        
        NSArray *emptyArray = [NSArray new];
        [emptyArray writeToFile:targetPath atomically:YES];
    }
    return targetPath;
}


- (NSString *)getCurrentDateString
{
    return [DateTool dateStringForDate:[NSDate date] formatter:@"yyyy-MM-dd HH:mm:ss"];
}

@end
