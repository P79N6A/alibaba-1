//
//  RegisterViewController.m
//  CultureHongshan
//
//  Created by ct on 16/7/18.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "RegisterViewController.h"

#import "MYTextInputView.h"

@interface RegisterViewController ()<MYTextInputViewDelegate>
{
    int _remainedTime;
    NSTimer *_timer;
}

@property (nonatomic, strong) UIButton *checkCodeBtn;

@end


@implementation RegisterViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _hasInputView = YES;
    _remainedTime = 60;
    
    [self initSubviews];
}

- (void)initSubviews
{
    // 白色背景
    MYMaskView *whiteBgView = [MYMaskView maskViewWithBgColor:COLOR_IWHITE frame:CGRectMake(0, 0, kScreenWidth, 285) radius:0];
    [_scrollView addSubview:whiteBgView];
    
    NSArray *titleArray = @[
                            @[@"手机号", @"请输入11位手机号"],
                            @[@"昵    称", @"输入7字以内的昵称"],
                            @[@"密    码", @"输入6～20位密码"],
                            @[@"验证码", @"输入6位验证码"],
                            ];
    int limitedLength[4];
    limitedLength[0] = 11;
    limitedLength[1] = 7;
    limitedLength[2] = 20;
    limitedLength[3] = 6;
    
    UIKeyboardType keyboardType[4];
    keyboardType[0] = UIKeyboardTypeNumberPad;
    keyboardType[1] = UIKeyboardTypeDefault;
    keyboardType[2] = UIKeyboardTypeNumbersAndPunctuation;
    keyboardType[3] = UIKeyboardTypeNumberPad;
    
    
    for (int i = 0; i < titleArray.count; i++)
    {
        MYBoldLabel *label = [[MYBoldLabel alloc] initWithFrame:CGRectMake(29, 20+i*60, [UIToolClass textWidth:@"手机号" font:FONT(16)]+2, 40)];
        label.font = FONT(16);
        label.text = titleArray[i][0];
        label.textColor = kDeepLabelColor;
        [whiteBgView addSubview:label];
        label.height = 40;
        
        MYTextField *myTF = [[MYTextField alloc] initWithFrame:CGRectMake(label.maxX, label.originalY, kScreenWidth-22-(label.maxX), label.height)];
        myTF.font = FontYT(16);
        [myTF setPlaceholder:titleArray[i][1] andColor:ColorFromHex(@"CCCCCC")];
        myTF.maxLength = limitedLength[i];
        myTF.delegateObject = self;
        myTF.tag = 10+i;
        myTF.textColor = label.textColor;
        myTF.secureTextEntry = ( i == 2);
        myTF.keyboardType = keyboardType[i];
        myTF.isPhoneInput = i==0;
        [whiteBgView addSubview:myTF];
    
        // 分割线
        [whiteBgView addSubview:[MYMaskView maskViewWithBgColor:kLineGrayColor frame:CGRectMake(20, label.maxY, kScreenWidth-40, kLineThick) radius:0]];
        
        if (i == titleArray.count-1) {
            // 发送验证码
            self.checkCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-22-100, myTF.originalY, 100, 32)];
            _checkCodeBtn.backgroundColor = ColorFromHex(@"E5E5E5");
            _checkCodeBtn.tag = 1;
            _checkCodeBtn.radius = 3;
            _checkCodeBtn.layer.borderColor = ColorFromHex(@"C7C7C7").CGColor;
            _checkCodeBtn.layer.borderWidth = kLineThick;
            _checkCodeBtn.titleLabel.font = FontYT(15);
            [_checkCodeBtn setTitleColor:kDeepLabelColor forState:UIControlStateNormal];
            [_checkCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
            [_checkCodeBtn addTarget:self action:@selector(registerVCButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [whiteBgView addSubview:_checkCodeBtn];
            
            _checkCodeBtn.centerY = myTF.centerY;
            myTF.width= _checkCodeBtn.originalX-8-myTF.originalX;
            if (kScreenWidth < 321) {
                myTF.clearButtonMode = UITextFieldViewModeNever;
            }
            
            whiteBgView.height = label.maxY+30;
        }
    }
    
    // 注册按钮
    WS(weakSelf)
    MYSmartButton *loginButton = [[MYSmartButton alloc] initWithFrame:CGRectMake(35, whiteBgView.maxY+45, kScreenWidth-70, 48) title:@"注 册" font:FontYT(18) tColor:COLOR_IWHITE bgColor:kThemeDeepColor actionBlock:^(id sender) {
        [weakSelf registerVCButtonClick:sender];
    }];
    loginButton.tag = 2;
    loginButton.radius = 4;
    [_scrollView addSubview:loginButton];
}


- (void)registerVCButtonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:{//获取验证码
            [self startCheckCodeRequest];
        }
            break;
        case 2:{//注册按钮
            [self startRegisterRequest];
        }
            break;
            
        default:
            break;
    }
}


