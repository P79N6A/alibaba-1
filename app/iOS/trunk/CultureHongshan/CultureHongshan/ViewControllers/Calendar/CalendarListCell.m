//
//  CalendarListCell.m
//  CultureHongshan
//
//  Created by ct on 17/2/8.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "CalendarListCell.h"
#import "ActivityGatherModel.h"


#pragma mark - ———— CalendarListTextCell ————

@interface CalendarListTextCell ()
@property (nonatomic, strong) ActivityGatherModel *model;

@property (nonatomic, strong) UILabel *tagTypeLabel; // 类型标签：话剧歌剧
@property (nonatomic, strong) UILabel *titleLabel; // 标题
@property (nonatomic, strong) UIButton *collectButton; // 收藏按钮
@property (nonatomic, strong) UIView *listView;
@property (nonatomic, strong) MYMaskView *bottomLine;

@property (nonatomic, copy) void (^actionHandler)(UIButton *sender, NSInteger index);
@end



@implementation CalendarListTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = COLOR_IWHITE;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        WS(weakSelf)
        
        // 采编活动类型
        self.tagTypeLabel = [MYSmartLabel al_labelWithMaxRow:1 text:@"" font:FontYT(13) color:COLOR_IWHITE lineSpacing:0 align:NSTextAlignmentCenter breakMode:NSLineBreakByTruncatingTail];
        self.tagTypeLabel.radius = 3;
        [self.contentView addSubview:self.tagTypeLabel];
        
        // 活动标题
        self.titleLabel = [MYSmartLabel al_labelWithMaxRow:3 text:@"" font:FontYT(16) color:kDeepLabelColor lineSpacing:4];
        [self.contentView addSubview:self.titleLabel];
        
        // 收藏按钮
        self.collectButton = [[MYSmartButton alloc] initWithFrame:CGRectZero image:IMG(@"icon_gather_collect_normal") selectedImage:IMG(@"icon_gather_collect_selected") actionBlock:^(id sender) {
            if (weakSelf.actionHandler) { weakSelf.actionHandler(sender, 1); }
        }];
        [self.contentView addSubview:self.collectButton];
        
        // 分割线
        MYMaskView *line1 = [MYMaskView maskViewWithBgColor:kLineGrayColor frame:CGRectZero radius:0];
        [self.contentView addSubview:line1];
        
        // ListView
        self.listView = [UIView new];
        [self.contentView addSubview:self.listView];
        
        // 分割线
        MYMaskView *line2 = [MYMaskView maskViewWithBgColor:kLineGrayColor frame:CGRectZero radius:0];
        [self.contentView addSubview:line2];
        
        self.bottomLine = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectZero radius:0];
        [self.contentView addSubview:self.bottomLine];
        
        
        [self.tagTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(8);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(40);
            make.top.equalTo(weakSelf.contentView).offset(15);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.tagTypeLabel.mas_right).offset(7);
            make.top.equalTo(weakSelf.tagTypeLabel);
            make.right.equalTo(weakSelf.collectButton.mas_left).offset(-10);
        }];
        
        [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.tagTypeLabel);
            make.centerX.equalTo(weakSelf.contentView.mas_right).offset(-27);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(5);
            make.right.equalTo(weakSelf.contentView).offset(-5);
            make.height.mas_equalTo(1);
            make.top.greaterThanOrEqualTo(weakSelf.tagTypeLabel.mas_bottom).offset(15).priorityHigh();
            make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(15).priorityMedium();
        }];
        
        [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(weakSelf.contentView);
            make.top.equalTo(line1.mas_bottom);
        }];
        
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.listView.mas_bottom);
            make.height.mas_equalTo(kLineThick);
            make.left.and.right.equalTo(weakSelf.contentView);
        }];
        
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(weakSelf.contentView);
            make.height.mas_equalTo(6);
            make.top.equalTo(line2.mas_bottom);
        }];
        
        
        [self loadListView];
    }
    return self;
}

