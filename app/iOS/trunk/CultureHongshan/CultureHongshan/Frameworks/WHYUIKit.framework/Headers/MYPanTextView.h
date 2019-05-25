//
//  MYPanTextView.h
//  WHYUIKit
//
//  Created by JackAndney on 2017/5/14.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MYTextView;

@interface MYPanTextView : UIView

@property (nonatomic, weak) UIView *locationInView;
@property (nonatomic, strong) MYTextView *textView;

- (instancetype)initWithFrame:(CGRect)frame panImageName:(NSString *)panImgName minHeight:(CGFloat)minHeight maxHeight:(CGFloat)maxHeight;

@end
