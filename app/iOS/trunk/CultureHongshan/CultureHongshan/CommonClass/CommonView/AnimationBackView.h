//
//  AnimationBackView.h
//  CultureHongshan
//
//  Created by one on 15/12/23.
//  Copyright © 2015年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimationBackView : UIView
//{
//    NSTimer *_anmationInterval;
//}
@property (nonatomic, strong) UIImageView *logoImgView;
@property (nonatomic, strong) UILabel *animationLabel;

@property (nonatomic, assign)NSTimer *anmationInterval;

@property (nonatomic, strong)NSArray *array;
@property (nonatomic, assign)NSInteger num;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, setter=setLoadAnimtaionHidden:) BOOL isLoadAnimation;

-(instancetype)initAnimationWithFrame:(CGRect)frame;

-(void)shutTimer;

-(void)beginAnimationView;

-(void)setAnimationLabelTextString:(NSString *)string;

+(void)carryOutAnimationView;

+(AnimationBackView *)shareAnitaionView;

@end
