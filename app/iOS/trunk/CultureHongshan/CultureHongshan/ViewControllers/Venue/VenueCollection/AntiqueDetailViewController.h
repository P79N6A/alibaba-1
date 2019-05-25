//
//  AntiqueDetailViewController.h
//  CultureHongshan
//
//  Created by one on 15/11/23.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "BasicViewController.h"

/**
 *  藏品详情:含WebView和音频播放
 */
@interface AntiqueDetailViewController : BasicViewController

@property (nonatomic, copy)NSString *antiqueId;

-(void)setSlideValue:(CGFloat)value;

@end
