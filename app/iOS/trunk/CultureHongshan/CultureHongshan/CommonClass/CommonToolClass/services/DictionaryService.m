//
//  DictionaryService.m
//  CultureHongshan
//
//  Created by ct on 16/4/19.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "DictionaryService.h"

#import "AppProtocolMacros.h"

#import "UserDataCacheTool.h"
#import "UserTagServices.h"
#import "CitySwitchModel.h"

#import "TagModel.h"

#import "ActivityFilterModel.h"
#import "CultureSpacingTagModel.h"


typedef enum : NSUInteger {
    RequestNumTypeArea = 0,// 地区、商圈
    RequestNumTypeActTags, // 活动标签
    RequestNumTypeVenuetTags,// 文化空间（场馆）标签
    RequestNumTypeCalendarTags,// 文化日历标签
} RequestNumType;



@implementation DictionaryService

int requestNum[10]; //  记录同一个请求的次数

static NSArray * statUrlList; // 数据统计的URL

static NSArray * actTagArray;
static NSArray * areaArray;
static NSArray * cultureSpacingTagArray;
static NSArray * calendarListTagArray;

static NSMutableArray * cityList;// 城市列表数据


+ (void)loadDictionary
{
    actTagArray = nil;
    areaArray = nil;
    cultureSpacingTagArray = nil;
        
    [DictionaryService InitActivityDictionary];
    [DictionaryService initAreaData];
    [DictionaryService initCultureSpacingTagDictionary];
    
    [DictionaryService initCalendarListTagData:nil];
}


#pragma mark -

// 地区和地区下的商圈
+(void)initAreaData
{
    [AppProtocol getActivityAllAreaAndBussinessRegionUsingBlock:^(HttpResponseCode responseCode, id responseObject)
     {
         @try {
             if (responseCode == HttpResponseSuccess)
             {
                 NSArray * ary = [NSArray arrayWithObject:responseObject];
                 if (ary.count > 0) {
                     areaArray = ary[0];
                     requestNum[RequestNumTypeArea] = 0;
                     return;
                 }
                 requestNum[RequestNumTypeArea]++;
                 if (requestNum[RequestNumTypeArea] < 3) {// 请求失败时，连续请求不超过3次。
                     [DictionaryService initAreaData];
                 }
             }
         } @catch (NSException *exception) {
             
         } @finally {
             
         }
     }];
}


//文化空间（场馆）的标签数据
+ (void)initCultureSpacingTagDictionary
{
    [AppProtocol getTagListOfCultureSpacingUsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        
        @try
        {
            if (responseCode == HttpResponseSuccess)
            {
                if ([responseObject count])
                {
                    cultureSpacingTagArray = [NSArray arrayWithArray:responseObject];
                    requestNum[RequestNumTypeVenuetTags] = 0;
                    return;
                }
            }
            requestNum[RequestNumTypeVenuetTags] += 1;
            if (requestNum[RequestNumTypeVenuetTags] < 3){
                [DictionaryService initCultureSpacingTagDictionary];
            }
        } @catch (NSException *exception)
        {
        }
    }];
}


+(void)InitActivityDictionary
{
    [AppProtocol getTagListOfActivityWithUserId:[UserService sharedService].userId UsingBlock:^(HttpResponseCode responseCode, id responseObject)
     {
         @try
         {
             if (responseCode == HttpResponseSuccess)
             {
                 NSArray * ary = [ThemeTagModel listArrayWithArray:responseObject];
                 if (ary.count > 1)
                 {
                     actTagArray = [NSArray arrayWithArray:ary[1]];
                     requestNum[RequestNumTypeActTags] = 0;
                     return;
                 }
                 requestNum[RequestNumTypeActTags]++;
                 if (requestNum[RequestNumTypeActTags] < 3) {
                     [DictionaryService InitActivityDictionary];
                 }
             }
         } @catch (NSException *exception)
         {
         }
     }];
}


/**
 登录后，重置活动的标签数据
 */
+ (void)resetActivityTags {
    actTagArray = nil;
    [DictionaryService InitActivityDictionary];
}



#pragma mark -


+ (NSArray * )getArea
{
    if (areaArray != nil || areaArray.count > 0)
    {
        return areaArray;
    }
    [DictionaryService initAreaData];
    return [NSArray  new];
}

+ (NSDictionary *)getAreaCode:(NSString *)area
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    dic[@"activityArea"] = @"";
    dic[@"activityLocation"] = @"";
    if (area == nil || area.length == 0 || areaArray == nil || areaArray.count == 0)
    {
        return dic;
    }
    for (AreaFilterListModel * model in areaArray)
    {
        
        if (model.listArray == nil || model.listArray.count == 0)
        {
            continue;
        }
        for (AreaFilterModel * m in model.listArray)
        {
            if ([m.conditionName isEqualToString:area])
            {
                dic[@"activityArea"] = model.conditionId;
                dic[@"activityLocation"] =  m.conditionId;
                break;
            }
        }
        if ([dic[@"activityLocation"] length] > 0)
        {
            break;
        }
        
    }
    
    
    return dic;
}


