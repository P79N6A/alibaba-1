//
//  DetailNavTitleView.m
//  CultureHongshan
//
//  Created by ct on 16/5/23.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "DetailNavTitleView.h"



@interface DetailNavTitleView()

@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) UIView *navView;

@end





@implementation DetailNavTitleView



- (instancetype)initWithFrame:(CGRect)frame navTitle:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES;
        
        //标题,初始状态为隐藏
        self.navView = [MYMaskView maskViewWithBgColor:kNavigationBarColor frame:CGRectMake(0, HEIGHT_STATUS_BAR+20-self.height, self.width, 44) radius:0];
        [self addSubview:_navView];
        
        //状态栏
        self.statusView = [MYMaskView maskViewWithBgColor:kNavigationBarColor frame:CGRectMake(0, 0, self.width, HEIGHT_STATUS_BAR) radius:0];
        [self addSubview:_statusView];
        
        //返回按钮
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, _navView.height, _navView.height)];
        [backButton setImage:IMG(kReturnButtonImageName) forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:backButton];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(backButton.maxX-5, 0, self.width-(backButton.maxX-5)-15, _navView.height)];
        titleLabel.text = title;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = FontYT(18);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_navView addSubview:titleLabel];
    }
    return self;
}



- (void)buttonClick:(UIButton *)sender
{
    //返回到上一个视图控制器
    UIViewController *vc = [UIToolClass getViewControllerFromView:self];
    [vc.navigationController popViewControllerAnimated:NO];
}


- (void)setContentOffsetY:(CGFloat)offsetY
{
    self.hidden = offsetY < (kScreenWidth*500)/750.0-HEIGHT_STATUS_BAR-20;
    
    //设置状态条的透明度
    _statusView.alpha = MIN(MAX( (offsetY - ((kScreenWidth*500)/750.0-HEIGHT_STATUS_BAR-20) )/20.0, 0), 1);
    
    _navView.originalY = MIN(MAX(offsetY-((kScreenWidth*500)/750.0-HEIGHT_STATUS_BAR), HEIGHT_STATUS_BAR+_statusView.maxY-self.height), HEIGHT_STATUS_BAR);
}





@end
