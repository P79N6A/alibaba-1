//
//  FBButton.h
//  ParkTour
//
//  Created by 李 兴 on 15-4-16.
//  Copyright (c) 2015年 李 兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBButton : UIButton
{

}
typedef void(^ClickEvent)(FBButton * owner);
@property(copy,nonatomic)ClickEvent block;
@property(assign,nonatomic)BOOL animation;
-(id)initWithText:(CGRect)frame font:(UIFont *)font fcolor:(UIColor *)fcolor bgcolor:(UIColor *)bgcolor  text:(NSString *)text;
-(id)initWithImage:(CGRect)frame  bgcolor:(UIColor *)bgcolor  img:(UIImage *)img;

-(id)initWithText:(CGRect)frame font:(UIFont *)font fcolor:(UIColor *)fcolor bgcolor:(UIColor *)bgcolor  text:(NSString *)text clickEvent:(ClickEvent )block;
-(id)initWithImage:(CGRect)frame  bgcolor:(UIColor *)bgcolor  img:(UIImage *)img clickEvent:(ClickEvent )block;


/**
 *  设置图片和文字同时显示：水平、上下
 *
 */
- (void)setTitle:(NSString *)title image:(UIImage *)image forState:(UIControlState)state isHorizontal:(BOOL)horizontal;



@end
