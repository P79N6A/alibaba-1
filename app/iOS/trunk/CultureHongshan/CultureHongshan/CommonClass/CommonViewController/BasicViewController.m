//
//  BasicViewController.m
//  徐家汇
//
//  Created by 李 兴 on 14-2-27.
//  Copyright (c) 2014年 李 兴. All rights reserved.
//

#import "BasicViewController.h"

#import "WebViewController.h"
#import "LoginViewController.h"
#import "MyNavigationController.h"


@interface BasicViewController ()
{
    // -1. 未初始化，0. 显示  1. 隐藏
    NSInteger navStatusWhenDisappear;// 记录视图控制器消失时导航条的隐藏状态
    UITapGestureRecognizer *_tapGesuture;
    NSTimeInterval _timelapse;
}
@end


@implementation BasicViewController


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.presentedViewController) {
        [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
    FBLOG(@"页面被释放了：%@", [self class]);
}

- (void)viewWillAppear:(BOOL)animated
{
   
    [LogService beginLog:[self.class description] addr:[NSString stringWithFormat:@"%p",self]];
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:[self.class description]];
    
    // 在初始化(视图消失)过之后，再使用
    if (navStatusWhenDisappear > -1) {
        self.navigationController.navigationBarHidden = navStatusWhenDisappear;
    }
    
    if (_hasInputView) {
        // 添加键盘通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [LogService endLog:[self.class description] addr:[NSString stringWithFormat:@"%p",self]];
    [super viewWillDisappear:animated];
    
    [self hideMask];
    [MobClick endLogPageView:[self.class description]];
    
    if (_hasInputView) {
        [self restoreViewFrame];
        // 移除键盘通知
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }else {
        [self.view endEditing:YES];
    }
    
    // 视图消失时，保存导航条的显示与否，用于，视图将要出现时恢复导航条的状态
    navStatusWhenDisappear = self.navigationController.navigationBarHidden;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kBgColor;
    navStatusWhenDisappear = -1;
    
    _maskView = [[UIView alloc] initWithFrame:MRECT(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN_FULL)];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    
    _indicator = [[UIActivityIndicatorView alloc] init];
    _indicator.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.width/2);
    [_indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    _indicator.color = [UIColor blackColor];

    viewOnKeyboard = [[UIView alloc] initWithFrame:MRECT(-1, HEIGHT_SCREEN + 66, WIDTH_SCREEN+2, 30)];
    viewOnKeyboard.layer.borderWidth = 0.6;
    viewOnKeyboard.layer.borderColor = COLOR_DEEPIGRAY.CGColor;
    viewOnKeyboard.backgroundColor = kWhiteColor;
    viewOnKeyboard.hidden = YES;

    UIButton * button = [[UIButton alloc] initWithFrame:MRECT(10, 0,40, 30)];
    button.titleLabel.font = FONT_MIDDLE;
    [button addTarget:self action:@selector(cancelKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:kDeepLabelColor forState:UIControlStateNormal];
    [viewOnKeyboard addSubview:button];

    
    UIButton * donebutton = [[UIButton alloc] initWithFrame:MRECT(WIDTH_SCREEN-50, 0,40, 30)];
    donebutton.titleLabel.font = FONT_MIDDLE;
    [donebutton addTarget:self action:@selector(cancelKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    [donebutton setTitle:@"完成" forState:UIControlStateNormal];
    [donebutton setTitleColor:kDeepLabelColor forState:UIControlStateNormal];
    [viewOnKeyboard addSubview:donebutton];
    
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"";
    self.navigationItem.backBarButtonItem = barButton;
    
    if(IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    
    // 添加手势
    UISwipeGestureRecognizer * swipeGesuture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(viewSwip:)];
    swipeGesuture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesuture];
    
    _tapGesuture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard:)];
    _tapGesuture.numberOfTapsRequired = 1;
    _tapGesuture.numberOfTouchesRequired = 1;
    _tapGesuture.enabled = NO;
    [self.view addGestureRecognizer:_tapGesuture];
    
    // App进入退出前后台通知
    if (_addAppBecomeActiveNotification) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
}


- (void)appWillEnterForeground {}
- (void)appDidBecomeActive {}
- (void)appWillResignActive {}
- (void)appDidEnterBackground {}

- (void)viewSwip:(UISwipeGestureRecognizer *)gesture
{//右划
    CGPoint point = [gesture locationInView:self.view];
    if (point.y < HEIGHT_TOP_BAR) {
        // 如果系统导航条隐藏的话，在顶部的高度为64的区域，右划应该没有响应
        if (self.navigationController.navigationBarHidden) {
            return;
        }
    }
    
    if ([self isKindOfClass:[WebViewController class]]) {
        if (point.x > 20) {
            return;
        }
    }else{
        if (point.x > kScreenWidth*0.7) {
            return;
        }
    }
    
    if ([self isKindOfClass:[WebViewController class]]) {
        [((WebViewController *)self) backToLastPage];
    }else {
        [self popViewController];
    }
}

- (void)loadData {}


- (void)removeCache {
    if(_dataUrl.length > 0)
    {
        [[CacheServices shareInstance] removeCache:_dataUrl];
    }
}

- (void)reloadData
{
    [self removeCache];
    [self loadData];
}

- (void)initNavgationBar {
}

- (void)reloadUI
{

}

- (void)loadUI
{
    
}

- (void)showMask
{

    [self.view addSubview:_maskView];
}

- (void)hideMask
{
    [_maskView removeFromSuperview];
}

- (void)startIndicatorView
{
    [_indicator startAnimating];
}

- (void)stopIndicatorView
{
    [_indicator stopAnimating];
}


- (void)keyboardChangeFrame:(NSNotification *)notification
{
    [self keyboardWillShow:notification];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    _tapGesuture.enabled = YES;
    
    NSDictionary *userInfo = [notification userInfo];
    CGFloat animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect rect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if ((rect.size.height + 30) > _maxKeyboardHeight)
    {//还有个viewonkeyboard的高度
        _maxKeyboardHeight = rect.size.height + 30;
    }
    if (viewOnKeyboard)
    {
        [[UIApplication sharedApplication].keyWindow addSubview:viewOnKeyboard];
        [UIView animateWithDuration:animationDuration animations:
         ^{
             viewOnKeyboard.frame = MRECT(0, HEIGHT_SCREEN - rect.size.height + 34, WIDTH_SCREEN, 30);
         }];
    }
    [self moveViewWhenKeyboardAppear];
}

- (void)cancelKeyboard:(id)sender
{
    [self.view endEditing:YES];
    [viewOnKeyboard  removeFromSuperview];
}



- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self restoreViewFrame];
    if (viewOnKeyboard) {
        [UIView animateWithDuration:0.7 animations:^{
             viewOnKeyboard.frame = MRECT(0, HEIGHT_SCREEN + 66, WIDTH_SCREEN, 30);
         }];
    }
    _tapGesuture.enabled = NO;
}



