                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         //
//  CustomPointAnnotation.h
//  CultureHongshan
//
//  Created by ct on 15/11/20.
//  Copyright © 2015年 CT. All rights reserved.
//

#import <AMapNaviKit/AMapNaviKit.h>

@interface CustomPointAnnotation : MAPointAnnotation

@property (nonatomic,copy) NSString *detailID;//活动或者场馆的ID

@property (nonatomic,copy) NSString *imageURL;//图片URL
@property (nonatomic,copy) NSString *introduce;//活动或者场馆的简短介绍
@property (nonatomic,copy) NSString *name;//活动或者场馆的名字
@property (nonatomic,copy) NSString *address;//活动或者场馆的地址
@property (nonatomic,copy) NSString *time;//活动或者场馆的时间
@property (nonatomic,copy) NSString *tagName;//活动标签
@property (nonatomic,copy) NSString *tagRGB;//地图中标签的颜色
@property (nonatomic,assign) NSInteger ticket;//活动或者场馆的余票
@property (nonatomic,assign) BOOL activityIsReservation;

@property (nonatomic,copy) NSString *activityPrice;//活动价格，对应活动参加方式
//活动价格的显示颜色
@property (nonatomic,copy) UIColor *activityPriceColor;



@end
