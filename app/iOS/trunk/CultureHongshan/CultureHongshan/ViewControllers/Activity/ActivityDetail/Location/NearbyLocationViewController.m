//
//  NearbyLocationViewController.m
//  CultureHongshan
//
//  Created by xiao on 15/11/18.
//  Copyright © 2015年 CT. All rights reserved.
//
#import "NearbyLocationViewController.h"
#import "LocationService2.h"

#import <MAMapKit/MAMapKit.h>


@interface NearbyLocationViewController () <MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@end

@implementation NearbyLocationViewController

- (void)dealloc {
    if (self.mapView) {
        [self.mapView removeAnnotations:self.mapView.annotations];
        self.mapView.delegate = nil;
        [self.mapView removeFromSuperview];
        self.mapView = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.statusBarIsBlack = NO;
    [self cheakAuthorizationStatus];
}

- (void)viewDidLoad {
    _addAppBecomeActiveNotification = YES;
    [super viewDidLoad];
    self.view.backgroundColor = kBgColor;
    self.navigationItem.title = @"地  址";
}

- (void)loadUI {
    if (self.mapView) {
        return;
    }
    
    // 地址信息
    UIView *bgView = [UIView new];
    bgView.radius = 5;
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    MYLabel *addressLabel = [[MYLabel alloc] initWithFrame:CGRectZero text:nil font:FontYT(15) tColor:kDeepLabelColor lines:5 align:NSTextAlignmentCenter];
    addressLabel.line_spacing = 4;
    [addressLabel updateText:[NSString stringWithFormat:@"地址：%@", self.addressString]];
    [bgView addSubview:addressLabel];
    
    
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectZero];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    _mapView.showsCompass = YES;
    _mapView.showsScale = NO;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [self.view insertSubview:self.mapView atIndex:0];

    [self.mapView setCenterCoordinate:self.locationCoordinate2D];
    [self.mapView setZoomLevel:14.f animated:YES];
    
    // 添加标注
    MAPointAnnotation *destinationPoint = [[MAPointAnnotation alloc] init];
    destinationPoint.coordinate = self.locationCoordinate2D;
    destinationPoint.title = @"目的地";
    [self.mapView addAnnotation:destinationPoint];
    
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.lessThanOrEqualTo(self.view).offset(-80);
        make.width.mas_greaterThanOrEqualTo(160); // 宽度不能太小
        make.top.equalTo(self.view).offset(30);
    }];
    
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(15, 10, 15, 10));
    }];
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, HEIGHT_HOME_INDICATOR, 0));
    }];
}


#pragma mark - ———————————— MAMapViewDelegate —————————————

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"Destination1";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.annotation = annotation;
        if (_type == DataTypeActivity) {
            annotationView.image = [IMG(@"activityMap") scaleToWidth:25 canBeLarger:YES imgScale:2];
        }else {
            annotationView.image = [IMG(@"annotationViewVenue") scaleToWidth:30 canBeLarger:YES imgScale:2];
        }
        
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = YES;
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        
        return annotationView;
    }
    
    return nil;
}



#pragma mark -

/** 检查定位授权状态 */
- (void)cheakAuthorizationStatus {
    CLAuthorizationStatus status = [LocationService2 sharedService].authStatus;
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self loadUI];
    }else if (status == kCLAuthorizationStatusRestricted) {
        if (self.mapView) {
            return;
        }
        
        WS(weakSelf)
        [WHYAlertActionUtil showAlertWithTitle:@"温馨提示" msg:@"定位权限获取受限，无法查看位置信息！" actionBlock:^(NSInteger index, NSString *buttonTitle) {
            [weakSelf popViewController];
        } buttonTitles:@"", nil];
    }else if (status == kCLAuthorizationStatusDenied) {
        if (self.mapView) {
            return;
        }
        
        // 判断是否开启定位服务
        if ([CLLocationManager locationServicesEnabled]) {
            [self showNoDataView:@"您已拒绝获取定位权限，无法查看位置信息！" image:nil btnTitle:@"去设置" topView:nil];
        } else {
            // 定位服务关闭，不可用
            [self showNoDataView:@"定位服务已关闭，无法查看位置信息！" image:nil btnTitle:@"去设置" topView:nil];
        }

    }else if (status == kCLAuthorizationStatusNotDetermined) {
        [LocationService2 requestWhenInUseAuthorization];
        [self loadUI];
    }
}

- (void)noDataView:(MYNoDataView *)noDataView didClickButton:(NSString *)actionTitle {
    if ([actionTitle isEqualToString:@"去设置"]) {
        [LocationService2 openSystemLocationSetting];
    }else {
        
    }
}

- (void)appWillEnterForeground {
    [self cheakAuthorizationStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

