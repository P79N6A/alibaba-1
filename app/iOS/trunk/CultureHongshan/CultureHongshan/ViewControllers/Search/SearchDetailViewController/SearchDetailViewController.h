//
//  SearchDetailViewController.h
//  CultureHongshan
//
//  Created by ct on 15/11/11.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "BasicViewController.h"


@interface SearchDetailViewController : BasicViewController
{
    UITableView *_tableView;
    NSInteger _pageIndex;//加载数据的页数
    NSArray *_listArray;//活动列表或者场馆列表
}
@property (nonatomic,strong) NSDictionary *parameterDict;//搜索的参数:modelType,modelArea,searchKey
@property (nonatomic,assign) SearchType searchType;
@property (nonatomic,assign) BOOL hiddenPopAnimation; // YES时，返回上一个页面不带动画
@property (nonatomic,assign) BOOL activityTypeSearch;// 是否为“活动类型”搜索

@end
