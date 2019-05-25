//
//  VenueDetailModel.m
//  CultureHongshan
//
//  Created by one on 15/11/11.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "VenueDetailModel.h"


@interface VenueDetailModel ()

// ————————————————————————————  暂时不用的字段  ————————————————————————————

@property (nonatomic, copy) NSString *openNotice;//开放时间备注
@property (nonatomic, copy) NSString *venueOpenTime;//开放时间段的开始时间点
@property (nonatomic, copy) NSString *venueEndTime;//开放时间段的结束时间点
@property (nonatomic, copy) NSString *venueRemark;//展馆备注

@property (nonatomic, copy) NSString *collectNum;//展馆收藏数
@property (nonatomic, copy) NSString *venueStars;//展馆星级
@property (nonatomic, copy) NSString *remarkName;//评论者名字
@property (nonatomic, copy) NSString *commentRemark;//评论内容


@property (nonatomic, assign) BOOL venueHasAntique;//有无藏品
@property (nonatomic, assign) BOOL venueHasRoom;//有无活动室
@property (nonatomic, assign) BOOL venueHasBus;//有无公交
@property (nonatomic, assign) BOOL venueHasMetro;//有无地铁


@end


@implementation VenueDetailModel

-(id)initWithAttributes:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]])
        {
            return nil;
        }
        
        self.venueId      = [dictionary safeStringForKey:@"venueId"];
        self.venueName    = [dictionary safeStringForKey:@"venueName"];
        self.venueIconUrl = [dictionary safeImgUrlForKey:@"venueIconUrl"];
        self.venueAddress = [dictionary safeStringForKey:@"venueAddress"];
        self.venueLat     = [dictionary safeDoubleForKey:@"venueLat"];
        self.venueLon     = [dictionary safeDoubleForKey:@"venueLon"];
        self.venueMobile  = [dictionary safeStringForKey:@"venueMobile"];//咨询电话
        //展馆详情内容
        NSString *venueMemo = [dictionary safeStringForKey:@"venueMemo"];
        if (venueMemo.length) {
            self.venueMemo = venueMemo.isPlainText ? [NSString stringWithFormat:@"<p>%@</p>",venueMemo] : venueMemo;
        }else {
            self.venueMemo = @"";
        }
