//
//  MYTwoColumnView.h
//  WHYUIKit
//
//  Created by JackAndney on 2017/5/14.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MYSmartLabel;

/**
 左右各一个Label的视图，右侧Label可以多行
 */
@interface MYTwoColumnView : UIView


@property (nonatomic, strong) MYSmartLabel *leftLabel;
@property (nonatomic, strong) MYSmartLabel *rightLabel;


/**
 初始化方法
 
 @param leftTitle  左侧标题(不能为空)
 @param rightTitle 右侧标题
 @param font       字体
 @param tColor     文字颜色
 */
- (instancetype)initWithFrame:(CGRect)frame leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle font:(UIFont *)font tColor:(UIColor *)tColor;

- (void)updateLeftWidth:(CGFloat)leftWidth;


@end
