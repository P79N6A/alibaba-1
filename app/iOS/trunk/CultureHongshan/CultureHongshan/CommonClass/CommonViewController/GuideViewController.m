//
//  GuideViewController.m
//  时尚五角场
//
//  Created by 李 兴 on 14-7-21.
//  Copyright (c) 2014年 李 兴. All rights reserved.
//

#import "GuideViewController.h"
#import "FBTabbarController.h"
@interface GuideViewController ()<UIScrollViewDelegate>
{
    UIButton *jumpButton;
}

@end

@implementation GuideViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
    _haveAnimation = NO;
    self.view.backgroundColor = COLOR_IWHITE;
    NSArray * imgAry = @[@"intro_1",@"intro_2",@"intro_3"];
   
    

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN_FULL)];
    _scrollView.contentSize =  CGSizeMake(WIDTH_SCREEN*imgAry.count, HEIGHT_SCREEN);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    float widthScale = WIDTH_SCREEN/640;
    float heightScale = HEIGHT_SCREEN_FULL/1136;
    for (int i=0; i<imgAry.count; i++)
    {

        if ([imgAry[i] rangeOfString:@".gif"].location == NSNotFound)
        {
            NSString *imgName = [NSString stringWithFormat:@"%@%@.jpg",imgAry[i],[self getIntroImageSize]];
            UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH_SCREEN*i, 0, WIDTH_SCREEN, HEIGHT_SCREEN+HEIGHT_NAVIGATION_BAR+HEIGHT_STATUS_BAR)];
            imgV.image = IMG(imgName);
            [_scrollView addSubview:imgV];

            if(i == (imgAry.count - 1))
            {
                imgV.tag = 9876;
            }
            
            if (i == (imgAry.count - 1))
            {
                imgV.userInteractionEnabled = YES;
                
                //按钮
                UIButton *goButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,WIDTH_SCREEN , HEIGHT_SCREEN_FULL)];
                [goButton addTarget:self action:@selector(gotoMainPage) forControlEvents:UIControlEventTouchUpInside];
                [imgV addSubview:goButton];
              
            }
        }
        else
        {
            NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:imgAry[i] ofType:@""]];
            if (gif == nil)
            {
                continue;
            }
            // view生成
            UIWebView *webView = [[UIWebView alloc] initWithFrame:MRECT(WIDTH_SCREEN*i*2, 0, 640, 1136)];
            webView.userInteractionEnabled = NO;
            webView.center = CGPointMake((WIDTH_SCREEN * i) + WIDTH_SCREEN/2, HEIGHT_SCREEN_FULL/2);
            webView.transform = CGAffineTransformMakeScale(widthScale,heightScale);
            NSURL *baseURL = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
            [webView loadData:gif MIMEType:@"image/gif" textEncodingName:@"utf-8" baseURL:baseURL];
            [_scrollView addSubview:webView];
            if (i == imgAry.count-1)
            {
                UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_SCREEN*(imgAry.count-1), 0, WIDTH_SCREEN, HEIGHT_SCREEN_FULL)];

                [_scrollView addSubview:button];
                [button addTarget:self action:@selector(gotoMainPage) forControlEvents:UIControlEventTouchUpInside];

            }
            gif = nil;
        }
    }
    
    jumpButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-80, 25, 80, 36)];
    [jumpButton setTitle:@"跳过" forState:UIControlStateNormal];
    [jumpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [jumpButton addTarget:self action:@selector(gotoMainPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jumpButton];

    pageControl = [[UIPageControl alloc] initWithFrame:MRECT(0,HEIGHT_SCREEN_FULL-20, WIDTH_SCREEN, 20)];
    pageControl.numberOfPages = imgAry.count;
    pageControl.pageIndicatorTintColor = kDeepLabelColor;
    pageControl.currentPageIndicatorTintColor = kLightLabelColor;
    pageControl.currentPage = 0;
    [self.view addSubview:pageControl];

    // Do any additional setup after loading the view.
}



-(void)gotoMainPage
{
    [ToolClass updateFirstVisitState];
    __block UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //图片
    __block UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    imgView.image = [UIToolClass getScreenShotImageWithSize:CGSizeMake(kScreenWidth, kScreenHeight) views:@[window] isBlurry:NO];
    [window addSubview:imgView];
    
    
    [UIView animateWithDuration:0.8 animations:^{
        imgView.alpha = 0.3;
    } completion:^(BOOL finished) {
        window.rootViewController = nil;
        FBTabbarController * tabbar = [FBTabbarController new];
        window.rootViewController = tabbar;
    }];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (fabs(scrollView.contentOffset.x + WIDTH_SCREEN - 1) / WIDTH_SCREEN);
    if (index != pageControl.currentPage)
    {
        pageControl.currentPage = index;
        
    }
    jumpButton.hidden = index > 3-2 ? YES : NO;
}


- (NSString *)getIntroImageSize
{
    /*
     
     3.5 —————— 320x480
     4.0 —————— 320x568
     4.7 —————— 375x667
     5.5 —————— 414x736
     
     */
    NSString *screenSize = nil;
    if (kScreenWidth == 320 && kScreenHeight == 480)
    {
        screenSize = @"_3_5";
        _position = 15;
    }
    else
    {
        screenSize = @"_5_5";
        _position = 40;
    }
    return screenSize;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
