//
//  ActivityDetailTitleCell.m
//  CultureHongshan
//
//  Created by ct on 16/1/25.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "ActivityDetailTitleCell.h"

@implementation ActivityDetailTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        
        self.titleLable = [UILabel new];
        _titleLable.numberOfLines = 0;
        _titleLable.lineBreakMode = NSLineBreakByCharWrapping;
        _titleLable.textColor = kDeepLabelColor;
        _titleLable.font = FONT(18);
        [self.contentView addSubview:_titleLable];
    }
    return self;
}


- (void)setActivityName:(NSString *)activityName
{
    if (!activityName) {
        return;
    }
    if (_activityName)
    {
        _activityName = nil;
    }
    
    if (activityName.length)
    {
        _activityName = activityName;

        _titleLable.attributedText = [UIToolClass boldString:_activityName font:FontYT(18)];
        _titleLable.frame = CGRectMake(10, 16, kScreenWidth-20, [UIToolClass attributedTextHeight:_titleLable.attributedText width:kScreenWidth-20]);
    }
}


@end
