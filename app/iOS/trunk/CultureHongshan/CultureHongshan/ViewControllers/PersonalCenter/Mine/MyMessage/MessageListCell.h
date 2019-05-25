//
//  MessageListCell.h
//  CultureHongshan
//
//  Created by JackAndney on 16/4/24.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserMessage;

@interface MessageListCell : UITableViewCell


- (void)setModel:(UserMessage *)model forIndexPath:(NSIndexPath *)indexPath;


@end
