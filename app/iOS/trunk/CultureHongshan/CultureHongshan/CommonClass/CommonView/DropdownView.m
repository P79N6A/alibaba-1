//
//  SelectBarViewController.m
//  徐家汇
//
//  Created by 李 兴 on 13-10-5.
//  Copyright (c) 2013年 李 兴. All rights reserved.
//

#import "DropdownView.h"
#import "ActivityFilterModel.h"
#define HEIGHT_TABLEVIEW    200
#define HEIGHT_TITLEVIEW    30
#define WIDTH_RADIUS  10
#define COLOR_BGCOLOR   RGB(38,38,38)
#define COLOR_CONTENT   RGB(0xa9, 0xc7, 255)


@interface DropdownView ()
{
    float viewHeight;
}

@end



@implementation DropdownView

-(id)initWithArray:(CGRect)frame   title:(NSString *)title  dataList:(NSArray * )dataList   delegate:(id<DropdownViewDelegate>)delegate
{
    if (self = [super init])
    {
        
        self.frame = frame;
        orgFrame = frame;
        _orgSuperWidth = 0;
        _selectMainCellIndex = -1;
        _selectSubCellIndex = -1;
        _delegate  = delegate;
        _isShrink = YES;
        _haveSubArray = NO;
        _orgTitle = title;
        _subTypeAry = [[NSMutableArray alloc] init];
        [self loadUI];
        [self updateDataList:dataList];
        [self initTableView];
        [self setTitleText:title];
        
        
    }
    return self;
}

-(void)updateDataList:(NSArray *)data
{
    _dataList = nil;
    if (data.count == 0)
    {
        return;
    }
    _dataList = data;
    superviewWidth = 115;
    if ([_dataList[0] isKindOfClass:[NSString class]])
    {
        _mainTitleArray = [NSMutableArray arrayWithArray:_dataList];
        _haveSubArray = NO;
    }
    else if ([_dataList[0] isKindOfClass:[AreaFilterListModel class]])
    {
        _mainTitleArray = [[NSMutableArray alloc] initWithCapacity:_dataList.count];
        for (AreaFilterListModel * mode  in _dataList)
        {
            [_mainTitleArray addObject:mode.conditionName];
            NSMutableArray * subarray = [NSMutableArray new];
            for (AreaFilterListModel * subarea in mode.listArray)
            {
                [subarray addObject:subarea.conditionName];
            }
            [_subTypeAry addObject:subarray];
        }
        _haveSubArray = YES;
        superviewWidth = 225;
    }
    else
    {
        _mainTitleArray = [[NSMutableArray alloc] initWithCapacity:_dataList.count];
        for (NSDictionary * dic in _dataList)
        {
            
            NSArray * ary =  dic.allKeys;
            if (ary.count == 1)
            {
                NSString * str = ary[0];
                [_mainTitleArray addObject:str];
                NSArray * subary = dic[str];
                [_subTypeAry addObject:subary];
                if (subary && subary.count > 0)
                {
                    _haveSubArray = YES;
                    superviewWidth = 225;
                }
            }
            
        }
    }
}


-(void)restoreDefault
{
    [self setTitleText:_orgTitle];
    if (_haveSubArray)
    {
        [_subTableViewBgView removeFromSuperview];
        _subTitleArray = _subTypeAry[0];
        [_subtitleTableView reloadData];
    }
    if(_lastMainSelectedCell)
    {
        _lastMainSelectedCell.backgroundColor = COLOR_CLEAR;
        if (_lastMainSelectedCell.contentView.subviews.count > 0)
        {
            UILabel * label = (_lastMainSelectedCell.contentView.subviews)[0];
            label.textColor = COLOR_IWHITE;
        }
    }
}

-(void)initTableView
{
    if (_dataList == nil || _dataList.count == 0)
    {
        return;
    }
    viewHeight = (_dataList.count + 1) * 30 + 20;
    if (viewHeight > HEIGHT_TABLEVIEW)
    {
        viewHeight = HEIGHT_TABLEVIEW;
    }
    
    
    _maintitleTableView = [UITableView new];
    _maintitleTableView.scrollsToTop = NO;
    _maintitleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _maintitleTableView.delegate = self;
    _maintitleTableView.dataSource = self;
    _maintitleTableView.backgroundColor = COLOR_CLEAR;
    
    if (_haveSubArray)
    {
        _subTableViewBgView = [UIView new];
        _subTableViewBgView.backgroundColor = RGB(0x26, 0x26, 0x26);
        _subTableViewBgView.radius = WIDTH_RADIUS;
        
        _subtitleTableView = [UITableView new];
        _subtitleTableView.scrollsToTop = NO;
        _subtitleTableView.delegate = self;
        _subtitleTableView.dataSource = self;
        _subtitleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _subtitleTableView.backgroundColor = COLOR_CLEAR;
        [_subTableViewBgView addSubview:_subtitleTableView];
        _subTableViewBgView.clipsToBounds = YES;
        _subTableViewBgView.frame = MRECT(superviewWidth/5*2, 0, superviewWidth/5*3, viewHeight);
        _subtitleTableView.frame  = MRECT(0, HEIGHT_TITLEVIEW, _subTableViewBgView.width, _subTableViewBgView.height - HEIGHT_TITLEVIEW - 5);
        
    }
    
}

