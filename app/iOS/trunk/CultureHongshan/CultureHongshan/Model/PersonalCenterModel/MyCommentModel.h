//
//  MyCommentModel.h
//  CultureHongshan
//
//  Created by ct on 16/4/13.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCommentModel : NSObject

@property (nonatomic, assign) DataType type;

@property (nonatomic,copy) NSString *commentId;//评论id
@property (nonatomic,copy) NSString *modelId;//活动 或 场馆的id
@property (nonatomic,copy) NSString *titleStr;//活动或者场馆的名称
@property (nonatomic,copy) NSString *addressStr;//地址：活动的先显示活动所在的场馆名，没有再显示活动的地址
@property (nonatomic,copy) NSString *contentStr;//评论内容
@property (nonatomic,copy) NSArray  *imageUrlArray;//图片链接数组
@property (nonatomic,copy) NSString *dateStr;//评论日期


//  type说明： 1-－－活动  2-－－场馆
+ (NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray withType:(DataType)type;


@end
