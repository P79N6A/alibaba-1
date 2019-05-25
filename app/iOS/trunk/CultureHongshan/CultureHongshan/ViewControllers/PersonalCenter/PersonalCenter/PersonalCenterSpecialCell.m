//
//  PersonalCenterSpecialCell.m
//  CultureHongshan
//
//  Created by ct on 16/5/26.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "PersonalCenterSpecialCell.h"


@implementation PersonalCenterSpecialCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        NSArray *imageNames =  @[@"icon_订单",@"icon_收藏",@"icon_评论"];
        NSArray *titles = @[@"我的订单",@"我的收藏",@"我的评论"];
        
        CGFloat btnWidth = kScreenWidth*1.0/imageNames.count;
        CGFloat btnHeight = 85;
        for (int i = 0; i < imageNames.count; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*btnWidth, 0, btnWidth, btnHeight)];
            button.titleLabel.font = FontYT(15);
            [button setImage:IMG(imageNames[i]) forState:UIControlStateNormal];
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIToolClass colorFromHex:@"262626"] forState:UIControlStateNormal];
            button.tag = i+1;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            
            CGFloat textWidth = [UIToolClass textWidth:button.titleLabel.text font:button.titleLabel.font];
            CGFloat imgWidth = button.imageView.image.size.width;
            CGFloat titleOffsetY = (button.height-[UIToolClass fontHeight:button.titleLabel.font])*0.5-15;
            CGFloat imgOffsetY = -14;
            
            button.titleEdgeInsets = UIEdgeInsetsMake(titleOffsetY, -imgWidth, -titleOffsetY, 0);
            button.imageEdgeInsets = UIEdgeInsetsMake(imgOffsetY, 0, -imgOffsetY, -textWidth);
            
            if (i < imageNames.count-1) {
                MYMaskView *line = [MYMaskView maskViewWithImage:IMG(@"sh_icon_filter_line") frame:CGRectMake(button.width-1, 8, 1, button.height-2*8) radius:0];
                [button addSubview:line];
            }
        }
    }
    return self;
}

- (void)buttonClick:(UIButton *)sender
{
    if (_block) {
        self.block(sender,sender.tag-1,NO);
    }
}


@end
