//
//  Registration TableViewCell.m
//  CultureHongshan
//
//  Created by xiao on 15/12/8.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "RegistrationTableViewCell.h"


@implementation RegistrationTableViewCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.headerImage.radius = 8;
        
        
        CGFloat cellHeight = 60;
        UIColor *blackColor = [UIColor colorWithRed:2/255.0 green:40/255.0 blue:85/255.0 alpha:1];
        
        //头像
        _headerImage = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
        _headerImage.userInteractionEnabled = NO;
        _headerImage.radius = 5;
        [self.contentView addSubview:_headerImage];
        
        //年龄和性别
        CGFloat textWidth = [UIToolClass textWidth:@"男" font:FontYT(15)];
        _ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-textWidth-40, 0, textWidth, cellHeight)];
        _ageLabel.textAlignment = NSTextAlignmentRight;
        _ageLabel.font = FontYT(15);
        _ageLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
        [self.contentView addSubview:_ageLabel];
        
        //昵称
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImage.frame)+8, 0, CGRectGetMinX(_ageLabel.frame)-8-CGRectGetMaxX(_headerImage.frame)-18, cellHeight)];
        _nameLabel.textColor = blackColor;
        _nameLabel.font = FontYT(15);
        [self.contentView addSubview:_nameLabel];
        
        //分割线
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight-1, kScreenWidth, 1)];
        _lineView.backgroundColor = [UIColor colorWithRed:198/255.0 green:225/255.0 blue:242/255.0 alpha:1];
        [self.contentView addSubview:_lineView];
    }
    return self;
}



@end
