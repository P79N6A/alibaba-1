//
//  SharePresentView.m
//  CultureHongshan
//
//  Created by JackAndney on 2017/7/10.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "SharePresentView.h"

#import "ShareService.h"

// 动画持续时间
#define kAnimationDuration 0.25

static float bottom_view_height; // 底部视图的高度



@interface SharePresentView ()
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, copy) void(^actionHandler)(NSInteger index);
@end



@implementation SharePresentView


// 仅展示分享视图
+ (void)showShareViewWithActionHandler:(void (^)(NSInteger))handler {

    SharePresentView *shareView = [[SharePresentView alloc] initWithFrame:CGRectZero];
    shareView.backgroundColor = [UIColor clearColor];
    shareView.actionHandler = handler;
    [shareView initSubviews];
    
    UIWindow *topWindow = [UIToolClass getKeyWindow];
    [topWindow addSubview:shareView];
    
    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    // 必须加上下面的两句话，否则动画有问题
    [shareView setNeedsLayout];
    [shareView layoutIfNeeded];
    
    bottom_view_height = CGRectGetHeight(shareView.contentView.frame);
    
    [shareView switchShowStatus:YES];
}



// 分享方法
+ (void)showShareViewWithTitle:(NSString *)title content:(NSString *)content sharedImage:(UIImage *)sharedImage imageUrl:(NSString *)imageUrl shareUrl:(NSString *)shareUrl extParams:(NSDictionary *)extParams {
    
    if (title.length > 30) title = [title substringToIndex:30];
    if (content.length > 40) content = [content substringToIndex:40];
    
    [SharePresentView showShareViewWithActionHandler:^(NSInteger index) {
        
        SSDKPlatformType platformType = SSDKPlatformTypeUnknown;
        // 1-微信好友  2-微信朋友圈  3-QQ好友  4-新浪微博
        if (index == 1) platformType = SSDKPlatformSubTypeWechatSession;
        if (index == 2) platformType = SSDKPlatformSubTypeWechatTimeline;
        if (index == 3) platformType = SSDKPlatformSubTypeQQFriend;
        if (index == 4) platformType = SSDKPlatformTypeSinaWeibo;
        
        if (platformType == SSDKPlatformTypeUnknown) {
            return;
        }
        
        if ([imageUrl isValidImgUrl]) {
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
             {
                 UIImage *tmpImage = [image isKindOfClass:[UIImage class]] ? image : sharedImage;
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     if ([tmpImage isKindOfClass:[UIImage class]]) {
                         [SharePresentView beginShareWithPlatform:platformType title:title content:content sharedImage:tmpImage imageUrl:nil shareUrl:shareUrl extParams:extParams];
                     }else {
                         [SharePresentView beginShareWithPlatform:platformType title:title content:content sharedImage:nil imageUrl:imageUrl shareUrl:shareUrl extParams:extParams];
                     }
                 });
             }];
        }else {
            
            if ([sharedImage isKindOfClass:[UIImage class]]) {
                [SharePresentView beginShareWithPlatform:platformType title:title content:content sharedImage:sharedImage imageUrl:nil shareUrl:shareUrl extParams:extParams];
            }else {
                [SharePresentView beginShareWithPlatform:platformType title:title content:content sharedImage:nil imageUrl:imageUrl shareUrl:shareUrl extParams:extParams];
            }
        }
        
    }];
}


#pragma mark -


// 创建子视图
- (void)initSubviews {
    WS(weakSelf)
    
    self.dismissButton = [[MYSmartButton alloc] initWithFrame:CGRectZero image:nil selectedImage:nil actionBlock:^(MYSmartButton *sender) {
        [weakSelf switchShowStatus:NO];
    }];
    self.dismissButton.userInteractionEnabled = NO;
    [self addSubview:self.dismissButton];
    
    self.contentView = [MYMaskView maskViewWithBgColor:ColorFromHex(@"F5F5F5") frame:CGRectZero radius:0];
    [self addSubview:self.contentView];
    
    
    // 分享标题
    MYSmartLabel *shareTitleLabel = [MYSmartLabel al_labelWithMaxRow:1 text:@"分享到" font:FontSystem(16) color:ColorFromHex(@"8187A1") lineSpacing:0 align:NSTextAlignmentCenter breakMode:NSLineBreakByTruncatingTail];
    [self.contentView addSubview:shareTitleLabel];
    
    
    // 取消按钮
    MYSmartButton *cancelButton = [[MYSmartButton alloc] initWithFrame:CGRectZero title:@"取消" font:FontSystem(19) tColor:kLightLabelColor bgColor:kWhiteColor actionBlock:^(MYSmartButton *sender) {
        [weakSelf switchShowStatus:NO];
    }];
    [self.contentView addSubview:cancelButton];
    
    
    BOOL isInstall[4];
    NSArray *imageArray = @[@"share_微信",@"share_朋友圈",@"share_qq",@"share_微博"];
    
    UIButton *preButton = nil;
    NSInteger clientNum = [self.class checkClientInstall:isInstall];
    NSInteger realIndex = 0;
    
    for (int i = 0; i < imageArray.count; i++) {
        if (isInstall[i] == NO) continue;
        
        // 按钮
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
        button.tag = 1+i;
        [button setImage:IMG(imageArray[i]) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];

        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(55, 55));
            make.top.equalTo(shareTitleLabel.mas_bottom).offset(20);
            
            if (clientNum == 1) {
                make.centerX.equalTo(weakSelf.contentView);
            }else if (clientNum == 2) {
                make.centerX.equalTo(weakSelf.contentView).multipliedBy( 2.0* (2*realIndex+3)/(2 * imageArray.count));
            }else if (clientNum == 3) {
                make.centerX.equalTo(weakSelf.contentView).multipliedBy( 2.0* (2*(realIndex + 1))/(2 * imageArray.count));
            }else if (clientNum == 4) {
                make.centerX.equalTo(weakSelf.contentView).multipliedBy( 2.0* (2*realIndex+1)/(2 * imageArray.count));
            }
        }];
        
        realIndex++;
        preButton = button;
    }
    
    
    
    [self.dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.contentView);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.mas_bottom);
    }];
    
    [shareTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.contentView).offset(18);
        make.width.equalTo(weakSelf.contentView).offset(-40);
    }];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(preButton.mas_bottom).offset(30);
        make.left.and.right.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(weakSelf.contentView).offset(-HEIGHT_HOME_INDICATOR);
    }];
}

