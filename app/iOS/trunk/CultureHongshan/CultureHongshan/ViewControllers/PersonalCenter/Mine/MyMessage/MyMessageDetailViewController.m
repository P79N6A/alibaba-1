//
//  MyMessageDetailViewController.m
//  CultureHongshan
//
//  Created by ct on 16/2/20.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "MyMessageDetailViewController.h"


@implementation MyMessageDetailViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"查看消息";
    self.view.backgroundColor = kBgColor;
    
    [self initSubviews];
}


- (void)initSubviews
{
    //通知图标
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 20, 40, 40)];;
    logoView.image = IMG(@"活动通知");
    [self.view addSubview:logoView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(logoView.maxX+8, logoView.originalY, kScreenWidth-logoView.maxX-8-20, logoView.height)];
    titleLabel.font = FontSystem(17);
    titleLabel.textColor = COLOR_IBLACK;
    titleLabel.text = _model.messageType;
    [self.view addSubview:titleLabel];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, logoView.maxY+15, kScreenWidth, kScreenHeight-logoView.maxY-15-HEIGHT_TOP_BAR)];
    [self.view addSubview:scrollView];
    
    //消息内容
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kScreenWidth-30, 0)];
    contentLabel.font = FontYT(14);
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = ColorFromHex(@"8B969A");
    contentLabel.attributedText = [UIToolClass getAttributedStr:_model.messageContent font:contentLabel.font lineSpacing:7];
    contentLabel.height = [UIToolClass attributedTextHeight:contentLabel.attributedText width:contentLabel.width];
    [scrollView addSubview:contentLabel];
    
    scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width, contentLabel.maxY+40);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
