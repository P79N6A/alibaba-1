//
//  LoginViewController.m
//
//
//  Created by JackAndney on 16/4/14.
//  Copyright © 2016年 Andney. All rights reserved.
//

#import "LoginViewController.h"

#import "PasswordForgetViewController.h"//忘记密码
#import "UserLoginToolClass.h"//用户登录
#import "RegisterViewController.h"//注册
#import "CenterViewController.h"//
#import "DynamicLoginViewController.h"

#import "WebViewController.h"
#import "VenueListViewController.h"
#import "AssociationViewController.h"

#import "MYTextInputView.h"

#import "ShareService.h"



@interface LoginViewController () <MYTextInputViewDelegate>
@end



@implementation LoginViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_phoneNumber.length) {//注册完成后，自动填充手机号
        ( (MYTextField *)[_scrollView viewWithTag:50]).text = _phoneNumber;
        _phoneNumber = nil;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _hasInputView = YES;
    
    [self initSubviews];
}

- (void)initSubviews
{
    WS(weakSelf)
    
    UIView *whiteBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, 175)];
    whiteBgView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:whiteBgView];
    
    NSArray *titleArray = @[
                            @[@"手机号", @"请输入11位手机号码"],
                            @[@"密    码", @"6-20位字母和数字"]
                            ];
    
    for (int i = 0; i < titleArray.count; i++)
    {
        MYBoldLabel *label = [[MYBoldLabel alloc] initWithFrame:CGRectMake(29, 20+i*60, [UIToolClass textWidth:@"手机号" font:FONT(16)]+2, 40)];
        label.font = FONT(16);
        label.text = titleArray[i][0];
        label.textColor = kDeepLabelColor;
        [whiteBgView addSubview:label];
        label.height = 40;
        
        
        MYTextField *myTF = [[MYTextField alloc] initWithFrame:CGRectMake(label.maxX , label.originalY, kScreenWidth-22-(label.maxX), label.height)];
        myTF.font = FontYT(16);
        [myTF setPlaceholder:titleArray[i][1] andColor:ColorFromHex(@"CCCCCC")];
        myTF.maxLength = 20;
        myTF.keyboardType = (i == 0) ? UIKeyboardTypeNumberPad : UIKeyboardTypeNumbersAndPunctuation;
        myTF.secureTextEntry = (i == 1);
        myTF.isPhoneInput = ( i==0 );
        myTF.delegateObject = self;
        myTF.tag = 50+i;
        myTF.textColor = label.textColor;
        [whiteBgView addSubview:myTF];
        
        // 分割线
        [whiteBgView addSubview:[MYMaskView maskViewWithBgColor:kLineGrayColor frame:CGRectMake(20, label.maxY, kScreenWidth-40, kLineThick) radius:0]];
        
        if (i == titleArray.count-1) {
            //  忘记密码
            MYSmartButton *forgetButton = [[MYSmartButton alloc] initWithFrame:CGRectMake(kScreenWidth-27-100, label.maxY, 100, 48) title:@"忘记密码" font:FontYT(14) tColor:kLightLabelColor bgColor:nil actionBlock:^(id sender) {
                [weakSelf buttonClick:sender];
            }];
            forgetButton.tag = 3;
            forgetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [whiteBgView addSubview:forgetButton];
            
            whiteBgView.height = label.maxY + 55;
        }
    }
    
    // 登录按钮
    MYSmartButton *loginButton = [[MYSmartButton alloc] initWithFrame:CGRectMake(22, whiteBgView.maxY+43, kScreenWidth-44, 47) title:@"登 录" font:FontYT(18) tColor:COLOR_IWHITE bgColor:kThemeDeepColor actionBlock:^(id sender) {
        [weakSelf buttonClick:sender];
    }];
    loginButton.tag = 4;
    loginButton.radius = 4;
    [_scrollView addSubview:loginButton];
    
    // 手机验证码登录
    CGFloat dynamicLoginButtonWidth = [UIToolClass textWidth:@"手机号快捷登录" font:FontYT(15)]+6+2*6+IMG(@"icon_arrow_guide").size.width;
    MYSmartButton *dynamicLoginButton = [[MYSmartButton alloc] initWithFrame:CGRectMake(loginButton.maxX-dynamicLoginButtonWidth, loginButton.maxY+15, dynamicLoginButtonWidth, 35) contentLayout:ButtonContentLayoutImageLeft font:FontYT(15) actionBlock:^(id sender) {
        [weakSelf buttonClick:sender];
    }];
    dynamicLoginButton.spacing = 6;
    [dynamicLoginButton setTitle:@"手机号快捷登录" forState:UIControlStateNormal];
    [dynamicLoginButton setTitleColor:kThemeDeepColor forState:UIControlStateNormal];
    [dynamicLoginButton setImage:IMG(@"icon_arrow_guide") forState:UIControlStateNormal];
    dynamicLoginButton.tag = 8;
    dynamicLoginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_scrollView addSubview:dynamicLoginButton];
    
    BOOL isInstall[3];
    NSInteger clientNumber = [self.class checkClientInstall:isInstall];
    
    // ——————————————————————— 这里判断是否添加第三方登录 ———————————————————————————
    if (clientNumber == 0) {
        _scrollView.contentSize = CGSizeMake(_scrollView.width, dynamicLoginButton.maxY + 50);
        return;
    }
    
    CGFloat spacing1 = kScreenWidth < 321 ? 45 : 90; // 手机验证码登录 与 其它方式登录 之间的垂直距离
    CGFloat spacing2 = kScreenWidth < 321 ? 30 : 45; // 其它方式登录 与 图标 之间的垂直距离
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, dynamicLoginButton.maxY + spacing1, kScreenWidth, [UIToolClass fontHeight:FONT(13)])];
    label.font = FONT(13);
    label.text = @"其他方式登录";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = kDeepLabelColor;
    [_scrollView addSubview:label];
    
    CGFloat spacing = [UIToolClass textWidth:label.text font:label.font]+40;
    CGFloat lineWidth = (kScreenWidth-2*loginButton.originalX-spacing)*0.5;
    for (int i = 0; i < 2; i++)
    {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(loginButton.originalX+i*(spacing+lineWidth), 0, lineWidth, 1)];
        lineView.backgroundColor = ColorFromHex(@"8C8C8C");
        [label addSubview:lineView];
        lineView.centerY = label.height*0.5;
    }
    
    
    CGFloat btnWidth = 60;
    CGFloat btnHeight = btnWidth;
    CGFloat btnSpacing = ConvertSize(105);
    
    CGFloat offsetX = kScreenWidth*0.5 - (btnWidth*0.5*clientNumber + btnSpacing*0.5*(clientNumber-1));
    
    NSArray *imageArray = @[@"share_微信",@"share_qq",@"share_微博"];
    NSArray *shareTitles = @[@"微信",@"QQ",@"微博"];
    for (int i = 0; i < 3; i++)
    {
        if (isInstall[i] == NO) {
            continue;
        }
        
        //分享按钮
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(offsetX, label.maxY+spacing2, btnWidth, btnHeight)];
        button.radius = 5;
        [button setBackgroundImage:IMG(imageArray[i]) forState:UIControlStateNormal];
        button.tag = 5+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(button.originalX, button.maxY, btnWidth, 31)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = kLightLabelColor;
        titleLabel.font = FontYT(14);
        titleLabel.text = shareTitles[i];
        [_scrollView addSubview:titleLabel];
        
        offsetX += btnSpacing + btnWidth;
    }
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width, label.maxY + 25 + (btnHeight+31) + 60);
}


