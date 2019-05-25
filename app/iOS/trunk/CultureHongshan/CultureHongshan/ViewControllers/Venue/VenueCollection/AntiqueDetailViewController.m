//
//  AntiqueDetailViewController.m
//  CultureHongshan
//
//  Created by one on 15/11/23.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "AntiqueDetailViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMedia/CoreMedia.h>

#import "WebPhotoBrowser.h"
#import "AnimationBackView.h"

#import "AntiqueDetailModel.h"

#import "WebViewController.h"

// 视频播放
#import <AVFoundation/AVFoundation.h>
#import "KrVideoPlayerController.h"
#import "KrVideoPlayerControlView.h"


@interface AntiqueDetailViewController ()<UIWebViewDelegate>
{
    UIScrollView *_bgScrollView;
    UIView *webBackView;
    UIWebView *remarkWebView;
    UIView *voiceBackView;
    UIButton *playAndPauseBtn;
    
    CGFloat timeRatio;
    
    AnimationBackView *_animationView;
    UIImageView *_topImgView;
}

@property (nonatomic, strong) AntiqueDetailModel *detailModel;

@property (nonatomic, strong) UILabel *playTimeLabel;//播放时间

@property (nonatomic, strong) AVPlayer *voicePlayer;//音频播放器
@property (nonatomic, strong) AVPlayerItem *item;

@property (nonatomic, assign) CGFloat videoDuraion;//总时间

@property (nonatomic, assign) CGFloat currentTime;//当前播放时间

@property (nonatomic, strong)id timeObserver;

@property (nonatomic, assign) BOOL isPlayer;

@property (nonatomic, assign) BOOL isFist;

// 视频播放
@property(nonatomic,strong) UIView *videoContentView;
@property(nonatomic,strong) KrVideoPlayerController *videoController;

@end

@implementation AntiqueDetailViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"藏品展示";
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_voicePlayer) {
        if(_voicePlayer.status == AVPlayerStatusReadyToPlay) {
            [_voicePlayer pause]; // 暂停播放
            
            [playAndPauseBtn setImage:IMG(@"icon_play_audio") forState:UIControlStateNormal];
            _isPlayer = NO;
        }
    }
    
    [self.videoController dismiss];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kBgColor;
    
    _isFist = YES;
    _isPlayer = NO;
    
    _animationView = [[AnimationBackView alloc] initAnimationWithFrame:CGRectMake(0, 0, 100, 80)];
    [_animationView beginAnimationView];
    [self.view addSubview:_animationView];
    _animationView.center = CGPointMake(self.view.center.x, kScreenHeight/2-40);
    [self.view bringSubviewToFront:_animationView];
    
    [self loadAntiqueDetailData];
}

#pragma -mark 加载数据
-(void)loadAntiqueDetailData
{
    WS(weakSelf);
    [AppProtocol getAntiqueDetailWithAntiqueId:_antiqueId UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
         if (responseCode == HttpResponseSuccess) {
             _animationView.isLoadAnimation = YES;
             _detailModel = responseObject;
             [weakSelf loadAntiqueDetailView];
         }else{
             [_animationView shutTimer];
             if (_detailModel > 0) {
                 [SVProgressHUD showInfoWithStatus:responseObject];
             }else{
                 [_animationView setAnimationLabelTextString:responseObject];
             }
         }
     }];
}