- (void)moveViewWhenKeyboardAppear
{
    if (_currentInputFocusView)
    {
        Boolean haveNavbar = self.navigationController  && (self.navigationController.navigationBarHidden== NO);
        CGRect frame = [_currentInputFocusView convertRect:_currentInputFocusView.bounds toView:self.view];
        NSInteger offset = (frame.origin.y+frame.size.height) - (HEIGHT_SCREEN- _maxKeyboardHeight);
        if (offset < 0) {
            return;
        }
        
        [UIView animateWithDuration:0.5f animations:^(void) {
             if (haveNavbar) {
                 self.view.frame = CGRectMake(0, MIN(-offset+HEIGHT_NAVIGATION_BAR+HEIGHT_STATUS_BAR, 0), WIDTH_SCREEN, HEIGHT_SCREEN);
             }else {
                 self.view.frame = CGRectMake(0, MIN(-offset+HEIGHT_NAVIGATION_BAR+HEIGHT_STATUS_BAR, 0), WIDTH_SCREEN, HEIGHT_SCREEN+HEIGHT_STATUS_BAR+HEIGHT_NAVIGATION_BAR);
             }
         }];
    }
}



- (void)moveViewWhenKeyboardAppear:(UIView *)view
{
    _currentInputFocusView = view;
}


- (void)restoreViewFrame
{
    [self.view endEditing:YES];
    Boolean viewMoved = NO;
    Boolean haveNavbar = self.navigationController  && (self.navigationController.navigationBarHidden == NO);
    if (haveNavbar) {
        if (self.view.frame.origin.y < (HEIGHT_NAVIGATION_BAR+HEIGHT_STATUS_BAR) ) {
            viewMoved = YES;
        }
    }else {
        if (self.view.frame.origin.y < 0) {
            viewMoved = YES;
        }
    }
    
    if (viewMoved) {
        [UIView animateWithDuration:0.5f animations:^{
            if(haveNavbar) {
                self.view.frame = CGRectMake(0, HEIGHT_STATUS_BAR+HEIGHT_NAVIGATION_BAR, self.view.bounds.size.width, self.view.bounds.size.height);
            }else {
                self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
            }
        } completion:nil];
    }
}


