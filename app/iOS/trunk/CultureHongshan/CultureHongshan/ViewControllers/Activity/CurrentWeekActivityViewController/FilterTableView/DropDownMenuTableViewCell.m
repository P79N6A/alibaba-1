//
//  DropDownMenuTableViewCell.m
//  FSDropDownMenu
//
//  Created by ct on 16/3/11.
//  Copyright © 2016年 chx. All rights reserved.
//

#import "DropDownMenuTableViewCell.h"

@implementation DropDownMenuTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //标题
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FONT(17);
        _titleLabel.numberOfLines = 1;
        [self.contentView addSubview:_titleLabel];
        
        //分割线
        self.lineView = [[UIView alloc] init];
        _lineView.backgroundColor = ColorFromHex(@"E2E2E2");
        [self.contentView addSubview:_lineView];
    }
    return self;
}


@end