+ (NSInteger)checkClientInstall:(BOOL *)isInstall {
    // 微信好友、微信朋友圈、QQ好友、微博
    
#ifndef FUNCTION_ENABLED_SHARE
    return 0; // 禁用第三方分享功能
#endif
    
    
#ifdef FUNCTION_ENABLED_WECHAT
    isInstall[0] = isInstall[1] = [ShareService isWeiXinInstalled];
#else
    isInstall[0] = isInstall[1] = NO;
#endif
    
#ifdef FUNCTION_ENABLED_QQ
    isInstall[2] = [ShareService isQQInstalled];
#else
    isInstall[2] = NO;
#endif
    
#ifdef FUNCTION_ENABLED_WEIBO
    isInstall[3] = [ShareService isSinaWeiboInstalled];;
#else
    isInstall[3] = NO;
#endif
    
    NSInteger installNum = 0;
    for (int i = 0; i < 4; i++) {
        if (isInstall[i] == YES) {
            installNum++;
        }
    }
    return installNum;
}


- (void)buttonClick:(UIButton *)sender
{
    //  1-微信好友  2-微信朋友圈  3-QQ好友  4-新浪微博
    switch (sender.tag) {
        case 1: { // 微信好友
            if (![ShareService isWeiXinInstalled]) {
                [SVProgressHUD showInfoWithStatus:@"您尚未安装微信App，无法分享到微信！"]; return;
            }else {
                if (self.actionHandler) self.actionHandler(1);
            }
        }
            break;
        case 2: { // 微信朋友圈
            if (![ShareService isWeiXinInstalled]) {
                [SVProgressHUD showInfoWithStatus:@"您尚未安装微信App，无法分享到微信！"]; return;
            }else {
                if (self.actionHandler) self.actionHandler(2);
            }
        }
            break;
        case 3: { // QQ好友
            if (![ShareService isQQInstalled]) {
                [SVProgressHUD showInfoWithStatus:@"您尚未安装QQ，无法分享给QQ好友！"]; return;
            }else {
                if (self.actionHandler) self.actionHandler(3);
            }
        }
            break;
        case 4: { // 新浪微博
            if (self.actionHandler) self.actionHandler(4);
        }
            break;
            
        default: {
            return;
        }
            break;
    }
    
    

    [self switchShowStatus:NO];
}



#pragma mark - 出现与消失

// 切换 显示/隐藏 的状态
- (void)switchShowStatus:(BOOL)show {
    
    CGFloat offset = 0;
    UIColor *backgroundColor = nil;
    if (show) {
        offset = -bottom_view_height;
        backgroundColor = kMaskBgColor;
    }else {
        offset = 0;
        backgroundColor = [UIColor clearColor];
    }
    
    WS(weakSelf)
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_bottom).offset(offset);
    }];
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        
        weakSelf.backgroundColor = backgroundColor;
        [weakSelf setNeedsLayout];
        [weakSelf layoutIfNeeded];
        
        if (show==NO) {
            self.contentView.alpha = 0.4;
        }
        
    } completion:^(BOOL finished) {
        if (show == NO) {
            [weakSelf removeFromSuperview];
        }else {
            weakSelf.dismissButton.userInteractionEnabled = YES;
        }
    }];
}


#pragma mark - 分享方法

+ (void)beginShareWithPlatform:(SSDKPlatformType)platform title:(NSString *)title content:(NSString *)content sharedImage:(UIImage *)sharedImage imageUrl:(NSString *)imageUrl shareUrl:(NSString *)shareUrl extParams:(NSDictionary *)extParams {
    
    
    [ShareService shareWithPlatformType:platform title:title content:content sharedImage:sharedImage imageUrl:imageUrl shareUrl:shareUrl addIntegral:[extParams safeIntForKey:@"addIntegral"]==1 onStateChanged:^(SSDKResponseState state) {
        
    }];
    
}


/**
 是否可以展示分享视图
 
 @return 布尔值
 */
+ (BOOL)canShowShareView {
    
#ifndef FUNCTION_ENABLED_SHARE
    return NO; // 禁用分享功能
#else
    
#ifdef FUNCTION_ENABLED_WECHAT
    if ([ShareService isWeiXinInstalled]) {
        return YES;
    }
#endif
    
#ifdef FUNCTION_ENABLED_QQ
    if ([ShareService isQQInstalled]) {
        return YES;
    }
#endif
    
#ifdef FUNCTION_ENABLED_WEIBO
    if ([ShareService isSinaWeiboInstalled]) {
        return YES;
    }
#endif
    
    return NO;
#endif
}



@end
