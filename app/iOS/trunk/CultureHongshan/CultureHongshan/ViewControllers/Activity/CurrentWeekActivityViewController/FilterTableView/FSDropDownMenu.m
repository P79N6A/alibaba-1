//
//  FSDropDownMenu.m
//  FSDropDownMenu
//
//  Created by xiang-chen on 14/12/17.
//  Copyright (c) 2014年 chx. All rights reserved.
//

#import "FSDropDownMenu.h"


#import "VenueListViewController.h"

#import "DropDownMenuTableViewCell.h"

#import "DropDownMenuMultipleButtonsCell.h"


#define kScale 0.38


static NSString *reuseID = @"DropDownMenuCell";
static NSString *reuseID_MultipleButtons = @"MultipleButtonsCell";

@interface FSDropDownMenu()
{
    NSInteger _leftSelectedRow;
}

@property (nonatomic, assign) BOOL show;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIView *backGroundView;

@end

@implementation FSDropDownMenu

#pragma mark - init method
- (instancetype)initWithOrigin:(CGPoint)origin type:(DropDownMenuType)type andHeight:(CGFloat)height
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, 0)];
    if (self)
    {
        _type = type;
        
        _rightSelectedRow = 0;
        
        _origin = origin;
        _show = NO;
        _height = height;
        
        [self initSelectedStatus];
        
        //tableView init
        
        if (type == DropDownMenuTypeOne)
        {
            _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, 0, 0) style:UITableViewStylePlain];
            
            
            _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x+kScreenWidth, self.frame.origin.y + self.frame.size.height, kScreenWidth, 0) style:UITableViewStylePlain];
        }
        else
        {
            _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, kScreenWidth*kScale, 0) style:UITableViewStylePlain];
            
            _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x+kScreenWidth*kScale, self.frame.origin.y + self.frame.size.height, kScreenWidth*(1-kScale), 0) style:UITableViewStylePlain];
        }
        
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        _leftTableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.f];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_leftTableView registerClass:[DropDownMenuTableViewCell class] forCellReuseIdentifier:reuseID];
        [_rightTableView registerClass:[DropDownMenuTableViewCell class] forCellReuseIdentifier:reuseID];
        
        [_rightTableView registerClass:[DropDownMenuMultipleButtonsCell class] forCellReuseIdentifier:reuseID_MultipleButtons];
        
        //self tapped
        self.backgroundColor = [UIColor whiteColor];
        
        //background init and tapped
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, screenSize.height)];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        //        _backGroundView.opaque = NO;
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
        [_backGroundView addGestureRecognizer:gesture];
    }
    return self;
}



- (void)initSelectedStatus
{
    _rightSelectedRow = -1;
    _selectedConditionIndex = -1;
    _selectedWeekIndex = -1;
}


