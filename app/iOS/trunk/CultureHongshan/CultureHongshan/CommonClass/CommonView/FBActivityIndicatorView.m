//
//  FBActivityIndicatorView.m
//  WhereIsMyForward
//
//  Created by 李 兴 on 15-6-24.
//  Copyright (c) 2015年 李 兴. All rights reserved.
//

#import "FBActivityIndicatorView.h"

@implementation FBActivityIndicatorView

-(id)initWithImgary:(CGRect)frame imgary:(NSArray * )imgary
{

    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = NO;
        _animationView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageArray = imgary;
        imageCount = _imageArray.count;
        [self addSubview:_animationView];
        _timer = [[NSTimer alloc]initWithFireDate:[NSDate date]
                                         interval:0.05
                                           target:self
                                         selector:@selector(animationStep:)
                                         userInfo:nil
                                          repeats:YES];

        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        self.hidden = YES;

    }
    return self;

}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = NO;
        _animationView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageArray = @[@"loading1",@"loading2"];
        imageCount = _imageArray.count;
        [self addSubview:_animationView];
        _timer = [[NSTimer alloc]initWithFireDate:[NSDate date]
                                         interval:0.05
                                           target:self
                                         selector:@selector(animationStep:)
                                         userInfo:nil
                                          repeats:YES];

        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        self.hidden = YES;

    }
    return self;
}


-(void)animationStep:(NSTimer *)timer
{

    dispatch_async(dispatch_get_main_queue(), ^{


        imageIndex++;
        if (imageIndex >= imageCount)
        {
            imageIndex = 0;

        }
        _animationView.image = IMG(_imageArray[imageIndex]);

    });
    
}



-(void)startAnimating
{
    _isAnimating = YES;
    _animationView.hidden = NO;
    self.hidden = NO;
    //_timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(animationStep:) userInfo:nil repeats:YES];

    imageIndex = 0;
    _animationView.image = IMG(_imageArray[0]);
    [_timer setFireDate:[NSDate date]];
    _animationView.frame = self.bounds;

}


-(void)stopAnimating
{

    _isAnimating = NO;
    _animationView.hidden = YES;
    self.hidden = YES;
     [_timer setFireDate:[NSDate distantFuture]];
    

}

-(Boolean)isAnimating
{
    return _isAnimating;
}


@end
