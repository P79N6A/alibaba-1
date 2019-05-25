//
//  OrderDetailModel.m
//  CultureHongshan
//
//  Created by ct on 16/5/13.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "OrderDetailModel.h"

@implementation OrderDetailModel

- (id)initWithAttributes:(NSDictionary *)dict type:(NSInteger)type
{
    if (self = [super init])
    {
        //防止返回null时崩溃
        if (dict == nil || ![dict isKindOfClass:[NSDictionary class]] || (type != 1 && type != 2))
        {
            return nil;
        }
        self.type = type;
        
        
        self.longitude = (type == 1) ? [dict safeDoubleForKey:@"activityLon"] : [dict safeDoubleForKey:@"venueLon"];
        self.latitude  = (type == 1) ? [dict safeDoubleForKey:@"activityLat"] : [dict safeDoubleForKey:@"venueLat"];
        
        self.orderId      = (type == 1) ? [dict safeStringForKey:@"activityOrderId"] : [dict safeStringForKey:@"roomOrderId"];
        self.modelId      = (type == 1) ? [dict safeStringForKey:@"activityId"] : [dict safeStringForKey:@"roomId"];
        self.titleStr     = (type == 1) ? [dict safeStringForKey:@"activityName"] : [dict safeStringForKey:@"roomName"];
        self.venueName    = [dict safeStringForKey:@"venueName"];
        self.venueAddress = [dict safeStringForKey:@"venueAddress"];
        self.imageUrl     = (type == 1) ? [dict safeImgUrlForKey:@"activityIconUrl"] : [dict safeImgUrlForKey:@"roomPicUrl"];
        if (type == 1) {
            self.addressStr = [ToolClass getJointedString:dict[@"activityAddress"] otherStr:dict[@"activitySite"] jointedBy:@"."];
        }else {
            self.addressStr = [dict safeStringForKey:@"venueAddress"];
        }
        
        
        if (type == 1){
            NSString *startDate = [dict safeStringForKey:@"eventDate"];
            NSString *endDate = [dict safeStringForKey:@"eventEndDate"];
            if (startDate.length && endDate.length) {
                if ([startDate isEqualToString:endDate]) {
                    NSDate *participateDate = [DateTool dateForDateString:startDate formatter:@"yyyy-MM-dd" ];
                    self.participateDate = [NSString stringWithFormat:@"%@ %@",[DateTool dateStringForDate:participateDate formatter:@"yyyy年MM月dd日"],[DateTool weekStringForDate:participateDate]];
                }else{
                    self.participateDate = [NSString stringWithFormat:@"%@至%@",startDate, endDate];
                }
            }else{
                self.participateDate = startDate;
            }
            self.participateTime = [dict safeStringForKey:@"eventTime"];
            
        }else{
            self.participateDate = [dict safeStringForKey:@"date"];
            self.participateTime = [dict safeStringForKey:@"openPeriod"];
        }
        NSString *orderCreatTime  = (type == 1) ? [dict safeStringForKey:@"orderTime"] : [dict safeStringForKey:@"orderTime"];
        self.orderCreatTime = [DateTool dateStringForTimeSp:orderCreatTime formatter:@"yyyy.MM.dd HH:mm:ss" millisecond:NO];
        self.orderPayTime    = (type == 1) ? [DateTool dateStringForTimeSp:[dict safeStringForKey:@"orderPayTime"] formatter:@"yyyy.MM.dd HH:mm:ss" millisecond:NO] : [dict safeStringForKey:@""];
        self.orderNumber     = (type == 1) ? [dict safeStringForKey:@"orderNumber"] : [dict safeStringForKey:@"orderNumber"];
        self.orderName       = [dict safeStringForKey:@"orderName"];
        self.orderPhoneNo    = [dict safeStringForKey:@"orderPhoneNo"];
        self.checkCode       = (type == 1) ? [dict safeStringForKey:@"orderValidateCode"] : [dict safeStringForKey:@"orderValidateCode"];
        self.qrCodeImgUrl    = (type == 1) ? [dict safeStringForKey:@"activityQrcodeUrl"] : [dict safeStringForKey:@"roomQrcodeUrl"];
        
        //取票码处理
        self.checkCode = [ToolClass getSpaceSeparatedString:_checkCode length:4];
        
        if (type == 1) {
            [self setActivityOrderProperty:dict];
        }else{
            [self setPlayroomOrderProperty:dict];
        }
        
        //积分
//        self.lowestCredit = [dict safeIntegerForKey:@"lowestCredit"];
//        self.costCredit = [dict safeIntegerForKey:@"costCredit"];
        self.showedCostCredit = [dict safeIntegerForKey:@"costTotalCredit"];
        
        
        self.tUserIsFreeze = [dict safeIntegerForKey:@"tuserIsDisplay"] == 2;//使用者是否被冻结
        NSInteger orderStatus = (type == 1) ? [dict safeIntegerForKey:@"orderPayStatus"] : [dict safeIntegerForKey:@"bookStatus"];
        [OrderDetailModel matchedOrderStatus:orderStatus
                                    userType:[dict safeIntegerForKey:@"userType"]
                              tuserIsDisplay:[dict safeIntegerForKey:@"tuserIsDisplay"]
                                 checkStatus:[dict safeIntegerForKey:@"checkStatus"]
                                     tUserId:self.roomUserId
                                 orderStatus:&_orderStatus
                               certifyStatus:&_certifyStatus
                                        type:type];
        
        }
    return self;
}


