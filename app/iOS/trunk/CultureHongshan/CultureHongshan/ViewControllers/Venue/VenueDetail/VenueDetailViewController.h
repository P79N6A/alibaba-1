//
//  VenueDetailViewController.h
//  CultureHongshan
//
//  Created by one on 15/11/6.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "BasicViewController.h"

/**
 *  场馆详情页面
 */
@interface VenueDetailViewController : BasicViewController

@property (nonatomic, strong) NSString *venueId;//场馆id
@property (nonatomic, copy  ) NSArray<UIImage *> *screenshotImages; // 前一个页面的截屏
@property (nonatomic ,copy  ) void (^collectRefreshBlock)();


@end
