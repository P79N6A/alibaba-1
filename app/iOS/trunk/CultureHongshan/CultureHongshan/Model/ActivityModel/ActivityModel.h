//
//  ActivityModel.h
//  CultureHongshan
//
//  Created by ct on 15/11/7.
//  Copyright © 2015年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ActivityModel : NSObject


// BOOL值
@property (nonatomic,assign) BOOL activityIsCollect;//活动是否被收藏
@property (nonatomic,assign) BOOL activityIsSecKill;//活动是否为秒杀的活动
@property (nonatomic,assign) BOOL activityIsSalesOnline;//是否为在线预订
@property (nonatomic,assign) BOOL activityIsReservation;//是否可预订
@property (nonatomic,assign) NSInteger activitySupplementType; // 活动预订补充类型：1-不可预订  2-直接前往  3-电话预约
@property (nonatomic,assign) BOOL activityIsPast;//是否过期
@property (nonatomic, assign) NSInteger activityIsReserved; //(我的日历中使用)是否已经预订: 1-已预订  3-直接前往  其它-未预订


@property (nonatomic,copy) NSString *activityId;//活动id
@property (nonatomic,copy) NSString *activityName;//活动名称
@property (nonatomic,copy) NSString *venueName;//活动所在的场馆名
@property (nonatomic,assign) double activityLat;//活动纬度
@property (nonatomic,assign) double activityLon;//活动经度
@property (nonatomic,copy) NSString *activityAddress;//活动地点(地点不存在，则用地址)
@property (nonatomic,copy) NSString *activityIconUrl;//活动图片
@property (nonatomic,copy) NSString *activityLocationName;//商圈.场馆名
@property (nonatomic,copy) NSString *activitySubject;//7个字主题标签.在线选座

@property (nonatomic,copy) NSString *showedPrice;//显示的价格
@property (nonatomic,assign) NSInteger activityAbleCount;//活动剩余票数

@property (nonatomic,copy) NSString *showedActivityDate;//显示的活动日期
@property (nonatomic,copy) NSString *showedDistance;//显示的距离

@property (nonatomic,copy) NSString *distance;//用户与活动之间的距离
@property (nonatomic,copy) NSString *activityType;// 活动类型（只有一个）
@property (nonatomic,copy) NSArray  *activityTagArray;// 类型下的标签

/* 3.5属性 */
@property (nonatomic,copy) NSArray *jointedTagArray;//在线预订、绘画、萌娃最爱

/* 文化日历相关属性 */
@property (nonatomic, assign) NSInteger orderOrCollect; //  1-订单活动  2-收藏活动




- (id)initWithAttributes:(NSDictionary *)itemDict;

//由数组生成Model数组
+ (NSArray *)listArrayWithArray:(NSArray *)array;

+ (NSArray *)listArrayWithArray:(NSArray *)array removedActivityId:(NSString *)activityId;



@end