- (void)setActivityOrderProperty:(NSDictionary *)dict
{
    self.activityIsFree        = [[dict safeStringForKey:@"activityIsFree"] intValue] != 2;//活动是否收费 1-免费 2-收费
    self.activityIsSalesOnline = [[dict safeStringForKey:@"activitySalesOnline"] isEqualToString:@"Y"];//Y-在线选座  N-直接前往
    self.activityAddress       = [dict safeStringForKey:@"activityAddress"];
    self.peopleCountStr        = [dict safeStringForKey:@"orderVotes"];
    self.showedSeatArray       = [self getShowedSeatArray:[dict safeStringForKey:@"activitySeats"]];
    self.seatLineArray         = [self getSeatLineArray:[dict safeStringForKey:@"orderLine"]];
    
    self.orderPayStatus        = [dict safeIntegerForKey:@"orderPaymentStatus"];
}

- (void)setPlayroomOrderProperty:(NSDictionary *)dict
{
    self.venueId    = [dict safeStringForKey:@"venueId"];
    self.roomUser   = [dict safeStringForKey:@"tuserName"];
    self.roomUserId = [dict safeStringForKey:@"tuserId"];
    self.roomBooker = [dict safeStringForKey:@"orderName"];
    self.bookerTel  = [dict safeStringForKey:@"orderTel"];
}

- (void)setParticipateDateAndTime:(NSString *)string
{
    if (string.length) {
        NSArray *array = [string componentsSeparatedByString:@" "];
        
        NSDate *participateDate = [DateTool dateForDateString:[array firstObject] formatter:@"yyyy-MM-dd"];
        self.participateDate = [NSString stringWithFormat:@"%@ %@",[DateTool dateStringForDate:participateDate formatter:@"yyyy年MM月dd日"], [DateTool weekStringForDate:participateDate]];
        self.participateTime = [array lastObject];
    }else{
        self.participateDate = @"";
        self.participateTime = @"";
    }
}


- (NSArray *)getShowedSeatArray:(NSString *)seats
{
    if ([seats rangeOfString:@"_"].location != NSNotFound) {
        
        NSArray *array = [seats componentsSeparatedByString:@","];
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < array.count; i++)
        {
            NSString *aSeat = array[i];
            if (aSeat.length)
            {
                NSArray *tmpArray = [aSeat componentsSeparatedByString:@"_"];
                if (tmpArray.count == 2)
                {
                    [mutableArray addObject:[NSString stringWithFormat:@"%@排%@座",tmpArray[0],tmpArray[1]]];
                }
            }
        }
        return [mutableArray copy];
    }
    return @[];
}


- (NSArray *)getSeatLineArray:(NSString *)seatLine
{
    if ([seatLine rangeOfString:@"_"].location != NSNotFound) {
        NSArray *array = [seatLine componentsSeparatedByString:@","];
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < array.count; i++){
            NSString *aSeat = array[i];
            if (aSeat.length){
                [mutableArray addObject:aSeat];
            }
        }
        return [mutableArray copy];
    }
    return @[];
}


