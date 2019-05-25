//
//  UserCollectModel.h
//  CultureHongshan
//
//  Created by xiao on 15/7/13.
//  Copyright (c) 2015年 Sun3d. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCollectModel : NSObject

@property (nonatomic,copy) NSString *collectId;//收藏id
@property (nonatomic,copy) NSString *modelId;//活动 或 场馆的id

@property (nonatomic,copy) NSString *imageUrl;//图片
@property (nonatomic,copy) NSString *titleStr;//活动或者场馆的名称
@property (nonatomic,copy) NSString *addressStr;//地址
@property (nonatomic,copy) NSString *dateStr;//活动的举办日期
@property (nonatomic,copy) NSString *collectDateStr;//收藏日期
@property (nonatomic,copy) NSString *activityVenueName;//活动所属场馆


@property (nonatomic, assign) NSInteger type;


//  type说明： 1-－－活动  2-－－场馆
+ (NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray withType:(NSInteger)type;


@end
