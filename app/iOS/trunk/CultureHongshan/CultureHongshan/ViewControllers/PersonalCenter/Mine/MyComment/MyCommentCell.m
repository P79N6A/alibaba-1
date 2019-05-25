//
//  MyCommentCell.m
//  CultureHongshan
//
//  Created by ct on 16/4/12.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "MyCommentCell.h"

#import "UIButton+WebCache.h"

#import "HZPhotoBrowser.h"


@interface MyCommentCell ()<HZPhotoBrowserDelegate>
{
    
    UIView *_bgView;
    
    //标题
    UILabel *_titleLabel;
    
    //地图小图标
    UIImageView *_locationImgView;
    
    //灰色背景视图
    UIView *_roundedView;
    
    //评论内容
    UILabel *_contentLabel;
    
    //地址标签
    UILabel *_addressLabel;
    
    //评论图片的容器视图
    UIView *_imageContainerView;
    
    //日期
    UILabel *_dateLabel;
}

@property (nonatomic, strong) MyCommentModel *model;


@end




@implementation MyCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        // 15+[UIToolClass fontHeight:FONT(17)]+10+[UIToolClass fontHeight:FONT(15)]+15+5+stringHeight(_contentLabel.width, 15, _contentLabel.text)+10   +10+10+[UIToolClass fontHeight:FONT(13)]+25+10
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = RGB(243, 243, 243);
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        //标题
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, kScreenWidth-20, [UIToolClass fontHeight:FONT(17)])];
        _titleLabel.font = FONT(17);
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_bgView addSubview:_titleLabel];
        
        //地图小图标
        _locationImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_titleLabel.originalX, 0, 10, 15)];
        _locationImgView.image = IMG(@"icon_地址");
        [_bgView addSubview:_locationImgView];
        
        //地址标签
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_locationImgView.maxX+5, _titleLabel.maxY + 10, _titleLabel.maxX-_locationImgView.maxX-5, [UIToolClass fontHeight:FONT(15)])];
        _addressLabel.textColor = [UIColor lightGrayColor];
        _addressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _addressLabel.font = FONT(15);
        [_bgView addSubview:_addressLabel];
        _locationImgView.centerY = _addressLabel.centerY;
        
        //圆角背景视图
        _roundedView = [[UIView alloc] initWithFrame:CGRectMake(_titleLabel.originalX, _addressLabel.maxY + 15, _titleLabel.width, 0)];
        _roundedView.radius = 6;
        _roundedView.backgroundColor = RGB(240, 240, 240);
        [_bgView addSubview:_roundedView];
        
        //评论内容
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, _roundedView.width-2*10, 0)];
        _contentLabel.font = FONT(15);
        _contentLabel.textColor = [UIColor grayColor];
        _contentLabel.numberOfLines = 0;
        [_roundedView addSubview:_contentLabel];
        
        //评论图片容器视图
        _imageContainerView = [[UIView alloc] initWithFrame:CGRectMake(_contentLabel.originalX, 0, _contentLabel.width, 0)];
        [_roundedView addSubview:_imageContainerView];
        
        //日期
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.originalX, 0, _titleLabel.width, [UIToolClass fontHeight:FONT(13)])];
        _dateLabel.font = FONT(13);
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.textColor = [UIColor lightGrayColor];
        [_bgView addSubview:_dateLabel];
    }
    
    return self;
}

- (void)setModel:(MyCommentModel *)model forIndexPath:(NSIndexPath *)indexPath topSpacing:(CGFloat)topSpacing
{
    if (!model)
    {
        return;
    }
    if (_model)
    {
        _model = nil;
    }
    _model = model;
    
    [_imageContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _bgView.originalY = topSpacing;//白色背景
    //是否显示地址
    if (_model.type == DataTypeActivity){
        _roundedView.originalY = _addressLabel.maxY + 15;
        _locationImgView.hidden = _addressLabel.hidden = NO;
    }else{
        _roundedView.originalY = _titleLabel.maxY + 15;
        _locationImgView.hidden = _addressLabel.hidden = YES;
    }
    
    _titleLabel.text = _model.titleStr;
    _addressLabel.text = _model.addressStr;
    _contentLabel.attributedText = [UIToolClass getAttributedStr:_model.contentStr font:_contentLabel.font lineSpacing:4];
    _dateLabel.text = _model.dateStr;
    
    _contentLabel.height = [UIToolClass textHeight:_model.contentStr lineSpacing:4 font:_contentLabel.font width:_contentLabel.width];
    //是否有评论内容
    _imageContainerView.originalY =  _contentLabel.height > 1  ? _contentLabel.maxY + 10 : _contentLabel.originalY;
    
    //有图片
    if (_model.imageUrlArray.count)
    {
        _imageContainerView.hidden = NO;
        
        CGFloat btnSpacingX = 10;
        CGFloat btnSpacingY = 15;
        CGFloat btnWidth = (_contentLabel.width - 2*btnSpacingX)/3.0;
        CGFloat btnHeight = btnWidth*0.667;
        
        UIImage *image = [UIToolClass getPlaceholderWithViewSize:CGSizeMake(btnWidth, btnHeight) centerSize:CGSizeMake(20, 20) isBorder:NO];
        
        CGFloat height = 0;
        for (int i = 0; i < _model.imageUrlArray.count; i++)
        {
            NSString *imgUrl = _model.imageUrlArray[i];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i%3*(btnWidth+btnSpacingX), i/3*(btnHeight+btnSpacingY), btnWidth, btnHeight)];
            button.tag = 1 + i;
            button.imageView.contentMode = UIViewContentModeScaleAspectFill;
            button.layer.masksToBounds = YES;
            [button sd_setImageWithURL:[NSURL URLWithString:JointedImageURL(imgUrl, @"_150_150")] forState:UIControlStateNormal placeholderImage:image];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_imageContainerView addSubview:button];
            
            height = button.maxY;
        }
        _imageContainerView.height = height;
        _roundedView.height = _imageContainerView.maxY+10;
    }
    else{//无图片
        _imageContainerView.hidden = YES;
        _roundedView.height = _contentLabel.maxY+10;
    }
    
    //无图片、无评论内容
    if (_contentLabel.text.length == 0 && _model.imageUrlArray.count == 0)
    {
        _roundedView.hidden = YES;
        _dateLabel.originalY = _addressLabel.maxY + 10;
    }
    else
    {
        _roundedView.hidden = NO;
        _dateLabel.originalY = _roundedView.maxY + 10;
    }

    _bgView.height = _dateLabel.maxY + 20;
}



- (void)buttonClick:(UIButton *)sender
{
    //启动图片浏览器
    HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
    browserVc.sourceImagesContainerView = sender.superview; // 原图的父控件
    browserVc.imageCount = _model.imageUrlArray.count; // 图片总数
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
    id imageOrUrlStr = _model.imageUrlArray[index];
    
    
    return imageOrUrlStr;
}


@end
