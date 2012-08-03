//
//  LoginResult.m
//  juzhai
//
//  Created by JiaJun Wu on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginResult.h"

@implementation LoginResult

@synthesize success;
@synthesize errorCode;
@synthesize errorInfo;

+ (id)loginResultWithSuccess:(BOOL)success errorCode:(NSInteger)errorCode errorInfo:(NSString *)errorInfo
{
    LoginResult *loginResult = [[LoginResult alloc] init];
    loginResult.success = success;
    loginResult.errorCode = errorCode;
    loginResult.errorInfo = errorInfo;
    return loginResult;
}

+ (id)successLoginResult
{
    return [LoginResult loginResultWithSuccess:YES errorCode:0 errorInfo:nil];
}

@end
