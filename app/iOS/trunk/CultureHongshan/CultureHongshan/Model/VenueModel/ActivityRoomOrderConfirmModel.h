//
//  ActivityRoomOrderConfirmModel.h
//  CultureHongshan
//
//  Created by ct on 16/6/12.
//  Copyright © 2016年 CT. All rights reserved.
//


/*
 
 活动室订单确定
 
 */
#import <Foundation/Foundation.h>

@interface ActivityRoomOrderConfirmModel : NSObject

@property (nonatomic, copy) NSString *orderId;//活动室订单id
@property (nonatomic, copy) NSString *roomName;
@property (nonatomic, copy) NSString *venueName;
@property (nonatomic, copy) NSString *roomDate;//活动室预订日期：2015年4月13日 周六
@property (nonatomic, copy) NSString *openPeriod;//活动室开放时间段
@property (nonatomic, copy) NSString *tUserName;
@property (nonatomic, copy) NSString *orderName;
@property (nonatomic, copy) NSString *orderTel;
@property (nonatomic, assign) NSInteger userType;//用户实名认证状态: 1-普通用户 2-管理员用户 3-认证中 4-实名认证不通过
@property (nonatomic, assign) NSInteger tUserIsDisplay;//使用者认证状态: 0-未认证, 1-正常, 2-禁用, 3-资质认证未通过

/*
 userType为1、4时，需要实名认证；
 userType为2时，再判断tUserIsDisplay：0.需要资质认证， 1-已通过资质认证
 
 */
- (id)initWithAttributes:(NSDictionary *)dictionary;

@end
