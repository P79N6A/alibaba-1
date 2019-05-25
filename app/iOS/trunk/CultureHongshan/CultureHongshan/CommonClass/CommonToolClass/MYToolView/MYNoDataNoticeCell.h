//
//  MYNoDataNoticeCell.h
//  CheckTicketSystem
//
//  Created by JackAndney on 2017/11/9.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYNoDataNoticeCell : UITableViewCell

@property (nonatomic, copy) NSIndexPath *my_indexPath;
@property (nonatomic, copy) void (^didClickBlock)(MYNoDataNoticeCell *cell);

- (void)showActionButton:(BOOL)show forIndexPath:(NSIndexPath *)indexPath;
- (void)updateActionButtonTitle:(NSString *)title;

// 设置图片和文字
- (void)setImage:(UIImage *)image andMsg:(NSString *)msg;


@end

