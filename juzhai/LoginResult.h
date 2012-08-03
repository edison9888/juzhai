//
//  LoginResult.h
//  juzhai
//
//  Created by JiaJun Wu on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginResult : NSObject

@property BOOL success;
@property NSInteger errorCode;
@property NSString *errorInfo;

+ (id)loginResultWithSuccess:(BOOL)success errorCode:(NSInteger)errorCode errorInfo:(NSString *)errorInfo;

+ (id)successLoginResult;

@end
