//
//  CenterViewController.h
//  CultureHongshan
//
//  Created by ct on 15/11/10.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "BasicViewController.h"

@interface CenterViewController : BasicViewController

@property (nonatomic,assign) BOOL         isUpdateUserInfoForbidden;
@property (nonatomic,retain) UIImage      *image;
@property (nonatomic,retain) NSDictionary *userInfo;

@end
