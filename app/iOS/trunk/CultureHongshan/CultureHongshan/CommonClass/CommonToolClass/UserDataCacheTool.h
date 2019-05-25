//
//  UserDataCacheTool.h
//  SearchHistoryTest
//
//  Created by ct on 16/3/8.
//  Copyright © 2016年 ct. All rights reserved.
//

#import <Foundation/Foundation.h>

//定义枚举类型
typedef enum {
    UserDataCacheToolTypeNone = 0,
    UserDataCacheToolTypeSearchHistory = 1,//搜索活动历史
    UserDataCacheToolTypeHotKeywords = 2,//热搜关键词
    UserDataCacheToolTypeArea = 3,//区域，个人中心里的区域设置要用
    UserDataCacheToolTypeAreaAndBusinessDistrict  = 4,//区域和商圈
    UserDataCacheToolTypeActivityTypeTag = 5, //活动类型标签数据,即用户选择的标签
    UserDataCacheToolTypeVenueSearchTag = 6, //场馆搜索标签数据
    UserDataCacheToolTypeNewTagDayCount = 7, //“新”小时数
    UserDataCacheToolTypeActivityHotSearch = 8,//活动热门搜索
    UserDataCacheToolTypeVenueHotSearch = 9,//场馆热门搜索
    UserDataCacheToolTypeSearchHistoryVenue = 10,//搜索场馆历史
    UserDataCacheToolTypeAppUpdate,//App更新
    UserDataCacheToolTypeCultureSpacingTag,//文化空间标签
} UserDataCacheToolType;



@interface UserDataCacheTool : NSObject



+ (instancetype)sharedInstance;

@property (nonatomic, assign) UserDataCacheToolType cacheType;


#pragma mark -
#pragma mark - 搜索历史

//获取数据
- (NSArray *)getAllSearchHistory;

//添加数据
- (void)addItemByKeyword:(NSString *)keyword;
- (void)addItemsWithArray:(NSArray *)keywordsArray;

//删除数据
- (void)deleteItemByKeyword:(NSString *)keyword;//根据搜索关键词删除一条记录
- (void)deleteAllItems;//删除所有搜索记录



#pragma mark -
#pragma mark - 区域数据、区域和商圈数据、活动类型标签

- (BOOL)isDataNeedUpdate;//检查是否需要更新数据
- (NSArray *)getArrayData;//获取数据
- (void)saveDataArrayWithArray:(NSArray *)dataArray;//保存数据
- (void)deleteCacheDataForType:(UserDataCacheToolType)type;
- (void)deleteAllCacheData;


@end
