//
//  ActOrderDetailModel.h
//  CultureHongshan
//
//  Created by ct on 17/2/23.
//  Copyright © 2017年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 活动订单详情
 */
@interface ActOrderDetailModel : NSObject

@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double latitude;

@property (nonatomic, assign) BOOL isUnParticipateOrder;//是否“待参加订单”
@property (nonatomic, assign) BOOL isHistoryOrder;//是否“历史订单”
@property (nonatomic, assign) BOOL isDelete; // 是否下架: 1-正常 2-删除  3-下架

@property (nonatomic,copy) NSString *orderId;//订单Id
@property (nonatomic,copy) NSString *activityId;//活动Id
@property (nonatomic,copy) NSString *activityName;//活动名称
@property (nonatomic,copy) NSString *venueName;//场馆名
@property (nonatomic,copy) NSString *venueAddress;//场馆的地址
@property (nonatomic,copy) NSString *activityAddress;//活动地址
@property (nonatomic,copy) NSString *addressString;//拼接的活动地址与活动地点
@property (nonatomic,copy) NSString *activityIconUrl;//活动封面图片
@property (nonatomic,copy) NSString *priceStr;//活动价格
@property (nonatomic, assign)  double activityUnitPrice; // 活动单价
@property (nonatomic,copy) NSString *participateDate;//活动的参加日期：yyyy年M月d日 周x
@property (nonatomic,copy) NSString *participateTime;//活动参加的时间段： 10:00-15:00
@property (nonatomic,copy) NSString *orderCreatTime;//下单时间:yyyy-MM-dd HH:mm:ss
@property (nonatomic,copy) NSString *orderPayTime;//支付时间
@property (nonatomic,copy) NSString *orderNumber;//订单号:150731000009
@property (nonatomic,copy) NSString *checkCode;//验票码(取票码):1507310000091066
@property (nonatomic,copy) NSString *qrCodeImgUrl;//订单二维码图片链接

@property (nonatomic,copy) NSString *orderUserName;//预订人
@property (nonatomic,copy) NSString *orderPhoneNum;//联系人手机

@property (nonatomic, assign) NSInteger costCredit;//参与此活动消耗的积分数

@property (nonatomic,assign) BOOL tUserIsFreeze;//使用者是否被冻结

/** 订单状态:  0.未定义  1.预订成功 2.已取消 3.已出票 4.已验票 5.已过期 6.已删除 */
@property (nonatomic,assign) NSInteger orderStatus;
/** 订单支付状态：0-无需支付  1-未支付  2-支付成功  3-退款中  4-退款成功 */
@property (nonatomic,assign) NSInteger orderPayStatus;
@property (nonatomic, assign) NSInteger orderPayMethod;// 支付方式： 1-支付宝  2-微信


@property (nonatomic,assign) BOOL activityIsSalesOnline;//是否为在线选座
@property (nonatomic,assign) BOOL activityIsFree;//活动是否免费
@property (nonatomic,assign) NSInteger peopleCount;//活动参与的人数
@property (nonatomic,copy) NSArray *showedSeatArray;//座位：x排x座
@property (nonatomic,copy) NSArray *seatLineArray;//取消座位时使用:x


- (id)initWithAttributes:(NSDictionary *)dict;



@end
