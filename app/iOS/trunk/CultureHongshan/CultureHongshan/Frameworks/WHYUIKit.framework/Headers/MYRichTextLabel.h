//
//  MYRichTextLabel.h
//  WHYToolSDK
//
//  Created by JackAndney on 2017/5/14.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYRichTextLabel : UILabel

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text autoAdjustHeight:(BOOL)autoAdjustHeight;

#pragma mark - AutoLayout 方法

+ (instancetype)al_labelWithText:(NSString *)text;

@end
