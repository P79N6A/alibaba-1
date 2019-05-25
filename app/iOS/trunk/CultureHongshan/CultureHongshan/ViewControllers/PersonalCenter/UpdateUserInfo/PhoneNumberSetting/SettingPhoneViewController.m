//
//  SettingPhoneViewController.m
//  CultureHongshan
//
//  Created by ct on 15/11/16.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "SettingPhoneViewController.h"

#import "MYTextInputView.h"

@interface SettingPhoneViewController ()<MYTextInputViewDelegate>
@property (nonatomic, strong) MYTextField *inputTF;
@end



@implementation SettingPhoneViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    _hasInputView = YES;
    
    [self initSubviews];
}


- (void)initSubviews {

    UIView *whiteBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, 50)];
    whiteBgView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:whiteBgView];
    
    MYBoldLabel *label = [[MYBoldLabel alloc] initWithFrame:CGRectMake(29, 0, [UIToolClass textWidth:@"手机号" font:FONT(16)]+2, whiteBgView.height)];
    label.font = FONT(16);
    label.text = @"手机号";
    label.textColor = ColorFromHex(@"CCCCCC");
    [whiteBgView addSubview:label];
    label.height = whiteBgView.height;
    
    self.inputTF = [[MYTextField alloc] initWithFrame:CGRectMake(label.maxX , label.originalY, kScreenWidth-22-(label.maxX), label.height)];
    _inputTF.font = FontYT(16);
    [_inputTF setPlaceholder:@"请输入11位手机号" andColor:kPlaceholderColor];
    _inputTF.isPhoneInput = YES;
    _inputTF.delegateObject = self;
    _inputTF.textColor = kDeepLabelColor;
    [whiteBgView addSubview:_inputTF];
    
    WS(weakSelf)
    // 确定按钮
    MYSmartButton *loginButton = [[MYSmartButton alloc] initWithFrame:CGRectMake(35, whiteBgView.maxY+45, kScreenWidth-70, 48) title:@"确  定" font:FontYT(18) tColor:COLOR_IWHITE bgColor:kThemeDeepColor actionBlock:^(id sender) {
        [weakSelf confirmButtonClick:sender];
    }];
    loginButton.radius = 4;
    [_scrollView addSubview:loginButton];
}




#pragma mark - 修改手机号
- (void)confirmButtonClick:(id)sender
{
    NSString *mobile = self.inputTF.text;
    
    if ([DataValidate isValidPhoneNumber:mobile]) {
        User *user = [UserService sharedService].user;
        
        if ([user.userMobileNo isEqualToString:mobile]) {
            [SVProgressHUD showInfoWithStatus:@"新手机号与原手机号相同，无需修改!"];
            return;
        }
        
        WS(weakSelf)
        [AppProtocol updateUserInfoWithUserId:user.userId userName:nil userSex:[NSString stringWithFormat:@"%d",(int)user.userSex] userTelephone:mobile userArea:nil UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
            if (responseCode == HttpResponseSuccess) {
                [weakSelf updateUserPhoneNumberSuccess];
            } else {
                [SVProgressHUD showErrorWithStatus:responseObject];
            }
        }];
    }
}


- (void)updateUserPhoneNumberSuccess
{
    User *aUser = [UserService sharedService].user;
    aUser.userMobileNo = self.inputTF.text;
    [UserService saveUser:aUser];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
