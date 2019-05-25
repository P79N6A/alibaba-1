//
//  DynamicLoginViewController.m
//  CultureHongshan
//
//  Created by ct on 16/12/1.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "DynamicLoginViewController.h"

#import "MYTextInputView.h"
#import "UserLoginToolClass.h"
#import "WebViewController.h"
#import "AssociationViewController.h"
#import "VenueListViewController.h"
#import "RegisterViewController.h"

@interface DynamicLoginViewController ()<MYTextInputViewDelegate>
{
    int _remainedTime;
    NSTimer *_timer;
    
}
@property (nonatomic, strong) UIButton *checkCodeBtn;

@end

@implementation DynamicLoginViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _hasInputView = YES;
    _remainedTime = 60;
    
    [self initSubviews];
}

- (void)initSubviews
{
    UIView *whiteBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, 150)];
    whiteBgView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:whiteBgView];
    
    NSArray *leftTitleArray = @[@"手机号",@"验证码"];
    NSArray *rightTitleArray = kScreenWidth > 321 ? @[@"请输入11位手机号",@"请输入6位验证码"] : @[@"输入11位手机号",@"输入6位验证码"];
    
    for (int i = 0; i < leftTitleArray.count; i++)
    {
        MYBoldLabel *label = [[MYBoldLabel alloc] initWithFrame:CGRectMake(29, 20+i*60, [UIToolClass textWidth:@"手机号" font:FONT(16)]+2, 40)];
        label.font = FONT(16);
        label.text = leftTitleArray[i];
        label.textColor = kDeepLabelColor;
        [whiteBgView addSubview:label];
        label.height = 40;
        
        
        MYTextField *myTF = [[MYTextField alloc] initWithFrame:CGRectMake(label.maxX , label.originalY, kScreenWidth-22-(label.maxX), label.height)];
        myTF.font = FontYT(16);
        myTF.textColor = label.textColor;
        [myTF setPlaceholder:rightTitleArray[i] andColor:ColorFromHex(@"CCCCCC")];
        myTF.maxLength = (i == 1 ? 6 : 11);
        myTF.keyboardType = UIKeyboardTypeNumberPad;
        myTF.isPhoneInput = i==0;
        myTF.delegateObject = self;
        myTF.tag = 50+i;
        [whiteBgView addSubview:myTF];
        
        
        // 分割线
        [whiteBgView addSubview:[MYMaskView maskViewWithBgColor:kLineGrayColor frame:CGRectMake(20, label.maxY, kScreenWidth-40, kLineThick) radius:0]];
        
        if (i == leftTitleArray.count-1) {
            // 发送验证码
            self.checkCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-22-100, myTF.originalY, 100, 32)];
            _checkCodeBtn.tag = 1;
            _checkCodeBtn.backgroundColor = ColorFromHex(@"E5E5E5");
            _checkCodeBtn.radius = 3;
            _checkCodeBtn.layer.borderColor = ColorFromHex(@"C7C7C7").CGColor;
            _checkCodeBtn.layer.borderWidth = kLineThick;
            _checkCodeBtn.titleLabel.font = kScreenWidth < 321 ? FontYT(14) : FontYT(15);
            [_checkCodeBtn setTitleColor:kDeepLabelColor forState:UIControlStateNormal];
            [_checkCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
            [_checkCodeBtn addTarget:self action:@selector(sendCheckCodeAction) forControlEvents:UIControlEventTouchUpInside];
            [whiteBgView addSubview:_checkCodeBtn];
            
            _checkCodeBtn.centerY = myTF.centerY;
            myTF.width = _checkCodeBtn.originalX-8-myTF.originalX;
            
            if (kScreenWidth < 321) { // 窄屏幕上，不显示右侧的X按钮
                myTF.clearButtonMode = UITextFieldViewModeNever;
            }
        }
    }
    
    WS(weakSelf)
    
    // 登录按钮
    MYSmartButton *loginButton = [[MYSmartButton alloc] initWithFrame:CGRectMake(35, whiteBgView.maxY+45, kScreenWidth-70, 48) title:@"登录" font:FontYT(18) tColor:COLOR_IWHITE bgColor:kThemeDeepColor actionBlock:^(id sender) {
        [weakSelf loginButtonAction];
    }];
    loginButton.radius = 4;
    [_scrollView addSubview:loginButton];
    
    // 账号密码登录 - 返回按钮作用一样
    CGFloat backLoginButtonWidth = [UIToolClass textWidth:@"账号密码登录" font:FontYT(15)]+6+2*6+IMG(@"icon_arrow_guide").size.width;
    MYSmartButton *backLoginButton = [[MYSmartButton alloc] initWithFrame:CGRectMake(loginButton.maxX-backLoginButtonWidth, loginButton.maxY+15, backLoginButtonWidth, 35) contentLayout:ButtonContentLayoutImageLeft font:FontYT(15) actionBlock:^(id sender) {
        [weakSelf popViewController];
    }];
    backLoginButton.spacing = 6;
    [backLoginButton setTitle:@"账号密码登录" forState:UIControlStateNormal];
    [backLoginButton setTitleColor:kThemeDeepColor forState:UIControlStateNormal];
    [backLoginButton setImage:IMG(@"icon_arrow_guide") forState:UIControlStateNormal];
    backLoginButton.tag = 8;
    backLoginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_scrollView addSubview:backLoginButton];
    
}


