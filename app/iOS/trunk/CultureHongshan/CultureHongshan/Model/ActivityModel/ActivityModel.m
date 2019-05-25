//
//  ActivityModel.m
//  CultureHongshan
//
//  Created by ct on 15/11/7.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "ActivityModel.h"

#import "UserDataCacheTool.h"

#import "ActivitySubModel.h"
#import "JiaDingTicketModel.h"
#import "LocationService2.h"


@interface ActivityModel ()

@property (nonatomic,assign) BOOL isJiaDingData;//是否为嘉定数据: sysNo为1,sysId不为空
@property (nonatomic,assign) BOOL activityIsRecommend;//是否推荐
@property (nonatomic,assign) BOOL activityIsHot;//是否热
@property (nonatomic,copy) NSString *tagRGB;//标签的颜色
@property (nonatomic,copy) NSString *tagInitial;//标签的首字母
@property (nonatomic,strong) UIColor *activityPriceColor;//活动价格的显示颜色
@property (nonatomic,copy) NSString *activityUpdateTime;//活动最后更新时间,判断是否为新活动
@property (nonatomic,copy) NSString *activityArea;//活动的区域（商圈）

@property (nonatomic,copy) NSString *activityStartTime;//活动开始时间
@property (nonatomic,copy) NSString *activityEndTime;//活动结束时间
@property (nonatomic,copy) NSString *sysId;

@end



@implementation ActivityModel

- (id)initWithAttributes:(NSDictionary *)itemDict
{
    if (self = [super init])
    {
        if (itemDict == nil || ![itemDict isKindOfClass:[NSDictionary class]])
        {
            return nil;
        }
        
        NSInteger sysNo = [itemDict safeIntegerForKey:@"sysNo"];
        self.sysId = [itemDict safeStringForKey:@"sysId"];
        self.isJiaDingData = (sysNo == 1 && _sysId.length) ? YES : NO;//是否为嘉定的数据
        
        self.activityId      = [itemDict safeStringForKey:@"activityId"];
        self.activityLat     = [itemDict safeDoubleForKey:@"activityLat"];
        self.activityLon     = [itemDict safeDoubleForKey:@"activityLon"];
        self.activityName    = [itemDict safeStringForKey:@"activityName"];
        self.activityIconUrl = [itemDict safeImgUrlForKey:@"activityIconUrl"];
        
        self.activityStartTime  = [itemDict safeStringForKey:@"activityStartTime"];
        self.activityEndTime    = [itemDict safeStringForKey:@"activityEndTime"];
        self.activityUpdateTime = [itemDict safeStringForKey:@"activityUpdateTime"];//活动的最后更新时间
        self.showedActivityDate = [itemDict safeStringForKey:@"eventDateTime"];
        if (self.showedActivityDate.length == 0) {
            self.showedActivityDate = [self getShowedActivityDate];
        }
        
        
        self.activityIsRecommend   = [[itemDict safeStringForKey:@"activityRecommend"] isEqualToString:@"Y"];//Y-推荐 N-不推荐
        self.activityIsHot         = [itemDict safeIntegerForKey:@"activityIsHot"] == 1;//是否是热门活动 0-否 1-是
        self.activityIsPast        = [itemDict safeIntegerForKey:@"activityPast"] == 1;//活动过期: 0.未过期 1. 过期
        self.activityIsReservation = [itemDict safeIntegerForKey:@"activityIsReservation"] == 2;//是否可预订 1：否 2：是
        self.activitySupplementType = [itemDict safeIntegerForKey:@"activitySupplementType"];
        self.activityIsSalesOnline = [[itemDict safeStringForKey:@"activitySalesOnline"] isEqualToString:@"Y"];//Y-在线选座  N-直接前往
        self.activityIsCollect     = [itemDict safeIntegerForKey:@"activityIsCollect"] == 1;
        self.activityIsSecKill     = [itemDict safeIntegerForKey:@"spikeType"] == 1;
        
        
        self.activityAbleCount = [itemDict safeIntegerForKey:@"activityAbleCount"];//余票 availableCount  activityAbleCount
        if (self.activityAbleCount == 0) {
            self.activityAbleCount = [itemDict safeIntegerForKey:@"availableCount"];
        }
        
        self.activitySubject   = [itemDict safeStringForKey:@"activitySubject"];//7个字标签:萌娃最爱
        self.jointedTagArray   = [self getJointedTagArray:itemDict];
        
        NSString *areaStr = [itemDict safeStringForKey:@"activityArea"];//活动区域（商圈）
        if (areaStr.length) {
            areaStr = [areaStr stringByReplacingOccurrencesOfString:@":" withString:@","];
            NSArray *components = [areaStr componentsSeparatedByString:@","];
            self.activityArea = [components lastObject];
        } else {
            self.activityArea = @"";
        }
        
        //距离   地址:activityAddress   地点:activitySite
        self.distance = [itemDict safeStringForKey:@"distance"];
        self.showedDistance = [self getShowedDistance];
        self.activityAddress = [itemDict safeStringForKey:@"activityAddress"];//activitySite activityAddress
        if (_activityAddress.length < 1)
        {
            self.activityAddress = [itemDict safeStringForKey:@"activitySite"];
        }
        //商圈＋场馆名
        self.activityLocationName = [itemDict safeStringForKey:@"activityLocationName"];
        if (self.activityLocationName.length < 1)
        {
            self.activityLocationName = self.activityAddress;
            self.venueName = self.activityAddress;
        }else{
            NSString *locationName = [NSString stringWithString:_activityLocationName];
            locationName = [locationName stringByReplacingOccurrencesOfString:@". " withString:@"."];
            self.venueName = [[locationName componentsSeparatedByString:@"."] lastObject];
        }
        
        //价格
        self.showedPrice = MYActPriceHandle([itemDict safeIntegerForKey:@"activityIsFree"], [itemDict safeIntegerForKey:@"priceType"], [itemDict safeStringForKey:@"activityPrice"], [itemDict safeStringForKey:@"activityPayPrice"]);
        
        /* 文化日历相关属性 */
        self.orderOrCollect = [itemDict safeIntForKey:@"orderOrCollect"];
        self.activityIsReserved = [itemDict safeIntForKey:@"activityIsReserved"];
    }
    return self;
}