- (void)loadAntiqueDetailView
{
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-HEIGHT_TOP_BAR)];
    _bgScrollView.directionalLockEnabled = YES;
    _bgScrollView.backgroundColor = kBgColor;
    [self.view addSubview:_bgScrollView];
    
    [_bgScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    
    _topImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*kPicScale_ListCover)];
    _topImgView.userInteractionEnabled = YES;
    UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:_topImgView.viewSize centerSize:CGSizeMake(40, 40) isBorder:NO];
    [_topImgView sd_setImageWithURL:[[NSURL alloc] initWithString:JointedImageURL(_detailModel.antiqueImgUrl,kImageSize_750_500)] placeholderImage:placeImg];
    [_bgScrollView addSubview:_topImgView];
    
    // 添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageClick:)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [_topImgView addGestureRecognizer:tap];
    
    // 视频容器视图
    if (_detailModel.antiqueVideoUrl.length) {
        _videoContentView = [[UIView alloc] initWithFrame:_topImgView.frame];
        _videoContentView.backgroundColor = kBgColor;
        [_bgScrollView insertSubview:_videoContentView belowSubview:_topImgView];
    }
    
    
    // 基本信息的白色背景
    MYMaskView *whiteBgView = [MYMaskView maskViewWithBgColor:COLOR_IWHITE frame:CGRectMake(0, _topImgView.maxY+5, kScreenWidth, 0) radius:0];
    [_bgScrollView addSubview:whiteBgView];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, kScreenWidth-20, 0)];
    titleLabel.font = FontYT(18);
    titleLabel.textColor = COLOR_IBLACK;
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = [UIToolClass getAttributedStr:_detailModel.antiqueName font:titleLabel.font lineSpacing:4];
    titleLabel.height = [UIToolClass attributedTextHeight:titleLabel.attributedText width:titleLabel.width];
    [whiteBgView addSubview:titleLabel];
    
    MYMaskView *lineView = [self getLineView:titleLabel.maxY+15];
    [whiteBgView addSubview:lineView];
    
    
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:2];
    if (_detailModel.antiqueTime.length) { //时间
        [tmpArray addObject:@[@"时间:",_detailModel.antiqueTime]];
    }
    if (_detailModel.antiqueSpectfictaion.length) { //规格
        [tmpArray addObject:@[@"规格:",_detailModel.antiqueSpectfictaion]];
    }
    if (_detailModel.VenueName.length) { //藏馆
        [tmpArray addObject:@[@"藏馆:",_detailModel.VenueName]];
    }
    
    CGFloat positionY = lineView.maxY;
    CGFloat leftLabelWidth = [UIToolClass textWidth:@"藏馆:" font:FontYT(14)]+3;
    
    for (NSArray *array in tmpArray) {
        NSString *leftTitle = array[0];
        NSString *rightTitle = array[1];
        
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.originalX, positionY+15, leftLabelWidth, [UIToolClass fontHeight:FontYT(14)])];
        leftLabel.font = FontYT(14);
        leftLabel.textColor = COLOR_IBLACK;
        leftLabel.text = leftTitle;
        [whiteBgView addSubview:leftLabel];
        
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftLabel.maxX, leftLabel.originalY, titleLabel.maxX-leftLabel.maxX, 0)];
        rightLabel.font = leftLabel.font;
        rightLabel.numberOfLines = 0;
        rightLabel.textColor = leftLabel.textColor;
        rightLabel.attributedText = [UIToolClass getAttributedStr:rightTitle font:rightLabel.font lineSpacing:4];
        rightLabel.height = [UIToolClass attributedTextHeight:rightLabel.attributedText width:rightLabel.width];
        [whiteBgView addSubview:rightLabel];
        
        MYMaskView *line = [self getLineView:rightLabel.maxY+15];
        [whiteBgView addSubview:line];
        
        positionY = line.maxY;
    }
    
    whiteBgView.height = positionY;
    
    
    //简介
    webBackView = [[UIView alloc] initWithFrame:CGRectMake(0, whiteBgView.maxY, kScreenWidth, 50)];
    webBackView.backgroundColor = [UIColor whiteColor];
    [_bgScrollView addSubview:webBackView];
    
    remarkWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, webBackView.frame.size.height)];
    remarkWebView.delegate = self;
    remarkWebView.backgroundColor = COLOR_IWHITE;
    [webBackView addSubview:remarkWebView];
    
    [remarkWebView loadHTMLString:_detailModel.antiqueIntroduction baseURL:nil];
    remarkWebView.scrollView.bounces = NO;
    [remarkWebView request];
    
    if (_detailModel.antiqueVoiceUrl.length > 0){
        // 音频播放器
        voiceBackView = [[UIView alloc] initWithFrame:CGRectMake(0, webBackView.maxY+45, kScreenWidth, 70)];
        voiceBackView.backgroundColor = [UIColor whiteColor];
        [_bgScrollView addSubview:voiceBackView];
        
        UIView *progessView = [[UIView alloc] initWithFrame:CGRectMake(0, voiceBackView.height-16, kScreenWidth, 2)];
        progessView.backgroundColor = [UIColor grayColor];
        [voiceBackView addSubview:progessView];
        
        _playTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(voiceBackView.bounds)-16, 35, 15)];
        _playTimeLabel.font = FontYT(10);
        _playTimeLabel.textAlignment = NSTextAlignmentCenter;
        _playTimeLabel.textColor = [UIColor lightGrayColor];
        _playTimeLabel.backgroundColor = [UIColor whiteColor];
        _playTimeLabel.layer.borderWidth = 1.0;
        _playTimeLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _playTimeLabel.radius = 7.5;
        _playTimeLabel.text = @"00:00";
        [voiceBackView addSubview:_playTimeLabel];
        _playTimeLabel.center = CGPointMake(_playTimeLabel.center.x, progessView.center.y);
        
        playAndPauseBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2-30, CGRectGetMinY(voiceBackView.frame)-30, 60, 60)];
        [playAndPauseBtn setImage:IMG(@"icon_play_audio") forState:UIControlStateNormal];
        [playAndPauseBtn addTarget:self action:@selector(playAndPauseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bgScrollView addSubview:playAndPauseBtn];
    }
}

