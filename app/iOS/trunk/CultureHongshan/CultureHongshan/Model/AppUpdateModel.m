//
//  AppUpdateModel.m
//  CultureHongshan
//
//  Created by ct on 16/4/28.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "AppUpdateModel.h"

@implementation AppUpdateModel

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        if (!attributes || ![attributes isKindOfClass:[NSDictionary class]] || attributes.count == 0) {
            return nil;
        }
        
        self.updateType        = [attributes safeIntForKey:@"updateType"];
        self.updateVersion     = [attributes safeStringForKey:@"updateVersion"];
        self.updateDescription = [attributes safeStringForKey:@"updateDescription"];
        self.updateLink        = [attributes safeStringForKey:@"updateLink"];
    }
    return self;
}


- (BOOL)forceUpdate {
    if (self.updateType==2) {
        return YES;
    }else {
        return NO;
    }
}

@end
