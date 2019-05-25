//
//  UIResponder+FirstResponder.m
//  CommonTestProject
//
//  Created by ct on 16/12/22.
//  Copyright © 2016年 Andney. All rights reserved.
//

#import "UIResponder+FirstResponder.h"

static __weak id  firstResponder;

@implementation UIResponder (FirstResponder)

+ (id)currentFirstResponder; {
    firstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder) to:nil from:nil forEvent:nil];
    return firstResponder;
}

- (void)findFirstResponder {
    firstResponder = self;
}

@end
