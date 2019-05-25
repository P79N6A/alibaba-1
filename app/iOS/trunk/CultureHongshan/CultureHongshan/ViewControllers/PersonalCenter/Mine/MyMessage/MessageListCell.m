//
//  MessageListCell.m
//  CultureHongshan
//
//  Created by JackAndney on 16/4/24.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "MessageListCell.h"
#import "UserMessage.h"

@interface MessageListCell ()

@property (nonatomic, strong) UIImageView *imgView;//图标
@property (nonatomic, strong) UILabel *titleLabel;//消息的标题
@property (nonatomic, strong) UILabel *contentLabel;//消息内容

@end



@implementation MessageListCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        _imgView.radius = _imgView.height*0.5;
        _imgView.layer.masksToBounds = 1;
        _imgView.image = IMG(@"活动通知");
        [self.contentView addSubview:_imgView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imgView.maxX + 10, _imgView.originalY, kScreenWidth-10-_imgView.maxX-10, _imgView.height)];
        _titleLabel.font = FontSystem(17);
        _titleLabel.textColor = kDeepLabelColor;
        [self.contentView addSubview:_titleLabel];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imgView.originalX, _imgView.maxY+10, kScreenWidth-20, 0)];
        _contentLabel.font = FontSystem(14);
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = kLightLabelColor;
        [self.contentView addSubview:_contentLabel];
    }
    return self;
}



- (void)setModel:(UserMessage *)model forIndexPath:(NSIndexPath *)indexPath
{
    if (model) {
        _titleLabel.text = model.messageType;
        _contentLabel.text = model.messageContent;
        _contentLabel.height = [UIToolClass textHeight:_contentLabel.text font:_contentLabel.font width:_contentLabel.width maxRow:4];
    }
}

@end