//        self.venueMemo = [NSString stringWithFormat:@"\
//                             <html>\
//                                <head>\
//                                    <style type='text/css'>\
//                                        body {font-family:'Yuanti SC';background-color:#FFFFFF;}\
//                                    </style>\
//                                </head>\
//                                <body>\
//                                    %@\
//                                </body>\
//                             </html>",
//                             [dictionary safeStringForKey:@"venueMemo"]];
        
        self.venueIsCollect = [dictionary safeIntegerForKey:@"venueIsCollect"] == 1;//是否收藏(未登录显示未收藏):1.收藏  0.未收藏
        self.venueIsReserve = [dictionary safeIntegerForKey:@"venueIsReserve"] == 2;//是否可预订:1不预订 2可预订
        self.venueIsWant    = [dictionary safeIntegerForKey:@"venueIsWant"] != 0;//是否已经对场馆点赞(报名)：0.未报名  其它.已报名
        
        self.shareUrl      = [dictionary safeStringForKey:@"shareUrl"];
        self.venueVoiceUrl = [dictionary safeStringForKey:@"venueVoiceUrl"];
        
        self.roomIconUrls  = [ToolClass getComponentArray:[dictionary safeStringForKey:@"roomIconUrl"] separatedBy:@","];
        self.roomNames     = [ToolClass getComponentArray:[dictionary safeStringForKey:@"roomNames"] separatedBy:@","];
        
        self.openNotice    = [dictionary safeStringForKey:@"openNotice"];//开放时间备注
        self.venueOpenTime = [dictionary safeStringForKey:@"venueOpenTime"];
        self.venueEndTime  = [dictionary safeStringForKey:@"venueEndTime"];
        NSString *openTime = @"";
        if (_venueOpenTime.length && _venueEndTime.length) {
            openTime = [NSString stringWithFormat:@"%@-%@",_venueOpenTime,_venueEndTime];
        }else if (_venueOpenTime.length && _venueEndTime.length < 1){
            openTime = _venueOpenTime;
        }else if (_venueOpenTime.length < 1 && _venueEndTime.length){
            openTime = _venueEndTime;
        }
        self.showOpenTimeAndNotice = [NSString stringWithFormat:@"%@\n%@",openTime, _openNotice];
        if ([_showOpenTimeAndNotice hasPrefix:@"\n"]) {
            self.showOpenTimeAndNotice = [_showOpenTimeAndNotice substringFromIndex:1];
        }
        if ([_showOpenTimeAndNotice hasSuffix:@"\n"]) {
            self.showOpenTimeAndNotice = [_showOpenTimeAndNotice substringToIndex:_showOpenTimeAndNotice.length-1];
        }
        
        // 价格
        BOOL venueIsFree = [dictionary safeIntegerForKey:@"venueIsFree"] != 2;
        NSString *price = [dictionary safeStringForKey:@"venuePrice"];
        if (venueIsFree) {
            price = @"免费";
        }
        if (price.length == 0) {
            price = @"免费";
        }else {
            if ([DataValidate isPureFloat:price]) {
                if ([price floatValue] < 0.01) {
                    price = @"免费";
                }else {
                    price = [NSString stringWithFormat:@"%@ 元/人",price];
                }
            }
        }
        self.showedVenuePrice = [price isEqualToString:@"免费"]  ? @"免费" : @"收费";
        NSString *priceNotice = [dictionary safeStringForKey:@"venuePriceNotice"];
        if (priceNotice.length) {
            self.showedVenuePriceAndNotice = [NSString stringWithFormat:@"%@||%@",price, priceNotice];
        }else {
            self.showedVenuePriceAndNotice = price;
        }
        
        // 标签
        [self settingShowedVenueTags:dictionary];
        
        /* ————————————— 不用的字段 ——————————————— */
//        self.venueHasAntique = [dictionary safeIntegerForKey:@"venueHasAntique"] == 2;
//        self.venueHasRoom    = [dictionary safeIntegerForKey:@"venueHasRoom"] == 2;
//        self.venueHasBus     = [dictionary safeIntegerForKey:@"venueHasBus"] == 2;
//        self.venueHasMetro   = [dictionary safeIntegerForKey:@"venueHasMetro"] == 2;
//        
//        self.venueStars  = [dictionary safeStringForKey:@"venueStars"];
//        self.collectNum     = [dictionary safeStringForKey:@"collectNum"];
    }
    return self;
}


+(NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray
{
    if (!dicArray || ![dicArray isKindOfClass:[NSArray class]])
    {
        return @[];
    }
    
    NSMutableArray *instanceArray = [NSMutableArray array];
    for (NSDictionary *instanceDic in dicArray) {
        VenueDetailModel *model = [[VenueDetailModel alloc] initWithAttributes:instanceDic];
        if (model) {
            [instanceArray addObject:model];
        }
    }
    return [NSArray arrayWithArray:instanceArray];
}

// 显示的场馆标签
- (void)settingShowedVenueTags:(NSDictionary *)dict
{
    /*
     1.场馆：位置+类型+2个标签
     
     2.活动室：类型+2个标签
     */
    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithCapacity:1];
    NSString *areaName = [dict safeStringForKey:@"dictName"];
    if (areaName.length) {
        [tmpArray addObject:areaName];
    }
    
    NSString *tagName = [dict safeStringForKey:@"tagName"];
    if (tagName.length) {
        [tmpArray addObject:[[ToolClass getComponentArray:tagName separatedBy:@","] firstObject]];
    }
    
    NSArray *subListArray = [dict safeArrayForKey:@"subList"];
    for (int i = 0 ; i < subListArray.count && i < 2; i++) {
        NSDictionary *item = subListArray[i];
        if ([item isKindOfClass:[NSDictionary class]]) {
            NSString *tagName = [item safeStringForKey:@"tagName"];
            if (tagName.length) {
                [tmpArray addObject:tagName];
            }
        }
    }
    
    self.showedVenueTags = tmpArray;
}




@end
