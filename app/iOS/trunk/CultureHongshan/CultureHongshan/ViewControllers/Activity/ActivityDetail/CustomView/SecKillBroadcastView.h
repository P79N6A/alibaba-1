//
//  SecKillBroadcastView.h
//  CultureHongshan
//
//  Created by ct on 16/5/31.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecKillBroadcastView : UIView


- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title//秒杀播报
             notice:(NSString *)notice//积分提醒等
         modelArray:(NSArray *)modelArray;//秒杀的Model

@end