-(NSString *)getTitleText
{
    return _titleLabelButton.titleLabel.text;
}

-(void)setTitleText:(NSString *)title
{
    [_titleLabelButton setTitle:title forState:UIControlStateNormal];
    
}

- (void)loadUI
{
    _titleLabelButton = [[UIButton alloc ]initWithFrame:MRECT(0, 0, self.frame.size.width*0.8, HEIGHT_TITLEVIEW)];
    [_titleLabelButton setTitleColor:COLOR_IWHITE forState:UIControlStateNormal];
    _titleLabelButton.titleLabel.font = FONT(14);
    [_titleLabelButton addTarget:self action:@selector(process) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_titleLabelButton];
    
    arrowButton = [[UIButton alloc] initWithFrame:MRECT(self.frame.size.width*0.8, 0, self.frame.size.width*0.2, HEIGHT_TITLEVIEW)];
    [arrowButton  addTarget:self action:@selector(process) forControlEvents:UIControlEventTouchUpInside];
    [arrowButton setImage:IMG(@"arrow_down_lightGray") forState:UIControlStateNormal];
    [self addSubview:arrowButton];
}


-(void)process
{
    if (_isShrink)
    {
        [self expandDropView];
    }
    else
    {
        [self shrinkDropView];
    }
}

#pragma mark --------table view delegate--------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * title = nil;
    NSInteger rowidx = indexPath.row;
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (tableView == _maintitleTableView)
    {
        _selectMainCellIndex = rowidx;
        NSString * t = _mainTitleArray[rowidx];
        if([t isEqualToString:[NSString stringWithFormat:@"全%@", CITY_NAME]])
        {
            title = t;
            _subtitleTableView.hidden = YES;
        }
        else
        {
            _subtitleTableView.hidden = NO;
        }
        if(_haveSubArray)
        {
            _subTitleArray = _subTypeAry[rowidx];
            _selectSubCellIndex = -1;
            [_subtitleTableView reloadData];
            
            if(_lastMainSelectedCell)
            {
                _lastMainSelectedCell.backgroundColor = COLOR_CLEAR;
            }
            cell.backgroundColor = COLOR_BGCOLOR;
        }
        else
        {
            
            if (_lastMainSelectedCell && _lastMainSelectedCell.contentView.subviews.count > 0)
            {
                UILabel * label = _lastMainSelectedCell.contentView.subviews[0];
                label.textColor = COLOR_IWHITE;
            }
            if (cell && cell.contentView.subviews.count > 0)
            {
                UILabel * label = cell.contentView.subviews[0];
                label.textColor = COLOR_CONTENT;
            }
            title = t;
        }
        _lastMainSelectedCell = cell;
    }
    else
    {
        _selectSubCellIndex = rowidx;
        if(_lastSubSelectedCell)
        {
            if (_lastSubSelectedCell.contentView.subviews.count > 0)
            {
                UILabel * label = (_lastSubSelectedCell.contentView.subviews)[0];
                label.textColor = COLOR_IWHITE;
            }
            
        }
        if (cell.contentView.subviews.count > 0)
        {
            UILabel * label = (cell.contentView.subviews)[0];
            label.textColor = COLOR_CONTENT;
        }
        
        title = _subTitleArray[rowidx];
        _lastSubSelectedCell = cell;
    }
    
    if (title)
    {
        if ([title isEqualToString:@"**"]) {
            title = [NSString stringWithFormat:@"全%@", CITY_NAME];
        }
        [_titleLabelButton setTitle:title forState:UIControlStateNormal];
        [self shrinkDropView];
        
    }
    if (_delegate && title && [_delegate respondsToSelector:@selector(dropdownView:result:)])
    {
        [_delegate dropdownView:self result:title];
        
    }
    
}

