//
//  LaunchPage.m
//  CultureHongshan
//
//  Created by ct on 16/5/5.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "LaunchPage.h"

#define kDismissDuration 2.5//多长时间后，该页面自动消失

@interface LaunchPage ()
{
    CAShapeLayer * trackLayer;
    NSTimer * _timer;
    BOOL _AllowDrawCircle;
}

@property (nonatomic, strong) UIImageView *topImgView;
@property (nonatomic, strong) UIButton *jumpButton;
@property (nonatomic, copy) IndexBlock block;

@end



@implementation LaunchPage

static double perAngel = M_PI_2/75;

+ (void)loadLaunchPageWithBlock:(IndexBlock)block
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    LaunchPage *launchView = [[LaunchPage alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    launchView.block = block;
    
    // 下载图片
    [launchView startRequestLaunchImage];
    
    CGFloat bottomHeight = kScreenWidth*421.0/1242;
    
    //背景图
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (iPhoneX) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"LaunchImage-1100-Portrait-2436h@3x" ofType:@"png"];
        bgImageView.image = [UIImage imageWithContentsOfFile:path];
    }else {
        bgImageView.image = [UIImage imageWithContentsOfFile:[UIToolClass appLaunchImagePath]];
    }
    [launchView addSubview:bgImageView];
    
    //上方的图片
    launchView.topImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-bottomHeight)];
    [launchView addSubview:launchView.topImgView];
 
    //按钮
    launchView.jumpButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-25-48, HEIGHT_STATUS_BAR+5, 48, 48)];
    launchView.jumpButton.hidden = YES;
    launchView.jumpButton.radius = launchView.jumpButton.height*0.5;
    [launchView.jumpButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:.8f]];
    [launchView.jumpButton setTitle:@"跳过" forState:UIControlStateNormal];
    [launchView.jumpButton setTitleColor:COLOR_IWHITE forState:UIControlStateNormal];
    launchView.jumpButton.titleLabel.font = FONT(14);
    [launchView.jumpButton addTarget:launchView action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [launchView addSubview:launchView.jumpButton];

    [window addSubview:launchView];
    
    [launchView initTimer];
}


- (void)initTimer
{
    trackLayer = [CAShapeLayer layer];
    trackLayer.frame = MRECT(kScreenWidth - 25 - 48 -1.5, HEIGHT_STATUS_BAR+5 - 1.5, 51, 51);
    [self.layer addSublayer:trackLayer];
    trackLayer.fillColor = [[UIColor clearColor] CGColor];
    trackLayer.strokeColor = [COLOR_IWHITE CGColor];
    trackLayer.lineCap = kCALineCapRound;
    trackLayer.lineWidth = 2;
    trackLayer.path =  [UIBezierPath bezierPathWithArcCenter:CGPointMake(25.5, 25.5) radius:(51-2)/2 startAngle:-M_PI_2 endAngle:M_PI * 2  - M_PI_2  clockwise:YES].CGPath;
    trackLayer.strokeStart = -M_PI_2;
    trackLayer.strokeEnd = -M_PI_2;

    NSTimer *timer =  [NSTimer scheduledTimerWithTimeInterval:.016f target:self selector:@selector(updateCircle:) userInfo:nil repeats:YES];
    [timer fire];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:kDismissDuration target:self selector:@selector(dismiss) userInfo:nil repeats:YES];
}


-(void)updateCircle:(NSTimer *)timer
{
    if (_AllowDrawCircle) {
        if (trackLayer.strokeEnd >= 1) {
            [timer invalidate];
            timer = nil;
        }else {
            trackLayer.strokeEnd = trackLayer.strokeEnd + perAngel;
        }
    }
}

- (void)buttonClick:(UIButton *)sender
{
    [self dismiss];
}

- (void)dismiss
{
    [_timer invalidate];
    _timer = nil;
    
    if (self.block) {
        _block(nil, 0 , NO);
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIImage *placeImg  = [UIToolClass getScreenShotImageWithSize:CGSizeMake(kScreenWidth, kScreenHeight) views:@[window] isBlurry:NO];
    //图片
    __block UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    imgView.image = placeImg;
    [window addSubview:imgView];

    [self removeFromSuperview];
    
    [UIView animateWithDuration:0.35 animations:^{
        imgView.alpha = 0.2f;
    } completion:^(BOOL finished) {
        [imgView removeFromSuperview];
    }];
}

//获取启动页图片
- (void)startRequestLaunchImage
{
    WS(weakSelf);
    [AppProtocol getLaunchImageUrlUsingBlock:^(HttpResponseCode responseCode, id responseObject)
     {
         if (responseCode == HttpResponseSuccess) {
             
             NSString *oldImageUrl = [ToolClass getDefaultValue:kUserDefault_LaunchImageURL];
             if ([oldImageUrl isEqualToString:responseObject] == NO) {
                 [ToolClass setDefaultValue:responseObject forKey:kUserDefault_LaunchImageURL];
                 [weakSelf.topImgView sd_setImageWithURL:[NSURL URLWithString:responseObject] placeholderImage:weakSelf.topImgView.image options:SDWebImageHighPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                     weakSelf.jumpButton.hidden = NO;
                     _AllowDrawCircle = YES;
                 }];
             }else {
                 weakSelf.jumpButton.hidden = NO;
                 _AllowDrawCircle = YES;
                 [weakSelf.topImgView sd_setImageWithURL:[NSURL URLWithString:oldImageUrl]];
             }
         }
     }];
}


@end
