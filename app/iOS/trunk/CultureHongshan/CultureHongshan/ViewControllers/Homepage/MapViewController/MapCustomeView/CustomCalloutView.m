//
//  CustomCalloutView.m
//  CultureHongshan
//
//  Created by ct on 15/11/17.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "CustomCalloutView.h"
#import <QuartzCore/QuartzCore.h>

#import "UIImageView+WebCache.h"
#import "InsideRoundedView.h"

#import "CustomPointAnnotation.h"


#define kCalloutWidth ConvertSize(525)

#define kArrorHeight  10
#define kRoundedViewRadius 8
#define kColor RGBA(0, 39, 86, 1)//深黑色

@interface CustomCalloutView ()

//场馆
@property (nonatomic, strong) UIImageView *enterImage;
@property (nonatomic, strong) UILabel *subtitleLabel;

@property (nonatomic, copy) NSString *type;


@end

@implementation CustomCalloutView

- (id)initWithFrame:(CGRect)frame type:(NSString *)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.type = type;
        
        self.backgroundColor = [UIColor clearColor];
        if ([type isEqualToString:@"Activity"])
        {
            [self initActivitySubViews];
        }
        else//Venue 或 VenueMap
//            if ([type isEqualToString:@"Venue"])
        {
            [self initVenueSubViews];
        }
        
    }
    return self;
}


- (void)initActivitySubViews
{
    //图片
    _upRoundedView = [[InsideRoundedView alloc] init];
    _upRoundedView.isArrow = NO;
    _upRoundedView.fillColor = [UIColor whiteColor];
    _upRoundedView.radius = kRoundedViewRadius;
    [self addSubview:_upRoundedView];
    
    //附件图片
    _picView = [[UIImageView alloc] init];
    [_upRoundedView addSubview:_picView];
    
    //下边的视图
    _downRoundedView = [[InsideRoundedView alloc] init];
    _downRoundedView.isArrow = YES;
    _downRoundedView.fillColor = [UIColor whiteColor];
    _downRoundedView.radius = kRoundedViewRadius;
    [self addSubview:_downRoundedView];
    
    //中间的分割线
    _colorView = [[UIView alloc] init];
    _colorView.backgroundColor = kOrangeYellowColor;
    [self addSubview:_colorView];
    
    //标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = kColor;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleLabel.numberOfLines = 2;
    _titleLabel.font = FontYT(20);
    [_downRoundedView addSubview:_titleLabel];
    //标题按钮
    _titleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _picView.bounds.size.width, _titleLabel.bounds.size.height+2*13)];
    [_titleButton addTarget:self action:@selector(enterDetailVC:) forControlEvents:UIControlEventTouchUpInside];
    [_downRoundedView addSubview:_titleButton];
    _titleButton.center = _titleLabel.center;
    
    //地点图标
    _addressView = [UIImageView new];
    _addressView.image = IMG(@"mapIcon_Address");
    [_downRoundedView addSubview:_addressView];
    //地址
    _addressLabel = [[UILabel alloc] init];
    _addressLabel.text = @"地点：";
    _addressLabel.font = FontYT(14);
    _addressLabel.textColor = kColor;
    [_downRoundedView addSubview:_addressLabel];
    //具体的地点
    _addressContext = [[UILabel alloc] init];
    _addressContext.font = FontYT(14);
    _addressContext.numberOfLines = 1;
    _addressContext.lineBreakMode = NSLineBreakByTruncatingTail;
    _addressContext.textColor = kColor;
    [_downRoundedView addSubview:_addressContext];
    //时间图标
    _timeView = [UIImageView new];
    _timeView.image = IMG(@"mapIcon_Time");
    [_downRoundedView addSubview:_timeView];
    //时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.text = @"时间：";
    _timeLabel.font = FontYT(14);
    _timeLabel.textColor = kColor;
    [_downRoundedView addSubview:_timeLabel];
    //具体的时间
    _timeContext = [[UILabel alloc] init];
    _timeContext.font = FontYT(14);
    _timeContext.numberOfLines = 1;
    _timeContext.lineBreakMode = NSLineBreakByTruncatingTail;
    _timeContext.textColor = kColor;
    [_downRoundedView addSubview:_timeContext];
    //余票图标
    _ticketView = [UIImageView new];
    _ticketView.image = IMG(@"mapIcon_Ticket");
    [_downRoundedView addSubview:_ticketView];
    //余票
    _ticketLabel = [[UILabel alloc] init];
    _ticketLabel.font = FontYT(14);
    [_downRoundedView addSubview:_ticketLabel];
    
    //按钮
    _lookupButton = [[UIButton alloc] init];
    [_lookupButton setTitle:@"查看" forState:UIControlStateNormal];
    [_lookupButton setTitleColor:kOrangeYellowColor forState:UIControlStateNormal];
    _lookupButton.titleLabel.font = FontYT(14);
    [_lookupButton addTarget:self action:@selector(enterDetailVC:) forControlEvents:UIControlEventTouchUpInside];
    [_downRoundedView addSubview:_lookupButton];
    
    //查看按钮上的图片
    CGFloat fontHeight = [UIToolClass fontHeight:FontYT(14)];
    UIImageView *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(70, (35-fontHeight)*0.5, fontHeight*0.5, fontHeight)];
    accessoryView.image = IMG(@"sh_icon_next");
    [_lookupButton addSubview:accessoryView];
}


