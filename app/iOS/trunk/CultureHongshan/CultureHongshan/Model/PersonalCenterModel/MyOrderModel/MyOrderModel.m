//
//  MyOrderModel.m
//  CultureHongshan
//
//  Created by ct on 16/5/12.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "MyOrderModel.h"

#import "OrderDetailModel.h"


@implementation MyOrderModel

- (id)initWithDict:(NSDictionary *)dict withType:(DataType)type
{
    if (self = [super init])
    {
        //防止返回null时崩溃
        if (dict == nil || ![dict isKindOfClass:[NSDictionary class]] || (type != DataTypeActivity && type != DataTypeVenue))
        {
            return nil;
        }
        self.type = type;
        
        self.orderId        = (type == DataTypeActivity) ? [dict safeStringForKey:@"activityOrderId"] : [dict safeStringForKey:@"roomOrderId"];
        self.modelId        = (type == DataTypeActivity) ? [dict safeStringForKey:@"activityId"] : [dict safeStringForKey:@"roomId"];
        self.imageUrl       = (type == DataTypeActivity) ? [dict safeImgUrlForKey:@"activityIconUrl"] : [dict safeImgUrlForKey:@"roomPicUrl"];
        self.orderCreatTime = (type == DataTypeActivity) ? [dict safeStringForKey:@"orderTime"] : [dict safeStringForKey:@"orderTime"];
        self.orderNumber    = (type == DataTypeActivity) ? [dict safeStringForKey:@"orderNumber"] : [dict safeStringForKey:@"roomOrderNo"];

        self.titleStr       = (type == DataTypeActivity) ? [dict safeStringForKey:@"activityName"] : [dict safeStringForKey:@"roomName"];
        self.addressStr     = (type == DataTypeActivity) ? [dict safeStringForKey:@"activityAddress"] : [dict safeStringForKey:@"venueName"];
        self.requiredScore  = (type == DataTypeActivity) ? [dict safeIntegerForKey:@"requiredScore"] : [dict safeIntegerForKey:@"requiredScore"];
        
        //日期与时间
        
        NSString *string = (type == DataTypeActivity) ? [dict safeStringForKey:@"activityEventDateTime"] : [dict safeStringForKey:@"roomTime"];
        if (type == DataTypeActivity) {
            self.dateStr = string;//[string stringByReplacingOccurrencesOfString:@"-" withString:@"."];
            self.timeStr = @"";
        }else{
            NSArray *array =  [ToolClass getComponentArray:string separatedBy:@" "];
            if (array.count > 3) {
                self.dateStr = [[NSString stringWithFormat:@"%@  %@",array[0],array[1]] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
                self.timeStr = [NSString stringWithFormat:@"%@  %@",array[2],array[3]];
            }else{
                self.dateStr = @"";
                self.timeStr = @"";
            }
        }

        //活动订单的特有属性
        if (type == DataTypeActivity) {
            [self setActivityOrderProperty:dict];
            NSString *orderPrice = [dict safeStringForKey:@"orderPrice"];
            if (orderPrice.length < 1 || [orderPrice floatValue]==0) {
                orderPrice = @"免费";
            }
            self.priceStr = orderPrice;
        }else {
            NSString *priceString = [dict safeStringForKey:@"price"];
            if (priceString.length) {
                priceString = [dict safeStringForKey:@"roomOrderPrice"];
            }
            self.priceStr = [self getActivityRoomPrice:priceString];
            self.tUserId = [dict safeStringForKey:@"tuserId"];
            self.tuserTeamName = [dict safeStringForKey:@"tuserTeamName"];
            self.checkStatus = [dict safeIntegerForKey:@"cheakStatus"];
        }
        
        NSInteger orderStatus = (type == DataTypeActivity) ? [dict safeIntegerForKey:@"orderPayStatus"] : [dict safeIntegerForKey:@"orderStatus"];//bookStatus
        
        
        NSInteger userType = -1;
        if (type == 2) {
            //  用户等级：1-普通用户 2-管理员用户 3-待认证（当为管理员用户时，表示用户通过实名认证）
            userType = [UserService sharedService].user.userType;
            
            self.tuserIsDisplay = [dict safeIntegerForKey:@"tuserIsDisplay"];
        }
        self.tUserIsFreeze = [dict safeIntegerForKey:@"tuserIsDisplay"] == 2;//使用者是否被冻结
        [OrderDetailModel matchedOrderStatus:orderStatus
                                    userType:userType
                              tuserIsDisplay:[dict safeIntegerForKey:@"tuserIsDisplay"]
                                 checkStatus:[dict safeIntegerForKey:@"checkStatus"]
                                     tUserId:self.tUserId
                                 orderStatus:&_orderStatus
                               certifyStatus:&_certifyStatus
                                        type:type];
        
    }
    return self;
}


- (void)setActivityOrderProperty:(NSDictionary *)dict
{
    self.orderPayStatus  = [dict safeIntegerForKey:@"orderPaymentStatus"];
    self.showedSeatArray = [ToolClass seatsArrayForOrderSeats:[dict safeStringForKey:@"activitySeats"]];//座位：x排x座
    self.isSalesOnline   = [[dict safeStringForKey:@"activitySalesOnline"] isEqualToString:@"Y"];
    self.peopleCount     = [dict safeIntegerForKey:@"orderVotes"];
}


+ (NSArray *)listArrayFromDictArray:(NSArray *)dicArray withType:(DataType)type
{
    if (dicArray == nil || ![dicArray isKindOfClass:[NSArray class]])
    {
        return @[];
    }
    
    NSMutableArray *instanceArray = [NSMutableArray array];
    for (NSDictionary *instanceDic in dicArray)
    {
        [instanceArray addObject:[[self alloc] initWithDict:instanceDic withType:type]];
    }
    
    return [instanceArray copy];
}


- (NSString *)getActivityRoomPrice:(NSString *)venuePrice
{
    if (venuePrice.length) {
        if ([DataValidate isPureFloat:venuePrice]) {
            return [NSString stringWithFormat:@"¥ %@",venuePrice];
        }else{
            return @"收费";
        }
    }else{
        return @"免费";
    }
    return @"";
}



#pragma mark - 

// 订单排序
+ (NSArray<MyOrderModel *> *)sortedOrderListWithModels:(NSArray *)orderList {
    return [orderList sortedArrayUsingComparator:^NSComparisonResult(MyOrderModel *obj1, MyOrderModel *obj2) {
        if ([obj1.orderCreatTime longLongValue] < [obj2.orderCreatTime longLongValue]) {
            return NSOrderedDescending;
        }
        
        if ([obj1.orderCreatTime longLongValue] > [obj2.orderCreatTime longLongValue]) {
            return NSOrderedAscending;
        }
        
        return NSOrderedSame;
    }];   
}

@end