- (void)loadListView {
    
    WS(weakSelf)
    UILabel *preLabel = nil;
    CGFloat halfFontHeight = [UIToolClass fontHeight:FontYT(14)] * 0.5;
    
    for (int i = 0; i < 4; i++) {
        UIImageView *iconView = [UIImageView new];
        [self.listView addSubview:iconView];
        
        MYSmartLabel *textLabel = [MYSmartLabel al_labelWithMaxRow:20 text:@"" font:FontYT(14) color:kLightLabelColor lineSpacing:4];
        [self.listView addSubview:textLabel];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.listView.mas_left).offset(17);
            if (preLabel) {
                make.top.equalTo(preLabel.mas_bottom).offset(9);
            }else {
                make.top.equalTo(weakSelf.listView).offset(16);
            }
        }];
        
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconView.mas_centerY).offset(-halfFontHeight);
            make.left.equalTo(weakSelf.listView).offset(33);
            make.right.equalTo(weakSelf.listView).offset(-15);
        }];
        
        preLabel = textLabel;
    }

    if (preLabel) {
        [self.listView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(preLabel.mas_bottom).offset(16);
        }];
    }
}


- (void)setButtonActionHandler:(void (^)(UIButton *, NSInteger))actionHandler {
    self.actionHandler = actionHandler;
}

- (void)setModel:(ActivityGatherModel *)model forIndexPath:(NSIndexPath *)indexPath {
    if (model && [model isKindOfClass:[ActivityGatherModel class]]) {
        self.model = model;
        
        NSString *gatherType = MYActivityGatherTypeShowHandle(model.gatherType);
        self.tagTypeLabel.text = gatherType;
        self.tagTypeLabel.backgroundColor = MYActivityGatherTypeColorHandle(model.gatherType);
        CGFloat textWidth = [UIToolClass textWidth:self.tagTypeLabel.text font:self.tagTypeLabel.font]+16;
        [self.tagTypeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(textWidth);
        }];
        self.titleLabel.text = model.gatherTitle;
        self.collectButton.selected = model.gatherIsCollect;
        
        
        NSArray *listArray = [model handleCalemdarListShowDataArray];
        
        for (int i = 0; i < MIN(listArray.count, 4); i++) {
            
            UIImageView *imgView = self.listView.subviews[2*i];
            UILabel *textLabel = self.listView.subviews[2*i+1];
            
            NSArray *item = listArray[i];
            imgView.image = IMG(item[0]);
            textLabel.text = item[1];
        }
        
        
        /*
         
        [self.listView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        NSArray *listArray = [model handleCalemdarListShowDataArray];
        
        WS(weakSelf)
        UILabel *preLabel = nil;
        CGFloat halfFontHeight = [UIToolClass fontHeight:FontYT(14)] * 0.5;
        for (NSArray *item in listArray) {
            UIImage *iconImage = IMG(item[0]);
            NSString *text = item[1];
            
            UIImageView *iconView = [UIImageView new];
            iconView.image = iconImage;
            [self.listView addSubview:iconView];
            
            MYSmartLabel *textLabel = [MYSmartLabel al_labelWithMaxRow:20 text:text font:FontYT(14) color:kLightLabelColor lineSpacing:4];
            textLabel.text = text;
            [self.listView addSubview:textLabel];
            
            [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakSelf.listView.mas_left).offset(17);
                if (preLabel) {
                    make.top.equalTo(preLabel.mas_bottom).offset(9);
                }else {
                    make.top.equalTo(weakSelf.listView).offset(16);
                }
            }];
            
            [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(iconView.mas_centerY).offset(-halfFontHeight);
                make.left.equalTo(weakSelf.listView).offset(33);
                make.right.equalTo(weakSelf.listView).offset(-15);
            }];
            
            preLabel = textLabel;
        }
        
        if (preLabel) {
            [self.listView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(preLabel.mas_bottom).offset(16);
            }];
        }
         
         */
    }
}



