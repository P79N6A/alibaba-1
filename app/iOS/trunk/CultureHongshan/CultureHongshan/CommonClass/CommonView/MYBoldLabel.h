//
//  MYBoldLabel.h
//  CultureHongshan
//
//  Created by ct on 16/8/26.
//  Copyright © 2016年 ct. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 显示粗体字体的Label(在设置text属性前，请设置好其它的相关属性)
 */
@interface MYBoldLabel : UILabel


/**
 该属性可以不设置，默认值为4
 */
@property (nonatomic, assign) CGFloat spacingOfLine; // 变量名为lineSpacing时，不知道为何会导致文本显示不出来
/**
 *  是否为自动布局【如果是自动布局，需要在设置显示内容前，设置这个属性】
 */
@property (nonatomic, assign) BOOL isAutoLayout;

@end