+ (NSArray *)getUserActTagsWithFirstTitle:(NSString * )title
{
    NSArray *tagArray = nil;
    NSString *jsonTagString = [[UserTagServices getInstance] getUserTag:[UserService sharedService].userId citycode:CITY_AD_CODE];
    if (jsonTagString.length) {
        tagArray = [NSJSONSerialization JSONObjectWithData:[jsonTagString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        if (tagArray.count) {
            NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:[ThemeTagModel listArrayWithArray:tagArray][1]];
            if (title.length && tmpArray.count) {
                ThemeTagModel *model = [ThemeTagModel new];
                model.tagId = @"0";
                model.tagName = title;
                
                [tmpArray insertObject:model atIndex:0];
            }
            return tmpArray;
        }
    }
    
    tagArray = [DictionaryService getAllActTags];
    
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:tagArray];
    if (title.length && tmpArray.count) {
        ThemeTagModel *model = [ThemeTagModel new];
        model.tagId = @"0";
        model.tagName = title;
        [tmpArray insertObject:model atIndex:0];
    }
    
    return tmpArray;
}


+ (NSArray *)getAllTagNames
{
    NSArray * tag = [DictionaryService getAllActTags];
    if (tag && tag.count > 0)
    {
        NSMutableArray * retDic = [[NSMutableArray alloc] initWithCapacity:tag.count + 1];
        [retDic addObject:@"全部"];
        for (ThemeTagModel * model in tag)
        {
            [retDic addObject:model.tagName];
        }
        return retDic;
    }
    return [[NSMutableArray alloc] initWithCapacity:1];
}

+(NSString *)getTagIdByName:(NSString *)tagName
{
    if([tagName isEqualToString:@"全部"])
    {
        return @"";
    }
    NSArray * tag = [DictionaryService getAllActTags];
    if (tag && tag.count > 0)
    {
        for (ThemeTagModel * model in tag)
        {
            if ([tagName isEqualToString:model.tagName])
            {
                return model.tagId;
            }
        }
    }
    return @"";
}

+(NSArray *)getAllActTags
{
    if (actTagArray.count > 0  )
    {
        return actTagArray;
    }
    else
    {
        // 没有数据时从网络上获取，不再使用默认值
        [DictionaryService InitActivityDictionary];
        return [NSArray new];
    }
}

/**
 *  要统计的接口地址
 */
+(NSArray *)allowStatisticsUrlList
{
    if (statUrlList == nil)
    {
        /*
         v3.5.3  v3.5.4(忘记修改了)
            @[kTopActivityUrl,kRecommendActivityUrl,kNearLocationActivityAllUrl,kAppEveryDateActivityList,kVenueFilterListUrl,kActivityDetailUrl,kVenueDetailUrl]
         
         v3.5.4.1
         
         */
        statUrlList = @[kActivityYouMayLoveUrl, // 首页
                        kNearLocationActivityAllUrl, // 附近活动
                        kGetExhibitionHallAllUrl, // 附近场馆
                        kCultureCalendarListUrl, // 文化日历
                        kTopActivityUrl, // 文化活动
                        kVenueFilterListUrl, // 文化空间
                        kActivityDetailUrl, // 活动详情
                        kVenueDetailUrl, // 场馆详情
                        kSearchActivityUrl, // 活动搜索
                        kSearchVenueUrl, // 场馆搜索
                        kMyCalendarActivityListUrl, // 我的日历(5个月内)
                        kMyCalendarHistoryActivityUrl, // 我的日历（已参加）
                        ];
        //首页 附近 日历 活动list 活动detail 场馆list 场馆detail
    }
    return statUrlList;
    
}

+ (void)getActivityNewTagHourCount
{
    UserDataCacheTool *cacheTool = [UserDataCacheTool sharedInstance];
    cacheTool.cacheType = UserDataCacheToolTypeNewTagDayCount;
    if ([cacheTool isDataNeedUpdate])
    {
        [AppProtocol getAcitivitySearchHotKeywordsAndNewTagWithType:@"1" UsingBlock:^(HttpResponseCode responseCode, id responseObject)
         {
             
         }];
    }
}


+(NSArray *)getSmartOrder
{
    return @[@"智能排序",@"热门排序",@"最新上线",@"即将结束",@"离我最近"];
}

+(NSString *)getSmartOrderValue:(NSString *)order
{
    //1-智能排序 2-热门排序 3-最新上线 4-即将结束 5-离我最近
    NSArray * ary = [self getSmartOrder];
    for (int i=0; i<ary.count; i++)
    {
        if ([order isEqualToString:ary[i]])
        {
            return StrFromInt(i+1);
        }
    }
    return @"";
}