+ (CGFloat)cellHeightForModel:(ActivityGatherModel *)model {
    static CalendarListTextCell *cell = nil;
    if (!cell) {
        cell = [[CalendarListTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellHeight"];
    }
    cell.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    [cell setModel:model forIndexPath:nil];
    
    [cell layoutIfNeeded];
    
    return cell.bottomLine.maxY;
}

@end




#pragma mark - ———— CalendarListPictureCell ————



@interface CalendarListPictureCell ()
@property (nonatomic, strong) ActivityGatherModel *model;

@property (nonatomic, strong) UIImageView *pictureView;
@property (nonatomic, strong) UILabel *tagTypeLabel; // 类型标签：话剧歌剧
@property (nonatomic, strong) UILabel *titleLabel; // 标题
@property (nonatomic, strong) UIButton *collectButton; // 收藏按钮
@property (nonatomic, strong) UIView *listView;
@property (nonatomic, strong) MYMaskView *bottomLine;

@property (nonatomic, copy) void (^actionHandler)(UIButton *sender, NSInteger index);
@end



@implementation CalendarListPictureCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = COLOR_IWHITE;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        WS(weakSelf)
        
        // 封面图片
        self.pictureView = [UIImageView new];
        self.pictureView.contentMode = UIViewContentModeScaleAspectFill;
        self.pictureView.clipsToBounds = YES;
        self.pictureView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.pictureView];
        
        // 收藏按钮
        self.collectButton = [[MYSmartButton alloc] initWithFrame:CGRectZero image:IMG(@"icon_gather_collect_normal") selectedImage:IMG(@"icon_gather_collect_selected") actionBlock:^(id sender) {
            if (weakSelf.actionHandler) { weakSelf.actionHandler(sender, 1); }
        }];
        [self.pictureView addSubview:self.collectButton];
        
        // 采编活动类型
        self.tagTypeLabel = [MYSmartLabel al_labelWithMaxRow:1 text:@"" font:FontYT(13) color:COLOR_IWHITE lineSpacing:0 align:NSTextAlignmentCenter breakMode:NSLineBreakByTruncatingTail];
        self.tagTypeLabel.radius = 3;
        [self.contentView addSubview:self.tagTypeLabel];
        
        // 活动标题
        self.titleLabel = [MYSmartLabel al_labelWithMaxRow:3 text:@"" font:FontYT(16) color:kDeepLabelColor lineSpacing:4];
        [self.contentView addSubview:self.titleLabel];
        
        // 分割线
        MYMaskView *line1 = [MYMaskView maskViewWithBgColor:kLineGrayColor frame:CGRectZero radius:0];
        [self.contentView addSubview:line1];
        
        // ListView
        self.listView = [UIView new];
        [self.contentView addSubview:self.listView];
        
        // 分割线
        MYMaskView *line2 = [MYMaskView maskViewWithBgColor:kLineGrayColor frame:CGRectZero radius:0];
        [self.contentView addSubview:line2];
        
        self.bottomLine = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectZero radius:0];
        [self.contentView addSubview:self.bottomLine];
        
        
        [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.top.equalTo(weakSelf.contentView);
            make.height.equalTo(weakSelf.contentView.mas_width).multipliedBy(kPicScale_ListCover);
        }];
        
        [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.pictureView.mas_right).offset(-27);
            make.centerY.equalTo(weakSelf.pictureView.mas_top).offset(27);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        [self.tagTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(8);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(40);
            make.top.equalTo(weakSelf.pictureView.mas_bottom).offset(15);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.tagTypeLabel.mas_right).offset(7);
            make.top.equalTo(weakSelf.tagTypeLabel);
            make.right.equalTo(weakSelf.contentView).offset(-15);
        }];
        
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(5);
            make.right.equalTo(weakSelf.contentView).offset(-5);
            make.height.mas_equalTo(1);
            make.top.greaterThanOrEqualTo(weakSelf.tagTypeLabel.mas_bottom).offset(15).priorityHigh();
            make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(15).priorityMedium();
        }];
        
        [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(weakSelf.contentView);
            make.top.equalTo(line1.mas_bottom);
        }];
        
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.listView.mas_bottom);
            make.height.mas_equalTo(kLineThick);
            make.left.and.right.equalTo(weakSelf.contentView);
        }];
        
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(weakSelf.contentView);
            make.height.mas_equalTo(6);
            make.top.equalTo(line2.mas_bottom);
        }];
        
        [self loadListView];
    }
    return self;
}

