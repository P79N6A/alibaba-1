//
//  WHYAlertActionUtil.h
//  WHYToolSDK
//
//  Created by JackAndney on 2016/12/28.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WHYAlertActionUtil : NSObject


// index： 0-取消  其它从下到上 - 1, 2, ...
+ (void)showAlertWithTitle:(NSString *)title msg:(NSString *)msg actionBlock:(void(^)(NSInteger index, NSString *buttonTitle))actionBlock buttonTitles:(NSString *)buttonTitle, ...;

+ (void)showActionSheetWithTitle:(NSString *)title msg:(NSString *)msg cancelButtonTitle:(NSString *)cancelTitle destructiveButtonTitle:(NSString *)destructiveTitle actionBlock:(void(^)(NSInteger index, NSString *buttonTitle))actionBlock otherButtonTitles:(NSString *)otherTitle, ...;

+ (void)showActionSheetInView:(UIView *)view withTitle:(NSString *)title msg:(NSString *)msg cancelButtonTitle:(NSString *)cancelTitle destructiveButtonTitle:(NSString *)destructiveTitle actionBlock:(void(^)(NSInteger index, NSString *buttonTitle))actionBlock otherButtonTitles:(NSString *)otherTitle, ...;

@end
