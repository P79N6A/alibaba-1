//
//  FBLabel.h
//  ParkTour
//
//  Created by 李 兴 on 15-4-13.
//  Copyright (c) 2015年 李 兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBLabel : UILabel
{
    CGSize textSize;
    CGFloat _lineSpace;
    CGFloat _heightOffset;
}
@property(assign,nonatomic)CGFloat textWidth;
@property(assign,nonatomic)CGFloat textHeight;
@property(assign,nonatomic)CGFloat showTextWidth;
@property(assign,nonatomic)CGFloat showTextHeight;
@property (nonatomic,copy) NSString *textContent;


-(id)initWithStyle:(CGRect)frame font:(UIFont *)font fcolor:(UIColor *)fcolor text:(NSString *)text;
-(id)initWithStyle:(CGRect)frame font:(UIFont *)font fcolor:(UIColor *)fcolor text:(NSString *)text linespace:(CGFloat)linespace;


@end