- (BOOL)isUncheckOrder
{
    if (_type == 2) {//活动室订单
        if (_orderStatus == 1 || _orderStatus == 0) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isUnParticipateOrder
{
    if (_type == 1) {//活动订单
        if (_orderPayStatus != 1 && (_orderStatus == 1 || _orderStatus == 3)) {
            return YES;
        }
    }
    
    if (_type == 2) {//活动室订单
        if (_orderStatus == 3 || _orderStatus == 5 ) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isHistoryOrder
{
    if (_type == 1) {//活动订单
        if (_orderStatus == 2 || _orderStatus == 4 || _orderStatus == 5) {
            return YES;
        }
    }
    
    if (_type == 2) {//活动室订单
        if (_orderStatus == 2 || _orderStatus == 4 || _orderStatus == 6 || _orderStatus == 7 || _orderStatus == 8) {
            return YES;
        }
    }
    return NO;
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

+ (void)matchedOrderStatus:(NSInteger)status
                     userType:(NSInteger)userType
            tuserIsDisplay:(NSInteger)tuserIsDisplay
               checkStatus:(NSInteger)checkStatus
                       tUserId:(NSString *)tUserId
                  orderStatus:(NSInteger *)orderStatus//目标订单状态
                certifyStatus:(NSInteger *)certifyStatus//目标认证状态
                         type:(NSInteger)type//1-活动订单  2-活动室订单
{
    if (type == 1)
    {
        /*
         活动订单：0.未定义  1.预订成功 2.已取消 3.已出票 4.已验票 5.已过期 6.已删除
         */
        switch (status)
        {
            case 1: *orderStatus = 1;//预订成功
                break;
            case 2: *orderStatus = 2;//已取消
                break;
            case 3: *orderStatus = 3;//已出票
                break;
            case 4: *orderStatus = 4;//已验票
                break;
            case 5: *orderStatus = 5;//已过期
                break;
            case 6: *orderStatus = 6;//已删除
                break;
            default:
                *orderStatus = 0;
                break;
        }
    }
    else if (type == 2)
    {
        /*
         
         活动室订单：
            订单预订状态：
                0-考虑认证状态 1-预订成功  2-已取消  3-已出票  4-已验票  5-已过期  6-已删除 7-订单审核未通过
            订单认证状态：
                -1.未定义的认证状态  0-未实名认证  1-实名认证中  2-实名认证未通过  3-未资质认证  4-资质认证中  5-资质认证未通过  6-资质认证已通过 7-使用者被冻结 (3-7表明实名认证已通过)
         */
        switch (status) {
            case 1: *orderStatus = 1;//预订成功
                break;
            case 2:
            {
                if (checkStatus == 2) {
                    *orderStatus = 7;//订单审核未通过
                }else{
                    *orderStatus = 2;//已取消
                }
            }
                break;
            case 3: *orderStatus = 4;//已验票
                break;
            case 4: *orderStatus = 6;//已删除
                break;
            case 5: *orderStatus = 3;//已出票
                break;
            case 6: *orderStatus = 5;//已过期（已失效）
                break;
            case 0://需要考虑认证状态
            {
                *orderStatus = 0;//考虑认证状态
                
                if (userType == 1) {
                    *certifyStatus = 0;//未实名认证
                }else if (userType == 2)
                {
                    //实名认证已通过
                    if (tUserId.length < 1) {
                        *certifyStatus = 3;//未资质认证
                    }else
                    {
                        if (tuserIsDisplay == 0) {
                            *certifyStatus = 4;//资质认证中
                        }else if (tuserIsDisplay == 1){
                            *certifyStatus = 6;//资质认证已通过
                        }else if (tuserIsDisplay == 2){
                            *certifyStatus = 7;//使用者被冻结
                        }else if (tuserIsDisplay == 3){
                            *certifyStatus = 5;//资质认证未通过
                        }
                    }
                }else if (userType == 3){
                    *certifyStatus = 1;//实名认证中
                }else if (userType == 4){
                    *certifyStatus = 2;//实名认证未通过
                }else{
                    *certifyStatus = -1;//未定义的认证状态
                }
            }
                break;
                
            default:
                break;
    }
}
}

/**
 后台的状态：
 
 
 userType
        用户实名认证： 1.未认证 2.已认证  3.待审核 4.认证不通过
 tuserIsDisplay
        使用者认证状态：0.待认证  1.认证通过  2.冻结   3.认证不通过

 bookStatus
        活动室预订状态：0.待审核  1.已预订  2.已取消  3.已验票   4.已删除  5.已出票  6.已失效
 
 tuserId
    使用者id
 
 ——————————————  checkStatus字段暂时不需要    ——————————————
 checkStatus审核状态： 0.待审核 1.审核通过 2.审核未通过
 
 
 orderPaymentStatus 支付状态 0.无需支付 1.待支付 2.支付完成 3.申请退款 4.退款成功
 
 */


@end
