//
//  SettingSexViewController.m
//  CultureHongshan
//
//  Created by ct on 15/11/16.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "SettingSexViewController.h"

@interface SettingSexViewController ()
{
    int _selectedIndex;//1- 男， 2- 女
}
@end


@implementation SettingSexViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _selectedIndex = (int) MAX([UserService sharedService].user.userSex, 1);
    
    [self initSubviews];
}


- (void)initSubviews
{
    CGFloat width = (kScreenWidth-2*18-10)/2.0;
    for (int i = 1; i < 3; i++)
    {
        //按钮
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(18+(i-1)*(width+10), 140, width, 50)];
        button.tag = i;
        button.titleLabel.font = FontYT(18);
        if (i == 1) {
            [button setTitle:@"男" forState:UIControlStateNormal];
        }else{
            [button setTitle:@"女" forState:UIControlStateNormal];
        }
        
        if (i == _selectedIndex) {
            button.backgroundColor = kThemeDeepColor;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            button.backgroundColor = [UIColor whiteColor];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
    
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgImgView addSubview:button];
    }
}



//请求数据
- (void)updateUserSex
{
    WS(weakSelf);
    
    [AppProtocol updateUserInfoWithUserId:[UserService sharedService].userId userName:nil userSex:StrFromInt(_selectedIndex) userTelephone:nil userArea:nil UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        if (responseCode == HttpResponseSuccess) {
            [weakSelf updateUserInfoSuccess];
        }else {
            [SVProgressHUD showErrorWithStatus:(NSString *)responseObject];
        }
    }];
}


- (void)updateUserInfoSuccess
{
    User *aUser = [UserService sharedService].user;
    aUser.userSex = _selectedIndex;
    [UserService saveUser:aUser];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)buttonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 1://男
        {
            if (_selectedIndex == 1) {
                [self updateUserInfoSuccess];
                return;
            }
            _selectedIndex = 1;
            [self updateUserSex];
        }
            break;
        case 2://女
        {
            if (_selectedIndex == 2) {
                [self updateUserInfoSuccess];
                return;
            }
            
            _selectedIndex = 2;
            [self updateUserSex];
        }
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
