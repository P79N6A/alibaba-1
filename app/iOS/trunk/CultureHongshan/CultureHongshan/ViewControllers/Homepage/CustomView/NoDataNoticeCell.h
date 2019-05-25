//
//  NoDataNoticeCell.h
//  CultureHongshan
//
//  Created by ct on 16/8/5.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoDataNoticeCell : UITableViewCell

- (void)setPromptStyle:(NoDataPromptStyle)style message:(NSString *)msg actionHandler:(void(^)())handler;

@end
