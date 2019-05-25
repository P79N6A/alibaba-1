//
//  ActivityListDetail.m
//  CultureHongshan
//
//  Created by xiao on 15/7/9.
//  Copyright (c) 2015年 Sun3d. All rights reserved.
//

#import "ActivityDetail.h"

@interface ActivityDetail ()

@property (nonatomic, assign) BOOL activityIsPast;//是否过期
@property (copy, nonatomic) NSString *activitySite;
@property (copy, nonatomic) NSString *activityVenue;//活动所属的场馆名

@end


@implementation ActivityDetail

-(id)initWithAttributes:(NSDictionary *)dictionary
{
    if(self = [super init])
    {
        if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]])
        {
            return nil;
        }
        
        self.activityLon           = [dictionary safeDoubleForKey:@"activityLon"];
        self.activityIconUrl       = [dictionary safeImgUrlForKey:@"activityIconUrl"];
        self.activityIsReservation = [dictionary safeIntegerForKey:@"activityIsReservation"]==2;//是否可预订 1 否 2是
        self.activitySupplementType = [dictionary safeIntegerForKey:@"activitySupplementType"];
        self.activityIsSalesOnline   = [[dictionary safeStringForKey:@"activitySalesOnline"] isEqualToString:@"Y"];
        self.activityIsCollect     = [dictionary safeIntegerForKey:@"activityIsCollect"] == 1;
        self.activityIsPast        = [dictionary safeIntegerForKey:@"activityIsPast"] == 1;
        
        self.activityId        = [dictionary safeStringForKey:@"activityId"];
        self.activityAddress   = [dictionary safeStringForKey:@"activityAddress"];
        self.activityTel       = [dictionary safeStringForKey:@"activityTel"];
        self.activityName      = [dictionary safeStringForKey:@"activityName"];
        self.activityLat       = [dictionary safeDoubleForKey:@"activityLat"];
        self.activityAbleCount = [dictionary safeIntegerForKey:@"activityAbleCount"];
        
        //活动详情
        NSString *detailStr = [dictionary safeStringForKey:@"activityMemo"];
        if (detailStr.length) {
            self.activityMemo = detailStr.isPlainText ? [NSString stringWithFormat:@"<p>%@</p>",detailStr] : detailStr;
        }else {
            self.activityMemo = @"";
        }
        
        self.activityEventimes = [dictionary safeStringForKey:@"activityEventimes"];
        self.activityEventIds = [dictionary safeStringForKey:@"activityEventIds"];
        
        //价格
        self.priceDescribe = [dictionary safeStringForKey:@"priceDescribe"];
        self.actIsFree = [dictionary safeIntegerForKey:@"activityIsFree"];
        self.showedPrice = MYActPriceHandle(self.actIsFree, [dictionary safeIntegerForKey:@"priceType"], [dictionary safeStringForKey:@"activityPrice"], [dictionary safeStringForKey:@"activityPayPrice"]);
        
        self.status = [dictionary safeStringForKey:@"status"];
        self.shareUrl = [dictionary safeStringForKey:@"shareUrl"];
        self.activityIsWant = [dictionary safeIntegerForKey:@"activityIsWant"] == 1;
        self.activityNotice = [dictionary safeStringForKey:@"activityNotice"];
        self.activityInformation = [[dictionary safeStringForKey:@"activityTips"] stringByReplacingOccurrencesOfString:@"温馨提示：" withString:@""];
        self.activityFunName = [dictionary safeStringForKey:@"activityFunName"];//模板名称
        self.eventCounts = [dictionary safeStringForKey:@"eventCounts"];
        self.eventPrices = [dictionary safeStringForKey:@"eventPrices"];
        
        //活动单位
        self.activityUnitArray = [self getActivityUnitArrayWithDict:dictionary];
        
        
        //日期与时间
        self.activityTimeDes   = [dictionary safeStringForKey:@"activityTimeDes"];
        self.activityStartTime = [dictionary safeStringForKey:@"activityStartTime"];
        self.activityEndTime   = [dictionary safeStringForKey:@"activityEndTime"];
        self.showedDate        = [self getShowedActivityDate];
        NSString *timeQuantum = [dictionary safeStringForKey:@"timeQuantum"];//时间段
        if ([timeQuantum hasSuffix:@","])
        {
            timeQuantum = [timeQuantum substringToIndex:timeQuantum.length-2];
        }
        self.timeQuantum = timeQuantum;//时间段
        
        self.isSingleEvent      = [dictionary safeIntegerForKey:@"singleEvent"] == 1;
        self.isSeckillActivity  = [dictionary safeIntegerForKey:@"spikeType"] == 1;
        self.isNeedIdentityCard = [dictionary safeIntegerForKey:@"identityCard"] == 1;
        self.integralStatus     = [dictionary safeIntegerForKey:@"integralStatus"];
        self.lowestCredit       = [dictionary safeIntegerForKey:@"lowestCredit"];
        self.costCredit         = [dictionary safeIntegerForKey:@"costCredit"];
        self.deductionCredit    = [dictionary safeIntegerForKey:@"deductionCredit"];
        
        
        //订票限购
        self.isDefaultTicketSetting = [[dictionary safeStringForKey:@"ticketSettings"] isEqualToString:@"Y"];
        self.limitedFrequency = [dictionary safeIntegerForKey:@"ticketNumber"];
        self.limitedCount = [dictionary safeIntegerForKey:@"ticketCount"];
        
        if (_isDefaultTicketSetting){
            self.limitedCount = 5;
        }
        
        self.subPlatformReserveUrl = [dictionary safeStringForKey:@"sysUrl"];
    }
    return self;
}



