//
//  TagSelectScrollView.h
//  TableViewTest
//
//  Created by ct on 16/4/8.
//  Copyright © 2016年 ct. All rights reserved.
//


/*
 
 说明：
 ＋号的index为1，标签的index从2开始
 
 */

#import <UIKit/UIKit.h>
#import "TagModel.h"

@protocol TagSelectScrollViewDelegate;

@interface TagSelectScrollView : UIView<UIScrollViewDelegate>
{
@private
    
    UIButton *_lastSelectedButton;//记录上一个选中的按钮
    
    UIScrollView *_scrollView;
    
    UIView * _indicatorView;
    
    MYMaskView *_bottomLineView; //底部的分割线
    
    BOOL _autolayout;
}


@property (nonatomic, strong) UIColor *selectedColor;//标签选中的颜色
@property (nonatomic, strong) UIColor *normalColor;//标签未选中的颜色

@property (nonatomic, copy) NSArray *titleArray;//Model数组: ThemeTagModel、CultureSpacingTagModel

@property (nonatomic, assign) BOOL isSameButton;//是否两次点击的是同一个按钮

@property (nonatomic, assign) id<TagSelectScrollViewDelegate> delegate;

@property(nonatomic,assign) BOOL canGoPreTag;
@property(nonatomic,assign) BOOL canGoNextTag;

- (instancetype)initWithFrame:(CGRect)frame autolayout:(BOOL)autolayout;

-(void)movePreTag;
-(void)moveNextTag;
-(void)updateSelectTagArray;
-(void)hiddenAddButton;
-(void)moveToIndex:(NSInteger)index;

@end



/* ———————————  TagSelectScrollViewDelegate  ————————— */


@protocol TagSelectScrollViewDelegate <NSObject>

@optional
/**
 *  标签选择视图的代理方法
 *
 *  @param tagSelectView 标签选择视图
 *  @param model         选中的Model
 *  @param index         选中的是第几个
 */
- (void)tagSelectView:(TagSelectScrollView *)tagSelectView didSelectItem:(id)model forIndex:(NSInteger)index;


@end
