//
//  ActivityListDetail.h
//  CultureHongshan
//
//  Created by xiao on 15/7/9.
//  Copyright (c) 2015年 Sun3d. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecKillModel.h"

@interface ActivityDetail : NSObject

@property (nonatomic,assign) BOOL activityIsGathered; // 是否为采编的活动
@property (nonatomic,assign) BOOL activityIsCollect;
@property (nonatomic,assign) BOOL activityIsWant;// 1－ 点过赞， 0 － 未点过赞
@property (nonatomic,assign) BOOL activityIsSalesOnline;//是否支持在线选座 Y 是 N否
@property (nonatomic,assign) BOOL activityIsReservation;
@property (nonatomic,assign) NSInteger activitySupplementType; // 活动预订补充类型：1-不可预订  2-直接前往  3-电话预约


@property (copy, nonatomic) NSString *activityId;
@property (copy, nonatomic) NSString *activityName;
@property (copy, nonatomic) NSString *activityAddress;
@property (copy, nonatomic) NSString *activityIconUrl;
@property (copy, nonatomic) NSString *activityTel;
@property (copy, nonatomic) NSString *activityStartTime;
@property (copy, nonatomic) NSString *activityEndTime;

@property (nonatomic) double activityLon;
@property (nonatomic) double activityLat;


@property (copy, nonatomic) NSString *activityMemo;
@property (copy,nonatomic) NSString *activityTimeDes;//时间备注


@property (copy, nonatomic) NSString *priceDescribe;//价格说明

@property (copy, nonatomic) NSString *shareUrl;

@property (copy, nonatomic) NSString *activityNotice;//活动购票须知
@property (copy, nonatomic) NSString *activityInformation;//活动详情里的活动须知说明（温馨提示）

@property (copy, nonatomic) NSString *activityFunName;//活动模板名称：字符串拼接(我要投票,视频,实况直击,活动点评)

@property (nonatomic, strong) NSArray *activityInfoArray;//活动基本信息数组
// 子数组的数据结构： @[leftTitle, rightTitle, tagArray[], linkId];  或 @[leftTitle, rightTitle];
@property (nonatomic, strong) NSArray *activityUnitArray;// 活动单位数组
@property (nonatomic, copy) NSString *associationId;// 社团Id

//秒杀
@property (nonatomic, strong) NSArray *seckillArray;//秒杀时间点数组

@property (copy, nonatomic) NSString *showedAddress;//显示的地址
@property (copy, nonatomic) NSString *showedDate;//显示的日期
@property (copy, nonatomic) NSArray *showedTimeArray;//显示的时间段
@property (copy, nonatomic) NSString *showedPrice;//显示的价格
/**  活动支付单价 */
@property (nonatomic, copy) NSString *activityUnitPrice;

@property (copy, nonatomic) NSArray *showedActivityTags;//活动的标签，通过data1获取(showedActivityTags)
/*  ————————————————————  活动预订相关的属性  ————————————————————  */

@property (nonatomic) NSInteger activityAbleCount;//活动剩余票数
@property (copy, nonatomic) NSString *status;//活动时间状态: 0.已过期或票已售完 1未过期，字符串拼接
@property (copy, nonatomic) NSString *timeQuantum;//活动时间段
@property (copy, nonatomic) NSString *activityEventimes;//活动具体时间（用于在线选座传参数）
@property (copy, nonatomic) NSString *activityEventIds;//活动场次id（用于在线选座传参数）
@property (copy, nonatomic) NSString *spikeDifferences;//每个活动秒杀倒计时（时间戳）（如果非秒杀活动为0）

@property (copy, nonatomic) NSString *eventCounts;//每个场次的最大预订票数
@property (copy, nonatomic) NSString *eventPrices;//每个场次的价格

@property (nonatomic, assign) BOOL isSingleEvent;//是否为单场次活动
@property (nonatomic, assign) BOOL isSeckillActivity;//是否为秒杀的活动
@property (nonatomic, assign) BOOL isNeedIdentityCard;//是否需要身份证号

@property (nonatomic, assign) BOOL isDefaultTicketSetting;//账号订票设置（Y默认,N自定义）
@property (nonatomic, assign) NSInteger limitedFrequency;//订票限制次数
@property (nonatomic, assign) NSInteger limitedCount;//单次最大订票张数
@property (nonatomic, assign,readonly) NSInteger maxCount;//最大订票张数
@property (nonatomic, assign) NSInteger actIsFree; // 是否免费: 1-免费 2-收费 3-支付
@property (nonatomic, assign) NSInteger priceType;// 价格类型：0：XX元起  1:XX元/人  2:XX元/张   3:XX元/份  其它:XX元/张
@property (nonatomic, assign) NSInteger lowestCredit;//参与此活动用户拥有的最低积分
@property (nonatomic, assign) NSInteger costCredit;//参与此活动消耗的积分数
@property (nonatomic, assign) NSInteger requiredScoreType;//0-不需要积分 1-仅需要积分作为门槛，2-仅需要扣除相应的积分，3-既需要积分作为门槛，也要扣除积分
@property (nonatomic, assign) NSInteger deductionCredit;//没有参加活动后将扣除的积分
@property (nonatomic, assign) NSInteger integralStatus;//用户的积分状态:0-可以预订 1-未达最低积分 2-未达抵扣积分
@property (copy, nonatomic) NSString *showedLimitedNotice;//限购提示
@property (copy, nonatomic) NSString *showedScoreNotice;//积分限制提示

@property (nonatomic, copy) NSString *subPlatformReserveUrl; // 子平台活动预订URL
/*  ————————————————————  自定义的属性  ————————————————————  */

@property (nonatomic, assign) NSInteger totalNumOfComment;//总评论数
@property (nonatomic, assign) NSInteger totalNumOfLike;//总点赞数
@property (nonatomic, assign) NSInteger totalNumOfScan;//总浏览数
@property (nonatomic, assign) NSInteger totalNumOfOtherActivity;//总其他活动数

@property (nonatomic,assign,readonly) NSInteger reserveStatus;//1-已结束  2-直接前往  3-已订完  4-无法预订 5-立即预订



-(id)initWithAttributes:(NSDictionary *)dictionary;

/**
 *  判断是否显示“活动详情、活动单位”锚点
 */
- (BOOL)isShowAnchor;


@end
