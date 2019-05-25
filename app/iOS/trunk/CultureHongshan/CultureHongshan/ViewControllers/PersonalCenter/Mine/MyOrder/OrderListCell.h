//
//  OrderListCell.h
//  CultureHongshan
//
//  Created by ct on 17/2/17.
//  Copyright © 2017年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyOrderModel;

@interface OrderListCell : UITableViewCell

/**
 
 @param model          订单Model
 @param operationType  操作类型：1-前往认证  2-付款
 */
@property (nonatomic, copy) void(^actionHandler)(MyOrderModel *model, NSInteger operationType);

- (void)setModel:(MyOrderModel *)model listType:(NSInteger)listType; // listType：1-待审核订单 2-待支付订单 3-待参加订单 4-历史订单

@end