#pragma mark- 代理方法

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        
        NSString *url = request.URL.absoluteString;
        if ([url hasPrefix:@"http"]) {
            
            WebViewController *vc = [WebViewController new];
            vc.url = url;
            [self.navigationController pushViewController:vc animated:YES];
            return NO;
        }
    }
    
    // 查看大图
    if ([request.URL.scheme isEqualToString:@"image-preview"])
    {
        NSString *path = [request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
        path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSArray *pathArray = [ToolClass getComponentArray:path separatedBy:@";"];
        
        _bgScrollView.userInteractionEnabled = 0;
        WEAK_VIEW(_bgScrollView);
        
        [WebPhotoBrowser photoBrowserWithImageUrlArray:[webView getImageUrlArrayFromWeb]
                                          currentIndex:[pathArray[1] integerValue]
                                       completionBlock:^(WebPhotoBrowser *photoBrowser) {
                                           weakView.userInteractionEnabled = 1;
                                       }];
        
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView addJudgeImageEventExistJs];
    [webView addGetImageUrlJs];
    
    //修改图片的尺寸
    [webView addResizeWebImageJs];
    [webView addImageClickActionJs];
    
    // 重设字体的格式
    [webView addFontSettingJs];
    
    
    remarkWebView.height = [webView getWebViewContentHeight];
    webBackView.height = remarkWebView.height;
    
    if (_detailModel.antiqueVoiceUrl.length > 0) {
        voiceBackView.originalY = webBackView.maxY+45;
        playAndPauseBtn.originalY = voiceBackView.originalY-30;
        
        _bgScrollView.contentSize = CGSizeMake(kScreenWidth, voiceBackView.maxY+45);
    }else {
        
        _bgScrollView.contentSize = CGSizeMake(kScreenWidth, webBackView.maxY+45);
    }
}


#pragma mark-  按钮点击事件