- (void)initVenueSubViews
{
    // 添加标题
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ConvertSize(20), ConvertSize(20), self.frame.size.width- ConvertSize(110), ConvertSize(28))];
    _titleLabel.textColor = kColor;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    _titleLabel.numberOfLines = 0;
    _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self addSubview:self.titleLabel];
    
    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame)+ConvertSize(10), _titleLabel.frame.size.width, ConvertSize(30))];
    _subtitleLabel.textColor = kColor;
    _subtitleLabel.numberOfLines = 0;
    _subtitleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.subtitleLabel.font = FontYT(14);
    [self addSubview:self.subtitleLabel];
    
    _enterImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ConvertSize(35), ConvertSize(60))];
    _enterImage.image = IMG(@"sh_icon_next");
    [self addSubview:_enterImage];
    _calloutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ConvertSize(100), ConvertSize(100))];
    [self.calloutButton addTarget:self action:@selector(enterDetailVC:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_calloutButton];
    
    /*
     
     隐藏停车位界面里的按钮和图标，但是场馆列表地图页面需要显示这两个按钮
     
     */
    if ([_type isEqualToString:@"VenueMap"])
    {
        _calloutButton.hidden = NO;
        _enterImage.hidden = NO;
    }
    else
    {
        _calloutButton.hidden = YES;
        _enterImage.hidden = YES;
    }
}



- (void)setAnnotation:(CustomPointAnnotation *)annotation
{
    _annotation = annotation;
    
    if ([_type isEqualToString:@"Activity"])
    {
        [self setActivityAnnotation];
    }
    else
    {
        [self setVenueAnnotation];
    }
}


- (void)setActivityAnnotation
{
    int calloutViewWidth = kScreenWidth-ConvertSize(80);
    
    CGFloat picScale = 348/653.0;
    CGFloat edge = 15;
    
    //上边的视图
    _upRoundedView.frame = CGRectMake(0, 0, calloutViewWidth, calloutViewWidth*picScale);
    _picView.frame = _upRoundedView.frame;
    
    UIImage *placeholderImage = [UIToolClass getPlaceholderWithViewSize:_picView.viewSize centerSize:CGSizeMake(45, 45) isBorder:NO];
    _picView.image = roundedImageByInside(_picView.bounds.size, placeholderImage, kRoundedViewRadius);
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:JointedImageURL(_annotation.imageURL, kImageSize_750_500)] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
         _picView.image = roundedImageByInside(_picView.bounds.size, image, kRoundedViewRadius);
     }];
    
    //中间的分割线
    _colorView.frame = CGRectMake(0, _picView.bounds.size.height-1.5, _picView.bounds.size.width-2*kRoundedViewRadius, 3);
    _colorView.center = CGPointMake(_picView.center.x, _colorView.center.y);
    //标题
    
    _titleLabel.frame = CGRectMake(edge, edge, _picView.bounds.size.width-2*edge, [UIToolClass textHeight:_annotation.name font:FontYT(20) width:_picView.bounds.size.width-2*edge maxRow:2]);
    _titleLabel.text = _annotation.name;
    
    //标题按钮
    _titleButton.bounds = CGRectMake(0, 0, _picView.bounds.size.width, _titleLabel.bounds.size.height+2*13);
    _titleButton.center = _titleLabel.center;
    
    _addressContext.text = _annotation.address;
    _timeContext.text = _annotation.time;
    
    
    NSString *ticketNum = [NSString stringWithFormat:@"%d",(int)_annotation.ticket];
    NSMutableAttributedString *ticketStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"余票：%@",ticketNum]];
    [ticketStr addAttribute:NSForegroundColorAttributeName value:kColor range:NSMakeRange(0, 3)];
    [ticketStr addAttribute:NSForegroundColorAttributeName value:kOrangeYellowColor range:NSMakeRange(3, ticketStr.length-3)];
    _ticketLabel.attributedText = ticketStr;
    
    
    //地点
    _addressView.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleButton.frame), [UIToolClass fontHeight:FONT(14)], [UIToolClass fontHeight:FONT(14)]);
    _addressLabel.frame = CGRectMake(CGRectGetMaxX(_addressView.frame)+8, CGRectGetMinY(_addressView.frame), [UIToolClass textWidth:_addressLabel.text font:_addressLabel.font], [UIToolClass fontHeight:FONT(14)]);
    
    CGFloat width = _picView.bounds.size.width-2*edge-[UIToolClass fontHeight:FONT(14)]-[UIToolClass textWidth:_addressLabel.text font:_addressLabel.font]-8;
    CGFloat textHeight = [UIToolClass textHeight:_addressContext.text font:FONT(14) width:width maxRow:1];
    _addressContext.frame = CGRectMake(CGRectGetMaxX(_addressLabel.frame), CGRectGetMinY(_addressView.frame), width, textHeight);
    //时间
    _timeView.frame = CGRectMake(CGRectGetMinX(_addressView.frame), CGRectGetMaxY(_addressContext.frame)+10, _addressView.bounds.size.width,_addressView.bounds.size.height);
    _timeLabel.frame = CGRectMake(CGRectGetMinX(_addressLabel.frame), CGRectGetMinY(_timeView.frame), _addressLabel.bounds.size.width,_addressLabel.bounds.size.height);
    textHeight = [UIToolClass textHeight:_timeContext.text font:FONT(14) width:width maxRow:1];
    _timeContext.frame = CGRectMake(CGRectGetMinX(_addressContext.frame), CGRectGetMinY(_timeView.frame), width, textHeight);
    //余票
    if (_annotation.activityIsReservation)
    {
        _ticketView.frame = CGRectMake(edge, CGRectGetMaxY(_timeView.frame)+8, _timeView.bounds.size.width, _timeView.bounds.size.height);
        _ticketLabel.frame = CGRectMake(CGRectGetMaxX(_ticketView.frame)+8, CGRectGetMinY(_ticketView.frame), [UIToolClass attributedTextWidth:_ticketLabel.attributedText], _ticketView.bounds.size.height);
    }
    else
    {
        _ticketView.frame = CGRectMake(edge, CGRectGetMaxY(_timeView.frame)+8, _timeView.bounds.size.width, 0);
        _ticketLabel.frame = CGRectMake(CGRectGetMaxX(_ticketView.frame)+8, CGRectGetMinY(_ticketView.frame), [UIToolClass attributedTextWidth:_ticketLabel.attributedText], 0);
    }
    
    //查看按钮
    _lookupButton.frame = CGRectMake(_picView.bounds.size.width-100-10, CGRectGetMaxY(_ticketView.frame), 100, 35);
    
    //下边的视图
    _downRoundedView.frame = CGRectMake(0, calloutViewWidth*picScale, calloutViewWidth, CGRectGetMaxY(_lookupButton.frame)+15);
    
    CGRect rect = self.frame;
    rect.size.height = CGRectGetMaxY(_downRoundedView.frame);
    self.frame = rect;
}

