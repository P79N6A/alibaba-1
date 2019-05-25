//
//  MYNoDataView.h
//  CultureHongshan
//
//  Created by JackAndney on 2017/11/22.
//  Copyright © 2017年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MYNoDataViewDelegate;

/**
 无数据时的提示视图
 */
@interface MYNoDataView : UIView
@property (nonatomic, assign) CGFloat centerOffsetY; // 中心位置Y的偏移量
@property (nonatomic, assign) BOOL fullViewClickable; // 是否整个视图可点击，默认为NO
@property (nonatomic, assign) CGFloat spacingOfImgAndMsg; // 图片和文本的间距，默认为5
@property (nonatomic, assign) CGFloat spacingOfMsgAndBtn; // 文本和按钮的间距，默认为22
@property (nonatomic, assign) CGFloat btnHeight;  // 按钮Label的高度，默认为28
@property (nonatomic, strong) MYLabel *actionLabel;

/**
 初始化方法

 @param msg       消息内容
 @param iconImage 图标
 @param btnTitle  按钮的标题
 
 @return MYNoDataView对象
 */
- (instancetype)initWithMessage:(NSString *)msg iconImage:(UIImage *)iconImage buttonTitle:(NSString *)btnTitle delegate:(id<MYNoDataViewDelegate>)delegate;
- (void)reloadSubviews; // 调用该方法刷新子视图
- (void)showInView:(UIView *)parentView;
- (void)showInView:(UIView *)parentView topView:(UIView *)topView;

@end




@protocol MYNoDataViewDelegate <NSObject>
@optional
- (void)noDataView:(MYNoDataView *)noDataView didClickButton:(NSString *)actionTitle;
@end;
