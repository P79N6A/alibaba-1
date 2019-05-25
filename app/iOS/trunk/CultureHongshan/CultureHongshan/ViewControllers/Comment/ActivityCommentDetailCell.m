//
//  ActivityCommentDetailCell.m
//  CultureHongshan
//
//  Created by ct on 16/3/31.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "ActivityCommentDetailCell.h"

#import "CommentModel.h"//评论的Model类

#import "UIButton+WebCache.h"

#import "HZPhotoBrowser.h"


@interface ActivityCommentDetailCell ()<HZPhotoBrowserDelegate>
{
    //用户头像
    UIButton *_headerButton;
    
    //用户昵称
    UILabel *_nameLabel;
    
    //评论时间
    UILabel *_dateLabel;
    
    //评论内容
    UILabel *_contentLabel;
    //单元格底部的分割线
    UIView *_lineView;
    
}

@property (nonatomic, strong) CommentModel *model;


@end




@implementation ActivityCommentDetailCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        
        //用户头像
        _headerButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 18, 32, 32)];
        _headerButton.radius = 5;
        _headerButton.userInteractionEnabled = NO;
        [self.contentView addSubview:_headerButton];
        
        //昵称
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerButton.maxX+10, _headerButton.originalY, kScreenWidth - (_headerButton.maxX+10+10), [UIToolClass fontHeight:FONT(14)])];
        _nameLabel.font = FONT(14);
        _nameLabel.textColor = ColorFromHex(@"999999");
        [self.contentView addSubview:_nameLabel];
        
        //日期
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.originalX, _nameLabel.maxY+8, _nameLabel.width, [UIToolClass fontHeight:FONT(12)])];
        _dateLabel.font = FONT(12);
        _dateLabel.textColor = ColorFromHex(@"999999");
        [self.contentView addSubview:_dateLabel];
        
        //评论内容
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.originalX, _dateLabel.maxY+10, _nameLabel.width, 0)];
        _contentLabel.font = FONT(14);
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _contentLabel.textColor = kDeepLabelColor;
        [self.contentView addSubview:_contentLabel];
        
        //图片的容器视图
        _imageContainerView = [[UIView alloc] initWithFrame:CGRectMake(_contentLabel.originalX, 0, _contentLabel.width, 0)];
        [self.contentView addSubview:_imageContainerView];
        
        //单元格底部的分割线
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(_contentLabel.originalX-4, 0, kScreenWidth-_contentLabel.originalX+4, 0.7)];
        _lineView.backgroundColor = ColorFromHex(@"DFDFDF");
        [self.contentView addSubview:_lineView];
    }
    
    return self;
}



- (void)setCommmentModel:(CommentModel *)model forIndexPath:(NSIndexPath *)indexPath
{
    if (!model)
    {
        return;
    }
    if (_model)
    {
        _model = nil;
        //移除之前的图片
        [_imageContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    _model = model;
    
    //用户头像
    [_headerButton sd_setImageWithURL:[NSURL URLWithString:[ToolClass getSmallHeaderImgUrl:_model.userHeadImgUrl]] forState:UIControlStateNormal placeholderImage:IMG(@"sh_user_header_icon") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         //下载缩略图失败后，下载原图
         if (error || CGSizeEqualToSize(image.size, CGSizeZero) == YES)
         {
             [_headerButton sd_setImageWithURL:[NSURL URLWithString:_model.userHeadImgUrl] forState:UIControlStateNormal placeholderImage:IMG(@"sh_user_header_icon")];
         }
     }];
    
    _nameLabel.text = _model.commentUserNickName.length ?  _model.commentUserNickName : @"匿名用户";
    _dateLabel.text = _model.commentTime;
    
    //评论内容
    _contentLabel.attributedText = [UIToolClass getAttributedStr:_model.commentRemark font:FONT(14) lineSpacing:4];
    _contentLabel.height = [UIToolClass attributedTextHeight:_contentLabel.attributedText width:_contentLabel.width];
    if (_contentLabel.height < 1) {
        _imageContainerView.originalY = _contentLabel.originalY;
    }else{
        _imageContainerView.originalY = _contentLabel.maxY+12.5;
    }
    
    CGFloat btnSpacingX = 10;
    CGFloat btnSpacingY = 10;
    CGFloat btnWidth = (_contentLabel.width - 2*btnSpacingX)/3.0;
    CGFloat btnHeight = btnWidth;

    UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:CGSizeMake(btnWidth, btnHeight) centerSize:CGSizeMake(20, 20) isBorder:NO];
    CGFloat height = 0;
    for (int i = 0; i < _model.imageOrUrlStrArray.count && i < 9; i++)
    {
        id imgOrImgUrl = _model.imageOrUrlStrArray[i];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i%3*(btnWidth+btnSpacingX), i/3*(btnHeight+btnSpacingY), btnWidth, btnHeight)];
        button.tag = 1 + i;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(imgButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_imageContainerView addSubview:button];
        
        if ([imgOrImgUrl isKindOfClass:[NSString class]]) {
            [button sd_setImageWithURL:[NSURL URLWithString:JointedImageURL(imgOrImgUrl, @"_150_150")] forState:UIControlStateNormal placeholderImage:placeImg];
        }else{
            [button setImage:imgOrImgUrl forState:UIControlStateNormal];
        }
        
        height = button.maxY;
    }
    
    //设置图片容器的高度
    _imageContainerView.height = height;
    
    _lineView.originalY = (_model.imageOrUrlStrArray.count) ? _imageContainerView.maxY + 19.3 : _contentLabel.maxY+19.3;
}


- (void)setLineViewHidden:(BOOL)isHidden {
    _lineView.hidden = isHidden;
}


- (void)imgButtonClick:(UIButton *)sender
{
    // 启动图片浏览器
    HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
    browserVc.sourceImagesContainerView = sender.superview; // 原图的父控件
    browserVc.imageCount = MIN(_model.imageOrUrlStrArray.count, 9); // 图片总数
    browserVc.currentImageIndex = (int)sender.tag - 1;
    browserVc.delegate = self;
    [browserVc show];
}


#pragma mark - HZPhotoBrowserDelegate

- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIButton *imgButton = _imageContainerView.subviews[index];
    return imgButton.currentImage;
}

- (id)photoBrowser:(HZPhotoBrowser *)browser highQualityImageOrImageURLForIndex:(NSInteger)index
{
    id imageOrUrlStr = _model.imageOrUrlStrArray[index];
    return imageOrUrlStr;
}

@end