#pragma mark - 数据请求

- (void)startCheckCodeRequest
{
    NSString *phoneNumber = ( (MYTextField *)[_scrollView viewWithTag:50] ).text;
    
    if ([DataValidate isValidPhoneNumber:phoneNumber]) {
        WS(weakSelf);
        _checkCodeBtn.userInteractionEnabled = NO;
        
        [AppProtocol getCheckCodeWithType:CheckCodeTypeDynamicLogin phoneNum:phoneNumber UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
            if (responseCode == HttpResponseSuccess) {
                [SVProgressHUD showSuccessWithStatus:@"验证码已发送"];
                [weakSelf beginCountdown:nil];
            } else {
                [SVProgressHUD showErrorWithStatus:(NSString *)responseObject];
                _checkCodeBtn.userInteractionEnabled = YES;
            }
        }];
    }
}

#pragma mark - Button Actions

// 登录按钮点击事件
- (void)loginButtonAction {
    NSString *phoneNumber = ( (MYTextField *)[_scrollView viewWithTag:50] ).text;
    NSString *checkCode   = ( (MYTextField *)[_scrollView viewWithTag:51] ).text;
    
    WS(weakSelf)
    if ([DataValidate isValidPhoneNumber:phoneNumber] &&
        [DataValidate isValidCheckCode:checkCode]
        ) {
        
        [UserLoginToolClass loginWithLoginType:LoginTypeWenHuaYunDynamic accountType:1 account:phoneNumber password:checkCode callbackBlock:^(NSInteger statusCode) {
            if (statusCode == 1) {
                [weakSelf loginSuccess];
            }else{
            }
        }];
    }
}

// 注册
- (void)rightNavigationItemAction
{
    RegisterViewController *vc = [RegisterViewController new];
    vc.navTitle = @"新用户注册";
    vc.rightItemTitle = @"登录";
    [self.navigationController pushViewController:vc animated:YES];
}


// 发送验证码
- (void)sendCheckCodeAction {
    [self startCheckCodeRequest];
}


#pragma mark - 

/** 开始进行倒计时 */
- (void)beginCountdown:(NSTimer *)timer {
    
    if (timer.userInfo == nil) {
        // 首次调用该方法，需要开启定时器
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(beginCountdown:) userInfo:@"countdown" repeats:YES];
        [_timer fire];
        
    }else {
        
        if (_remainedTime <= 0) {
            [timer invalidate];
            timer = nil;
            
            _remainedTime = 60;
            [_checkCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
            _checkCodeBtn.userInteractionEnabled = YES;
        }else {
            [_checkCodeBtn setTitle:[NSString stringWithFormat:@"%02d秒",_remainedTime] forState:UIControlStateNormal];
            _checkCodeBtn.userInteractionEnabled = NO;
        }
        _remainedTime--;
    }
}


- (void)loginSuccess
{
    if (self.redirectUrl.length) {
        UITabBarController *tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        if ([tabBarVC isKindOfClass:[UITabBarController class]]) {
            
            UINavigationController *selectedNav = tabBarVC.viewControllers[tabBarVC.selectedIndex];
            
            UIViewController *vc = [selectedNav.viewControllers lastObject];
            
            if ([vc isKindOfClass:[WebViewController class]]) {
                [((WebViewController *)vc) loadRedirectUrlAfterLogining:self.redirectUrl];
            }else if ([vc isKindOfClass:[AssociationViewController class]]) {
                [((AssociationViewController *)vc) loadRedirectUrlAfterLogining:self.redirectUrl];
            }else if ([vc isKindOfClass:[VenueListViewController class]]) {
                [((VenueListViewController *)vc) loadRedirectUrlAfterLogining:self.redirectUrl];
            }        }
        self.redirectUrl = nil;
    }
    
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
    
    if (self.loginCompletionHandler) {
        self.loginCompletionHandler();
    }
}

@end
