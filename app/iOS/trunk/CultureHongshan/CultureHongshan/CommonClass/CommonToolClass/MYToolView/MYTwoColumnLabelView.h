//
//  MYTwoColumnLabelView.h
//  WHYUIToolKit
//
//  Created by JackAndney on 2017/10/31.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 左右两列Label的视图
 
 @discussion 左侧Label只显示一行，右侧根据内容多少而定
 */
@interface MYTwoColumnLabelView : UIView

@property (nonatomic, strong, readonly) UILabel *leftLabel;
@property (nonatomic, strong, readonly) UILabel *rightLabel;
@property (nonatomic, assign) CGFloat spacingX; // 两个Label的水平间距，默认为1
@property (nonatomic, assign) CGFloat lineSpacing; // 行间距，默认为0

/**
 初始化方法
 
 @discussion 通过Frame设置时，其高度无效，高度会重新计算
 
 @param leftTitle  左侧标题(不能为空)
 @param rightTitle 右侧标题
 @param font       字体
 @param tColor     文字颜色
 */
- (instancetype)initWithFrame:(CGRect)frame leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle font:(UIFont *)font tColor:(UIColor *)tColor;


/**
 刷新子视图
 */
- (void)reloadSubviews; // 左侧Label的文字长度变化时，须调用该方法刷新

/** 更新右侧Label文字 */
- (void)updateRightTitle:(NSString *)title; // 只需要在lineSpacing>0时，通过该方法更新文字

@end
