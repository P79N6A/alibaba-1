//
//  MYSmartButton.h
//  WHYToolSDK
//
//  Created by JackAndney on 2017/5/14.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ButtonContentLayout) {
    ButtonContentLayoutNormal = 0,          // 普通的按钮
    ButtonContentLayoutImageLeft,           // 图像左、文字右
    ButtonContentLayoutImageRight,          // 图像右、文字左
    ButtonContentLayoutImageUp,             // 图像上、文字下
    ButtonContentLayoutImageDown,           // 图像下、文字上
    ButtonContentLayoutJustifiedImageLeft,  // 两端对齐，图片居左
    ButtonContentLayoutJustifiedImageRight, // 两端对齐，图片居右
};


/**
 自定义的Button
 */
@interface MYSmartButton : UIButton

@property (nonatomic, assign) NSInteger row; // 用于区别不同行的单元格

/** 点击时是否需要动画：默认为NO */
@property (nonatomic, assign) BOOL animationWhenClicked;

@property (nonatomic, strong) UIFont *titleFont; // 请通过该属性给字体赋值，而不是button.titleLable.font
@property (nonatomic, assign) CGFloat spacing; // 设置图片和文字之间的水平或垂直方向的距离，默认值为6。
@property (nonatomic, assign) CGFloat leftMargin; // 左侧外边距，默认值为5
@property (nonatomic, assign) CGFloat rightMargin; // 右侧外边距，默认值为5
/**
 *  图片与文字共存的Button
 *
 *  @param layout 图像显示的位置ButtonContentLayout
 *
 */
- (instancetype)initWithFrame:(CGRect)frame contentLayout:(ButtonContentLayout)layout font:(UIFont *)font actionBlock:(void(^)(MYSmartButton *sender))block;


/**
 普通的带Title的按钮
 */
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font tColor:(UIColor *)tColor bgColor:(UIColor *)bgColor actionBlock:(void(^)(MYSmartButton *sender))block;

/**
 普通的带图片的按钮
 */
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image selectedImage:(UIImage *)selectedImage actionBlock:(void(^)(MYSmartButton *sender))block;


#pragma mark - AutoLayout 方法

+ (instancetype)al_buttonWithContentLayout:(ButtonContentLayout)layout font:(UIFont *)font title:(NSString *)title tColor:(UIColor *)tColor image:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor radius:(CGFloat)radius actionBlock:(void(^)(MYSmartButton *sender))block;





@end
