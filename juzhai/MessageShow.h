//
//  MessageShow.h
//  juzhai
//
//  Created by JiaJun Wu on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageShow : NSObject

#define SERVER_ERROR_INFO @"服务器忙...请稍候再试"

+ (void)error:(NSString *)msg onView:(UIView *)view;
+ (void)error:(NSString *)msg withDelegate:(id <UIAlertViewDelegate>)deletage onView:(UIView *)view;

@end
