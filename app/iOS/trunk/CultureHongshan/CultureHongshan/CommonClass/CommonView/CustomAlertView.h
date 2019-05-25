//
//  CustomAlertView.h
//  CultureHongshan
//
//  Created by JackAndney on 2017/2/19.
//  Copyright © 2017年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MYAlertStyle) {
    /** 退款提交成功提示 */
    MYAlertStyleRefundSuccess,
    /** 支付中 */
    MYAlertStylePaying,
    /** 自动消失的弹窗提示消息 */
    MYAlertStyleAutoDismiss,
};



/** 自定义弹窗视图 */
@interface CustomAlertView : UIView

+ (nullable instancetype)showAlertWithStyle:(MYAlertStyle)style animated:(BOOL)animated;
+ (nullable instancetype)showAlertWithStyle:(MYAlertStyle)style message:(nullable NSString *)msg animated:(BOOL)animated;

- (void)dismiss;

@end
