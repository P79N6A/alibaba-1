//
//  ActivityRoomOrderConfirmModel.m
//  CultureHongshan
//
//  Created by ct on 16/6/12.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "ActivityRoomOrderConfirmModel.h"

@implementation ActivityRoomOrderConfirmModel


- (id)initWithAttributes:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]])
        {
            return nil;
        }
        
        self.orderId        = [dictionary safeStringForKey:@"cmsRoomOrderId"];
        self.roomName       = [dictionary safeStringForKey:@"roomName"];
        self.venueName      = [dictionary safeStringForKey:@"venueName"];
        self.roomDate       = [dictionary safeStringForKey:@"date"];
        self.openPeriod     = [dictionary safeStringForKey:@"openPeriod"];
        self.tUserName      = [dictionary safeStringForKey:@"tuserName"];
        self.orderName      = [dictionary safeStringForKey:@"orderName"];
        self.orderTel       = [dictionary safeStringForKey:@"orderTel"];
        self.userType       = [dictionary safeIntegerForKey:@"userType"];
        self.tUserIsDisplay = [dictionary safeIntegerForKey:@"tuserIsDisplay"];
    }
    return self;
}

@end
