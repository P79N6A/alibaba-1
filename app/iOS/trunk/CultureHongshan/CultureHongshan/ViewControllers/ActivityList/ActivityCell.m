//
//  ActivityCell.m
//  TableViewTest
//
//  Created by ct on 16/4/8.
//  Copyright © 2016年 ct. All rights reserved.
//

#import "ActivityCell.h"

#import "ActivityModel.h"



@interface ActivityCell ()
{
    //图片
    UIImageView *_picView;
    
    //左上角的类型图标
    UIImageView *_typeView;
    
    // 收藏按钮
    MYSmartButton *_collectButton;
    
    //价格
    UILabel *_priceLabel;
    
    //标签容器视图
    UIView *_tagContainerView;
    
    //标题
    UILabel *_titleLabel;
    
    //子标题
    UILabel * _subTitleLabel;
    
    //距离
    MYMaskView *_distanceView;
}
@property (nonatomic, strong) UILabel *participateWayAndDateView; // 参与方式与日期视图
@property (nonatomic, copy) void (^actionHandler)(UIButton *sender, NSInteger index);
@end




@implementation ActivityCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        // cellHeight = kScreenWidth*kPicScale_ListCover + 76
        
        //图片
        _picView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*kPicScale_ListCover)];
        _picView.userInteractionEnabled = YES;
        _picView.clipsToBounds = YES;
        [self.contentView addSubview:_picView];
        
        //“订、秒”标签
        _typeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
        [_picView addSubview:_typeView];
        
        // 收藏按钮
        _collectButton = [[MYSmartButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50) image:IMG(@"icon_gather_collect_normal") selectedImage:IMG(@"icon_gather_collect_selected") actionBlock:^(MYSmartButton *sender) {
            if (self.actionHandler) {
                self.actionHandler(sender, 1);
            }
        }];
        _collectButton.center = CGPointMake(_picView.width-27, 27);
        _collectButton.hidden = YES;
        [_picView addSubview:_collectButton];
        
        
        //标签容器视图
        _tagContainerView = [[UIView alloc] initWithFrame:CGRectMake(10, _picView.height-10-18, 0, 18)];
        [_picView addSubview:_tagContainerView];
        
        //价格
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _picView.height-8.5-28, 0, 28)];
        _priceLabel.textColor = [UIColor whiteColor];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.backgroundColor = kThemeDeepColor;
        _priceLabel.radius = 4;
        _priceLabel.layer.borderColor = ColorFromHex(@"434856").CGColor;
        _priceLabel.layer.borderWidth = 0.8;
        [_picView addSubview:_priceLabel];
        
        //标题
        CGFloat fontHeight = [UIToolClass fontHeight:FontYT(18)];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _picView.maxY+13, kScreenWidth-20, fontHeight)];
        _titleLabel.font = FontYT(18);
        _titleLabel.textColor = kDeepLabelColor;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_titleLabel];
        
        //子标题
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.originalX, _titleLabel.maxY+10, _titleLabel.width, [UIToolClass fontHeight:FontYT(14)])];
        _subTitleLabel.font = FontYT(14);
        _subTitleLabel.textColor = kLightLabelColor;
        _subTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_subTitleLabel];
        
        //距离
        _distanceView = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(0, _subTitleLabel.maxY-20, 0, 20) radius:4];
        _distanceView.layer.borderColor = kLightLabelColor.CGColor;
        _distanceView.layer.borderWidth = 0.6;
        [self.contentView addSubview:_distanceView];
        
        MYMaskView *bottomMaskView = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(0, _picView.height+76-6, kScreenWidth, 6) radius:0];
        [self.contentView addSubview:bottomMaskView];
        
        MYMaskView *lineView = [MYMaskView maskViewWithBgColor:RGB(236, 236, 236) frame:CGRectMake(0, 0, kScreenWidth, 0.8) radius:0];
        [bottomMaskView addSubview:lineView];
    }
    return self;
}


- (UIView *)participateWayAndDateView {
    if (!_participateWayAndDateView) {
        _participateWayAndDateView = [MYSmartLabel al_labelWithMaxRow:1 text:@"" font:FONT(13) color:kWhiteColor lineSpacing:0 align:NSTextAlignmentCenter breakMode:NSLineBreakByTruncatingTail];
        _participateWayAndDateView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        _participateWayAndDateView.radius = 6;
        [_picView addSubview:_participateWayAndDateView];
        
        [_participateWayAndDateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_picView).offset(12);
            make.top.equalTo(_picView).offset(10);
            make.height.mas_equalTo(25);
            make.left.lessThanOrEqualTo(_collectButton.mas_left).offset(-10).priorityHigh();
        }];
    }
    return _participateWayAndDateView;
}

- (UIImageView *)getHeadImage
{
    return _picView;
}

