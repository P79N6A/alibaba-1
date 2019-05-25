//
//  AnimationBackView.m
//  CultureHongshan
//
//  Created by one on 15/12/23.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "AnimationBackView.h"


@implementation AnimationBackView

-(instancetype)initAnimationWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _array = @[@"加载中.",@"加载中..",@"加载中..."];
        _num = 0;
        _logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _logoImgView.image = IMG(@"placeholder");
        [self addSubview:_logoImgView];
        _logoImgView.center = CGPointMake(self.center.x, _logoImgView.center.y);
        
        _animationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 180, 20)];
        _animationLabel.numberOfLines = 0;
        _animationLabel.font = FontYT(14);
        _animationLabel.textColor = COLOR_IBLACK;
        _animationLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_animationLabel];
        _animationLabel.center = CGPointMake(self.center.x, _animationLabel.center.y);
        
        
        _button = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_animationLabel.frame)+20, 80, 30)];
        _button.hidden = YES;
        _button.layer.borderColor = kOrangeYellowColor.CGColor;
        _button.layer.borderWidth = 1;
        _button.radius = 5;
        _button.titleLabel.font = FontYT(14);
        [_button setTitle:@"点我刷新" forState:UIControlStateNormal];
        [_button setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
        [self addSubview:_button];
        _button.center = CGPointMake(self.center.x, _button.center.y);
    }
    return self;
}

-(void)beginAnimationView
{
//    self.isLoadAnimation = NO;
    if (_anmationInterval)
    {
        [_anmationInterval invalidate];
        _anmationInterval = nil;
    }
    _anmationInterval = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(anmationClick) userInfo:nil repeats:YES];
    [_anmationInterval fire];
}

-(void)anmationClick
{
    [UIView animateWithDuration:0.0 animations:^{
        _animationLabel.text = _array[_num];
        _num ++;
        if (_num == 3) {
            _num = 0;
        }
    }];
}


-(void)setLoadAnimtaionHidden:(BOOL)isLoadAnimation
{
    if (isLoadAnimation == YES) {
        [_anmationInterval invalidate];
        _anmationInterval = nil;
        self.hidden = YES;
    }else{
        self.hidden = NO;
//        if (_anmationInterval == nil) {
//            _anmationInterval = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(anmationClick) userInfo:nil repeats:YES];
//        }
    }
    
}


-(void)shutTimer
{
    [_anmationInterval invalidate];
    _anmationInterval = nil;
   
}

-(void)setAnimationLabelTextString:(NSString *)string
{
    CGFloat animationHeight = [UIToolClass textHeight:string font:FontYT(14) width:180];
    CGRect animaionRect = _animationLabel.frame;
    if (animationHeight > 20) {
        animaionRect.size.height = animationHeight;
    }
    _animationLabel.frame = animaionRect;
    _animationLabel.text = string;
}


+(void)carryOutAnimationView
{

    [[self shareAnitaionView] beginAnimationView];
}

+(AnimationBackView *)shareAnitaionView
{
    AnimationBackView *animationView = [[self alloc] initAnimationWithFrame:CGRectMake(kScreenWidth/2-50, kScreenHeight/2-40, 100, 80)];
    return animationView;
}

@end
