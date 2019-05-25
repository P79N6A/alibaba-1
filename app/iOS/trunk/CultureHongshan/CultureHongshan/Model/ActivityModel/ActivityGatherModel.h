//
//  ActivityGatherModel.h
//  CultureHongshan
//
//  Created by ct on 17/2/8.
//  Copyright © 2017年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 采编活动Model */
@interface ActivityGatherModel : NSObject
@property (nonatomic, assign) BOOL gatherIsCollect; // 是否收藏


@property (nonatomic, copy) NSString *gatherId;
@property (nonatomic, assign) ActivityGatherType gatherType;
@property (nonatomic, copy) NSString *gatherTitle;
@property (nonatomic, copy) NSString *gatherIconUrl;
@property (nonatomic, copy) NSString *gatherLink; // 访问链接

// 电影类型
@property (nonatomic, copy) NSString *gatherMovieType;
@property (nonatomic, copy) NSString *gatherMovieTime;
@property (nonatomic, copy) NSString *gatherMovieActor;
@property (nonatomic, copy) NSString *gatherMovieDirector;

// 其它类型
@property (nonatomic, copy) NSString *gatherAddress;
@property (nonatomic, copy) NSString *gatherHost;
@property (nonatomic, copy) NSString *gatherTime;
@property (nonatomic, copy) NSString *gatherPrice;


@property (nonatomic, strong) NSArray *listArray;

/** 文化日历List单元格中数据的显示数组 */
- (NSArray *)handleCalemdarListShowDataArray;


+ (NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray;
@end



/** 采编活动标签处理 */
NSString *MYActivityGatherTypeShowHandle(ActivityGatherType tagType);
ActivityGatherType MYServerGatherTypeHandle(NSInteger type);
/** 采编类型对应的颜色 */
UIColor *MYActivityGatherTypeColorHandle(ActivityGatherType tagType);