- (void)headImageClick:(UITapGestureRecognizer *)tapGesture
{
    if (_detailModel.antiqueVideoUrl.length > 0) {
        
        [self pauseAudio]; // 暂停音频
        
        // 播放视频
        self.videoController = [[KrVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.videoContentView.height)];
        __weak typeof(self)weakSelf = self;
        [self.videoController setDimissCompleteBlock:^{
            [weakSelf.videoController.view removeFromSuperview];
            weakSelf.videoController = nil;
        }];
        
        
        [self.videoController setWillBackOrientationPortrait:^{
            [[UIApplication sharedApplication]setStatusBarHidden:NO];
            weakSelf.navigationController.navigationBarHidden = NO;
            [weakSelf.videoController topBarHidden:YES];
            [weakSelf.videoController volumeHidden:YES];
            [weakSelf.videoContentView addSubview:weakSelf.videoController.view];
//            weakView.hidden = NO;
        }];
        [self.videoController setWillChangeToFullscreenMode:^{
            [[UIApplication sharedApplication]setStatusBarHidden:YES];
            weakSelf.navigationController.navigationBarHidden = YES;
            [weakSelf.videoController volumeHidden:NO];
            [weakSelf.videoController topBarHidden:NO];
            [weakSelf.videoController showInWindow];
            
        }];
        [self.videoContentView addSubview:self.videoController.view];
        
        self.videoController.contentURL = [NSURL URLWithString:_detailModel.antiqueVideoUrl];
        [self.videoController setTitle:_detailModel.antiqueName];
        [self.videoController topBarHidden:YES];
        
        [self.videoController play];
        
        _topImgView.hidden = YES;
        
    }else {
        _bgScrollView.userInteractionEnabled = NO;
        WEAK_VIEW(_bgScrollView);
        [WebPhotoBrowser photoBrowserWithImageUrlArray:@[JointedImageURL(_detailModel.antiqueImgUrl,kImageSize_750_500)]
                                          currentIndex:0
                                       completionBlock:^(WebPhotoBrowser *photoBrowser) {
                                           weakView.userInteractionEnabled = YES;
                                       }];
    }
}


-(void)playAndPauseBtnClick:(UIButton *)btn
{
    if (_isPlayer == NO) {
        [self playAudio];
        
    }else{
        [self pauseAudio];
    }
}

-(void)loadMusicData
{
    WS(weakSelf);
    
    NSURL *url = [NSURL URLWithString:_detailModel.antiqueVoiceUrl];
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    NSArray *requesteKeys = @[@"playable"];
    [asset loadValuesAsynchronouslyForKeys:requesteKeys completionHandler:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf prepareToPlayAsset:asset withKeys:requesteKeys];
        });
    }];
}



-(void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys
{
    for (NSString *thisKey in requestedKeys) {
        NSError *error = nil;
        AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
        if (keyStatus == AVKeyValueStatusFailed) {
            [SVProgressHUD showInfoWithStatus:@"抱歉，当前音频无法播放！"];
            
            [self removeTimeObserver];
            
            [playAndPauseBtn setImage:IMG(@"icon_play_audio") forState:UIControlStateNormal];
            _isPlayer = NO;
            _isFist = YES;
            return;
        }
    }
    
    if (_item) {
        [_item removeObserver:self forKeyPath:@"status"];
        _item = nil;
    }
    
    _item = [AVPlayerItem playerItemWithAsset:asset];
    
    [_item addObserver:self
            forKeyPath:@"status"
               options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
               context:nil];
    
    if (!_voicePlayer) {
        _voicePlayer = [AVPlayer playerWithPlayerItem:_item];
    }
    
    if (self.voicePlayer.currentItem != self.item) {
        [self.voicePlayer replaceCurrentItemWithPlayerItem:self.item];
    }
    
    [self removeTimeObserver];
    
    __weak AntiqueDetailViewController *weakSelf = self;
    self.timeObserver = [_voicePlayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        CGFloat currentTime = CMTimeGetSeconds(time);
        [weakSelf setSlideValue:currentTime / weakSelf.videoDuraion];
    }];
    
    [_voicePlayer play];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"])
    {
        AVPlayerStatus staus = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        
        switch (staus) {
            case AVPlayerStatusReadyToPlay://正在播放
            {
                //只有在播放状态才能获取视频时间长度
                AVPlayerItem *playerItem = (AVPlayerItem *)object;
                NSTimeInterval duration = CMTimeGetSeconds(playerItem.asset.duration);
                _videoDuraion = duration;
            }
                break;
                
            case AVPlayerStatusFailed: {
                [SVProgressHUD showInfoWithStatus:@"抱歉，当前音频无法播放！"];
                
                [self removeTimeObserver];
                
                [playAndPauseBtn setImage:IMG(@"icon_play_audio") forState:UIControlStateNormal];
                _isPlayer = NO;
                _isFist = YES;
            }
                break;
                
            case AVPlayerStatusUnknown: {
                
            }
                break;
                
            default:
                break;
        }
        
    }
}

