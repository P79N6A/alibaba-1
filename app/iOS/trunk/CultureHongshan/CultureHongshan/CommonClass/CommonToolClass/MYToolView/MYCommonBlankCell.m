//
//  MYCommonBlankCell.m
//  CultureHongshan
//
//  Created by JackAndney on 2017/11/28.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "MYCommonBlankCell.h"

@interface MYCommonBlankCell ()
@property (nonatomic, strong) UIView *bgView;
@end

@implementation MYCommonBlankCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.bgView = [UIView new];
        [self.contentView addSubview:self.bgView];
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

- (void)updateEstimatedHeight:(CGFloat)height {
    if (height <= 1) {
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_greaterThanOrEqualTo(height);
            make.height.mas_lessThanOrEqualTo(1);
        }];
    }else {
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
    }
}

@end
