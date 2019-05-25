//
//  MyOrderModel.h
//  CultureHongshan
//
//  Created by ct on 16/5/12.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderModel : NSObject

@property (nonatomic, assign) DataType type;//1- 活动  2- 场馆


@property (nonatomic,copy) NSString *orderId;//订单Id
@property (nonatomic,copy) NSString *modelId;//活动 或 活动室的id(应该不需要这个参数)
@property (nonatomic,copy) NSString *imageUrl;//图片

@property (nonatomic,copy) NSString *orderCreatTime;
@property (nonatomic,copy) NSString *orderNumber;//订单号:150731000009
@property (nonatomic,copy) NSString *titleStr;//活动或者活动室的名称
@property (nonatomic,copy) NSString *addressStr;//地址：活动的地点(非地址) 或 活动室所在的场馆
@property (nonatomic,copy) NSString *dateStr;//活动的举办时间或者场馆活动室的开放时间:2015.08.02 周几
@property (nonatomic,copy) NSString *timeStr;//活动: 13:00-15:00  或 活动室： 13:00-15:00 x小时
@property (nonatomic,copy) NSString *priceStr;//价格：¥ 12.00或 免费 或 收费
@property (nonatomic, assign) NSInteger requiredScore;//需要扣除的积分

/*
 订单状态:  (2016.06.24更新。  这是自定义的状态，需要和后台的对应)
 
 ————————活动订单：0.未定义  1.预订成功 2.已取消 3.已出票 4.已验票 5.已过期 6.已删除
 
 ————————活动室订单：
            订单预订状态：
                    0-需考虑认证状态 1-预订成功  2-已取消  3-已出票  4-已验票  5-已过期  6-已删除  7-订单审核未通过
            订单认证状态：
                    -1.未定义的认证状态  0-未实名认证  1-实名认证中  2-实名认证未通过  3-未资质认证  4-资质认证中  5-资质认证未通过  6-资质认证已通过 7-使用者被冻结 (3-7表明实名认证已通过)
 */
@property (nonatomic,assign) BOOL tUserIsFreeze;//使用者是否被冻结
@property (nonatomic,assign) NSInteger tuserIsDisplay;//进行认证时，需要传这个参数
@property (nonatomic,assign) NSInteger orderStatus;//订单状态
/** 订单支付状态：0-无需支付  1-未支付  2-支付成功  3-退款中  4-退款成功 */
@property (nonatomic,assign) NSInteger orderPayStatus;
@property (nonatomic,assign) NSInteger certifyStatus;//认证状态


//活动订单的特有属性
@property (nonatomic,copy) NSArray *showedSeatArray;//座位：x排x座
@property (nonatomic,assign) BOOL isSalesOnline;//是否为在线选座
@property (nonatomic,assign) NSInteger peopleCount;//人数

//活动室订单的特有属性
@property (nonatomic,copy) NSString *tuserTeamName;//使用者名字
@property (nonatomic,copy) NSString *tUserId;//使用者Id
@property (nonatomic,assign) NSInteger checkStatus;//历史订单中使用，来判断是否因为"审核未通过(checkStatus=2)"被取消

//  type说明： 1-－－活动  2-－－场馆
+ (NSArray *)listArrayFromDictArray:(NSArray *)dicArray withType:(DataType)type;


/** 订单排序 */
+ (NSArray<MyOrderModel *> *)sortedOrderListWithModels:(NSArray *)orderList;

@end
