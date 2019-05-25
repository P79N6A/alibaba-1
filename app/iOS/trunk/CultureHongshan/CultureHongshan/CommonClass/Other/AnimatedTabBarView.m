//
//  AnimatedTabBarView.m
//  TabBarAnimationTest
//
//  Created by ct on 16/5/20.
//  Copyright © 2016年 ct. All rights reserved.
//

#import "AnimatedTabBarView.h"


#define kWidth 34

/*
 图片的大小为 32.5x27.5（65x55）
 
 */
@interface AnimatedTabBarView ()

@property (nonatomic, copy) NSArray *normalImages;
@property (nonatomic, copy) NSArray *selectedImages;
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, strong) UIButton *lastButton;

@end



@implementation AnimatedTabBarView

+ (instancetype)sharedTabBar
{
    static AnimatedTabBarView *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AnimatedTabBarView alloc] initWithFrame:CGRectMake(0, kScreenHeight-50, kScreenWidth, 50)];
        sharedInstance.normalImages = @[@"首页",@"附近",@"日历",@"场馆",@"我"];
        sharedInstance.selectedImages = @[@"首页_on",@"附近_on",@"日历_on",@"场馆_on",@"我_on"];
        sharedInstance.titles = @[@"首页",@"附近",@"日历",@"场馆",@""];
        [sharedInstance initSubviews];
    });
    return sharedInstance;
}


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.4];
        self.backgroundColor = COLOR_IGRAY;
    }
    return self;
}

- (void)initSubviews
{
    CGFloat offsetX = 15;
    for (int i = 0; i < _titles.count; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(offsetX, 0, kWidth, self.height)];
        btn.layer.masksToBounds = YES;
        btn.tag = i+1;
        [btn setImage:IMG(_normalImages[i]) forState:UIControlStateNormal];
        [btn setImage:IMG(_selectedImages[i]) forState:UIControlStateSelected];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth, 0, [UIToolClass textWidth:_titles[i] font:FontYT(16)], btn.height)];
        titleLabel.tag = 99;
        titleLabel.font = FontYT(16);
        titleLabel.text = _titles[i];
        titleLabel.textColor = kOrangeYellowColor;
        [btn addSubview:titleLabel];
        
        btn.selected = (i==0);
        
        if (i == 0) {
            btn.width = kWidth+titleLabel.width;
            _lastButton = btn;
        }
        
        offsetX = btn.maxX+20;
        if (i == _titles.count-2) {
            offsetX = self.width - 15-kWidth;
        }
    }
    
    //顶部的分割线
    MYMaskView *line = [MYMaskView maskViewWithBgColor:RGBA(215, 217, 215, 0.8) frame:CGRectMake(0, 0, kScreenWidth, 0.7) radius:0];
    [self addSubview:line];
}


- (void)buttonClick:(UIButton *)sender
{
    if (_lastButton != sender) {
        _lastButton.selected = NO;
        sender.selected = YES;
        
        __weak typeof(self) weakSelf = self;
        
        [UIView animateWithDuration:0.3 animations:^{
            _lastButton.width = kWidth;
            CGFloat offsetX = 15;
            if (sender.tag < 5) {
                sender.width = kWidth+((UIView *)[sender viewWithTag:99]).width;
            }
            for (int i = 0; i < _titles.count-1; i++) {
                UIButton *btn = [weakSelf viewWithTag:1+i];
                btn.originalX = offsetX;
                
                offsetX += btn.width + 20;
            }
        }];
    }
    
    if (self.block) {
        _block(sender,sender.tag-1,_lastButton==sender);
    }
    
    _lastButton = sender;
}






@end
