//
//  MYSegmentView.h
//  WHYUIToolKit
//
//  Created by JackAndney on 2017/10/25.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MYSegmentViewDelegate;

/**
 分段显示视图
 */
@interface MYSegmentView : UIView

@property (nonatomic, assign) BOOL showMidLine; // 是否显示Item之间的分割线，默认为YES
@property (nonatomic, assign) BOOL showIndicatorView; // 是否显示底部的指示条，默认为YES

@property (nonatomic, readonly) NSInteger selectedIndex;
@property (nonatomic, readonly) BOOL sameButonClick;

/** 按钮被选中的类型：0-初始化时选中，1-按钮点击选中 2-外部手动调用 */
@property (nonatomic, readonly) int itemClickType; // =0的情况，不会调用delegate或block方法
@property (nonatomic, copy) void (^didClickItemBlock)(MYSegmentView *segmentView, NSInteger index, UIButton *button); // index从0计数
@property (nonatomic, weak) id<MYSegmentViewDelegate> delegate; // 优先级大于Block回调

@property (nonatomic, assign) CGFloat leftMargin; // 左侧按钮的左边距，默认为0
@property (nonatomic, assign) CGFloat rightMargin; // 右侧按钮的右边距，默认为0
@property (nonatomic, assign) CGFloat titleAndImageSpacing; // 图片和文字之间的间距，默认值为4
@property (nonatomic, assign) CGFloat seperatorHeightScale; // 分割线的高度与视图总高度的比例，默认为0.7(分割线为图片时，该属性无效)
@property (nonatomic, assign) CGFloat bottomLineHeight; // 底部分割线的高度，默认为0.5
// 首次调用-[MYSegmentView beginUpdate]前设置有效
// 注意：指示条的宽度<=1时，宽度为按钮宽度的百分比， >1时，宽度为指示条的实际宽度
@property (nonatomic, assign) CGFloat indicatorWidth; // 指示条的宽度，默认值为0.75
@property (nonatomic, assign) CGFloat indicatorHeight; // 指示条的高度，默认值为1
@property (nonatomic, assign) CGFloat indicatorOffsetY; // 指示条底部与视图底部的偏移量。为正时，向上偏移，默认为0


/** 标题字体 */
@property (nonatomic, strong) UIFont *font;
/** 按钮的背景色 */
@property (nonatomic, strong) UIColor *btnBackgroundColor;
/** 标题默认色 */
@property (nonatomic, strong) UIColor *normalColor;
/** 标题选中色 */
@property (nonatomic, strong) UIColor *selectedColor;
/** 中间分割线的颜色 */
@property (nonatomic, strong) UIColor *seperatorColor;
/** 中间分割线图片 */
@property (nonatomic, strong) UIImage *seperatorImage;
/** 底部指示条的颜色 */
@property (nonatomic, strong) UIColor *indicatorColor;
/** 底部分割线的颜色 */
@property (nonatomic, strong) UIColor *bottomLineColor;

/** 标题数组 */
@property (nonatomic, copy) NSArray<NSString *> *segmentTitles;
/** 默认图片数组 */
@property (nonatomic, copy) NSArray<UIImage *> *segmentNormalImages;
/** 选中图片数组 */
@property (nonatomic, copy) NSArray<UIImage *> *segmentSelectedImages;


/**
 设置好全部属性后，调用该方法更新视图
 */
- (void)beginUpdate;


/**
 根据索引选中指定的Item
 
 @discussion 注意：调用该方法后，不会调用点击事件的代理方法
 
 @param selectedIndex 要选中的索引
 @param animated      是否有动画
 */
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;


@end


#pragma mark - MYSegmentViewDelegate

@protocol MYSegmentViewDelegate <NSObject>
@optional

// index从0计数
- (void)segmentView:(MYSegmentView *)segmentView didClickItem:(UIButton *)button atIndex:(NSInteger)index;

@end