//初始化筛选下拉表下方的两个重置和确定按钮
- (void)initResetAndCertainButton
{
    //重置
    UIButton *resetButton = [[UIButton alloc] initWithFrame:CGRectMake(ConvertSize(115), _height-40-36, ConvertSize(230), 36)];
    resetButton.backgroundColor = kThemeDeepColor;
    resetButton.titleLabel.font = FONT(17);
    [resetButton setTitle:@"重置" forState:UIControlStateNormal];
    [resetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    resetButton.tag = 1;
    [resetButton addTarget:self action:@selector(resetAndCertainButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:resetButton];
    
    
    UIButton *certainButton = [[UIButton alloc] initWithFrame:CGRectMake(ConvertSize(405), _height-40-36, ConvertSize(230), 36)];
    certainButton.backgroundColor = kThemeDeepColor;
    certainButton.titleLabel.font = FONT(17);
    [certainButton setTitle:@"确定" forState:UIControlStateNormal];
    [certainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    certainButton.tag = 2;
    [certainButton addTarget:self action:@selector(resetAndCertainButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:certainButton];
}

#pragma mark - gesture handle

- (void)menuTapped
{
    
    
    [self animateBackGroundView:self.backGroundView show:!_show complete:^
     {
         [self animateTableViewShow:!_show complete:^
          {
              _show = !_show;
          }];
     }];
    
}

- (void)backgroundTapped:(UITapGestureRecognizer *)paramSender
{
//    VenueListViewController *vc = (VenueListViewController *)[UIToolClass getViewControllerFromView:self];
//    if (vc) {
//        
//        NSInteger index = -1;
//        if ([_identifier isEqualToString:kMenuId_Nearby]) {
//            index = 0;
//        }else if ([_identifier isEqualToString:kMenuId_AllCategories]){
//            index = 1;
//        }
//        else if ([_identifier isEqualToString:kMenuId_SmartSorting]){
//            index = 2;
//        }
//        else if ([_identifier isEqualToString:kMenuId_Filter]){
//            index = 3;
//        }
//        [vc changeFilterViewArrowDirectionWithIndex:index isDown:YES];
//    }
//    
//    [self animateBackGroundView:_backGroundView show:NO complete:^{
//        [self animateTableViewShow:NO complete:^{
//            _show = NO;
//        }];
//    }];
}

#pragma mark - animation method


- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void(^)())complete
{
    if (show)
    {
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        }];
    } else
    {
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    
    complete();
}

- (void)animateTableViewShow:(BOOL)show complete:(void(^)())complete
{
    if (show)
    {
        if (_type == DropDownMenuTypeOne)
        {
            _leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y, 0, 0);
            _rightTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y, kScreenWidth, 0);
        }
        else
        {
            _leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y, kScreenWidth*kScale, 0);
            _rightTableView.frame = CGRectMake(self.origin.x+kScreenWidth*kScale, self.frame.origin.y, kScreenWidth*(1-kScale), 0);
        }
        
        [self.superview addSubview:_leftTableView];
        
        [self.superview addSubview:_rightTableView];
        
        _leftTableView.alpha = 1.f;
        _rightTableView.alpha = 1.f;
        [UIView animateWithDuration:0.2 animations:^{
            
            _leftTableView.height = _height;
            _rightTableView.height = _height;
            
            if (self.transformView)
            {
                self.transformView.transform = CGAffineTransformMakeRotation(M_PI);
            }
        } completion:^(BOOL finished) {
            
        }];
    } else {
        
        [UIView animateWithDuration:0.2 animations:^{
            _leftTableView.alpha = 0.f;
            _rightTableView.alpha = 0.f;
            if (self.transformView) {
                self.transformView.transform = CGAffineTransformMakeRotation(0);
            }
        } completion:^(BOOL finished)
         {
             [_leftTableView removeFromSuperview];
             [_rightTableView removeFromSuperview];
         }];
    }
    complete();
}


