//
//  InsideRoundedView.h
//  ToolProject
//
//  Created by ct on 16/1/7.
//  Copyright © 2016年 ct. All rights reserved.
//

#import <UIKit/UIKit.h>

//内侧圆角视图

@interface InsideRoundedView : UIView

@property (nonatomic,assign) CGFloat arrowPosition;//箭头的位置，默认居中

@property (nonatomic,strong) UIColor *fillColor;//填充颜色，默认白色

@property (nonatomic,assign) BOOL isArrow;//是否带有箭头，默认无

@property (nonatomic,assign) CGFloat radius;//圆角半径，默认8

@property (nonatomic,assign) CGFloat arrowHeight;//箭头的高度，默认12


@end
