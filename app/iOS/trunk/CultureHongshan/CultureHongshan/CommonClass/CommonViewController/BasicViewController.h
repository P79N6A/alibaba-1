//
//  BasicViewController.h
//  徐家汇
//
//  Created by 李 兴 on 14-2-27.
//  Copyright (c) 2014年 李 兴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CacheServices.h"
#import "NoDataNoticeView.h"
#import "LogService.h"
#import "MYNoDataView.h"



#define RETURN_BLANK_CELL \
UITableViewCell *blankCell = [tableView dequeueReusableCellWithIdentifier:@"Blank_Cell"];\
if (!blankCell) {\
    blankCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Blank_Cell"];\
    blankCell.contentView.backgroundColor = kBgColor;\
}\
return blankCell;


@interface BasicViewController : UIViewController <MYNoDataViewDelegate>
{
    /** 是否添加App进入退出前后台通知 */
    BOOL _addAppBecomeActiveNotification;
    
    NSInteger keyboardHeight;
    NSString * _dataUrl;
    UIView * viewOnKeyboard;
    NSInteger _maxKeyboardHeight;
    UIView * _currentInputFocusView;
    
    CGFloat _beginDragOffsetY;
    CGFloat _preOffsetY;
    BOOL _didRequestData; //是否请求过数据
    BOOL _hasInputView;// 页面中是否有文本输入框【只有在有输入框的页面，才会添加键盘通知】
}

 
@property (nonatomic, assign) BOOL preVCIsLogin; // 上一个页面是否为登录页面
@property (nonatomic, assign) BOOL statusBarIsBlack; // 状态栏是否为黑色字体
@property (nonatomic, strong, nullable) UIView *maskView;
@property (nonatomic, strong, nullable) UIActivityIndicatorView *indicator;
@property (nonatomic, strong, nullable) MYNoDataView *noDataView;

- (void)initNavgationBar;

// 键盘将要出现时，请调用该方法，以调整文本框的位置。防止文本框被键盘挡住
-(void)moveViewWhenKeyboardAppear:(UIView * _Nullable)view;
-(void)restoreViewFrame;
-(void)showMask;
-(void)hideMask;
-(void)startIndicatorView;
-(void)stopIndicatorView;
-(void)loadData;
-(void)reloadData;
-(void)loadUI;
-(void)reloadUI;
-(void)removeCache;

-(void)keyboardWillShow:(NSNotification * _Nullable)notification;
- (void)keyboardWillBeHidden:(NSNotification * _Nullable)aNotification;

/**
 *  给视图添加点击手势
 *
 *  @param view     要添加点击手势的视图
 *  @param target   点击事件的响应者
 *  @param selector 要调用的方法
 */
- (void)addTapGestureOnView:(UIView * _Nullable)view target:(_Nullable id)target action:(_Nullable SEL)selector;

// 用户登录操作： 判断用户是否需要登录。 返回值为：YES，可以直接进行下一步操作； NO，自动进入登录页面
- (BOOL)userCanOperateAfterLogin;

/** 返回上一页 */
- (void)popViewController;

/**
 页面数据请求失败或无数据时的提示

 @param message    提示信息
 @param frame      视图的frame
 @param style      提示信息的风格
 @param parentView 提示视图的父视图
 @param block      回调block
 */
- (nonnull NoDataNoticeView *)showErrorMessage:(NSString * _Nonnull)message frame:(CGRect)frame promptStyle:(NoDataPromptStyle)style parentView:(UIView *_Nonnull)parentView callbackBlock:(_Nullable IndexBlock)block;

- (void)removeNoticeView:(UIView * _Nullable)parentView;

- (void)showNoDataView:(nullable NSString *)msg image:(nullable UIImage *)image btnTitle:(nullable NSString *)btnTitle topView:(UIView * _Nullable)topView;
- (void)removeErrorView;


- (void)appWillEnterForeground;
- (void)appDidBecomeActive;
- (void)appWillResignActive;
- (void)appDidEnterBackground;

// 由子类重写
- (void)userLoginSuccess;

@end

