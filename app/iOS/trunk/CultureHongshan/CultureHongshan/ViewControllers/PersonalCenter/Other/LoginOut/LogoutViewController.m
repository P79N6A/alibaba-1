//
//  LogoutViewController.m
//  CultureHongshan
//
//  Created by ct on 16/8/26.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "LogoutViewController.h"

@interface LogoutViewController ()<UIWebViewDelegate>

@end

@implementation LogoutViewController


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat btnHeight = 48;
    CGFloat spacingY = 15;
    
    NSArray *titleArray = @[@"取消",@"退出登录"];
    for (int i = 0; i < titleArray.count; i++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight-btnHeight-i*(btnHeight+spacingY), kScreenWidth, btnHeight)];
        button.backgroundColor = COLOR_IWHITE;
        button.titleLabel.font = i > 0 ? FontYT(18) : FontYT(16);
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:COLOR_IBLACK forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgImgView addSubview:button];
    }
}


- (void)buttonClick:(UIButton *)sender
{
    if (sender.tag == 1) {
        
        [CacheServices clearCacheDataWhenLogout];
        [ToolClass settingActivityListNeedUpdate];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
