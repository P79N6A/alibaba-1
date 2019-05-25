//
//  MYTableView.h
//  CultureHongshan
//
//  Created by ct on 17/2/28.
//  Copyright © 2017年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 自定义表视图 */
@interface MYTableView : UITableView
@property (nonatomic, assign) NoDataPromptStyle promptStyle;
@property (nonatomic, copy) NSString *errorMsg;
@end
