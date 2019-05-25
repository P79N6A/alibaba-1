//
//  AdvertModel.h
//  CultureHongshan
//
//  Created by ct on 16/6/27.
//  Copyright © 2016年 CT. All rights reserved.
// 526091b990c3494d91275f75726c064f

#import <Foundation/Foundation.h>

/**
 *  广告位Model：
 */
@interface AdvertModel : NSObject

@property (nonatomic,assign) NSInteger type;

@property (nonatomic,copy   ) NSString  *advertId;
@property (nonatomic,copy   ) NSString  *advertName;
@property (nonatomic,copy   ) NSString  *advertType; // 广告类型：A、B、C、D
@property (nonatomic,copy   ) NSString  *advImgUrl;//图片地址
@property (nonatomic,copy   ) NSString  *advUrl;//栏目连接内容(数据id或url 或关键词)
@property (nonatomic, assign) NSInteger advertSort;//排序
@property (nonatomic,assign ) BOOL      isOuterLink;//是否为外链
/**
 *  内链类型:0.活动列表 1.活动详情 2.场馆列表 3.场馆详情  4.文化日历  5.活动列表（带标签筛选）
 */
@property (nonatomic,assign) NSInteger advLinkType;
// 后台目前还未开发的字段
@property (nonatomic, copy) NSString *advShareContent;//分享的内容
@property (nonatomic, copy) NSString *advShareImgUrl;//分享的图片


/*
 type说明：  1.文化活动列表中的插入广告（跟随标签切换）
            2.文化日历中的一个广告
            3.文化空间 中的广告
            4.首页所有的广告
 */
- (id)initWithItemDict:(NSDictionary *)itemDict type:(NSInteger)type;

+ (NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray type:(NSInteger)type;

// 广告位置排序
+ (void)sortAdvertArray:(NSMutableArray *)modelArray;

@end
