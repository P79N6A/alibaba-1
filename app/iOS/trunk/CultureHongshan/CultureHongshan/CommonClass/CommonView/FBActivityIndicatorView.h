//
//  FBActivityIndicatorView.h
//  WhereIsMyForward
//
//  Created by 李 兴 on 15-6-24.
//  Copyright (c) 2015年 李 兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBActivityIndicatorView : UIView
{
    NSTimer * _timer;
    UIImageView * _animationView;
    NSArray * _imageArray;
    NSInteger imageIndex;
    NSInteger imageCount;
    Boolean _isAnimating;
}
-(id)initWithImgary:(CGRect)frame imgary:(NSArray * )imgary;
-(Boolean)isAnimating;
-(void)startAnimating;
-(void)stopAnimating;

@end
