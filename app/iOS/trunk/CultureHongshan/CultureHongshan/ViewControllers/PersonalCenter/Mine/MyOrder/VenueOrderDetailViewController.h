//
//  VenueOrderDetailViewController.h
//  CultureHongshan
//
//  Created by ct on 16/6/1.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "BasicViewController.h"
@class OrderDetailModel;

@interface VenueOrderDetailViewController : BasicViewController

@property (nonatomic,copy) NSString *orderId;
@property (nonatomic,strong) OrderDetailModel *model;//支付完成回来后，需要刷新数据


@end
