//
//  LocationViewController.m
//  CultureHongshan
//
//  Created by ct on 16/2/18.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "LocationViewController.h"

#import "SearchLocationTag.h"
#import "LocationTableViewCell.h"

#import "UserDataCacheTool.h"

static NSString *reuseID = @"Cell";

@interface LocationViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _selectedRow;
}

@property (nonatomic)NSArray *dataSource;
@property (nonatomic,copy)NSString *Location;

@end


@implementation LocationViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"地区";
    self.view.backgroundColor = kBgColor;
    _selectedRow = -1;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:@"LocationTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:reuseID];
    
    [self getNetWorking];
}


- (void)getNetWorking
{
    UserDataCacheTool *cacheTool  = [UserDataCacheTool sharedInstance];
    //从活动搜索标签接口中获取，数组的组成为：人群标题,心情标签,主题标签,区域位置
    cacheTool.cacheType = UserDataCacheToolTypeArea;
    
    WS(weakSelf);
    if ([cacheTool isDataNeedUpdate])
    {
        [AppProtocol searchTagActivityUsingBlock:^(HttpResponseCode responseCode, id responseObject)
         {
            if (responseCode == HttpResponseSuccess)
            {
                NSArray *array = (NSArray *)responseObject;//组成：人群标题，心情标签，主题标签，区域位置
                weakSelf.dataSource = array[3];
                _selectedRow = [weakSelf getSelectedRow];
                [weakSelf.tableView reloadData];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:responseObject];
            }
        }];
    }
    else
    {
        NSArray *dataArray = [cacheTool getArrayData];
        self.dataSource = [SearchLocationTag instanceArrayFromDictArray:dataArray[3]];
        _selectedRow = [self getSelectedRow];
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    
    SearchLocationTag *aLocation = self.dataSource[indexPath.row];
    
    cell.LocationLable.text = aLocation.areaName;
    
    cell.selectedImage.hidden = (indexPath.row != _selectedRow);
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedRow == indexPath.row)
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    SearchLocationTag *aLocation = self.dataSource[indexPath.row];
    [self ChangeLocationWithAreaString:[NSString stringWithFormat:@"%@:%@",aLocation.areaCode,aLocation.areaName]];
    
    _selectedRow = indexPath.row;
    [tableView reloadData];
}


#pragma mark - 更改区域

- (void)ChangeLocationWithAreaString:(NSString *)areaString
{
    User *user = [UserService sharedService].user;
    __weak typeof(self) weakSelf = self;
    
    [AppProtocol updateUserInfoWithUserId:user.userId
                                 userName:nil
                                  userSex:[NSString stringWithFormat:@"%d",(int)user.userSex]
                            userTelephone:nil
                                 userArea:areaString
                               UsingBlock:^(HttpResponseCode responseCode, id responseObject)
    {
        if (responseCode == HttpResponseSuccess) {
            [weakSelf updateUserLocationSuccess:areaString];
        } else {
            [SVProgressHUD showErrorWithStatus:(NSString *)responseObject];
        }
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)getSelectedRow
{
    NSString *userArea = [UserService sharedService].user.userArea;
    
    if (userArea.length) {
        NSString *areaName = [[userArea componentsSeparatedByString:@":"] lastObject];
        for (int i = 0; i < _dataSource.count; i++ ) {
            SearchLocationTag *aLocation = _dataSource[i];
            if ([areaName isEqualToString:aLocation.areaName]) {
                return i;
            }
        }
    }
    return -1;
}

- (void)updateUserLocationSuccess:(NSString *)areaStr
{
    User *aUser = [UserService sharedService].user;
    aUser.userArea = areaStr;
    [UserService saveUser:aUser];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end
