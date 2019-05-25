//
//  BasicCustomNavigationBarViewController.h
//  CultureHongshan
//
//  Created by ct on 16/12/5.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "BasicScrollViewController.h"



typedef enum : NSUInteger {
    NavigationBarLeftItemTypeDefault, // 返回箭头
    NavigationBarLeftItemTypeClose, // 关闭图标
} NavigationBarLeftItemType;




/** 导航条为浅灰色的页面 */
@interface BasicCustomNavigationBarViewController : BasicScrollViewController

/**  默认为返回按钮箭头 */
@property (nonatomic, assign) NavigationBarLeftItemType leftItemType;
/** 导航条标题 */
@property (nonatomic, copy, nullable) NSString *navTitle;
/** 导航条右侧的按钮标题 */
@property (nonatomic, copy, nullable) NSString *rightItemTitle;

- (void)leftNavigationItemAction; // 导航条左侧按钮的事件
- (void)rightNavigationItemAction; // 导航条右侧按钮的事件

@end
