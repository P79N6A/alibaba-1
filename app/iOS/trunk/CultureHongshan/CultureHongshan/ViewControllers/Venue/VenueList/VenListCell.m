//
//  VenListCell.m
//  CultureHongshan
//
//  Created by ct on 17/3/20.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "VenListCell.h"
#import "VenueModel.h"


@interface VenListCell ()

@property (nonatomic, strong) UIImageView *picView; // 封面图
@property (nonatomic, strong) UIView *containerView; // 容器视图
@property (nonatomic, strong) MYSmartLabel *titleLabel; // 标题
@property (nonatomic, strong) MYSmartLabel *subTitleLabel; // 子标题

@property (nonatomic, strong) MYSmartLabel *actCountLabel; // 在线活动数
@property (nonatomic, strong) MYSmartLabel *venueCountLabel; // 在线活动室数

@end


@implementation VenListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = kBgColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.picView = [UIImageView new];
        [self.contentView addSubview:self.picView];
        
        MYMaskView *maskView = [MYMaskView maskViewWithBgColor:[UIColor colorWithWhite:0 alpha:0.4] frame:CGRectZero radius:0];
        [self.contentView addSubview:maskView];
        
        self.containerView = [MYMaskView maskViewWithBgColor:[UIColor clearColor] frame:CGRectZero radius:0];
        [self.picView addSubview:self.containerView];
        
        self.titleLabel = [MYSmartLabel al_labelWithMaxRow:2 text:nil font:FontYTBold(18) color:kWhiteColor lineSpacing:4 align:NSTextAlignmentCenter breakMode:NSLineBreakByTruncatingTail];
        [self.containerView addSubview:self.titleLabel];
        
        MYMaskView *line = [MYMaskView maskViewWithBgColor:kWhiteColor frame:CGRectZero radius:0];
        [self.containerView addSubview:line];
        
        UIImageView *locationIconView = [[UIImageView alloc] initWithImage:IMG(@"sh_icon_location_white")];
        [self.containerView addSubview:locationIconView];
        
        self.subTitleLabel = [MYSmartLabel al_labelWithMaxRow:1 text:nil font:FontYT(14) color:kWhiteColor lineSpacing:0 align:NSTextAlignmentCenter breakMode:NSLineBreakByTruncatingTail];
        [self.containerView addSubview:self.subTitleLabel];
        
        self.actCountLabel = [MYSmartLabel al_labelWithMaxRow:1 text:nil font:FontYT(14) color:kWhiteColor lineSpacing:0 align:NSTextAlignmentCenter breakMode:NSLineBreakByTruncatingTail];
        self.actCountLabel.radius = 4;
        self.actCountLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self.containerView addSubview:self.actCountLabel];
        
        self.venueCountLabel = [MYSmartLabel al_labelWithMaxRow:1 text:nil font:FontYT(14) color:kWhiteColor lineSpacing:0 align:NSTextAlignmentCenter breakMode:NSLineBreakByTruncatingTail];
        self.venueCountLabel.radius = self.actCountLabel.radius;
        self.venueCountLabel.backgroundColor = self.actCountLabel.backgroundColor;
        [self.containerView addSubview:self.venueCountLabel];
        
        
        WS(weakSelf)
        [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.top.equalTo(weakSelf.contentView);
            make.height.equalTo(weakSelf.picView.mas_width).multipliedBy(kPicScale_ListCover);
        }];
        
        [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.picView);
        }];
        
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.and.centerY.equalTo(weakSelf.picView);
            make.width.equalTo(weakSelf.picView).offset(-40);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.top.equalTo(weakSelf.containerView);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(6);
            make.width.equalTo(weakSelf.contentView).multipliedBy(0.63);
            make.centerX.equalTo(weakSelf.containerView);
            make.height.mas_equalTo(0.8);
        }];
        
        [locationIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.subTitleLabel.mas_left).offset(3);
            make.size.mas_equalTo(CGSizeMake(11, 15));
        }];
    }
    return self;
}

- (void)setModel:(VenueModel *)model forIndexPath:(NSIndexPath *)indexPath {
    
    
    
}

- (UIImageView *)getImageView {
    return self.picView;
}


@end