//日期
- (NSString *)getShowedActivityDate
{
    NSString *showedActivityDate = @"";
    
    NSString *startTime = [DateTool dateStringForDate:[DateTool dateForDateString:_activityStartTime formatter:@"yyyy-MM-dd"] formatter:@"MM.dd"];
    NSString *endTime = [DateTool dateStringForDate:[DateTool dateForDateString:_activityEndTime formatter:@"yyyy-MM-dd"] formatter:@"MM.dd"];
    
    if (startTime.length && endTime.length && ![startTime isEqualToString:endTime])
    {
        showedActivityDate = [[NSString alloc] initWithFormat:@"%@-%@",startTime,endTime];
    }
    else
    {
        showedActivityDate = startTime;
    }
    return showedActivityDate;
}

//距离
- (NSString *)getShowedDistance
{
    if (_isJiaDingData || _distance.length < 1 || [LocationService2 sharedService].havePosition==NO)
    {
        return @"——";
    }
    return [ToolClass getDistance:[_distance doubleValue]];
}



// 在线预订、绘画、萌娃最爱
- (NSArray *)getJointedTagArray:(NSDictionary *)dict
{
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:1];
    
    NSString *tagName = [dict safeStringForKey:@"tagName"];
    if (tagName.length) {
        self.activityType = [[ToolClass getComponentArray:tagName separatedBy:@","] firstObject];
    }else{
        self.activityType = @"";
    }
    
    if (_activityType.length) {
        [tmpArray addObject:_activityType];
    }
    
    NSMutableArray *tagArray = [NSMutableArray new];
    
    NSArray *subListArray = [dict safeArrayForKey:@"subList"];
    
    for (int i = 0 ; i < subListArray.count; i++) {
        NSDictionary *item = subListArray[i];
        if ([item isKindOfClass:[NSDictionary class]]) {
            NSString *tagName = [item safeStringForKey:@"tagName"];
            if (tagName.length) {
                if (i < 2) {
                    [tmpArray addObject:tagName];
                    if (![tmpArray containsObject:tagName]) {
                        [tmpArray addObject:tagName];
                    }
                }
                
                if (![tagArray containsObject:tagName]) {
                    [tagArray addObject:tagName];
                }
            }
        }
    }
    self.activityTagArray = tagArray;
    
    return tmpArray;
}


+ (NSArray *)listArrayWithArray:(NSArray *)array
{
    return [self listArrayWithArray:array removedActivityId:nil];
}

+ (NSArray *)listArrayWithArray:(NSArray *)array removedActivityId:(NSString *)activityId
{
    if(![array isKindOfClass:[NSArray class]] || !array)
    {
        return @[];
    }
    
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    for (NSDictionary *item in array)
    {
        if (activityId.length && [[item safeStringForKey:@"activityId"] isEqualToString:activityId]) {
            continue;
        }
        
        ActivityModel *model = [[ActivityModel alloc] initWithAttributes:item];
        if (model) {
            [tmpArray addObject:model];
        }
    }
    return [tmpArray copy];
}




/** 活动的余票数 */
+ (NSInteger)getActAbleCount:(NSDictionary *)dict {
    
    return 0;
}


@end
