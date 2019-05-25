//
//  PasswordForgetViewController.m
//  CultureHongshan
//
//  Created by ct on 16/7/14.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "PasswordForgetViewController.h"

#import "MYTextInputView.h"
#import "PasswordFindViewController.h"

@interface PasswordForgetViewController ()<MYTextInputViewDelegate>
{
    UIButton *_checkCodeBtn;//获取验证码按钮
    
    int _remainedTime;
    NSTimer *_timer;
}

@end



@implementation PasswordForgetViewController


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
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
    NSArray *rightTitleArray = @[@"请输入11位手机号",@"输入6位验证码"];
    
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
        [myTF setPlaceholder:rightTitleArray[i] andColor:ColorFromHex(@"CCCCCC")];
        myTF.maxLength = (i == 1 ? 6 : 11);
        myTF.delegateObject = self;
        myTF.keyboardType = UIKeyboardTypeNumberPad;
        myTF.isPhoneInput = ( i==0 );
        myTF.tag = 50+i;
        myTF.textColor = label.textColor;
        [whiteBgView addSubview:myTF];
        
        // 分割线
        [whiteBgView addSubview:[MYMaskView maskViewWithBgColor:kLineGrayColor frame:CGRectMake(20, label.maxY, kScreenWidth-40, kLineThick) radius:0]];
        
        if (i == leftTitleArray.count-1) {
            // 发送验证码
            _checkCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-22-100, myTF.originalY, 100, 32)];
            _checkCodeBtn.tag = 1;
            _checkCodeBtn.backgroundColor = ColorFromHex(@"E5E5E5");
            _checkCodeBtn.radius = 3;
            _checkCodeBtn.layer.borderColor = ColorFromHex(@"C7C7C7").CGColor;
            _checkCodeBtn.layer.borderWidth = kLineThick;
            _checkCodeBtn.titleLabel.font = kScreenWidth < 321 ? FontYT(14) : FontYT(15);
            [_checkCodeBtn setTitleColor:kDeepLabelColor forState:UIControlStateNormal];
            [_checkCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
            [_checkCodeBtn addTarget:self action:@selector(getCheckCodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [whiteBgView addSubview:_checkCodeBtn];
            
            _checkCodeBtn.centerY = myTF.centerY;
            myTF.width = _checkCodeBtn.originalX-5-myTF.originalX;
            if (kScreenWidth < 321) {
                myTF.clearButtonMode = UITextFieldViewModeNever;
            }
        }
    }
    
    WS(weakSelf)
    
    // 下一步按钮
    MYSmartButton *loginButton = [[MYSmartButton alloc] initWithFrame:CGRectMake(35, whiteBgView.maxY+45, kScreenWidth-70, 48) title:@"下一步" font:FontYT(18) tColor:COLOR_IWHITE bgColor:kThemeDeepColor actionBlock:^(id sender) {
        [weakSelf nextStepButtonClick:sender];
    }];
    loginButton.radius = 4;
    [_scrollView addSubview:loginButton];
}


#pragma mark - 按钮的点击事件
//获取验证码
- (void)getCheckCodeButtonClick:(UIButton *)sender
{
    NSString *phoneNum = ((MYTextField *)[_scrollView viewWithTag:50]).text;
    
    if ([DataValidate isValidPhoneNumber:phoneNum]) {
        WS(weakSelf);
        _checkCodeBtn.userInteractionEnabled = NO;
        
        [AppProtocol getCheckCodeWithType:CheckCodeTypeFindPassWord phoneNum:phoneNum UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
            if (responseCode == HttpResponseSuccess)
            {
                [SVProgressHUD showSuccessWithStatus:@"验证码已发送"];
                [weakSelf beginCountdown:nil];
            }else
            {
                [SVProgressHUD showErrorWithStatus:(NSString *)responseObject];
                _checkCodeBtn.userInteractionEnabled = YES;
            }
        }];
    }
}



// 下一步
- (void)nextStepButtonClick:(UIButton *)sender {
    [self.view endEditing:YES];
    
    NSString *phoneNum = ((MYTextField *)[_scrollView viewWithTag:50]).text;
    NSString *checkCode = ((MYTextField *)[_scrollView viewWithTag:51]).text;
    
    if ([DataValidate isValidPhoneNumber:phoneNum] &&
        [DataValidate isValidCheckCode:checkCode])
    {
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
            _remainedTime = 60;
        }
        
        _checkCodeBtn.userInteractionEnabled = YES;
        [_checkCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        
        PasswordFindViewController *vc = [PasswordFindViewController new];
        vc.navTitle = @"找回密码";
        vc.phoneNumber = phoneNum;
        vc.checkCode = checkCode;
        [self.navigationController pushViewController:vc animated:YES];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
