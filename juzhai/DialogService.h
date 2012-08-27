//
//  DialogService.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DialogContentView;

#define DIALOG_CONTENT_LENGTH_MAX 400
#define DIALOG_CONTENT_LENGTH_MIN 2
#define DIALOG_ERROR_TEXT @"私聊内容字数控制在1-200个汉字内"

@interface DialogService : NSObject

//- (BOOL)sendSms:(NSString *)content toUser:(NSInteger)uid withImg:(UIImage *)image onSuccess:(void (^)(NSDictionary *))aSuccessBlock inView:(UIView *)view;

- (BOOL)sendSms:(DialogContentView *)dialogContentView inQueue:(NSOperationQueue *)smsQueue onSuccess:(void (^)(NSDictionary *))aSuccessBlock onFailure:(void (^)(NSString *, BOOL hasSent))aFailureBlock;

@end
