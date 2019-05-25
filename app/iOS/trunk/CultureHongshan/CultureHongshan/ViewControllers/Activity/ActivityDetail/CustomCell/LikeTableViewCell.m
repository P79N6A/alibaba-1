//
//  LikeTableViewCell.m
//  TableVIewCellTest
//
//  Created by JackAndney on 16/4/18.
//  Copyright © 2016年 Andney. All rights reserved.
//

#import "LikeTableViewCell.h"

#import "Registration.h"

#import "UIImageView+WebCache.h"

@interface LikeTableViewCell ()
{
    UILabel *_titleLabel;
}

@end

@implementation LikeTableViewCell

//height = 12.5+fontHeightWithfontNumber(17)+10
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat fontHeight = [UIToolClass fontHeight:FONT(14)] ; //
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12.5, kScreenWidth-20, fontHeight)];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)setLikeCount:(NSInteger)likeCount scanCount:(NSInteger)scanCount
{
    NSString *titleStr = scanCount > 49 ? [NSString stringWithFormat:@"共 %ld 人赞过，%ld 人浏览",(long)(long)likeCount,(long)(long)scanCount] : [NSString stringWithFormat:@"共 %ld 人赞过",(long)(long)likeCount];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleStr attributes:@{NSFontAttributeName:FONT(14), NSForegroundColorAttributeName:kDeepLabelColor}];
    // 给所有的数字添加指定的颜色
    for (NSValue *rangeValue in [ToolClass getDigitalNumberRanges:titleStr]) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:kDarkRedColor range:rangeValue.rangeValue];
    }

    _titleLabel.attributedText = attributedString;
}



- (void)setModelArray:(NSArray *)modelArray
{
    for (UIView *view in self.contentView.subviews) {
        if (![view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (modelArray.count)
    {
        CGFloat edge = 10;
        CGFloat btnWidth = 32;
        CGFloat btnSpacing = [ToolClass getElementSpacingWithMinSpacing:4 elementWidth:btnWidth containerWidth:kScreenWidth-2*edge elementNum:nil];
        CGFloat offsetX = edge;
        CGFloat offsetY = 10+_titleLabel.maxY;
        
        UIImage *image = IMG(@"sh_user_header_icon");
        
        for (int i = 0; i < modelArray.count; i++)
        {
            Registration *model = modelArray[i];
            
            if (offsetX + btnWidth < kScreenWidth - edge + 2) {
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(offsetX, offsetY, btnWidth, btnWidth)];
                imgView.radius = 4;
                [self.contentView addSubview:imgView];
                
                [imgView sd_setImageWithURL:[NSURL URLWithString:[ToolClass getSmallHeaderImgUrl:model.userHeadImgUrl]] placeholderImage:image];
                
                offsetX += btnWidth + btnSpacing;
            }else{
                break;
            }
        }
    }
}


@end
