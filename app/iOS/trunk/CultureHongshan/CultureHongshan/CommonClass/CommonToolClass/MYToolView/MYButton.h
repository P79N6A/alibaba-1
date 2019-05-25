//
//  MYButton.h
//  WHYUIToolKit
//
//  Created by JackAndney on 2017/10/19.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,MYButtonContentLayout) {
    MYButtonLayoutNormal = 0,          // 普通的按钮
    MYButtonLayoutImageLeft,           // 图像左、文字右(leftMargin和rightMargin均为0时两者居中，否则两者左对齐或右对齐)
    MYButtonLayoutImageRight,          // 图像右、文字左(leftMargin和rightMargin均为0时两者居中，否则两者左对齐或右对齐)
    MYButtonLayoutImageUp,             // 图像上、文字下
    MYButtonLayoutImageDown,           // 图像下、文字上
    MYButtonLayoutJustifiedImageLeft,  // 两端对齐，图片居左
    MYButtonLayoutJustifiedImageRight, // 两端对齐，图片居右
};



@interface MYButton : UIButton

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) NSInteger section; // 用于区别不同的按钮
@property (nonatomic, assign) BOOL animatedWhenClick; // 点击时是否显示动画，默认为NO
@property (nonatomic, assign) BOOL didSetupEdgeInsets; // 是否已设置过图片和文字的偏移量，通过重设为NO可以重绘视图

// 图片与文字共存时所需属性
@property (nonatomic, assign) CGFloat leftMargin; // 左边距，默认为0
@property (nonatomic, assign) CGFloat rightMargin; // 右边距，默认为0
@property (nonatomic, assign) CGFloat spacing; // 图文之间的水平（或垂直）间距，默认为5

@property (nonatomic, copy) void(^clickBlock)(MYButton *sender);


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font tColor:(UIColor *)tColor bgColor:(UIColor *)bgColor;
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image selectedImage:(UIImage *)selectedImage;

// 带block的方法
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font tColor:(UIColor *)tColor bgColor:(UIColor *)bgColor actionBlock:(void(^)(MYButton *sender))actionBlock;
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image selectedImage:(UIImage *)selectedImage actionBlock:(void(^)(MYButton *sender))actionBlock;

// 文字与图片同时显示
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image layout:(MYButtonContentLayout)layout actionBlock:(void(^)(MYButton *sender))actionBlock;

@end