-(void)expandDropView
{
    if (_isShrink == NO)
    {
        return;
    }
    
    if (_dataList == nil || _dataList.count == 0)
    {
        return;
    }
    self.superview.alpha = 0.95;
    if (_orgSuperWidth == 0)
    {
        _orgSuperWidth = self.superview.frame.size.width;
        _orginArrowButtonPosition = [arrowButton convertRect:arrowButton.bounds toView:self.superview];
        self.superview.clipsToBounds = YES;
    }
    
    
    _maintitleTableView.frame = MRECT(0, HEIGHT_TITLEVIEW, superviewWidth,0);
    [self.superview insertSubview:_maintitleTableView atIndex:999];
    CGRect ff = [arrowButton convertRect:arrowButton.bounds toView:self.superview];
    [self.superview addSubview:arrowButton];
    arrowButton.frame = ff;
    
    WS(weakSelf);
    [UIView animateWithDuration:.5 animations:^{
        
        [weakSelf.superview mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.equalTo(@(viewHeight));
            make.width.equalTo(@(superviewWidth));
        }];
        [weakSelf.superview layoutIfNeeded];
        
        //self.superview.frame = MRECT((WIDTH_SCREEN-superviewWidth)/2, self.superview.frame.origin.y, superviewWidth, viewHeight);
        arrowButton.transform   = CGAffineTransformMakeRotation(M_PI);
        arrowButton.center = CGPointMake(self.superview.frame.size.width/2, HEIGHT_TITLEVIEW/2);
        _titleLabelButton.alpha = 0.;
        _maintitleTableView.viewSize = CGSizeMake(superviewWidth, viewHeight - HEIGHT_TITLEVIEW - 10);
        
        if (_haveSubArray)
        {
            [weakSelf.superview insertSubview:_subTableViewBgView aboveSubview:_maintitleTableView];
            if(_subTitleArray == nil)
            {
                _subTitleArray = _subTypeAry[0];
            }
            _subTableViewBgView.frame = MRECT(superviewWidth/5*2, 0, superviewWidth/5*3, viewHeight);
            [_subtitleTableView reloadData];
            
        }
        
        for (UIView * view in weakSelf.superview.subviews)
        {
            if ([view isKindOfClass:[DropdownView class]] || [view isKindOfClass:[UIImageView class]])
            {
                view.alpha = 0.f;
            }
        }
    } completion:^(BOOL finished) {
        arrowButton.frame = MRECT(0, 0, superviewWidth, HEIGHT_TITLEVIEW);
        _isShrink = NO;
    }];
}

-(void)shrinkDropView
{
    if (_isShrink == NO)
    {
        if (_dataList == nil || _dataList.count == 0)
        {
            return;
        }
        self.superview.alpha = 0.75;
        arrowButton.frame = MRECT((self.superview.frame.size.width - arrowButton.frame.size.width)/2, 0, arrowButton.frame.size.width, HEIGHT_TITLEVIEW);
        
        
        WS(weakSelf);
        [UIView animateWithDuration:.5 animations:^{
            
            [weakSelf.superview mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.equalTo(@(HEIGHT_TITLEVIEW));
                make.width.equalTo(@(_orgSuperWidth));
            }];
            [weakSelf.superview layoutIfNeeded];
            
            arrowButton.transform   = CGAffineTransformMakeRotation(0);
            arrowButton.frame = _orginArrowButtonPosition;
            _titleLabelButton.alpha = 1;
            if (_haveSubArray)
            {
                _subTableViewBgView.viewSize = CGSizeMake(_orgSuperWidth/5*3,0);
            }
            for (DropdownView * view in weakSelf.superview.subviews)
            {
                view.alpha = 1.f;
            }
        } completion:^(BOOL finished)
         {
             _isShrink = YES;
             
             [weakSelf addSubview:arrowButton];
             arrowButton.frame = MRECT(weakSelf.frame.size.width*0.8, 0, weakSelf.frame.size.width*0.2, HEIGHT_TITLEVIEW);
             
             if (_haveSubArray)
             {
                 [_subTableViewBgView removeFromSuperview];
             }
             [_maintitleTableView removeFromSuperview];
             
         }];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return self.frame.size.height;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _maintitleTableView)
    {
        return _mainTitleArray.count;
    }
    else
    {
        return _subTitleArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell  * cell  = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    NSInteger rowidx = indexPath.row;
    
    UILabel * content = [[UILabel alloc] init];
    content.font = FONT(14);
    content.textColor  = COLOR_IWHITE;
    content.backgroundColor = COLOR_CLEAR;
    if (rowidx >= 0)
    {
        if (tableView  == _maintitleTableView)
        {
            content.frame = CGRectMake(20, 0, self.superview.frame.size.width - 40,self.frame.size.height);
            if(_haveSubArray)
            {
                content.textAlignment = NSTextAlignmentLeft;
                if (rowidx == _selectMainCellIndex)
                {
                    cell.backgroundColor = COLOR_BGCOLOR;
                }
            }
            else
            {
                content.textAlignment = NSTextAlignmentCenter;
                if (rowidx == _selectMainCellIndex)
                {
                    content.textColor = COLOR_CONTENT;
                }
            }
            content.text = _mainTitleArray[rowidx];
        }
        else
        {
            content.backgroundColor = COLOR_CLEAR;
            content.frame = CGRectMake(15, 0, _subTableViewBgView.width - 30,self.frame.size.height);
            NSString *title = _subTitleArray[rowidx];
            if ([title isEqualToString:@"**"]) {
                title = @"  ";
            }
            content.text = title;
            if (rowidx == _selectSubCellIndex)
            {
                content.textColor = COLOR_CONTENT;
            }
        }
        [cell.contentView addSubview:content];
    }
    cell.backgroundColor = COLOR_CLEAR;
    return cell;
    
    
}
@end
