//
//  SelectBarViewController.h
//  徐家汇
//
//  Created by 李 兴 on 13-10-5.
//  Copyright (c) 2013年 李 兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DropdownView;
@protocol DropdownViewDelegate <NSObject>

/**
 *  筛选条上的按钮点击事件
 *
 *  @param services 点击的下拉表
 *  @param result   选中的筛选条件
 */
-(void)dropdownView:(DropdownView *)services result:(NSString *)result;

@end




@interface DropdownView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _maintitleTableView;
    UITableView * _subtitleTableView;
    CGRect orgFrame;
    int _barWidth;
    int _barHeight;
    UIButton  * _titleLabelButton;
    NSMutableArray * _subTypeAry;
    NSMutableArray * _mainTitleArray;
    NSArray * _subTitleArray;
    NSString * _orgTitle;
    Boolean  _haveSubArray;
    NSInteger _selectMainCellIndex;
    NSInteger _selectSubCellIndex;
    NSInteger _superViewWidth;
    UITableViewCell * _lastMainSelectedCell;
    UITableViewCell * _lastSubSelectedCell;
    UIView * _subTableViewBgView;
    UIButton * arrowButton;
    CGRect  _orginArrowButtonPosition;
    int _orgSuperWidth;
    Boolean _isShrink;
    NSInteger superviewWidth;

}

@property(weak,nonatomic)    id<DropdownViewDelegate>                delegate;
@property(retain,nonatomic) NSArray * dataList;
@property (nonatomic, strong) UILabel *label;

-(void)restoreDefault;
-(void)setTitleText:(NSString *)title;
-(NSString *)getTitleText;
-(void)shrinkDropView;
-(id)initWithArray:(CGRect)frame  title:(NSString *)title dataList:(NSArray * )dataList   delegate:(id<DropdownViewDelegate>)delegate;
-(void)updateDataList:(NSArray * )data;

@end