- (void)setModel:(ActivityModel *)model type:(NSInteger)type forIndexPath:(NSIndexPath *)indexPath
{
    if (!model || model.showedPrice == nil) {
        return;
    }
    
    //图片
    UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:_picView.viewSize centerSize:CGSizeMake(30, 30) isBorder:NO];
    [_picView sd_setImageWithURL:[NSURL URLWithString:JointedImageURL(model.activityIconUrl,kImageSize_750_500)] placeholderImage:placeImg];
    
    if (_collectButton) {
        _collectButton.selected = model.activityIsCollect;
    }
    
    //活动类型
    if (model.activityIsReservation) {
        if (model.activityIsSecKill) {
            _typeView.image = IMG(@"icon_秒");
        }else {
            _typeView.image = IMG(@"icon_订");
        }
    }else {
        _typeView.image = nil;
    }
    
    //价格 或 已订完
    if (model.activityAbleCount == 0 && model.activityIsReservation && model.activityIsPast==NO) {
        _priceLabel.attributedText = [[NSAttributedString alloc] initWithString:@"已订完" attributes:@{NSFontAttributeName:FontYT(13.5), NSForegroundColorAttributeName:[UIColor whiteColor]}];
        _priceLabel.backgroundColor = RGBA(0x26, 0x26, 0x26, 0.7);
        _priceLabel.layer.borderColor = [UIColor blackColor].CGColor;
    }else {
        NSString *priceStr = model.showedPrice;
        NSInteger littleFontLength = 0;//字符串最后的小字体文本的长度
        UIFont *bigFont = FontYT(15);
        if ([priceStr containsSubString:@"元/"]) {
            littleFontLength = 3;
            bigFont = FontYT(17);
        }else if ([priceStr hasSuffix:@"元起"]) {
            littleFontLength = 2;
            bigFont = FontYT(17);
        }
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:priceStr];
        [attributedString addAttributes:@{NSFontAttributeName:bigFont, NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, priceStr.length- littleFontLength)];
        [attributedString addAttributes:@{NSFontAttributeName:FontYT(12), NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(priceStr.length- littleFontLength, littleFontLength)];
        _priceLabel.attributedText = attributedString;
        _priceLabel.backgroundColor = RGBA(0x4b, 0x70, 0xb7, 0.9f);
        _priceLabel.layer.borderColor = ColorFromHex(@"434856").CGColor;
    }
    
    _priceLabel.width = [UIToolClass attributedTextWidth:_priceLabel.attributedText]+30;

    _priceLabel.originalX = _picView.width + _priceLabel.radius - _priceLabel.width;

    //三个标签
    NSDictionary *layoutAttributes = @{MYShowOnlySingleLineAttributeName:@"YES",
                                       MYLabelPaddingAttributeName:@"12",
                                       MYItemHeightAttributeName:StrFromFloat(_tagContainerView.height),
                                       MYFontAttributeName:FontYT(12),
                                       MYSpacingXAttributeName:@"5",
                                       };
    NSDictionary *labelAttributes = @{kLabelTextColor:[UIColor whiteColor],
                                      kLabelBgColor:[UIColor colorWithWhite:0 alpha:0.6],
                                      kLabelBorderColor:[UIColor blackColor],
                                      kLabelBorderWidth:@"0.6",
                                      kLabelCornerRadius:@"4",
                                      };
    _tagContainerView.width = _priceLabel.originalX - 10 - _tagContainerView.originalX;
    
    [ToolClass addSubview:_tagContainerView titleArray:model.jointedTagArray attributes:layoutAttributes labelAttributes:labelAttributes clearSubviews:YES contentHeight:nil];
    
    //标题
    _titleLabel.text = model.activityName;
    
    //子标题
    if (type == 3) {
        _subTitleLabel.text = model.activityLocationName;
    }else {
        _subTitleLabel.text = [NSString stringWithFormat:@"%@ | %@",model.showedActivityDate,model.activityLocationName];
    }
    
    //距离
    _distanceView.hidden = type!=2;
    [_distanceView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (_distanceView.hidden == NO) {
        
        CGFloat textWidth = [UIToolClass textWidth:model.showedDistance font:FontYT(12)];
        
        UIImageView *locationView = [[UIImageView alloc] initWithImage:IMG(@"sh_icon_location_gray")];
        locationView.frame = CGRectMake(6, 0, 8.5, 9.5);
        [_distanceView addSubview:locationView];
        locationView.centerY = _distanceView.height*0.5;
        
        UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(locationView.maxX+3, 0, textWidth, _distanceView.height)];
        distanceLabel.text = model.showedDistance;
        distanceLabel.font = FontYT(12);
        distanceLabel.textColor = kLightLabelColor;
        [_distanceView addSubview:distanceLabel];
        
        _distanceView.width = distanceLabel.maxX+locationView.originalX;
        _distanceView.originalX = kScreenWidth-10-_distanceView.width;

        _subTitleLabel.width = _distanceView.originalX-10-_subTitleLabel.originalX;
    }else {
        _subTitleLabel.width = _titleLabel.maxX-_subTitleLabel.originalX;
    }
    
    
    if (type == 3 || type == 4) {
        _typeView.hidden = YES;
        self.participateWayAndDateView.hidden = NO;
        
        if (type == 3) {
            if (model.activityIsReserved == 1) {
                self.participateWayAndDateView.text = [NSString stringWithFormat:@"已预订 | %@",model.showedActivityDate];
            }else if (model.activityIsReserved == 3) {
                self.participateWayAndDateView.text = [NSString stringWithFormat:@"直接前往 | %@", model.showedActivityDate];
            }else {
                self.participateWayAndDateView.text = [NSString stringWithFormat:@"未预订 | %@", model.showedActivityDate];
            }
        }else {
            if (model.activityIsReserved == 1) {
                self.participateWayAndDateView.text = [NSString stringWithFormat:@"已预订 | %@",model.showedActivityDate];
            }else {
                self.participateWayAndDateView.text = [NSString stringWithFormat:@"未预订 | %@", model.showedActivityDate];
            }
        }
        
        CGFloat textWidth = [UIToolClass textWidth:self.participateWayAndDateView.text font:self.participateWayAndDateView.font] + 20;
        [self.participateWayAndDateView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(textWidth).priorityMedium();
        }];
    }else {
        _typeView.hidden = NO;
        _participateWayAndDateView.hidden = YES;
    }
}


- (void)setButtonActionHandler:(void(^)(UIButton *, NSInteger))handler {
    self.actionHandler = handler;
}

- (void)showCollectButton:(BOOL)show {
    _collectButton.hidden = !show;
}

- (void)hideTypeView:(BOOL)hidden {
    _typeView.hidden = hidden;
}


@end
