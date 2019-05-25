//
//  PasswordModifyViewController.m
//  CultureHongshan
//
//  Created by ct on 16/7/15.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "PasswordModifyViewController.h"

#import "MYTextInputView.h"

@interface PasswordModifyViewController () <MYTextInputViewDelegate>
@end






@implementation PasswordModifyViewController


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
    
    NSArray *leftTitleArray = @[@"原  密  码", @"新  密  码", @"确认密码"];
    NSArray *rightTitleArray = @[@"输入原密码", @"输入6-20位新密码", @"确认新密码"];
    
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
        myTF.secureTextEntry = YES;
        myTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [whiteBgView addSubview:myTF];
        
        // 分割线
        [whiteBgView addSubview:[MYMaskView maskViewWithBgColor:kLineGrayColor frame:CGRectMake(20, label.maxY, kScreenWidth-40, kLineThick) radius:0]];
        
        if (i == leftTitleArray.count-1) {
            whiteBgView.height = label.maxY+30;
        }
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
    
    NSString *oldPassword     = ((MYTextField *)[_scrollView viewWithTag:50]).text;
    NSString *newPassword     = ((MYTextField *)[_scrollView viewWithTag:51]).text;
    NSString *confirmPassword = ((MYTextField *)[_scrollView viewWithTag:52]).text;
    
    if ([DataValidate isValidPassword:oldPassword passwordType:PasswordTypeOld] &&
        [DataValidate isValidPassword:newPassword passwordType:PasswordTypeNew] &&
        [DataValidate isValidConfirmPassword:newPassword confirmPassword:confirmPassword])
    {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showWithStatus:@"修改中，请稍候..."];
        
        WS(weakSelf);
        [AppProtocol updatePasswordWithUserId:[UserService sharedService].userId password:[EncryptTool md5Encode:oldPassword] newPassword:[EncryptTool md5Encode:newPassword] UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
            
            if (responseCode == HttpResponseSuccess) {
                [SVProgressHUD showSuccessWithStatus:@"密码修改成功!"];
                [weakSelf updateUserPasswordSuccess];
            } else {
                [SVProgressHUD showErrorWithStatus:responseObject];
            }
        }];
    }
}


- (void)updateUserPasswordSuccess
{
    NSString *newPassword = ((MYTextField *)[_scrollView viewWithTag:51]).text;
    
    User *aUser = [UserService sharedService].user;
    aUser.userPwd = [EncryptTool md5Encode:newPassword];
    [UserService saveUser:aUser];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
