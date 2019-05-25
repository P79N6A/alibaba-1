//
//  AnimatedSpringPopupView.h
//  CultureHongshan
//
//  Created by ct on 16/5/27.
//  Copyright © 2016年 CT. All rights reserved.
//

/*
 
 弹跳的弹出框
 
 */
#import <UIKit/UIKit.h>

@interface AnimatedSpringPopupView : UIView


/**
 *  弹性弹窗
 *
 *  @param title   弹窗的标题
 *  @param message 弹窗消息
 *  @param block   弹窗消失后的回调
 *
 *  注意：当title和message同时存在时，标题的字体要比消息的字体大；当二者仅存在一个时，均按照标题来显示；两者都不存在时，则只有一个确定按钮
 */
+ (void)popupViewWithTitle:(NSString *)title message:(NSString *)message callbackBlock:(IndexBlock)block;

@end
