//
//  ActivityTicketModel.m
//  ActivityBookJieXiTest
//
//  Created by ct on 16/5/3.
//  Copyright © 2016年 ct. All rights reserved.
//

#import "ActivityTicketModel.h"

@implementation ActivityTicketModel


- (NSInteger)type
{
    if (_date.length && _endDate.length) {
        if ([_date isEqualToString:_endDate]) {
            return 0;
        }else{
            return 1;
        }
    }else if (_date.length && _endDate.length < 1){
        return 0;
    }else{
        return -1;
    }
}

@end
