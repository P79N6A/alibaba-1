//
//  BasicCustomNavigationBarViewController.m
//  CultureHongshan
//
//  Created by ct on 16/12/5.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "BasicCustomNavigationBarViewController.h"

@interface BasicCustomNavigationBarViewController ()
{
    UIView *_navbarView;
}
@end

@implementation BasicCustomNavigationBarViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIToolClass setupDontAutoAdjustContentInsets:_scrollView forController:self];

    if ([self isKindOfClass:NSClassFromString(@"LoginViewController")]) {
        // 登录页面用的地方较多，在这里处理导航条需要的有关属性
        self.leftItemType = NavigationBarLeftItemTypeClose;
        self.navTitle = @"账号密码登录";
        self.rightItemTitle = @"注册";
    }
    
    [self initNavigationBar];
    
    [_scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_navbarView.mas_bottom);
        make.left.right.and.bottom.equalTo(self.view);
    }];
}

- (void)initNavigationBar
{
    _navbarView = [UIView new];
    _navbarView.backgroundColor = ColorFromHex(@"F0F0F0");
    [self.view addSubview:_navbarView];
    
    UIImage *backImage = _leftItemType==NavigationBarLeftItemTypeDefault ? IMG(@"icon_arrow_back_black") : IMG(@"icon_present_close");
    MYButton *backButton = [[MYButton alloc] initWithFrame:CGRectZero image:backImage selectedImage:nil];
    [backButton addTarget:self action:@selector(leftNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
    [_navbarView addSubview:backButton];
    
    // 导航条标题
    if (self.navTitle.length) {
        MYLabel *titleLabel = [[MYLabel alloc] initWithFrame:CGRectZero text:nil font:FontYT(18) tColor:kDeepLabelColor lines:1 align:NSTextAlignmentCenter];
        titleLabel.boldText = YES;
        [titleLabel updateText:self.navTitle];
        [_navbarView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_navbarView);
            make.width.mas_equalTo(250);
            make.centerY.equalTo(backButton);
        }];
    }
    
    // 导航条右侧按钮标题
    if (self.rightItemTitle.length) {
        MYButton *rightItemButton = [[MYButton alloc] initWithFrame:CGRectZero title:self.rightItemTitle font:FontYT(15) tColor:kDeepLabelColor bgColor:nil];
        [rightItemButton addTarget:self action:@selector(rightNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
        [_navbarView addSubview:rightItemButton];
        
        [rightItemButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_navbarView);
            make.width.mas_equalTo(65);
            make.height.centerY.equalTo(backButton);
        }];
    }
    
    UIView *line = [UIView new];
    line.backgroundColor = kLineGrayColor;
    [_navbarView addSubview:line];
    
    [_navbarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT_TOP_BAR);
    }];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_navbarView).offset(2);
        make.width.height.mas_equalTo(44);
        make.bottom.equalTo(_navbarView);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_navbarView);
        make.height.mas_equalTo(1.0f);
    }];
}



- (void)leftNavigationItemAction
{
    [self popViewController];
}


- (void)rightNavigationItemAction
{
    FBLOG(@"子类:%@ 未实现-rightNavigationItemAction方法", [self class]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
