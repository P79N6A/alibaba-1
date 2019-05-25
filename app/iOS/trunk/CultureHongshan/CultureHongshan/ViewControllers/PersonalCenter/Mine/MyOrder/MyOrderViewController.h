//
//  MyOrderViewController.h
//  CultureHongshan
//
//  Created by JackAndney on 16/5/12.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "CommonTableViewController.h"

@interface MyOrderViewController : CommonTableViewController
{
    NSMutableArray * _joinArray;
}
@property(nonatomic,assign) NSInteger selectedIndex;//1-个人中心进入  2-活动预订页面进入  3-活动室预订页面进入
@end
