//
//  LoginService.h
//  juzhai
//
//  Created by JiaJun Wu on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LoginUser;
@class LoginResult;

#define P_TOKEN_COOKIE_NAME @"p_token"

@interface LoginService : NSObject

+ (id)getInstance;

//利用帐号密码登录
- (LoginResult *)useLoginName:(NSString *)account byPassword:(NSString *)password byToken:(NSString *)token;

//第三方登录
- (LoginResult *)loginWithTpId:(NSInteger)tpId withQuery:(NSString *)query;

//第三方重新授权
- (LoginResult *)authorize:(NSInteger)tpId withQuery:(NSString *)query;

//绑定第三方
- (LoginResult *)bind:(NSInteger)tpId withQuery:(NSString *)query;

//检查是否登录
- (BOOL)checkLogin;

//登录成功
- (void)loginSuccess:(LoginUser *)loginUser withJson:(NSDictionary *)jsonResult withCookies:(NSArray *)cookies;

//登出
- (void)logout;

//本地登出
- (void)localLogout;

//登录之后转向的UIViewController
- (UIViewController *)loginTurnToViewController;

@end
