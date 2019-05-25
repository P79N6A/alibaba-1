//
//  WebViewCell.h
//  CultureHongshan
//
//  Created by ct on 16/1/26.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewCell : UITableViewCell

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, copy) NSString *htmlString;

@property (nonatomic, strong) UIButton *moreButton;


@end
