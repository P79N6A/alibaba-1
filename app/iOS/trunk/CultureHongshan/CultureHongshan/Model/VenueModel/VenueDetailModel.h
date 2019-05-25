//
//  VenueDetailModel.h
//  CultureHongshan
//
//  Created by one on 15/11/11.
//  Copyright © 2015年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VenueDetailModel : NSObject

@property (nonatomic, copy) NSString *venueId;//展馆id
@property (nonatomic, copy) NSString *venueName;//展馆名称
@property (nonatomic, copy) NSString *venueIconUrl;//展馆图片URL
@property (nonatomic, copy) NSString *venueAddress;//展馆地址
@property (nonatomic, assign) double venueLat;//展馆纬度
@property (nonatomic, assign) double venueLon;//展馆经度
@property (nonatomic, copy) NSString *venueMobile;//咨询电话
@property (nonatomic, copy) NSString *showedVenuePrice;
@property (nonatomic, copy) NSString *showedVenuePriceAndNotice;//展馆费用与收费说明
@property (nonatomic, copy) NSString *venueMemo;//展馆详情内容

@property (nonatomic, assign) BOOL venueIsCollect;//是否收藏(未登录显示未收藏)
@property (nonatomic, assign) BOOL venueIsReserve;//是否可预订
@property (nonatomic, assign) BOOL venueIsWant;//是否已经对场馆点赞(报名)

@property (nonatomic, copy) NSString *showOpenTimeAndNotice;//开放时间与备注

@property (nonatomic, copy) NSString *shareUrl; //分享URL
@property (nonatomic, copy) NSString *venueVoiceUrl;//展馆音频地址url
@property (nonatomic, copy) NSString *venueAreaName;//场馆所在的区域（商圈）

@property (nonatomic, strong) NSArray *roomIconUrls;//活动室图片数组
@property (nonatomic, strong) NSArray *roomNames;//活动室标题数组
//@property (nonatomic, strong) NSArray *venueTagNames;//场馆的标签数组
@property (nonatomic, copy) NSArray *showedVenueTags;//展示的标签数组

@property (nonatomic, assign) long totalNumOfRelatedActivity;//总相关活动数
@property (nonatomic, assign) long totalNumOfPlayRoom;//总活动室数
@property (nonatomic, assign) long totalNumOfComment;//总评论数
@property (nonatomic, assign) long totalNumOfLike;//总点赞数
@property (nonatomic, assign) long totalNumOfScan;//总浏览数


-(id)initWithAttributes:(NSDictionary *)dictionary;
+(NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray;

@end
