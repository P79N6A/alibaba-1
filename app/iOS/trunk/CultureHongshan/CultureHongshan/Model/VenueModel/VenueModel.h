//
//  VenueModel.h
//  CultureHongshan
//
//  Created by one on 15/11/7.
//  Copyright © 2015年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VenueSubModel.h"

@interface VenueModel : NSObject

@property (nonatomic, copy) NSString *venueId;//展馆id
@property (nonatomic, copy) NSString *venueAddress;//展馆地址
@property (nonatomic, copy) NSString *venueIconUrl;//展馆图片
@property (nonatomic, copy) NSString *venueName;//展馆名称
@property (nonatomic, copy) NSString *venueLat;//展馆纬度
@property (nonatomic, copy) NSString *venueLon;//展馆纬度
@property (nonatomic, copy) NSString *distance;//用户与展馆间的距离
@property (nonatomic,copy,readonly) NSString *showedDistance;//显示的距离
@property (nonatomic, assign) BOOL venueIsReserve;


@property (nonatomic,assign) NSInteger venueOnlineActivityCount;//在线预订活动数
@property (nonatomic,assign) NSInteger venueRoomCount;//活动室数



//不用的字段
@property (nonatomic, copy) NSString *activityNewName;//最新活动的名称
@property (nonatomic, copy) NSString *remarkUserImgUrl;//评论人头像
@property (nonatomic, assign) BOOL venueHasBus;
@property (nonatomic, assign) BOOL venueHasMetro;
@property (nonatomic, copy) NSString *venueMemo;//展馆简介
@property (nonatomic, copy) NSString *venueStars;//展馆星级
@property (nonatomic, copy) NSString *remarkName;//评论人名
@property (nonatomic, copy) NSString *commentRemark;//评论内容

+(NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray;


//获取所有场馆的id
+ (NSString *)getAllVenueIdStringWithListArray:(NSArray *)listArray;

//两个Model数组的数据匹配
+ (NSArray *)getMatchedModelWithVenueModelArray:(NSArray *)venueArray subModelDict:(NSDictionary *)subModelDict;



@end
