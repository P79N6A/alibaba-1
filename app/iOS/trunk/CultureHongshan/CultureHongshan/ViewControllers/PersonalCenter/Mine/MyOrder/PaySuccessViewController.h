//
//  PaySuccessViewController.h
//  CultureHongshan
//
//  Created by ct on 17/2/23.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "BasicScrollViewController.h"
@class PrepayOrderModel;

/**
 支付成功页面
 */
@interface PaySuccessViewController : BasicScrollViewController
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, strong) PrepayOrderModel *model;
@end
