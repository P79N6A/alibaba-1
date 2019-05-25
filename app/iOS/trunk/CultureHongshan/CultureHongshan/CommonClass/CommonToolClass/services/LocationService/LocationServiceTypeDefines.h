//
//  LocationServiceTypeDefines.h
//  CultureShanghai
//
//  Created by JackAndney on 2017/12/4.
//  Copyright © 2017年 CT. All rights reserved.
//

#ifndef LocationServiceTypeDefines_h
#define LocationServiceTypeDefines_h


/**
 定位状态定义
 */
typedef NS_ENUM(int, MYLocationStatus) {
    /** 初始状态，未进行定位 */
    MYLocationStatusDefault = 0,
    /** 定位中 */
    MYLocationStatusInProgress,
    /** 定位成功 */
    MYLocationStatusSuccess,
    /** 定位失败 */
    MYLocationStatusFailed,
};


#endif /* LocationServiceTypeDefines_h */