#pragma mark - table datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSAssert(self.dataSource != nil, @"menu's dataSource shouldn't be nil");
    
    if ([self.dataSource respondsToSelector:@selector(menu:tableView:numberOfRowsInSection:)])
    {
        return [self.dataSource menu:self tableView:tableView
               numberOfRowsInSection:section];
    }
    else
    {
        NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *titleStr = nil;
    if ([self.dataSource respondsToSelector:@selector(menu:tableView:titleForRowAtIndexPath:)])
    {
        titleStr = [self.dataSource menu:self tableView:tableView titleForRowAtIndexPath:indexPath];
    }
    
    if ([self.identifier isEqualToString:kMenuId_Nearby] || [self.identifier isEqualToString:kMenuId_SmartSorting])//附近或排序
    {
        DropDownMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
        cell.titleLabel.frame = CGRectMake(33, 0, cell.bounds.size.width-33, cell.bounds.size.height);
        cell.lineView.frame = CGRectMake(20, cell.bounds.size.height-1, cell.bounds.size.width-20, 1);
        cell.titleLabel.text = titleStr;
        
        if(tableView == _rightTableView)
        {
            cell.backgroundColor = [UIColor whiteColor];
            cell.lineView.hidden = NO;
            if (indexPath.row == _rightSelectedRow)
            {
                cell.titleLabel.textColor = kNavigationBarColor;
            }
            else
            {
                cell.titleLabel.textColor = ColorFromHex(@"666666");
            }
            
            if ([titleStr isEqualToString:@"**"])// 全[城市名]，隐藏分割线
            {
                cell.titleLabel.hidden = YES;
                cell.lineView.hidden = YES;
            }
            else
            {
                cell.titleLabel.hidden = NO;
            }
            
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        else
        {
            if (indexPath.row == _leftSelectedRow)
            {
                cell.contentView.backgroundColor = [UIColor whiteColor];
            }
            else
            {
                cell.contentView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.000];
            }
            cell.titleLabel.backgroundColor = [UIColor clearColor];
            cell.titleLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];
            cell.lineView.hidden = YES;
        }
        
        return cell;
    }
    else if ([self.identifier isEqualToString:kMenuId_AllCategories])//分类
    {
        DropDownMenuMultipleButtonsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_MultipleButtons forIndexPath:indexPath];
        cell.onlyWeekendButton.hidden = YES;
        cell.titleButton.index = ButtonIndexMake(indexPath.row, 0);
        cell.titleButton.titleLabel.font = FONT(17);
        [cell.titleButton setTitle:@"全部" forState:UIControlStateNormal];
        cell.titleButton.frame = CGRectMake(15, 28, (kScreenWidth-2*15-3*8)*0.25, 38);
        cell.titleButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.lineView.originalY = cell.titleButton.maxY + 24;
        
        [cell setTitleString:titleStr withSection:0 spacing:20];
        
        for (ExtendedButton *btn in cell.contentView.subviews)
        {
            if ([btn isKindOfClass:[ExtendedButton class]])
            {
                [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }
        return cell;
    }
    else//筛选
    {
        DropDownMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
        cell.titleLabel.frame = CGRectMake(33, 0, cell.bounds.size.width-33, cell.bounds.size.height);
        cell.lineView.frame = CGRectMake(20, cell.bounds.size.height-1, cell.bounds.size.width-20, 1);
        cell.titleLabel.text = titleStr;
        
        if(tableView == _rightTableView)
        {
            cell.backgroundColor = [UIColor whiteColor];
            cell.lineView.hidden = NO;
            if (indexPath.row == _rightSelectedRow)
            {
                cell.titleLabel.textColor = kNavigationBarColor;
            }
            else
            {
                cell.titleLabel.textColor = ColorFromHex(@"666666");
            }
            if ([titleStr isEqualToString:@"**"]) // 全[城市名]，隐藏分割线
            {
                cell.titleLabel.hidden = YES;
                cell.lineView.hidden = YES;
            }
            else
            {
                cell.titleLabel.hidden = NO;
            }
            
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        else
        {
            if (indexPath.row == _leftSelectedRow)
            {
                cell.contentView.backgroundColor = [UIColor whiteColor];
            }
            else
            {
                cell.contentView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.000];
            }
            cell.titleLabel.backgroundColor = [UIColor clearColor];
            cell.titleLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];
            cell.lineView.hidden = YES;
        }
        
        return cell;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource respondsToSelector:@selector(menu:tableView:heightForRowAtIndexPath:)])
    {
        return [_dataSource menu:self tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    else
    {
        NSAssert(0 == 1, @"dataSource method needs to be implemented");
    }
    
    return 44;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_identifier isEqualToString:kMenuId_AllCategories])
    {
        return;
    }
    
    if (self.delegate || [self.delegate respondsToSelector:@selector(menu:tableView:didSelectRowAtIndexPath:)])
    {
        if (tableView == self.rightTableView)
        {
            [self animateBackGroundView:_backGroundView show:NO complete:^{
                [self animateTableViewShow:NO complete:^{
                    _show = NO;
                }];
            }];
            //            [self menuTapped];
            _rightSelectedRow = indexPath.row;
        }
        else
        {
            _rightSelectedRow = -1;
            _leftSelectedRow = indexPath.row;
            
            
            if ([_identifier isEqualToString:kMenuId_Nearby] && indexPath.row == 0)
            {
                [self animateBackGroundView:_backGroundView show:NO complete:^{
                    [self animateTableViewShow:NO complete:^{
                        _show = NO;
                    }];
                }];
            }
        }
        [tableView reloadData];
        [self.delegate menu:self tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    else
    {
        //TODO: delegate is nil
    }
}



- (void)buttonClick:(ExtendedButton *)button
{
    if ([_identifier isEqualToString:kMenuId_AllCategories])//分类
    {
        UIView *btnSuperView = button.superview;
        
        ExtendedButton *lastButton = [btnSuperView viewWithTag:99+_rightSelectedRow];
        lastButton.layer.borderColor = ColorFromHex(@"C8C8C8").CGColor;
        lastButton.backgroundColor = [UIColor clearColor];
        [lastButton setTitleColor:ColorFromHex(@"666666") forState:UIControlStateNormal];
        
        button.layer.borderColor = kNavigationBarColor.CGColor;
        button.backgroundColor = kNavigationBarColor;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (button.index.tag > 99)
        {
            _rightSelectedRow = (int)button.index.tag-99;
        }
        else
        {
            _rightSelectedRow = 0;
        }
        
        [self.delegate menu:self tableView:self.rightTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag-99 inSection:0]];
        
        [self menuTapped];
    }
    else//筛选
    {
        if (button.index.tag > 99)
        {
            if (button.index.row == 0)//日期
            {
                if (button.index.tag == _rightSelectedRow + 100 && button.selected == YES)//按钮已经被选中,需要取消选中
                {
                    button.layer.borderColor = ColorFromHex(@"C8C8C8").CGColor;
                    button.backgroundColor = [UIColor clearColor];
                    [button setTitleColor:ColorFromHex(@"666666") forState:UIControlStateNormal];
                    button.selected = NO;
                    _rightSelectedRow = -1;
                    return;
                }
                
                UIView *btnSuperView = button.superview;
                
                if (_rightSelectedRow > -1)
                {
                    ExtendedButton *lastButton = [btnSuperView viewWithTag:100+_rightSelectedRow];
                    lastButton.selected = NO;
                    lastButton.layer.borderColor = ColorFromHex(@"C8C8C8").CGColor;
                    lastButton.backgroundColor = [UIColor clearColor];
                    [lastButton setTitleColor:ColorFromHex(@"666666") forState:UIControlStateNormal];
                }
                
                button.layer.borderColor = kNavigationBarColor.CGColor;
                button.backgroundColor = kNavigationBarColor;
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.selected = YES;
                _rightSelectedRow = button.index.tag-100;
            }
            else if (button.index.row == 1)//状态
            {
                
                if (button.index.tag == _selectedConditionIndex + 100 && button.selected == YES)//按钮已经被选中,需要取消选中
                {
                    button.selected = NO;
                    button.layer.borderColor = ColorFromHex(@"C8C8C8").CGColor;
                    button.backgroundColor = [UIColor clearColor];
                    [button setTitleColor:ColorFromHex(@"666666") forState:UIControlStateNormal];
                    _selectedConditionIndex = -1;
                    return;
                }
                
                UIView *btnSuperView = button.superview;
                
                if (_selectedConditionIndex > -1)
                {
                    ExtendedButton *lastButton = [btnSuperView viewWithTag:100+_selectedConditionIndex];
                    lastButton.selected = NO;
                    lastButton.layer.borderColor = ColorFromHex(@"C8C8C8").CGColor;
                    lastButton.backgroundColor = [UIColor clearColor];
                    [lastButton setTitleColor:ColorFromHex(@"666666") forState:UIControlStateNormal];
                }
                
                button.selected = YES;
                button.layer.borderColor = kNavigationBarColor.CGColor;
                button.backgroundColor = kNavigationBarColor;
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _selectedConditionIndex = (int)button.index.tag-100;
            }
            else//其它: 工作日、周末
            {
                if (button.index.tag == _selectedWeekIndex + 100 && button.selected == YES)//按钮已经被选中,需要取消选中
                {
                    button.selected = NO;
                    button.layer.borderColor = ColorFromHex(@"C8C8C8").CGColor;
                    button.backgroundColor = [UIColor clearColor];
                    [button setTitleColor:ColorFromHex(@"666666") forState:UIControlStateNormal];
                    _selectedWeekIndex = -1;
                    return;
                }
                
                UIView *btnSuperView = button.superview;
                
                if (_selectedWeekIndex > -1)
                {
                    ExtendedButton *lastButton = [btnSuperView viewWithTag:100+_selectedWeekIndex];
                    lastButton.selected = NO;
                    lastButton.layer.borderColor = ColorFromHex(@"C8C8C8").CGColor;
                    lastButton.backgroundColor = [UIColor clearColor];
                    [lastButton setTitleColor:ColorFromHex(@"666666") forState:UIControlStateNormal];
                }
                
                button.selected = YES;
                button.layer.borderColor = kNavigationBarColor.CGColor;
                button.backgroundColor = kNavigationBarColor;
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _selectedWeekIndex = (int)button.index.tag-100;
            }
        }
    }
}


- (void)resetAndCertainButtonClick:(UIButton *)sender
{
    if (sender.tag == 1)//重置
    {
        [self initSelectedStatus];
        [self.rightTableView reloadData];
    }
    else if (sender.tag == 2)//确定
    {
        FBLOG(@"确定");
        if (_delegate && [_delegate respondsToSelector:@selector(menu:tableView:didSelectRowAtIndexPath:)])
        {
            [self.delegate menu:self tableView:self.rightTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
        [self menuTapped];
    }
}


@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