- (void)setVenueAnnotation
{
    self.titleLabel.text = _annotation.name;
    self.subtitleLabel.text = _annotation.address;
    
    CGFloat biggerWidth = [self maxWidthWithString1:_titleLabel.text fontNum1:15 string2:_subtitleLabel.text fontNum2:14];
    CGFloat labelWidth = self.frame.size.width-ConvertSize(110);
    if (biggerWidth < labelWidth)
    {
        labelWidth = biggerWidth;
    }

    
    CGRect rect =  _titleLabel.frame;
    rect.size.width = labelWidth;
    rect.size.height = [UIToolClass textHeight:self.titleLabel.text font:FontYT(15) width:labelWidth];
    
    _titleLabel.frame = rect;
    
    rect =  _subtitleLabel.frame;
    rect.size.width = labelWidth;
    rect.origin.y = CGRectGetMaxY(_titleLabel.frame)+ConvertSize(10);
    rect.size.height = [UIToolClass textHeight:self.subtitleLabel.text font:FontYT(14) width:labelWidth];
    _subtitleLabel.frame = rect;
    
    rect = self.frame;
    rect.size.width = labelWidth+ConvertSize(110);
    rect.size.height = CGRectGetMaxY(_subtitleLabel.frame)+ ConvertSize(35);
    rect.origin.y = -(CGRectGetMaxY(_subtitleLabel.frame)+ ConvertSize(35));
    self.frame = rect;
    
    _enterImage.center = CGPointMake(self.frame.size.width-ConvertSize(52), (self.bounds.size.height-10)/2.0);
    _calloutButton.center = _enterImage.center;
}


#pragma mark - 点击进入详情

- (void)enterDetailVC:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(calloutView:didSelectedButton:)])
    {
        [_delegate calloutView:self didSelectedButton:sender];
    }
}



- (CGFloat)maxWidthWithString1:(NSString *)str1 fontNum1:(CGFloat)fontNum1 string2:(NSString *)str2 fontNum2:(CGFloat)fontNum2
{
    CGFloat width1 = [UIToolClass textWidth:str1 font:FontYT(fontNum1)];
    CGFloat width2 = [UIToolClass textWidth:str2 font:FontYT(fontNum2)];
    return width1 >= width2 ? width1 : width2;
}


- (void)drawRect:(CGRect)rect
{
    if ([_type isEqualToString:@"Venue"] || [_type isEqualToString:@"VenueMap"])
    {
        [self drawInContext:UIGraphicsGetCurrentContext()];
    }
    else
    {
        return;
    }
}

- (void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
}


- (void)getDrawPath:(CGContextRef)context
{
    
    
    
    CGRect rrect = self.bounds;
    CGFloat radius = 6;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)- kArrorHeight;
    
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}


@end
