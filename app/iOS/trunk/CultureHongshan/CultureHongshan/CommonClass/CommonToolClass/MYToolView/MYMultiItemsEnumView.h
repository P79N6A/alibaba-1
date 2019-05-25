//
//  MYMultiItemsEnumView.h
//  WHYUIToolKit
//
//  Created by JackAndney on 2017/10/30.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 多标签、座位信息显示类的视图
 
 @discussion 注意：不要在该视图上添加子视图
 */
@interface MYMultiItemsEnumView : UIView

- (instancetype)initWithFrame:(CGRect)frame itemTitles:(NSArray<NSString *>*)itemTitles configLabelBlock:(void(^)(UILabel *itemLabel, NSInteger index))block showBgColor:(BOOL)showBgColor;

@property (nonatomic, copy) NSArray<NSString *> *itemTitles;
@property (nonatomic, copy) void (^configLabelBlock)(UILabel *itemLabel, NSInteger index); // 配置Label外观的回调

@property (nonatomic, assign) NSUInteger numberOfLines; // 显示几行内容
@property (nonatomic, assign) CGFloat spacingX; // 水平间距，默认值为8
@property (nonatomic, assign) CGFloat spacingY; // 垂直间距，默认值为8
@property (nonatomic, assign) BOOL showBgColor;

// ————————— 显示背景色时才需要设置的相关属性 ———————
@property (nonatomic, assign) CGFloat padding; // 内边距，默认值为8
@property (nonatomic, assign) CGFloat itemHeight; // Label的高度，默认为22
@property (nonatomic, assign) CGFloat cornerRadius; // Label的圆角半径，默认为0


- (void)reloadSubviews; // 调用该方法更新子视图(初始化后，也需要调用该方法)


/**
 获取视图的高度

 @return 视图的实际高度（如frame的宽度为0，或itemTitles为空，返回的高度为0）
 */
- (CGFloat)getContentHeight;


@end
