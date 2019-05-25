//
//  ExtendedButton.h
//  ToolProject
//
//  Created by ct on 16/3/16.
//  Copyright © 2016年 ct. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ExtendedStructClass.h"

@class ExtendedButton;


//按钮点击回调的block
typedef void(^ButtonClickBlock)(ExtendedButton *);


/*      ————————————————  ExtendedButton  ————————————————         */

@interface ExtendedButton : UIButton

@property (nonatomic, copy) ButtonClickBlock actionBlock;

@property (nonatomic, assign) ButtonIndex index;


@end
