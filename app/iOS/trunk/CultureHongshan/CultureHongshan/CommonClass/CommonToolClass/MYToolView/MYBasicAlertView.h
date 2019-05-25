//
//  MYBasicAlertView.h
//  WHYUIToolKit
//
//  Created by JackAndney on 2017/11/1.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYBasicAlertView : UIView

@property (nonatomic, assign) CGFloat contentOffsetY;
@property (nonatomic, assign) BOOL strictWidthConstraint; // 横屏时的视图宽度是否与竖屏一样，默认为YES
@property (nonatomic, assign) BOOL dismissWhenTouchBackground; // 点击背景区域是否消失，默认为NO

@property (nonatomic, strong, readonly) UIView *contentView;

- (void)showWithAnimation:(BOOL)animated;
- (void)dismissWithAnimation:(BOOL)animated;

// 子类必须（或可以）重写的方法
- (void)tapOnBackgroundForDisappear; // dismissWhenTouchBackground为YES时，子类可以重写该方法
- (void)configContentViewConstraints; // 添加contentView的约束（子类可以覆盖该方法）
- (void)showInView:(UIView *)view; // 弹窗显示在哪个视图上，如果传nil，则显示在主window上

@end
