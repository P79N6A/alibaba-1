//
//  PayFailureViewController.h
//  CultureHongshan
//
//  Created by ct on 17/2/23.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "BasicScrollViewController.h"


/**
 支付失败页面
 */
@interface PayFailureViewController : BasicScrollViewController

///** 发起支付需要的参数 */
//@property (nonatomic, strong) NSDictionary *payParams;

/** 重新支付回调 */
@property (nonatomic, copy) void (^repayHandler)();

/** 支付失败消息 */
@property (nonatomic, copy) NSString *payErrorMsg;

@end