// 微信好友、微信朋友圈、QQ好友、微博
+ (NSInteger)checkClientInstall:(BOOL *)isInstall
{
#ifndef FUNCTION_ENABLED_THIRD_LOGIN
    return 0; // 禁用第三方登录功能
#else

    // 微信、QQ
#ifdef FUNCTION_ENABLED_WECHAT
    isInstall[0] = [ShareService isWeiXinInstalled];
#else
    isInstall[0] = NO;
#endif
    
#ifdef FUNCTION_ENABLED_QQ
    isInstall[1] = [ShareService isQQInstalled];
#else
    isInstall[1] = NO;
#endif
    
#ifdef FUNCTION_ENABLED_WEIBO
    isInstall[2] = YES;
#else
    isInstall[2] = NO;
#endif

    
    NSInteger installNum = 0;
    for (int i = 0; i < 3; i++) {
        if (isInstall[i] == YES) {
            installNum++;
        }
    }
    return installNum;
#endif
}



- (void)buttonClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    WS(weakSelf);
    switch (sender.tag) {
        case 3://忘记密码按钮
        {
            MYTextField *passwordTF = [_scrollView viewWithTag:51];
            passwordTF.text = @""; // 清空已经输入的密码
            
            PasswordForgetViewController *vc = [PasswordForgetViewController new];
            vc.navTitle = @"忘记密码";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4://登录按钮
        {
            [self wenhuayunLogin];
        }
            break;
        case 5://微信
        {
            [UserLoginToolClass loginWithLoginType:LoginTypeWechat
                                       accountType:0
                                           account:nil
                                          password:nil
                                     callbackBlock:^(NSInteger statusCode)
             {
                 if (statusCode == 1) {
                     [weakSelf loginSuccess];
                 }else{
                     
                 }
             }];
        }
            break;
        case 6://QQ
        {
            [UserLoginToolClass loginWithLoginType:LoginTypeQQ
                                       accountType:0
                                           account:nil
                                          password:nil
                                     callbackBlock:^(NSInteger statusCode)
             {
                 if (statusCode == 1) {
                     [weakSelf loginSuccess];
                 }else{
                 }
             }];
        }
            break;
        case 7://新浪微博
        {
            [UserLoginToolClass loginWithLoginType:LoginTypeSina
                                       accountType:0
                                           account:nil
                                          password:nil
                                     callbackBlock:^(NSInteger statusCode)
             {
                 if (statusCode == 1) {
                     [weakSelf loginSuccess];
                 }else{
                 }
             }];
        }
            break;
        case 8:// 动态登录
        {
            DynamicLoginViewController *vc = [DynamicLoginViewController new];
            vc.navTitle = @"手机号快捷登录";
            vc.rightItemTitle = @"注册";
            vc.loginCompletionHandler = self.loginCompletionHandler;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
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


#pragma mark - 登录

- (void)wenhuayunLogin
{
    [self.view endEditing:YES];
    
    MYTextField *phoneNumberTF = [_scrollView viewWithTag:50];
    MYTextField *passwordTF = [_scrollView viewWithTag:51];
    
    WS(weakSelf);
    
    // 请不要在此处对密码进行加密
    [UserLoginToolClass loginWithLoginType:LoginTypeWenHuaYun
                               accountType:1
                                   account:phoneNumberTF.text
                                  password:passwordTF.text
                             callbackBlock:^(NSInteger statusCode)
     {
         if (statusCode == 1) {
             [weakSelf loginSuccess];
         }else{
         }
     }];
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
            }
        }
        
        self.redirectUrl = nil;
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }];
    
    if (self.loginCompletionHandler) {
        self.loginCompletionHandler();
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
