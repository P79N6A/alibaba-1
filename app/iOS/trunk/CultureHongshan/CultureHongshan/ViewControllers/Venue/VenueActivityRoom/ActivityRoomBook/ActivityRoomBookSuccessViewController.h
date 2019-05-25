//
//  ActivityRoomBookSuccessViewController.h
//  CultureHongshan
//
//  Created by JackAndney on 16/5/29.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "BasicViewController.h"

@class ActivityRoomOrderConfirmModel;

@interface ActivityRoomBookSuccessViewController : BasicViewController

@property (nonatomic, copy) NSString *tUserId;//用于判断活动室的使用者是否认证过

@property (nonatomic, strong) ActivityRoomOrderConfirmModel *model;

@end
