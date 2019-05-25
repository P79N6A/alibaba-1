//
//  AnimatedSpringPopupView.m
//  CultureHongshan
//
//  Created by ct on 16/5/27.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "AnimatedSpringPopupView.h"


@interface AnimatedSpringPopupView ()

@property (nonatomic, copy  ) IndexBlock block;
@property (nonatomic, strong) MYMaskView *bgView;
@property (nonatomic, copy  ) NSString   *title;
@property (nonatomic, copy  ) NSString   *message;

@end


@implementation AnimatedSpringPopupView


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *)message
{
    if (self = [super initWithFrame:frame])
    {
        self.title = title;
        self.message = message;
        [self initSubviews];
    }
    return self;
}


- (void)initSubviews
{
    self.bgView = [MYMaskView maskViewWithBgColor:COLOR_IWHITE frame:CGRectMake(0, 0, ConvertSize(450), 0) radius:4];
    [self addSubview:_bgView];
    
    CGFloat offsetY = 26;
    CGFloat spacingY = 10;
    
    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithCapacity:1];
    if (_title.length) {
        [tmpArray addObject:_title];
    }
    if (_message.length) {
        [tmpArray addObject:_message];
    }
    
    for (int i = 0; i < tmpArray.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, offsetY, _bgView.width-40, 0)];
        label.tag = 10-i;
        if (i == 1){
            label.font = FontYT(16);
            label.textColor = [UIToolClass colorFromHex:@"363636"];
        }else {
            label.font = FontYT(18);
            label.textColor = [UIToolClass colorFromHex:@"262626"];
        }
        label.numberOfLines = 0;
        label.attributedText = [UIToolClass getAttributedStr:tmpArray[i] font:label.font lineSpacing:4];
        label.textAlignment = NSTextAlignmentCenter;
        [_bgView addSubview:label];
        label.height = [UIToolClass attributedTextHeight:label.attributedText width:label.width];
        
        offsetY = label.maxY+spacingY;
        
        if (i == tmpArray.count-1) {
            offsetY -= spacingY;
        }
    }
    
    //按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, offsetY+15, 105, 40)];
    button.backgroundColor = [UIToolClass colorFromHex:@"F5F5F5"];
    button.radius = 3;
    button.layer.borderColor = [UIToolClass colorFromHex:@"D0D0D0"].CGColor;
    button.layer.borderWidth = 0.8;
    button.titleLabel.font = FontYT(16);
    [button setTitle:@"确 定" forState:UIControlStateNormal];
    [button setTitleColor:[UIToolClass colorFromHex:@"7C7C7C"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:button];
    button.centerX = _bgView.width*0.5;
    
    _bgView.height = button.maxY+27;
}



- (void)buttonClick:(UIButton *)sender
{
    [self dismissWithAnimation];
}


- (void)showWithAnimation
{
    CGPoint startPoint = CGPointMake(self.centerX, -_bgView.height*0.5);
    _bgView.layer.position = startPoint;
    
    //damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
    //velocity:弹性复位的速度
    [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _bgView.layer.position = CGPointMake(kScreenWidth*0.5, kScreenHeight*0.5);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissWithAnimation
{
    WS(weakSelf);
    [UIView animateWithDuration:0.4 animations:^{
        _bgView.layer.position = CGPointMake(kScreenWidth*0.5, -_bgView.height*0.5);
        
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}


+ (void)popupViewWithTitle:(NSString *)title message:(NSString *)message callbackBlock:(IndexBlock)block
{
    AnimatedSpringPopupView *animView = [[AnimatedSpringPopupView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) title:title message:message];
    animView.backgroundColor  = [UIColor colorWithWhite:0.0 alpha:0.7];
    animView.block = block;
    
    [[UIApplication sharedApplication].keyWindow addSubview:animView];
    
    [animView showWithAnimation];
}


@end
