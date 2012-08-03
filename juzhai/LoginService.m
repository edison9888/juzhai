//
//  LoginService.m
//  juzhai
//
//  Created by JiaJun Wu on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginService.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "LoginUser.h"
#import "HttpRequestSender.h"
#import "MessageShow.h"
#import "UserContext.h"
#import "UserView.h"
#import "LoginViewController.h"
#import "GuideSettingViewController.h"
#import "CustomNavigationController.h"
#import "UrlUtils.h"
#import "LoginResult.h"
#import "Constant.h"

@interface LoginService(Private)

- (void)loginSuccess:(LoginUser *)loginUser withJson:(NSDictionary *)jsonResult withCookies:(NSArray *)cookies;

@end

@implementation LoginService

static LoginService *loginService;

+ (id) getInstance{
    @synchronized(loginService){
        if (!loginService) {
            loginService = [[LoginService alloc]init];
        }
        return loginService;
    }
}

- (LoginResult *)useLoginName:(NSString *)account byPassword:(NSString *)password byToken:(NSString *)token{
    //Http请求
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:account, @"account", password, @"password", [NSNumber numberWithBool:YES], @"remember", nil];
    ASIFormDataRequest *request = [HttpRequestSender postRequestWithUrl:[UrlUtils urlStringWithUri:@"passport/login"] withParams:params];
    if (nil != request) {
        if (nil != token && ![token isEqualToString:@""]) {
            NSDictionary *properties = [[NSMutableDictionary alloc] init];
            [properties setValue:token forKey:NSHTTPCookieValue];
            [properties setValue:P_TOKEN_COOKIE_NAME forKey:NSHTTPCookieName];
            [properties setValue:BASE_DOMAIN forKey:NSHTTPCookieDomain];
            [properties setValue:[NSDate dateWithTimeIntervalSinceNow:60] forKey:NSHTTPCookieExpires];
            [properties setValue:@"/" forKey:NSHTTPCookiePath];
            NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:properties];
            [request setRequestCookies:[NSMutableArray arrayWithObjects:cookie, nil]];
        }
        [request startSynchronous];
        NSError *error = [request error];
        if (!error && [request responseStatusCode] == 200){
            NSString *response = [request responseString];
            NSMutableDictionary *jsonResult = [response JSONValue];
            if([jsonResult valueForKey:@"success"] == [NSNumber numberWithBool:YES]){
                //登录成功
                LoginUser *loginUser = [[LoginUser alloc] initWithAccount:account password:password];
                [self loginSuccess:loginUser withJson:jsonResult withCookies:request.responseCookies];
                return [LoginResult successLoginResult];
            }else{
                return [LoginResult loginResultWithSuccess:NO errorCode:[[jsonResult valueForKey:@"errorCode"] intValue] errorInfo:[jsonResult valueForKey:@"errorInfo"]];
            }
        }else{
            NSLog(@"error: %@", [request responseStatusMessage]);
        }
    }
    return [LoginResult loginResultWithSuccess:NO errorCode:0 errorInfo:SERVER_ERROR_INFO];
}

- (LoginResult *)loginWithTpId:(NSInteger)tpId withQuery:(NSString *)query{
    //Http请求
    NSString *url = [UrlUtils urlStringWithUri:[NSString stringWithFormat:@"passport/tpAccess/%d?%@", tpId, query]];
    ASIFormDataRequest *request = [HttpRequestSender postRequestWithUrl:url withParams:nil];
    if (request != nil) {
        [request startSynchronous];
        NSError *error = [request error];
        if (!error && [request responseStatusCode] == 200){
            NSString *response = [request responseString];
            NSMutableDictionary *jsonResult = [response JSONValue];
            if([jsonResult valueForKey:@"success"] == [NSNumber numberWithBool:YES]){
                //登录成功
                [self loginSuccess:nil withJson:jsonResult withCookies:request.responseCookies];
                return [LoginResult successLoginResult];
            }else{
                return [LoginResult loginResultWithSuccess:NO errorCode:[[jsonResult valueForKey:@"errorCode"] intValue] errorInfo:[jsonResult valueForKey:@"errorInfo"]];
            }
        }else{
        }
    }
    return [LoginResult loginResultWithSuccess:NO errorCode:0 errorInfo:SERVER_ERROR_INFO];
}

- (BOOL)checkLogin{
    LoginUser *loginUser = [[LoginUser alloc] initFromData];
    if(loginUser != nil)
    {
        LoginResult *loginResult = nil;
        if (![@"" isEqualToString:loginUser.token]) {
            loginResult = [self useLoginName:loginUser.account byPassword:loginUser.password byToken:loginUser.token];
        }else if (![@"" isEqualToString:loginUser.account] && ![@"" isEqualToString:loginUser.password]) {
            loginResult = [self useLoginName:loginUser.account byPassword:loginUser.password byToken:nil];
        }
        if(loginResult && loginResult.success){
            return YES;
        }
    }
    [self localLogout];
    return NO;
}

- (void)loginSuccess:(LoginUser *)loginUser withJson:(NSDictionary *)jsonResult withCookies:(NSArray *)cookies
{
    if (loginUser == nil) {
        loginUser = [[LoginUser alloc] init];
    }
    for(NSHTTPCookie *cookie in cookies)
    {
        if ([cookie.name isEqualToString:P_TOKEN_COOKIE_NAME]) {
            loginUser.token = cookie.value;
        }
    }
    //登录成功
    [UserContext setUserView:[UserView convertFromDictionary:[jsonResult valueForKey:@"result"]]];
    if (loginUser.token != nil && ![loginUser.token isEqualToString:@""]) {
        [loginUser save];
        NSLog(@"save token %@", loginUser.token);
    }
}

- (void)logout{
    ASIHTTPRequest *request = [HttpRequestSender getRequestWithUrl:[UrlUtils urlStringWithUri:@"passport/logout"] withParams:nil];
    if (request) {
        [request startSynchronous];
    }
    [self localLogout];
}

- (void)localLogout
{
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:[UrlUtils urlStringWithUri:@"passport/login"]]]) {
//        if ([cookie.name isEqualToString:P_TOKEN_COOKIE_NAME]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
//            break;
//        }
    }
    [ASIHTTPRequest setSessionCookies:nil];
    //清除帐号信息
    [[[LoginUser alloc] init] reset];
    [UserContext logout];
}

- (UIViewController *)loginTurnToViewController{
    UIViewController *startController;
    if (![UserContext hasLogin]) {
        startController = [[CustomNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil]];
    } else if (![UserContext hasCompleteGuide]){
        startController = [[CustomNavigationController alloc] initWithRootViewController:[[GuideSettingViewController alloc] initWithStyle:UITableViewStyleGrouped]];
    }else {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TabBar" owner:self options:nil];
        startController = nib.lastObject;
    }
    return startController;
}

@end
