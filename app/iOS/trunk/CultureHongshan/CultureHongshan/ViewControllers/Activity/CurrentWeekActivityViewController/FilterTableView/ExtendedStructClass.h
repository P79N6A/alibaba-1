//
//  ExtendedStructClass.h
//  ToolProject
//
//  Created by ct on 16/3/16.
//  Copyright © 2016年 ct. All rights reserved.
//

#import <Foundation/Foundation.h>


/*  ————————  按钮Button的扩展结构体  ——————————  */

//定义一个Button的结构体
typedef struct ButtonIndex
{
    NSInteger row;//记录按钮所在的行号
    NSInteger tag;//记录按钮的tag
} ButtonIndex;

//生成Button索引的方法
ButtonIndex ButtonIndexMake(NSInteger row, NSInteger tag);