-(void)removeTimeObserver
{
    if (_timeObserver)
    {
        [self.voicePlayer removeTimeObserver:_timeObserver];
        _timeObserver = nil;
    }
}


-(void)setSlideValue:(CGFloat)value
{
    if (value>0) {
        timeRatio = value;
    }else{
        timeRatio = 0;
    }
    
    _currentTime = value * _videoDuraion;
    
    _playTimeLabel.width = _currentTime >= 3600 ? 50 : 35;
    _playTimeLabel.text = [ToolClass getMusicPlayTimeString:_currentTime];
    
    [self updateProgressText];
}

-(void)updateProgressText
{
    CGFloat widht = (kScreenWidth-30)*timeRatio;
    
    [UIView animateWithDuration:1.0 animations:^{
        
        _playTimeLabel.center = CGPointMake(CGRectGetWidth(_playTimeLabel.frame)/2+widht, _playTimeLabel.center.y);
    }];
    
    if (_currentTime == _videoDuraion) {
        _isPlayer = NO;
        _playTimeLabel.center = CGPointMake(CGRectGetWidth(_playTimeLabel.frame)/2, _playTimeLabel.center.y);
        _playTimeLabel.text = @"";
        [playAndPauseBtn setImage:IMG(@"icon_pause_audio") forState:UIControlStateNormal];
        CMTime time = CMTimeMake(0, 1);
        [_voicePlayer seekToTime:time completionHandler:^(BOOL finish){
            
            [_voicePlayer play];
            
        }];
    }
}

- (MYMaskView *)getLineView:(CGFloat)position
{
    MYMaskView *lineView = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(0, position, kScreenWidth, 1) radius:0];
    return lineView;
}


#pragma mark - 

- (void)popViewController {
    if (_voicePlayer) {
        if (_voicePlayer.status != AVPlayerStatusFailed) {
            [_voicePlayer pause];
        }
        [self removeTimeObserver];
        [self.item removeObserver:self forKeyPath:@"status"];
        [_voicePlayer cancelPendingPrerolls];
        [self.voicePlayer removeTimeObserver:_timeObserver];
        _timeObserver = nil;
    }
    
    [super popViewController];
}


// 播放音频
- (void)playAudio {
    if (_voicePlayer == nil) {
        _voicePlayer = [[AVPlayer alloc] init];
    }
    
    // 播放中
    if (_isFist == YES) {
        [self loadMusicData];
        _isFist = NO;
    }
    
    [playAndPauseBtn setImage:IMG(@"icon_pause_audio") forState:UIControlStateNormal];
    [self.voicePlayer play];
    _isPlayer = YES;
}

// 暂停播放音频
- (void)pauseAudio {
    [playAndPauseBtn setImage:IMG(@"icon_play_audio") forState:UIControlStateNormal];
    if (_voicePlayer) {
        [self.voicePlayer pause];
    }
    _isPlayer = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
