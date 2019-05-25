//
//  OrderDetailModel.h
//  CultureHongshan
//
//  Created by ct on 16/5/13.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailModel : NSObject

@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double latitude;

@property (nonatomic, assign) NSInteger type;//1- 活动  2- 场馆
@property (nonatomic, assign) BOOL isUncheckOrder;//是否“待审核订单”
@property (nonatomic, assign) BOOL isUnParticipateOrder;//是否“待参加订单”
@property (nonatomic, assign) BOOL isHistoryOrder;//是否“历史订单”


/* ————————————————————————————  公共的属性  ———————————————————————————— */
@property (nonatomic,copy) NSString *orderId;//订单Id
@property (nonatomic,copy) NSString *modelId;//活动 或 活动室的id
@property (nonatomic,copy) NSString *titleStr;//活动 或者 活动室的名称
@property (nonatomic,copy) NSString *venueName;//场馆名
@property (nonatomic,copy) NSString *venueAddress;//场馆的地址
@property (nonatomic,copy) NSString *addressStr;//活动的［地点］ 或 场馆的地址
@property (nonatomic,copy) NSString *imageUrl;//活动 或 活动室的封面图片
@property (nonatomic,copy) NSString *priceStr;//活动 或 活动室的收费价格
@property (nonatomic,copy) NSString *participateDate;//活动的参加日期（预订的是哪一天的活动） 或 活动室的预订日期: yyyy年M月d日 周x
@property (nonatomic,copy) NSString *participateTime;//活动参加的时间段 或 活动室的预订场次： 10:00-15:00
@property (nonatomic,copy) NSString *orderCreatTime;//下单时间:yyyy-MM-dd HH:mm:ss
@property (nonatomic,copy) NSString *orderPayTime;//支付时间:时间戳
@property (nonatomic,copy) NSString *orderNumber;//订单号:150731000009
@property (nonatomic,copy) NSString *checkCode;//验票码(取票码):1507310000091066
@property (nonatomic,copy) NSString *qrCodeImgUrl;//订单二维码图片链接
@property (nonatomic,copy) NSString *helpLinkUrl;//帮助中心的链接

@property (nonatomic,copy) NSString *orderName;//预订人
@property (nonatomic,copy) NSString *orderPhoneNo;//联系人手机

@property (nonatomic, assign) NSInteger lowestCredit;//参与此活动用户拥有的最低积分
@property (nonatomic, assign) NSInteger costCredit;//参与此活动消耗的积分数
@property (nonatomic, assign) NSInteger showedCostCredit;//显示的扣除积分


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
@property (nonatomic,assign) NSInteger orderStatus;//订单状态
/** 订单支付状态：0-无需支付  1-未支付  2-支付成功  3-退款中  4-退款成功 */
@property (nonatomic,assign) NSInteger orderPayStatus;
@property (nonatomic,assign) NSInteger certifyStatus;//认证状态


/* ————————————————————————————  活动订单的特有属性  ———————————————————————————— */

@property (nonatomic,assign) BOOL activityIsSalesOnline;//是否为在线选座
@property (nonatomic,assign) BOOL activityIsFree;//活动是否免费
@property (nonatomic,copy) NSString *activityAddress;//活动地址
@property (nonatomic,copy) NSString *peopleCountStr;//活动参与的人数
@property (nonatomic,copy) NSArray *showedSeatArray;//座位：x排x座
@property (nonatomic,copy) NSArray *seatLineArray;//取消座位时使用:x
//只有需要积分消耗的时候才出现积分标签
//@property (nonatomic,assign) NSInteger requiredScoreType;//积分要求的类型： 0-不需要积分 1-仅需要积分作为门槛，2-仅需要扣除相应的积分，3-既需要积分作为门槛，也要扣除积分


/* ————————————————————————————  活动室订单的特有属性  ———————————————————————————— */
@property (nonatomic,copy) NSString *venueId;//场馆的ID
@property (nonatomic,copy) NSString *roomUser;//活动室的使用者
@property (nonatomic,copy) NSString *roomUserId;//活动室的使用者Id：为空时，需要进行“资质认证”，否则显示为“待审核”
@property (nonatomic,copy) NSString *roomBooker;//预订联系人
@property (nonatomic,copy) NSString *bookerTel;//联系人手机


// type说明： 1-－－活动  2-－－场馆活动室
- (id)initWithAttributes:(NSDictionary *)dict type:(NSInteger)type;


+ (void)matchedOrderStatus:(NSInteger)status
                  userType:(NSInteger)userType
            tuserIsDisplay:(NSInteger)tuserIsDisplay
               checkStatus:(NSInteger)checkStatus
                   tUserId:(NSString *)tUserId
               orderStatus:(NSInteger *)orderStatus//目标订单状态
             certifyStatus:(NSInteger *)certifyStatus//目标认证状态
                      type:(NSInteger)type;//1-活动订单  2-活动室订单

@end