+(NSArray *)getFilter
{
    return @[@"全部",@"免费",@"在线预订"];
}


+(NSDictionary *)getFilterValue:(NSString *)filter
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    dic[@"activityIsFree"] = @"";
    dic[@"activityIsReservation"] = @"";
    
    if ([filter isEqualToString:@"免费"])
    {
       dic[@"activityIsFree"] = @"1";
    }
    else if ([filter isEqualToString:@"收费"])
    {
        dic[@"activityIsFree"] = @"2";
    }
    else if ([filter isEqualToString:@"不可预订"])
    {
        dic[@"activityIsReservation"] = @"1";
    }
    else if ([filter isEqualToString:@"在线预订"])
    {
        dic[@"activityIsReservation"] = @"2";
    }
    //activityIsFree 是否收费 1-免费 2-收费
    //activityIsReservation    是否预订 1-不可预订 2-可预订
    
    return dic;
}


#pragma mark - ————————————————  文化空间  ——————————————

+ (NSArray *)getAllCultureSpacingTags
{
    if (cultureSpacingTagArray && cultureSpacingTagArray.count) {
        return cultureSpacingTagArray;
    }else {
        [self initCultureSpacingTagDictionary];
        return @[];
    }
}


// 智能排序
+(NSArray *)getSmartOrderArrayOfVenue
{
    return @[@"热门程度",@"离我最近"];
}

// 筛选
+(NSArray *)getFilterArrayOfVenue
{
    return @[@"可预订",@"全部"];
}

+ (NSString *)getSmartOrderValueOfVenue:(NSString *)order
{
    //热门程度 -- 1,   离我最近 --- 2    为空时：按更新时间排序
    NSArray *array = [self getSmartOrderArrayOfVenue];
    for (int i = 0; i < array.count; i++) {
        if ([array[i] isEqualToString:order]) {
            return StrFromInt(i+1);
        }
    }
    return @"";
}

+(NSString *)getFilterValueOfVenue:(NSString *)filter
{
    if ([filter isEqualToString:@"可预订"]) {
        return @"2";
    }
    return @"1";
}

#pragma mark - 日历标签

+ (void)initCalendarListTagData:(void(^)(NSArray *tagArray))block {
    
    [AppProtocol getTagListOfActivityWithUserId:[UserService sharedService].userId UsingBlock:^(HttpResponseCode responseCode, id responseObject)
     {
         @try
         {
             if (responseCode == HttpResponseSuccess)
             {
                 NSArray * ary = [ThemeTagModel listArrayWithArray:responseObject];
                 if (ary.count > 1)
                 {
                     calendarListTagArray = [NSArray arrayWithArray:ary[1]];
                     requestNum[RequestNumTypeCalendarTags] = 0;
                     if (block) {
                         block(calendarListTagArray);
                     }
                     return;
                 }
                 requestNum[RequestNumTypeCalendarTags]++;
                 if (requestNum[RequestNumTypeCalendarTags] < 3) {
                     [DictionaryService initCalendarListTagData:block];
                 }
             }
         } @catch (NSException *exception)
         {
         }
     }];
}

+ (void)resetCalendarListTags {
    calendarListTagArray = nil;
    requestNum[RequestNumTypeCalendarTags] = 0;
    [DictionaryService initCalendarListTagData:nil];
}

+ (NSArray *)getCalendarListTagsWithFirstTitles:(NSArray<NSString *> *)titles completionBlock:(void(^)(NSArray *))block {
    if (calendarListTagArray.count) {
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:calendarListTagArray.count];
        if (titles.count) {
            for (NSString *tagTitle in titles) {
                ThemeTagModel *model = [ThemeTagModel new];
                model.tagId = [DictionaryService getCalendarTagIdWithTagName:tagTitle];
                model.tagName = tagTitle;
                [tmpArray addObject:model];
            }
        }
        
        [tmpArray addObjectsFromArray:calendarListTagArray];
        return tmpArray;
    }else {
        if (block) { [DictionaryService initCalendarListTagData:block]; }
        return @[];
    }
}

+ (NSString *)getCalendarTagIdWithTagName:(NSString *)tagName {
    // 全部，传空； 附近，传0
    if (tagName.length) {
        if ([tagName isEqualToString:@"全部"]) {
            return @"";
        }else if ([tagName isEqualToString:@"附近"]) {
            return @"0";
        }else {
            for (ThemeTagModel *tagModel in calendarListTagArray) {
                if ([tagName isEqualToString:tagModel.tagName]) {
                    return tagModel.tagId;
                }
            }
        }
    }
   
    return @""; // 全部
}
@end
