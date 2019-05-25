//
//  NoDataNoticeView.h
//  CultureHongshan
//
//  Created by JackAndney on 16/4/24.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NoDataNoticeView : UIView

+ (NoDataNoticeView *)noticeViewWithFrame:(CGRect)frame
                                  bgColor:(UIColor *)bgColor
                                  message:(NSString *)message
                              promptStyle:(NoDataPromptStyle)style
                            callbackBlock:(IndexBlock)block;

@end
