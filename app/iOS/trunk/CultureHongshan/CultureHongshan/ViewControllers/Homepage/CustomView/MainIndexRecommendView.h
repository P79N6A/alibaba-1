//
//  MainIndexRecommendView.h
//  CultureHongshan
//
//  Created by ct on 16/7/25.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainIndexRecommendView : UIView
@property (nonatomic, assign) CGFloat contentOffsetX;

- (instancetype)initWithFrame:(CGRect)frame
                  modelArray:(NSArray *)modelArray
               callBackBlock:(AdvertBlock)block;



@end
