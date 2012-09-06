//
//  MessageShow.h
//  juzhai
//
//  Created by JiaJun Wu on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageShow : NSObject

#define SERVER_ERROR_INFO @"网络不给力，稍后再试吧"

+ (void)error:(NSString *)msg onView:(UIView *)view;
+ (void)error:(NSString *)msg withDelegate:(id <UIAlertViewDelegate>)deletage onView:(UIView *)view;

@end
