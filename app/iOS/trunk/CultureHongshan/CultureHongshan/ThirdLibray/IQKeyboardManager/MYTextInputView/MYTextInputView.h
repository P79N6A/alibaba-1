//
//  MYTextInputView.h
//  CommonTestProject
//
//  Created by ct on 16/12/22.
//  Copyright © 2016年 Andney. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MYTextInputViewDelegate;

#pragma mark - ——————————————— MYTextField ———————————————

@interface MYTextField : UITextField
@property (nonatomic, assign) int maxLength;
/**
 是否要自定义左侧的视图
 
 @discussion  左侧视图默认用来做调整间隙使用；如果要自定义左侧的视图，请先设置该变量为YES。
 */
@property (nonatomic, assign) BOOL customLeftView;
@property (nonatomic, assign) BOOL isPhoneInput;
@property (nonatomic, assign) BOOL isLongNumberInput;
@property (nonatomic, assign) BOOL hideKeyboardWhenTapReturnkey;//默认为YES，当点击return键时，键盘自动消失
@property (nonatomic, weak) id<MYTextInputViewDelegate> delegateObject;

/** 设置颜色前，须设置placeholder */
@property (nonatomic, strong) UIColor *placeholderColor;

/** 设置占位字符以及占位符的颜色 */
- (void)setPlaceholder:(NSString *)placeholder andColor:(UIColor *)color;

@end

#pragma mark - ——————————————— MYTextView ———————————————


@interface MYTextView : UITextView
@property (nonatomic, assign) int maxLength;
@property (nonatomic, assign) BOOL hideKeyboardWhenTapReturnkey;//默认为YES，当点击return键时，键盘自动消失
@property (nonatomic, copy) NSString *placeholder;
/** 设置颜色前，须设置placeholder */
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, weak) id<MYTextInputViewDelegate> delegateObject;
@property (nonatomic, assign) BOOL placeholderHidden;


/** 设置占位字符以及占位符的颜色 */
- (void)setPlaceholder:(NSString *)placeholder andColor:(UIColor *)color;

@end






#pragma mark - ——————————————— MYTextInputViewDelegate ———————————————


@protocol MYTextInputViewDelegate <NSObject>
@optional
- (void)textInputViewTextDidChange:(id)inputView;
- (void)textInputViewDidClickReturnKey:(id)inputView;

- (BOOL)textInputViewShouldBeginEditing:(id)inputView;
- (BOOL)textInputViewShouldEndEditing:(id)inputView;

- (void)textInputViewDidBeginEditing:(id)inputView;
- (void)textInputViewDidEndEditing:(id)inputView;
@end



#pragma mark - ——————————————— Extension Methods ———————————————


/**
 手机号输入时文本的处理

 @param text 原始的输入文本
 
 @return 适合显示的手机号文本
 */
NSString *MYPhoneNumberInputHandle(NSString *text);

/**
 长的数字文本输入时的处理

 @param text      原始的输入文本
 @param maxLength 长度限制：maxLength > 0时才做限制
 
 @return 每4位用空格分割的文本
 */
NSString *MYLongNumberInputHandle(NSString *text, int maxLength);

/**
 手机号中间部分**处理
 
 @param text 原始的手机号
 */
NSString *MYPhoneNumberSecureShowHandle(NSString *text);




