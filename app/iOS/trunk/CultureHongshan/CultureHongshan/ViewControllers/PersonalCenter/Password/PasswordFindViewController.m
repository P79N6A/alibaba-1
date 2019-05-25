//
//  PasswordFindViewController.m
//  CultureHongshan
//
//  Created by ct on 16/7/14.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "PasswordFindViewController.h"

#import "MYTextInputView.h"

@interface PasswordFindViewController () <MYTextInputViewDelegate>
@end

@implementation PasswordFindViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _hasInputView = YES;
    
    [self initSubviews];
}


- (void)initSubviews
{
    UIView *whiteBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, 150)];
    whiteBgView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:whiteBgView];
    
    NSArray *leftTitleArray = @[@"新  密  码",@"确认密码"];
    NSArray *rightTitleArray = @[@"输入6～20位新密码",@"确认新密码"];
    
    for (int i = 0; i < leftTitleArray.count; i++)
    {
        MYBoldLabel *label = [[MYBoldLabel alloc] initWithFrame:CGRectMake(29, 20+i*60, [UIToolClass textWidth:@"确认密码" font:FONT(16)]+2, 40)];
        label.font = FONT(16);
        label.text = leftTitleArray[i];
        label.textColor = kDeepLabelColor;
        [whiteBgView addSubview:label];
        label.height = 40;
        
        MYTextField *myTF = [[MYTextField alloc] initWithFrame:CGRectMake(label.maxX , label.originalY, kScreenWidth-22-(label.maxX), label.height)];
        myTF.font = FontYT(16);
        [myTF setPlaceholder:rightTitleArray[i] andColor:ColorFromHex(@"CCCCCC")];
        myTF.maxLength = 20;
        myTF.delegateObject = self;
        myTF.tag = 50+i;
        myTF.textColor = label.textColor;
        myTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        myTF.secureTextEntry = YES;
        [whiteBgView addSubview:myTF];
        
        // 分割线
        [whiteBgView addSubview:[MYMaskView maskViewWithBgColor:kLineGrayColor frame:CGRectMake(20, label.maxY, kScreenWidth-40, kLineThick) radius:0]];
    }
    
    WS(weakSelf)
    
    // 确定按钮
    MYSmartButton *loginButton = [[MYSmartButton alloc] initWithFrame:CGRectMake(35, whiteBgView.maxY+45, kScreenWidth-70, 48) title:@"确  定" font:FontYT(18) tColor:COLOR_IWHITE bgColor:kThemeDeepColor actionBlock:^(id sender) {
        [weakSelf confirmButtonClick:sender];
    }];
    loginButton.radius = 4;
    [_scrollView addSubview:loginButton];
}


//确定
- (void)confirmButtonClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    NSString *password = ((MYTextField *)[_scrollView viewWithTag:50]).text;
    NSString *confirmPassword = ((MYTextField *)[_scrollView viewWithTag:51]).text;
    
    // 找回密码
    if ([DataValidate isValidPassword:password passwordType:PasswordTypeNew] &&
        [DataValidate isValidConfirmPassword:password confirmPassword:confirmPassword])
    {
        [SVProgressHUD showWithStatus:@"请稍候..."];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        
        WS(weakSelf);
        [AppProtocol resetUserPasswordWithMobile:_phoneNumber password:[EncryptTool md5Encode:password] checkCode:_checkCode UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
            if (responseCode == HttpResponseSuccess) {
                [SVProgressHUD showSuccessWithStatus:@"恭喜, 密码已修改，请使用新密码登录！"];
                [weakSelf backToLoginVC];
            } else {
                [SVProgressHUD showErrorWithStatus:responseObject];
            }
        }];
    }
}


- (void)backToLoginVC
{
    NSArray *viewControllers = self.navigationController.viewControllers;
    for (int i = (int)viewControllers.count - 1; i > -1; i--) {
        UIViewController *vc = viewControllers[i];
        if ([vc isKindOfClass:NSClassFromString(@"LoginViewController")])
        {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
