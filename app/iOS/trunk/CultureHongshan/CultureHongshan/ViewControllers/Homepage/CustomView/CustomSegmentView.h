//
//  CustomSegmentView.h
//  CultureHongshan
//
//  Created by ct on 16/4/12.
//  Copyright © 2016年 CT. All rights reserved.
//


/*
 
 按钮多选：活动、场馆
 
 */

#import <UIKit/UIKit.h>

@interface CustomSegmentView : UIView


@property (nonatomic, assign, readonly) BOOL isSameIndex;//两次点击的是否为同一个按钮

+ (instancetype)segmentViewWithFrame:(CGRect)frame
                         normalColor:(UIColor *)normalColor
                       selectedColor:(UIColor *)selectedColor
                           lineColor:(UIColor *)lineColor
                         titleArrray:(NSArray *)titleArray
                       callBackBlock:(IndexBlock)block;


@end
