//
//  RegisterWelcomeViewController.m
//  CultureHongshan
//
//  Created by ct on 16/7/18.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "RegisterWelcomeViewController.h"

#import "LoginViewController.h"



@implementation RegisterWelcomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initSubviews];
}

- (void)initSubviews
{
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, kScreenWidth-40, [UIToolClass fontHeight:FontSystem(24)])];
    headerLabel.font = FontSystem(24);
    headerLabel.text = [NSString stringWithFormat:@"%@ ,您好！",self.nickName];
    headerLabel.textColor = [UIColor whiteColor];
    [self.bgImgView addSubview:headerLabel];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerLabel.originalX, headerLabel.maxY + 55, kScreenWidth-30, [UIToolClass fontHeight:FontYT(17)])];
    contentLabel.font = FontYT(17);
    contentLabel.text = [NSString stringWithFormat:@"欢迎您注册成为%@用户，请登录。", APP_SHOW_NAME];
    contentLabel.textColor = [UIColor whiteColor];
    [self.bgImgView addSubview:contentLabel];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth*0.15, kScreenHeight-50-42, kScreenWidth*0.7, 42)];
    loginBtn.radius = 3;
    loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    loginBtn.layer.borderWidth = 0.8;
    [loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgImgView addSubview:loginBtn];
}

- (void)loginButtonClick:(UIButton *)sender
{
    NSArray *viewControllers = self.navigationController.viewControllers;
    for (int i = 0; i < viewControllers.count; i++) {
        UIViewController *vc = viewControllers[i];
        if ([vc isKindOfClass:NSClassFromString(@"LoginViewController")])
        {
            [(LoginViewController *)vc setPhoneNumber:_phoneNumber];
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
