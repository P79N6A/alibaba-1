//
//  VenueAntiqueViewController.m
//  CultureHongshan
//
//  Created by one on 15/11/20.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "VenueAntiqueViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MJRefresh.h"

#import "AntiqueDetailViewController.h"

#import "AntiqueListCell.h"
#import "AntiqueModel.h"

#import "AnimationBackView.h"

@interface VenueAntiqueViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>
{
    UICollectionView *_collectionView;
    CGFloat _cellHeight;
    UICollectionReusableView *_headerBackView;
    
    UITableView *_dropDownTableView;
    
    UIImageView *timeImgView;
    UIButton *timeBtn;
    
    UIImageView *typeImgView;
    UIButton *typeBtn;
    
//    NSInteger collIndex;
//    NSInteger collPagNum;
    NSInteger _typeIndexPath;
    NSInteger _dyNastyIndexPath;
    
    NSArray *ceollerData;
    AnimationBackView *_animationView;
}

@property (nonatomic, strong)NSArray *centerArray;//内容
@property (nonatomic, strong)NSMutableArray *typeArray;//类别
@property (nonatomic, strong)NSMutableArray *dyNastyArray;//朝代
@property (nonatomic, getter=mutableCopy) BOOL isFish;

@property (nonatomic, copy) NSString *typeString;
@property (nonatomic, copy) NSString *dyNastyString;

@end


#define cellID @"AntiqueListCell"
#define headerView @"HeaderBackView"

@implementation VenueAntiqueViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"藏品展示";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBgColor;
    
    _typeIndexPath = 0;
    _dyNastyIndexPath = 0;
    
    [self loadCollectionView];
    
    _animationView = [[AnimationBackView alloc] initAnimationWithFrame:CGRectMake(0, 0, 100, 80)];
    [_animationView beginAnimationView];
    [self.view addSubview:_animationView];
    _animationView.center = CGPointMake(self.view.center.x, kScreenHeight/2-40);
    [self.view bringSubviewToFront:_animationView];
    
    [self loadCeollertData];
    
    
    _dropDownTableView = [[UITableView alloc] init];
    _dropDownTableView.frame = CGRectMake(10, HEIGHT_TOP_BAR + 2, kScreenWidth-20, 0);
    _dropDownTableView.delegate = self;
    _dropDownTableView.dataSource = self;
    [self.view addSubview:_dropDownTableView];
    
    [UIToolClass setupDontAutoAdjustContentInsets:_dropDownTableView forController:nil];
    
}



#pragma -mark 加载视图
-(void)loadCollectionView
{
    UICollectionViewFlowLayout *fLayout = [[UICollectionViewFlowLayout alloc] init];
    [fLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:fLayout];
    _collectionView.hidden = YES;
    _collectionView.backgroundColor = [UIColor colorWithRed:235/255.f green:239/255.f blue:241/255.f alpha:1.0];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[AntiqueListCell class] forCellWithReuseIdentifier:cellID];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerView];
    
    [_collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma  -mark 加载数据
-(void)loadCeollertData
{
//    [SVProgressHUD showWithStatus:@"正在加载中..."];
    [AppProtocol getAntiqueListWithVenueId:self.venueId pageIndex:0 pageNum:999 cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
//        [SVProgressHUD dismiss];
        if (responseCode == HttpResponseSuccess) {
            _animationView.isLoadAnimation = YES;
            _collectionView.hidden = NO;
            ceollerData = (NSArray *)responseObject;
            _centerArray = ceollerData[0];
            _typeArray = ceollerData[1];
            _dyNastyArray = ceollerData[2];
            
            [_collectionView reloadData];
            
        }else{
            [_animationView shutTimer];
            
            if (ceollerData.count > 0) {
                [SVProgressHUD showErrorWithStatus:responseObject];
            }else {
                [_animationView setAnimationLabelTextString:responseObject];
            }
        }
    }];
}

