//
//  ExtendedStructClass.m
//  ToolProject
//
//  Created by ct on 16/3/16.
//  Copyright © 2016年 ct. All rights reserved.
//

#import "ExtendedStructClass.h"

//按钮的扩展结构体
ButtonIndex ButtonIndexMake(NSInteger row, NSInteger tag)
{
    return (ButtonIndex){row,tag};
}