- (void)loadListView {
    
    WS(weakSelf)
    UILabel *preLabel = nil;
    CGFloat halfFontHeight = [UIToolClass fontHeight:FontYT(14)] * 0.5;
    
    for (int i = 0; i < 4; i++) {
        UIImageView *iconView = [UIImageView new];
        [self.listView addSubview:iconView];
        
        MYSmartLabel *textLabel = [MYSmartLabel al_labelWithMaxRow:20 text:@"" font:FontYT(14) color:kLightLabelColor lineSpacing:4];
        [self.listView addSubview:textLabel];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.listView.mas_left).offset(17);
            if (preLabel) {
                make.top.equalTo(preLabel.mas_bottom).offset(9);
            }else {
                make.top.equalTo(weakSelf.listView).offset(16);
            }
        }];
        
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconView.mas_centerY).offset(-halfFontHeight);
            make.left.equalTo(weakSelf.listView).offset(33);
            make.right.equalTo(weakSelf.listView).offset(-15);
        }];
        
        preLabel = textLabel;
    }
    
    if (preLabel) {
        [self.listView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(preLabel.mas_bottom).offset(16);
        }];
    }
}

- (void)setButtonActionHandler:(void (^)(UIButton *, NSInteger))actionHandler {
    self.actionHandler = actionHandler;
}

- (void)setModel:(ActivityGatherModel *)model forIndexPath:(NSIndexPath *)indexPath {
    if (model && [model isKindOfClass:[ActivityGatherModel class]]) {
        self.model = model;
        
        NSString *gatherType = MYActivityGatherTypeShowHandle(model.gatherType);
        self.tagTypeLabel.text = gatherType;
        self.tagTypeLabel.backgroundColor = MYActivityGatherTypeColorHandle(model.gatherType);
        CGFloat textWidth = [UIToolClass textWidth:self.tagTypeLabel.text font:self.tagTypeLabel.font]+16;
        [self.tagTypeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(textWidth);
        }];
        self.titleLabel.text = model.gatherTitle;
        self.collectButton.selected = model.gatherIsCollect;
        
        UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:_pictureView.viewSize centerSize:CGSizeMake(40, 40) isBorder:NO];
        [self.pictureView sd_setImageWithURL:[NSURL URLWithString:JointedImageURL(model.gatherIconUrl, @"")] placeholderImage:placeImg];
        
        NSArray *listArray = [model handleCalemdarListShowDataArray];
        for (int i = 0; i < MIN(listArray.count, 4); i++) {
            UIImageView *imgView = self.listView.subviews[2*i];
            UILabel *textLabel = self.listView.subviews[2*i+1];
            
            NSArray *item = listArray[i];
            imgView.image = IMG(item[0]);
            textLabel.text = item[1];
        }
    }
}


+ (CGFloat)cellHeightForModel:(ActivityGatherModel *)model {
    static CalendarListPictureCell *cell = nil;
    if (!cell) {
        cell = [[CalendarListPictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellHeight"];
    }
    cell.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    [cell setModel:model forIndexPath:nil];
    
    [cell layoutIfNeeded];
    
    return cell.bottomLine.maxY;
}

@end
