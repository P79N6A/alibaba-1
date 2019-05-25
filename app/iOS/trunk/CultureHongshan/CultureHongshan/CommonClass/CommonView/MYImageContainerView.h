//
//  MYImageContainerView.h
//  CultureHongshan
//
//  Created by JackAndney on 2017/7/10.
//  Copyright © 2017年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 子视图的调整方式
 */
typedef NS_ENUM(NSInteger, MYImageContainerAdjustType) {
    /** 大小固定，间距可调 */
    MYImageContainerAdjustTypeSizeFixed = 0,
    /** 间距固定，大小可调 */
    MYImageContainerAdjustTypeSpacingFixed,
};



/**
 *  图片容器视图
 *  
 *  @discussion 可以自动调整子视图的位置（或约束）。如果要添加按钮，务必最后一个添加按钮
 */
@interface MYImageContainerView : UIView

@property (nonatomic, assign) CGFloat minValue;// 可变值的最小值，默认值为8
@property (nonatomic, assign) CGFloat imgSpacing;
@property (nonatomic, assign) CGFloat imgSize;
/** 图片的高度与宽度之比， 默认为1 */
@property (nonatomic, assign) CGFloat imgScale;
/** 调整内容的方式 */
@property (nonatomic, assign,readonly) MYImageContainerAdjustType adjustType;
@property (nonatomic, assign, readonly) NSInteger maxImgCount; // 最多有几张图片
@property (nonatomic, assign) NSInteger currentImgCount;// 当前有几张图片

@property (nonatomic, strong) UIImage *placeholderImage;


@property (nonatomic, copy) void (^tapActionHandler)(UIImageView *imgView, NSInteger index); // 点击事件
@property (nonatomic, copy) void (^longPressActionHandler)(UIImageView *imgView, NSInteger index);// 长按事件
@property (nonatomic, copy) void (^removePhotoActionHandler)(UIImageView *imgView, NSInteger index);// 移除图片
@property (nonatomic, copy) void (^addPhotoActionHandler)(); // 添加图片

// 初始化方法
- (instancetype)initWithFrame:(CGRect)frame maxImgCount:(NSInteger)maxCount adjustType:(MYImageContainerAdjustType)adjustType;

- (instancetype)initWithFrame:(CGRect)frame
                  maxImgCount:(NSInteger)maxCount
                   adjustType:(MYImageContainerAdjustType)adjustType
                   tapHandler:(void (^)(UIImageView *imgView, NSInteger index))tapHandler
             longPressHandler:(void (^)(UIImageView *imgView, NSInteger index))longPressHandler
           removePhotoHandler:(void (^)(UIImageView *imgView, NSInteger index))removePhotoHandler;


- (UIImageView *)imageViewAtIndex:(NSInteger)index;

- (void)updatePhotoWithImageArray:(NSArray *)imageArray;

@end





#pragma mark - MYImageEditView


@interface MYImageEditView : UIView

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *removeButton;

@end