- (void)rightNavigationItemAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


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


- (void)startCheckCodeRequest
{
    NSString *phoneNumber = ( (MYTextField *)[_scrollView viewWithTag:10] ).text;
    
    if ([DataValidate isValidPhoneNumber:phoneNumber])
    {
        WS(weakSelf);
        _checkCodeBtn.userInteractionEnabled = NO;
        
        [AppProtocol getCheckCodeWithType:CheckCodeTypeRegister phoneNum:phoneNumber UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
            
            if (responseCode == HttpResponseSuccess) {
                [SVProgressHUD showSuccessWithStatus:@"验证码已发送"];
                [weakSelf beginCountdown:nil];
            }else {
                [SVProgressHUD showErrorWithStatus:(NSString *)responseObject];
                _checkCodeBtn.userInteractionEnabled = YES;
            }
        }];
    }
}

- (void)startRegisterRequest
{
    NSString *phoneNumber = ( (MYTextField *)[_scrollView viewWithTag:10] ).text;
    NSString *nickName    = ( (MYTextField *)[_scrollView viewWithTag:11] ).text;
    NSString *password    = ( (MYTextField *)[_scrollView viewWithTag:12] ).text;
    NSString *checkCode   = ( (MYTextField *)[_scrollView viewWithTag:13] ).text;
    
    if ([DataValidate isValidPhoneNumber:phoneNumber] &&
        [DataValidate isValidNickname:nickName] &&
        [DataValidate isValidPassword:password passwordType:PasswordTypeRegister] &&
        [DataValidate isValidCheckCode:checkCode]
        )
    {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showWithStatus:@"正在为您注册..."];
        
        WS(weakSelf);
        
        //注册成功后，会返回userId
        [AppProtocol userRegisterWithUserName:nickName password:[EncryptTool md5Encode:password] mobile:phoneNumber checkCode:checkCode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
            
            if (responseCode == HttpResponseSuccess)
            {
                
                [AppProtocol queryUserInfoWithUserId:(NSString *)responseObject UsingBlock:^(HttpResponseCode responseCode2, id responseObject2) {
                    
                    if (responseCode2 == HttpResponseSuccess) {
                        [UserService saveUser:responseObject2];
                        [[UserService sharedService] setLoginType:LoginTypeWenHuaYun];
                        [UserService updateUserLoginStatus];
                        
                        [SVProgressHUD showSuccessWithStatus:@"恭喜您，注册成功！"];
                        
                        // 重置活动列表的标签数据
                        [DictionaryService resetActivityTags];
                        [ToolClass settingActivityListNeedUpdate];
                        
                        [weakSelf registerSuccess];
                    }else {
                        [SVProgressHUD showErrorWithStatus:responseObject2];
                    }
                }];
                
            }else
            {
                if ([responseObject length]) {
                    [SVProgressHUD showErrorWithStatus:(NSString *)responseObject];
                }
            }
        }];
    }
}

#pragma mark - 跳转到注册完后的欢迎登录页面
- (void)registerSuccess
{
    UITabBarController *tabBar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {
        // 分设城市
        UINavigationController *centerNav = [tabBar.viewControllers lastObject];
        if ([centerNav isKindOfClass:[UINavigationController class]]) {
            [self.navigationController dismissViewControllerAnimated:NO completion:^{
                [centerNav popToRootViewControllerAnimated:YES];
            }];
            return;
        }
    }
    
    [self popViewController];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