- (NoDataNoticeView *)showErrorMessage:(NSString *)message frame:(CGRect)frame promptStyle:(NoDataPromptStyle)style parentView:(UIView *)parentView callbackBlock:(IndexBlock)block
{
    [self removeNoticeView:parentView];
    
    NoDataNoticeView *noticeView = [NoDataNoticeView noticeViewWithFrame:frame bgColor:kWhiteColor message:message promptStyle:NoDataPromptStyleClickRefreshForNoContent callbackBlock:block];
    [parentView addSubview:noticeView];
    
    return noticeView;
}

- (void)removeNoticeView:(UIView *)parentView
{
    if (!parentView) {
        parentView = self.view;
    }
    
    for (UIView *noticeView in parentView.subviews) {
        if ([noticeView isKindOfClass:[NoDataNoticeView class]]) {
            [noticeView removeFromSuperview];
        }
    }
}

- (void)showNoDataView:(NSString *)msg image:(UIImage *)image btnTitle:(NSString *)btnTitle topView:(UIView * _Nullable)topView {
    if (self.noDataView) {
        [self.noDataView removeFromSuperview];
        self.noDataView = nil;
    }
    
    self.noDataView = [[MYNoDataView alloc] initWithMessage:msg iconImage:image buttonTitle:btnTitle delegate:self];
    self.noDataView.backgroundColor = kWhiteColor;
    self.noDataView.fullViewClickable = NO;
    self.noDataView.centerOffsetY = -20;
    [self.noDataView reloadSubviews];
    [self.noDataView showInView:self.view topView:topView];
}

- (void)removeErrorView {
    if (self.noDataView) {
        [self.noDataView removeFromSuperview];
        self.noDataView = nil;
    }
    
    for (UIView *noticeView in self.view.subviews) {
        if ([noticeView isKindOfClass:[NoDataNoticeView class]]) {
            [noticeView removeFromSuperview];
        }
    }
}


- (void)popViewController
{
    if ([self isKindOfClass:[LoginViewController class]]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }];
    }else {
        if (self.navigationController.viewControllers.count) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self dismissViewControllerAnimated:YES completion:^{}];
        }
    }
}

- (BOOL)userCanOperateAfterLogin
{
    BOOL isLogin = [UserService sharedService].userId.length > 0;
    if (!isLogin) {
        // 未登录
        LoginViewController *vc = [LoginViewController new];
        vc.screenshotImage = [UIToolClass getScreenShotImageWithSize:self.view.viewSize views:@[self.view] isBlurry:YES];
        vc.sourceType = LoginVCSourceTypePersonalCenter;
        
        WS(weakSelf)
        vc.loginCompletionHandler = ^() {
            [weakSelf userLoginSuccess];
        };
        
        MyNavigationController *nav = [[MyNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:^{}];
        return NO;
    }
    
    if ([UserService userShouldReLogin]) {
        WS(weakSelf)
        [WHYAlertActionUtil showAlertWithTitle:@"温馨提示" msg:@"距离您上一次登录已经很长时间了，请重新登录" actionBlock:^(NSInteger index, NSString *buttonTitle) {
            [weakSelf m_enterUserLoginPage];
        } buttonTitles:@"取消", @"确定", nil];
        
        return NO;
    }
    
    return YES;
}

// 进入登录页面
- (void)m_enterUserLoginPage {
    // 进入登录页面
    LoginViewController *vc = [LoginViewController new];
    vc.screenshotImage = [UIToolClass getScreenShotImageWithSize:self.view.viewSize views:@[self.view] isBlurry:YES];
    vc.sourceType = LoginVCSourceTypePersonalCenter;
    
    WS(weakSelf)
    vc.loginCompletionHandler = ^() {
        [weakSelf userLoginSuccess];
    };
    
    MyNavigationController *nav = [[MyNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{}];
}

- (void)userLoginSuccess {}





- (void)addTapGestureOnView:(UIView *)view target:(_Nullable id)target action:(_Nullable SEL)selector
{
    if (!target) {target = self;}
    if (!selector) {selector = @selector(restoreViewFrame);}
    
    UITapGestureRecognizer *tapGesuture = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    tapGesuture.numberOfTapsRequired = 1;
    tapGesuture.numberOfTouchesRequired = 1;
    [view addGestureRecognizer:tapGesuture];
}


#pragma mark - Setter And Getter Methods



- (void)setStatusBarIsBlack:(BOOL)statusBarIsBlack {
    _statusBarIsBlack = statusBarIsBlack;
    [UIApplication sharedApplication].statusBarStyle = statusBarIsBlack ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
