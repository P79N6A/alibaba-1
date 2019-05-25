//
//  SettingNickNameViewController.m
//  CultureHongshan
//
//  Created by ct on 15/11/16.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "SettingNickNameViewController.h"

#import "MYTextInputView.h"


@interface SettingNickNameViewController ()

@property (nonatomic, strong) MYTextField *inputTF;

@end

@implementation SettingNickNameViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.inputTF.text = [UserService sharedService].user.userNameFull;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _hasInputView = YES;
    
    [self initSubviews];
}

- (void)initSubviews
{
    UIView *whiteBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, 50)];
    whiteBgView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:whiteBgView];
    
    MYBoldLabel *label = [[MYBoldLabel alloc] initWithFrame:CGRectMake(29, 0, [UIToolClass textWidth:@"昵称" font:FONT(16)]+2, whiteBgView.height)];
    label.font = FONT(16);
    label.text = @"昵称";
    label.textColor = ColorFromHex(@"CCCCCC");
    [whiteBgView addSubview:label];
    label.height = whiteBgView.height;
    
    self.inputTF = [[MYTextField alloc] initWithFrame:CGRectMake(label.maxX+2 , label.originalY, kScreenWidth-22-(label.maxX+2), label.height)];
    _inputTF.font = FontYT(16);
    [_inputTF setPlaceholder:@"输入7字以内的昵称" andColor:kPlaceholderColor];
    _inputTF.maxLength = 7;
    _inputTF.textColor = kDeepLabelColor;
    _inputTF.keyboardType = UIKeyboardTypeDefault;
    [whiteBgView addSubview:_inputTF];
    
    
    // 确定按钮
    WS(weakSelf)
    MYSmartButton *loginButton = [[MYSmartButton alloc] initWithFrame:CGRectMake(35, whiteBgView.maxY+45, kScreenWidth-70, 48) title:@"确  定" font:FontYT(18) tColor:COLOR_IWHITE bgColor:kThemeDeepColor actionBlock:^(id sender) {
        [weakSelf buttonClick:sender];
    }];
    loginButton.radius = 4;
    [_scrollView addSubview:loginButton];

}


- (void)buttonClick:(id)sender
{
    NSString *userName = MYInputTextHandle(_inputTF.text);
    
    if ([DataValidate isValidNickname:userName]) {
        
        User *user = [UserService sharedService].user;
        
        WS(weakSelf);
        
        [AppProtocol updateUserInfoWithUserId:user.userId userName:userName userSex:StrFromInt(user.userSex) userTelephone:nil userArea:nil UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
            
            if (responseCode == HttpResponseSuccess) {
                [weakSelf editUserNameSuccess];
            }else {
                [SVProgressHUD showInfoWithStatus:responseObject];
            }
        }];
    }
}


- (void)editUserNameSuccess
{
    User *aUser = [UserService sharedService].user;
    aUser.userName = MYInputTextHandle(_inputTF.text);
    [UserService saveUser:aUser];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
