//
//  User.h
//  CultureHongshan
//
//  Created by Simba on 15/7/8.
//  Copyright (c) 2015年 Sun3d. All rights reserved.
//

/*
 
 文化云平台的注册用户，用户名最多7个字符，第三方平台的用户名会超过7个字符
 
 从2017-05-12起，使用userNickName字段，不再使用userName （在后台，userName要作为账号名使用，因此不能修改userName）
 
 从2017-08-17起，修改、显示的均为userName，userNickName用作实名认证。文化直播App的昵称暂时不能修改
 
 */


#import <Foundation/Foundation.h>

@interface User : NSObject

/********************************* 在使用的字段 **************************************/
@property (nonatomic, copy) NSString *userId;
/** 用户名(最多7个字符) */
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy, readonly) NSString *userNameFull;// 完整用户名

@property (nonatomic, copy) NSString *userHeadImgUrl;
@property (nonatomic, copy) NSString *userPwd;
@property (nonatomic, copy) NSString *userArea;//取出的值均以“:”分割
@property (nonatomic,assign) NSInteger userSex;//1- 男  2-女
@property (nonatomic, copy) NSString *userIsDisable;//用户是否激活：0-未激活 1-已激活 2-冻结
@property (nonatomic, copy) NSString *commentStatus;//是否禁止评论:0——禁止评论，1——正常
@property (nonatomic, copy) NSString *userMobileNo;
@property (nonatomic, copy) NSString *userTelephone;
@property (nonatomic, copy) NSString *registerOrigin;//账号来源：1 文化云，2 QQ  3 新浪微博 4 微信(现在已经不再用","拼接了)
/* 3.5.2 新增属性 */
@property (nonatomic,assign) NSInteger teamUserSize;//管理团队数量(数量大于0，表示通过资质认证)
@property (nonatomic,assign) NSInteger userIntegral;//用户当前积分
@property (nonatomic,assign) NSInteger userType;//用户等级：1-普通用户 2-管理员用户 3-待认证（当为管理员用户时，表示用户通过实名认证） 4-认证不通过
//1.未认证 2.已认证  3.待审核 4.认证不通过



/********************************* 未使用的字段 **************************************/
@property (nonatomic, copy) NSString *userNickName;

@property (nonatomic, copy) NSString *userProvince;
@property (nonatomic, copy) NSString *userEmail;
@property (nonatomic, copy) NSString *userCardNo;
@property (nonatomic, copy) NSString *userQq;
@property (nonatomic, copy) NSString *userRemark;
@property (nonatomic, copy) NSString *registerCount;
@property (nonatomic, copy) NSString *registerCode;
@property (nonatomic, copy) NSString *userBirth;
@property (nonatomic, copy) NSString *userCity;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *userAddress;
@property (nonatomic, copy) NSString *userAge;
@property (nonatomic, copy) NSString *userIsLogin;// 0- 首次用账号登录, 1-需要和后台沟通




- (id)initWithAttributes:(NSDictionary *)dictionary;
+ (NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray;

@end

/*
 
 0-未实名认证（userType＝1）
 1-实名认证中（userType＝3）
 2-实名认证未通过（userType＝4）
 3－实名认证已通过（userType＝2）
 4-未资质认证（个人中心：tuserTeamSize < 1  活动室预订：tuserId == nil  我的订单：tuserId == nil ）
 5-资质认证中(tUserIsDisplay == 0)
 6-资质认证未通过（tUserIsDisplay ＝＝ 3）
 7-资质认证已通过（个人中心：tuserTeamSize > 0  活动室预订：tUserIsDisplay == 1 我的订单：tUserIsDisplay == 1 ）
 
 */

