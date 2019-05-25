//
//  ActivityOrderDetailViewController.h
//  CultureHongshan
//
//  Created by ct on 16/6/1.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "BasicScrollViewController.h"
@class ActOrderDetailModel;

@interface ActivityOrderDetailViewController : BasicScrollViewController
@property (nonatomic,copy) NSString *orderId;
@property (nonatomic, copy) void (^orderHandler)(NSString *orderId);
@end