#pragma -mark UICollectionViewDataSoure
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_centerArray.count>0) {
        return _centerArray.count;
    }else{
        return 0;
    }
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AntiqueListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if (_centerArray.count > 0)
    {
        AntiqueModel *model = _centerArray[indexPath.row];
        
        [cell setModel:model forIndexPath:indexPath];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        _headerBackView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerView forIndexPath:indexPath];
        [_headerBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        
        typeBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, (kScreenWidth-20)/2-1, _headerBackView.frame.size.height-10)];
        typeBtn.tag = 188;
        [typeBtn setBackgroundImage:IMG(@"typeBtn_normal") forState:UIControlStateNormal];
        [typeBtn setTitle:@"类别" forState:UIControlStateNormal];
        [typeBtn setTitleColor:COLOR_IBLACK forState:UIControlStateNormal];
        [typeBtn addTarget:self action:@selector(dropDownClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headerBackView addSubview:typeBtn];
        
        typeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 12)];
        typeImgView.image = IMG(@"downPull_blue");
        typeImgView.center = CGPointMake(typeBtn.center.x+20, typeBtn.frame.size.height/2);
        [typeBtn addSubview:typeImgView];
        
        
        timeBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(typeBtn.frame)+1, 10, (kScreenWidth-20)/2-1, _headerBackView.frame.size.height-10)];
        timeBtn.tag = 199;
        [timeBtn setBackgroundImage:IMG(@"timeBtn_normal") forState:UIControlStateNormal];
        [timeBtn setTitle:@"朝代" forState:UIControlStateNormal];
        [timeBtn setTitleColor:COLOR_IBLACK forState:UIControlStateNormal];
        [timeBtn addTarget:self action:@selector(dropDownClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headerBackView addSubview:timeBtn];
        
        timeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(timeBtn.frame.size.width/2.0+[UIToolClass textWidth:@"代" font:FontYT(17)], 0, 20, 12)];
        timeImgView.image = IMG(@"downPull_blue");
        [timeBtn addSubview:timeImgView];
        timeImgView.center = CGPointMake(timeImgView.center.x+3, timeBtn.frame.size.height/2.0);
        reusableView = _headerBackView;
    }else {
        reusableView = [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }
    
    return reusableView;
}

#pragma -mark UICollectionViewDelegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_centerArray.count > 0) {
        CGFloat width = (kScreenWidth-30)/2;
        CGFloat height = 10 + (width-20)*0.667 + 30;
        return CGSizeMake(width, height);
    }else{
        return CGSizeMake(0, 0);
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth, 57);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WEAK_VIEW(_dropDownTableView);
    [UIView animateWithDuration:0.3 animations:^{
        weakView.height = 0;
    }];
    
    if (_centerArray.count > 0) {
        AntiqueModel *model = _centerArray[indexPath.row];
        AntiqueDetailViewController *ceollerDetailVC = [[AntiqueDetailViewController alloc] init];
        ceollerDetailVC.antiqueId = model.antiqueId;
        [self.navigationController pushViewController:ceollerDetailVC animated:YES];
    }
    
}

