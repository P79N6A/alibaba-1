//
//  FSDropDownMenu.h
//  FSDropDownMenu
//
//  Created by xiang-chen on 14/12/17.
//  Copyright (c) 2014年 chx. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kMenuId_Nearby        @"NearbyDropDownMenu"
#define kMenuId_AllCategories @"AllCategoriesDropDownMenu"
#define kMenuId_SmartSorting  @"SmartSortingDropDownMenu"
#define kMenuId_Filter        @"FilterDropDownMenu"
typedef enum {
    DropDownMenuTypeOne = 1,//只有右侧的表视图
    DropDownMenuTypeTwo = 2//两个表视图
} DropDownMenuType;


@class FSDropDownMenu;

@protocol FSDropDownMenuDataSource <NSObject>

@required

- (NSInteger)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section;

- (NSString *)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView titleForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

//返回单元格的高度
- (CGFloat)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;


@end



#pragma mark - delegate
@protocol FSDropDownMenuDelegate <NSObject>

@optional


- (void)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end



/*     ————————————————————  FSDropDownMenu  ————————————————————    */



@interface FSDropDownMenu : UIView<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, assign, readonly) NSInteger rightSelectedRow;
@property (nonatomic, assign, readonly) NSInteger selectedConditionIndex;//用于筛选下拉表里状态：可预订、不可预订
@property (nonatomic, assign, readonly) NSInteger selectedWeekIndex;//工作日、周末

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;



@property (nonatomic, assign) DropDownMenuType type;

@property (nonatomic, strong) UIView *transformView;

@property (nonatomic, weak) id <FSDropDownMenuDataSource> dataSource;
@property (nonatomic, weak) id <FSDropDownMenuDelegate> delegate;

- (instancetype)initWithOrigin:(CGPoint)origin type:(DropDownMenuType)type andHeight:(CGFloat)height;

- (void)menuTapped;

@end






// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
