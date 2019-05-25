//
//  MYAlertView.h
//  WHYUIToolKit
//
//  Created by JackAndney on 2017/10/26.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MYAlertViewDelegate;


/**
 自定义弹窗
 */
@interface MYAlertView : UIView

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *msgFont;
@property (nonatomic, strong) UIFont *btnFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *msgColor;
@property (nonatomic, strong) UIColor *btnColor;

@property (nonatomic, copy) void (^didClickItemBlock)(MYAlertView *alertView, NSString *title, NSInteger index);
@property (nonatomic, copy) void (^didDismissBlock)(MYAlertView *alertView, NSString *title, NSInteger index);

@property (nonatomic, assign) BOOL dismissWhenTouchBackground; // 点击背景区域是否消失弹窗，默认为NO

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<MYAlertViewDelegate>)delegate actionTitles:(NSArray<NSString *> *)actionTitles;

- (void)showInView:(UIView *)view; // parentView为空时，用view代替


@end



#pragma mark - MYAlertViewDelegate


@protocol MYAlertViewDelegate <NSObject>

@optional


/**
 弹窗按钮点击回调

 @param alertView 弹窗视图
 @param title     按钮标题
 @param index     按钮索引：从下到上，从0计数（仅2个时，左侧按钮的索引为0，右侧为1）
 */
- (void)alertView:(MYAlertView *)alertView didClickItem:(NSString *)title atIndex:(NSInteger)index;
// 弹窗消失（点击背景区域时，title为nil, index为-1）

/**
 弹窗消失回调
 
 @param alertView 弹窗视图
 @param title     若点击按钮消失，则为按钮标题，否则为nil
 @param index     索引：若点击按钮消失，则为按钮的索引，否则为-1
 */
- (void)alertView:(MYAlertView *)alertView didDismissWithItem:(NSString *)title atIndex:(NSInteger)index;

@end
