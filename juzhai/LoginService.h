//
//  LoginService.h
//  juzhai
//
//  Created by JiaJun Wu on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LoginUser;

#define P_TOKEN_COOKIE_NAME @"p_token"

@interface LoginService : NSObject

+ (id)getInstance;

- (NSString *)useLoginName:(NSString *)account byPassword:(NSString *)password byToken:(NSString *)token;
- (NSString *)loginWithTpId:(NSInteger)tpId withQuery:(NSString *)query;
- (BOOL)checkLogin;
- (void)loginSuccess:(LoginUser *)loginUser withJson:(NSDictionary *)jsonResult withCookies:(NSArray *)cookies;
- (void)logout;
- (void)localLogout;
- (UIViewController *)loginTurnToViewController;

@end
