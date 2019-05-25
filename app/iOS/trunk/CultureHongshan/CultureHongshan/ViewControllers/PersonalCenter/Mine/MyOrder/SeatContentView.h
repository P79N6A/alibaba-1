//
//  SeatContentView.h
//  CultureHongshan
//
//  Created by ct on 17/2/24.
//  Copyright © 2017年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 
 座位号显示视图
 
 @discussion 注意：不要约束视图的高度
 */
@interface SeatContentView : UIView

- (instancetype)initWithFrame:(CGRect)frame seatArray:(NSArray<NSString *> *)seatArray font:(UIFont *)font tColor:(UIColor *)tColor;

@end
