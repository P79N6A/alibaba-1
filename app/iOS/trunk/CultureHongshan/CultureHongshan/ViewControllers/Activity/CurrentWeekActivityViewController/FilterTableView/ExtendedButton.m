//
//  ExtendedButton.m
//  ToolProject
//
//  Created by ct on 16/3/16.
//  Copyright © 2016年 ct. All rights reserved.
//

#import "ExtendedButton.h"

@implementation ExtendedButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


- (void)touchAction:(ExtendedButton *)button
{
    if (_actionBlock)
    {
        _actionBlock(button);
    }
}



@end
