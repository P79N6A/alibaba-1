//
//  SearchDetailFooterView.m
//  CultureHongshan
//
//  Created by ct on 15/11/12.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "SearchDetailFooterView.h"


@implementation SearchDetailFooterView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        self.contentView.backgroundColor = RGB(230, 230, 230);
        _loadMoreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        _loadMoreButton.titleLabel.font = FontYT(10);
        [_loadMoreButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_loadMoreButton];
    }
    return self;
}


@end
