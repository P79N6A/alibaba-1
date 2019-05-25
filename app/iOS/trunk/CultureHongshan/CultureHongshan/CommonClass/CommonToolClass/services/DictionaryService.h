//
//  DictionaryService.h
//  CultureHongshan
//
//  Created by ct on 16/4/19.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DictionaryService : NSObject


+ (void)loadDictionary;

+ (void)resetActivityTags; // 登录成功后，重置活动的标签，并请求标签数据

+(NSArray *)getAllActTags;
+(NSArray *)getUserActTagsWithFirstTitle:(NSString * )title;
+(NSArray *)allowStatisticsUrlList; // 需要统计的接口地址（每次有新增接口时，都要更新这个数据）
+(NSArray *)getArea;
+(NSArray *)getSmartOrder;
+(NSString *)getSmartOrderValue:(NSString *)order;
+(NSArray *)getFilter;
+(NSDictionary *)getFilterValue:(NSString *)filter;
+(NSDictionary *)getAreaCode:(NSString *)area;
+(NSString *)getTagIdByName:(NSString *)tagName;
+(NSArray *)getAllTagNames;

+(NSArray *)getAllCultureSpacingTags;// 文化空间Tags
+(NSArray *)getSmartOrderArrayOfVenue;// 智能排序
+(NSArray *)getFilterArrayOfVenue;// 筛选
+ (NSString *)getSmartOrderValueOfVenue:(NSString *)order;
+(NSString *)getFilterValueOfVenue:(NSString *)filter;

// 日历标签
+ (void)resetCalendarListTags; // 切换城市后，需重新请求标签数据
+ (NSArray *)getCalendarListTagsWithFirstTitles:(NSArray<NSString *> *)titles completionBlock:(void(^)(NSArray *))block;
+ (NSString *)getCalendarTagIdWithTagName:(NSString *)tagName;



/**
 * "新"标签的小时数
 *
 */
+ (void)getActivityNewTagHourCount;


@end