#pragma -mark UICollectionViewDelegateFlowLayout
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma -mark 下拉事件
-(void)dropDownClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    switch (btn.tag) {
        case 188:
        {
            _isFish = YES;
            [typeBtn setBackgroundImage:IMG(@"typeBtn_selecd") forState:UIControlStateNormal];
            [typeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            if (btn.selected) {
                typeImgView.image = IMG(@"upPull_white");
                [UIView animateWithDuration:0.3 animations:^{
                    
                    CGRect dorpRect = _dropDownTableView.frame;
                    if ((_typeArray.count+1)*40 < 240) {
                        
                        dorpRect.size.height = (_typeArray.count+1)*40;
                    }else{
                        
                        dorpRect.size.height = 240;
                    
                    }
                    _dropDownTableView.frame = dorpRect;
                    [_dropDownTableView reloadData];
                    
                }];
            }else{
                typeImgView.image = IMG(@"downPull_white");
                [UIView animateWithDuration:0.3 animations:^{
                    
                    CGRect dorpRect = _dropDownTableView.frame;
                    dorpRect.size.height = 0;
                    _dropDownTableView.frame = dorpRect;
                    [_dropDownTableView reloadData];
                    
                }];
                
            }
            
            [timeBtn setBackgroundImage:IMG(@"timeBtn_normal") forState:UIControlStateNormal];
            [timeBtn setTitleColor:COLOR_IBLACK forState:UIControlStateNormal];
            timeImgView.image = IMG(@"downPull_blue");
 
            
        }
            break;
            
        case 199:
        {
            _isFish = NO;
            [timeBtn setBackgroundImage:IMG(@"timeBtn_selecd") forState:UIControlStateNormal];
            [timeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            if (btn.selected) {
                timeImgView.image = IMG(@"upPull_white");
                [UIView animateWithDuration:0.3 animations:^{
                    
                    CGRect dorpRect = _dropDownTableView.frame;
                    if ((_dyNastyArray.count+1)*40 < 240) {
                        dorpRect.size.height = (_dyNastyArray.count+1)*40;
                    }else{
                        dorpRect.size.height = 240;
                    }
                    
                    _dropDownTableView.frame = dorpRect;
                    [_dropDownTableView reloadData];
                    
                }];
                
            }else{
                timeImgView.image = IMG(@"downPull_white");
                [UIView animateWithDuration:0.3 animations:^{
                    
                    CGRect dorpRect = _dropDownTableView.frame;
                    dorpRect.size.height = 0;
                    _dropDownTableView.frame = dorpRect;
                    [_dropDownTableView reloadData];
                    
                }];
                
            }
            
            [typeBtn setBackgroundImage:IMG(@"typeBtn_normal") forState:UIControlStateNormal];
            [typeBtn setTitleColor:COLOR_IBLACK forState:UIControlStateNormal];
            typeImgView.image = IMG(@"downPull_blue");
            
        }
            break;
            
        default:
            break;
    }
}

#pragma -mark UITableViewDelegate/UITableViewdataSoure
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isFish == YES) {
        return _typeArray.count+1;
    }else if(_isFish == NO) {
        return _dyNastyArray.count+1;
    }else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idfenter = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idfenter];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idfenter];
        cell.textLabel.textColor = COLOR_IBLACK;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (_isFish == YES) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"查看全部";
        }else{
            cell.textLabel.text = [_typeArray[indexPath.row-1] objectForKey:@"antique"];
        }
        
        if (indexPath.row == _typeIndexPath) {
            cell.textLabel.textColor = [UIColor colorWithRed:238/255.0 green:45/255.0 blue:60/255.0 alpha:1];
        }else{
            cell.textLabel.textColor = COLOR_IBLACK;
        }
        
    }
    
    if (_isFish == NO) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"查看全部";
        }else {
            cell.textLabel.text = [_dyNastyArray[indexPath.row-1] objectForKey:@"dynasty"];
        }
        if (indexPath.row == _dyNastyIndexPath) {
            cell.textLabel.textColor = [UIColor colorWithRed:238/255.0 green:45/255.0 blue:60/255.0 alpha:1];
        }else {
            cell.textLabel.textColor = COLOR_IBLACK;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isFish == YES) {
        _typeIndexPath = indexPath.row;
        if (indexPath.row == 0) {
            _typeString = @"";
            
        }else{
            _typeString = [_typeArray[indexPath.row-1] objectForKey:@"antique"];
        }
        [self loadTypeViewData];
    }
    
    if (_isFish == NO) {
        
        _dyNastyIndexPath = indexPath.row;
        if (indexPath.row == 0) {
            _dyNastyString = @"";
        }else {
            _dyNastyString = [_dyNastyArray[indexPath.row-1] objectForKey:@"dynasty"];
        }
        [self loadDyNastyViewData];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect dorpRect = _dropDownTableView.frame;
        dorpRect.size.height = 0;
        _dropDownTableView.frame = dorpRect;
        
    }];
}

#pragma -mark 根据分类筛选列表
-(void)loadTypeViewData
{
    //[SVProgressHUD showWithStatus:@"正在加载中..."];
     [SVProgressHUD showLoading];
    
    [AppProtocol getAntiqueFilterListByAntiqueType:_typeString venueId:_venueId pageIndex:0 pageNum:999 cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        if (responseCode == HttpResponseSuccess) {
            _centerArray = responseObject;
            [_collectionView reloadData];
            
            [SVProgressHUD dismiss];
        }else {
            [SVProgressHUD showErrorWithStatus:responseObject];
        }

    }];
}


#pragma -mark 根据年代筛选列表
-(void)loadDyNastyViewData
{
    [SVProgressHUD showLoading];
    
    [AppProtocol getAntiqueFilterListByAntiqueDynasty:_dyNastyString venueId:self.venueId pageIndex:0 pageNum:999 cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
       
        if (responseCode == HttpResponseSuccess) {
            _centerArray = responseObject;
            [_collectionView reloadData];
            
            [SVProgressHUD dismiss];
        }else {
            [SVProgressHUD showErrorWithStatus:responseObject];
        }
    }];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_collectionView == scrollView) {
        typeImgView.image = IMG(@"downPull_blue");
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect dorpRect = _dropDownTableView.frame;
            dorpRect.size.height = 0;
            _dropDownTableView.frame = dorpRect;
            [_dropDownTableView reloadData];
            
        }];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
