//
//  ActivityListViewController.h
//  CultureHongshan
//
//  Created by ct on 16/4/11.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "CommonMultiTableViewController.h"
#import "TagSelectScrollView.h"
#import "ActivityCell.h"
#import "ActivityModel.h"
#import <MapKit/MapKit.h>
#import "DropdownView.h"
@class FBMapAnnotation;



/**
 *  @brief 文化活动
 *
 *  表视图的结构：分为2个区，frame保持不变
 *      0区，顶部的广告位； 1区，活动列表（含插入的广告）
 *      上下滑动时，通过更新tableView的contentInset，达到第一个单元格不被隐藏
 */
@interface ActivityListViewController : CommonMultiTableViewController
{
    MKMapView * _mapView;
    BOOL isShowMap;
    BOOL isNeedUpdateTag; //用户点击“加号”重新选中喜爱的标签后，需要重新初始化活动类型标签选择视图
    __weak MKAnnotationView * _lastSelectedAnnotationView;
    UIView * bottomView;
    NSString * _currentTagId; // 当前选中的活动类型Id
    NSMutableArray * annotationAry; // 地图标记数组
    
    TagSelectScrollView *tagSelectView; // 活动类型标签选择视图（scrollView）
    FBButton * _bottomViewButton;
    DropdownView * _areaDropdown; // 区域下拉表
    DropdownView * _smartDropdown; // 智能排序下拉表
    DropdownView * _filterDropdown; // 筛选下拉表
    NSString * _selectedOrder; // 保存每次选中的排序名称
    NSString * _selectedFilter; // 保存每次选中的筛选条件
    NSString * _selectedArea; // 保存每次选中的区域
}

- (void)setNeedUpdateSelectTagView:(BOOL)isNeed;


@end





@interface FBMapAnnotation : NSObject<MKAnnotation>

@property(nonatomic,readonly)CLLocationCoordinate2D coordinate;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,assign)NSInteger index;
-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
