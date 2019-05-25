//
//  TagModel.h
//  CultureHongshan
//
//  Created by ct on 15/11/7.
//  Copyright © 2015年 CT. All rights reserved.
//



#import <Foundation/Foundation.h>

/**
 获取首页活动（主题和类型）标签列表接口
 */
@interface TagModel : NSObject

@property (nonatomic, assign) NSInteger type;//1-活动类型标签 2-用途  3-面积  4-活动人数  5-配套设备

@property (nonatomic, copy) NSString *tagId;
@property (nonatomic, copy) NSString *tagName;


+ (NSArray *)listArrayWithArray:(NSArray *)dictArray type:(NSInteger)type;

@end






@interface ThemeTagModel : NSObject

@property (nonatomic,copy) NSString *recommendTagId;//推荐标签Id

@property (nonatomic,copy) NSString *tagId;//主题标签id
@property (nonatomic,copy) NSString *tagName;//主题标签名称
@property (nonatomic,copy) NSString *tagImageUrl;//标签图片
@property (nonatomic,copy) NSString *status;//status：用户是否选择该标签的状态 1 选中 2.未选中


//参数itemDict为构建Model的字典
- (id)initWithItemDict:(NSDictionary *)itemDict;

//由数组生成Model数组
+ (NSArray *)listArrayWithArray:(NSArray *)array;


@end
