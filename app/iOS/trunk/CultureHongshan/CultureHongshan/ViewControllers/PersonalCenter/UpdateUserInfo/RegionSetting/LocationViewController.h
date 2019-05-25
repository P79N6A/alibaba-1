//
//  LocationViewController.h
//  CultureHongshan
//
//  Created by ct on 16/2/18.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "BasicViewController.h"


typedef void(^UserLocationBlock) (NSString *Location);


@interface LocationViewController : BasicViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,copy) UserLocationBlock block;//回调，更新个人设置页面的地区

@end
