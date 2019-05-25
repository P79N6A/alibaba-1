//
//  WaitPayViewController.h
//  CultureHongshan
//
//  Created by ct on 17/2/17.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "BasicScrollViewController.h"

/**
 等待支付页面
 */
@interface WaitPayViewController : BasicScrollViewController
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, assign) DataType dataType;
@property (nonatomic, copy) void (^completionHandler)(BOOL success, NSString *orderId);
@end