- (NSString *)getShowedAddress
{
    //    if (_activityVenue.length && _activityAddress.length) {
    //        return [NSString stringWithFormat:@"%@ - %@",_activityAddress, _activityVenue];
    //    }
    return _activityAddress.length ? _activityAddress : @"位置信息缺失";
}

- (NSString *)getShowedActivityDate
{
    NSString *showedActivityDate = @"";
    NSString *startTime = [_activityStartTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *endTime = [_activityEndTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    if (startTime && endTime && ![startTime isEqualToString:endTime])
    {
        showedActivityDate = [[NSString alloc] initWithFormat:@"%@ - %@",startTime,endTime];
    }
    else
    {
        showedActivityDate = startTime;
    }
    return showedActivityDate;
}




- (NSArray *)activityInfoArray
{
    NSMutableArray *tmpArray = [NSMutableArray new];
    
    //地址和所属的场馆名
    NSString *string = self.activityAddress;
    if (self.activityVenue.length){
        string = [NSString stringWithFormat:@"%@ . %@",string, self.activityVenue];
    }
    NSArray *addressArray = [NSArray arrayWithObjects:@"icon_地址",string, @"", nil];
    //日期
    string = self.showedDate;
    NSArray *dateArray = [NSArray arrayWithObjects:@"icon_日期",string, @"", nil];
    //时间段
    NSArray *timeArray = [NSArray arrayWithObjects:@"icon_时间",[self getShowedTime:_timeQuantum], @"", nil];
    //电话
    string = self.activityTel;
    NSArray *telephoneArray = [NSArray arrayWithObjects:@"icon_电话",string, @"", nil];
    
    [tmpArray addObject:addressArray];
    [tmpArray addObject:dateArray];
    [tmpArray addObject:timeArray];
    [tmpArray addObject:telephoneArray];
    
    return [tmpArray copy];
}

//主办方、承办单位、协办单位、演出单位、主讲人
- (NSArray *)getActivityUnitArrayWithDict:(NSDictionary *)dict
{
    if (dict == nil || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSString *showUnitId = [dict safeStringForKey:@"assnId"];//演出单位Id
    self.associationId = showUnitId;
    
    
    // 子数组的数据结构： @[leftTitle, rightTitle, tagArray[], linkId];  或 @[leftTitle, rightTitle];
    
    NSMutableArray *tmpArray = [NSMutableArray new];
    //主办方
    NSString *title = [dict safeStringForKey:@"activityHost"];
    if (title.length) {
        [tmpArray addObject:[NSArray arrayWithObjects:@"主  办  方：",title,nil]];
    }
    //承办单位
    title = [dict safeStringForKey:@"activityOrganizer"];
    if (title.length) {
        [tmpArray addObject:[NSArray arrayWithObjects:@"承办单位：",title,nil]];
    }
    //协办单位
    title = [dict safeStringForKey:@"activityCoorganizer"];
    if (title.length) {
        [tmpArray addObject:[NSArray arrayWithObjects:@"协办单位：",title,nil]];
    }
    //演出单位
    title = [dict safeStringForKey:@"activityPerformed"];
    if (title.length) {
        NSArray *unitTagArray = [dict safeArrayForKey:@"assnSub"];//演出单位标签
        [tmpArray addObject:[NSArray arrayWithObjects:@"演出单位：",title,unitTagArray,showUnitId,nil]];
    }
    //主讲人
    title = [dict safeStringForKey:@"activitySpeaker"];
    if (title.length) {
        [tmpArray addObject:[NSArray arrayWithObjects:@"主  讲  人：",title,nil]];
    }
    
    return [tmpArray copy];
}


- (NSArray *)getShowedTime:(NSString *)timeString
{
    //    timeString = nil;
    //    timeString = @"10:00-14:23,10:00-14:23,10:00-14:23,10:00-14:23,10:00-14:23,";
    //    _activityTimeDes = @"阿尔贡阿里更健康话阿圭罗空间看了假发短发很高了卡就好啊嘎客户经理的";
    //    _activityTimeDes = nil;
    
    timeString = [timeString stringByReplacingOccurrencesOfString:@";" withString:@","];
    timeString = [timeString stringByReplacingOccurrencesOfString:@"，" withString:@","];
    
    NSMutableArray *tmpArray = [NSMutableArray new];
    
    NSArray *timeArray = [timeString componentsSeparatedByString:@","];
    
    for (int i = 0 ; i < timeArray.count; i++ ) {
        NSString *time = timeArray[i];
        if (time.length) {
            time = [time stringByReplacingOccurrencesOfString:@"-" withString:@" - "];
            [tmpArray addObject:time];
        }
    }
    
    if (self.activityTimeDes.length)
    {
        [tmpArray addObject:[NSString stringWithFormat:@"|%@",self.activityTimeDes]];
    }
    return [tmpArray copy];
}



//1-已结束  2-直接前往  3-已订完  4-无法预订 5-立即预订
- (NSInteger)reserveStatus
{
    //结束时间比今天早（活动已经结束）
    if (_activityIsPast)
    {
        return 1;//已结束
    }else
    {
        if (_activityIsReservation)
        {
            if (_activityAbleCount > 0)
            {
                if ([_status rangeOfString:@"1"].location != NSNotFound)
                {
                    return 5;
                }else
                {
                    return 4;
                }
            }else
            {
                return 3;
            }
        }else
        {
            return 2;
        }
    }
    return 4;
}

//0-不需要积分 1-仅需要积分作为门槛，2-仅需要扣除相应的积分，3-既需要积分作为门槛，也要扣除积分
- (NSInteger)requiredScoreType
{
    if (self.lowestCredit <= 0 && self.costCredit <= 0 ) {
        return 0;
    }else if (self.lowestCredit > 0 && self.costCredit <= 0 ){
        return 1;
    }else if (self.lowestCredit <= 0 && self.costCredit > 0 ){
        return 2;
    }else{
        return 3;
    }
}

//限购提示
- (NSString *)showedLimitedNotice
{
    if (self.isDefaultTicketSetting) {
        return @"此活动同一ID限购5张票";
    }else{
        if (_limitedCount  > 0 && _limitedFrequency > 0) {
            return [NSString stringWithFormat:@"此活动同一ID限购%d次，每次不超过%d张票",(int)_limitedFrequency,(int)_limitedCount];
        }else if (_limitedCount <= 0 && _limitedFrequency > 0){
            return [NSString stringWithFormat:@"此活动同一ID限购%d次",(int)_limitedFrequency];
        }else if (_limitedCount > 0 && _limitedFrequency <= 0){
            return [NSString stringWithFormat:@"此活动同一ID每次购买不超过%d张票",(int)_limitedCount];
        }else{
            return @"";
        }
    }
}

- (NSInteger)maxCount
{
    if (self.isDefaultTicketSetting) {
        return 5;
    }else{
        if (_limitedCount  > 0) {
            return _limitedCount;
        }else{
            return NSIntegerMax;
        }
    }
}

- (NSString *)showedScoreNotice
{
    NSString *deductionCredit = self.deductionCredit > 0 ? [NSString stringWithFormat:@"|此活动热门，预订后未到场将会被扣除 %d 积分",(int)_deductionCredit] : @"";
    
    if (self.requiredScoreType == 1) {
        return [NSString stringWithFormat:@"需要达到 %d 积分才可预订%@",(int)(self.lowestCredit),deductionCredit];
    }else if (self.requiredScoreType == 2){
        return [NSString stringWithFormat:@"每张票务需要抵扣 %d 积分%@",(int)(self.costCredit),deductionCredit];
    }else if (self.requiredScoreType == 3){
        return [NSString stringWithFormat:@"预订需要达到 %d 积分,且每张需抵扣 %d 积分%@",(int)self.lowestCredit,(int)self.costCredit,deductionCredit];
    }
    else{
        return deductionCredit;
    }
}

//- (NSArray *)getJointedTagArray:(NSDictionary *)dict
//{
//    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:1];
//    
//    NSString *tagName = [dict safeStringForKey:@"tagName"];
//    if (tagName.length) {
//        [tmpArray addObject:[[ToolClass getComponentArrayIgnoreBlank:tagName separatedBy:@","] firstObject]];
//    }
//    
//    NSArray *subListArray = [dict safeArrayForKey:@"subList"];
//    
//    for (int i = 0 ; i < subListArray.count; i++) {
//        NSDictionary *item = subListArray[i];
//        if ([item isKindOfClass:[NSDictionary class]]) {
//            NSString *tagName = [item safeStringForKey:@"tagName"];
//            if (tagName.length) {
//                if (tmpArray.count < 3) {
//                    [tmpArray addObject:tagName];
//                }else {
//                    break;
//                }
//            }
//        }
//    }
//    return tmpArray;
//}



- (BOOL)isShowAnchor
{
    if (_activityMemo.length && self.activityUnitArray.count) {
        return YES;
    }
    return NO;
}


@end
