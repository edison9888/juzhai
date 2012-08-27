//
//  DialogService.m
//  juzhai
//
//  Created by JiaJun Wu on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DialogService.h"
#import "HttpRequestSender.h"
#import "UrlUtils.h"
#import "SBJson.h"
#import "MessageShow.h"
#import "NSString+Chinese.h"
#import "MobClick.h"
#import "MBProgressHUD.h"
#import "DialogContentView.h"

@implementation DialogService

- (BOOL)sendSms:(DialogContentView *)dialogContentView inQueue:(NSOperationQueue *)smsQueue  onSuccess:(void (^)(NSDictionary *))aSuccessBlock onFailure:(void (^)(NSString *, BOOL hasSent))aFailureBlock
{
    NSString *content = [dialogContentView.content stringByTrimmingCharactersInSet: 
                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger textLength = [content chineseLength];
    if (textLength < DIALOG_CONTENT_LENGTH_MIN || textLength > DIALOG_CONTENT_LENGTH_MAX) {
        if (aFailureBlock) {
            aFailureBlock(DIALOG_ERROR_TEXT, NO);
        }
        return false;
    }
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:content, @"content", [NSNumber numberWithInt:dialogContentView.receiverUid], @"uid", nil];
    __unsafe_unretained __block ASIFormDataRequest *request = [HttpRequestSender postRequestWithUrl:[UrlUtils urlStringWithUri:@"dialog/sendSms"] withParams:params];
    if (request) {
        if (dialogContentView.image != nil) {
            CGFloat compression = 0.9f;
            CGFloat maxCompression = 0.1f;
            int maxFileSize = 1*1024*1024;
            
            NSData *imageData = UIImageJPEGRepresentation(dialogContentView.image, compression);
            while ([imageData length] > maxFileSize && compression > maxCompression){
                compression -= 0.1;
                imageData = UIImageJPEGRepresentation(dialogContentView.image, compression);
            }
            [request setData:imageData withFileName:@"dialogImg.jpg" andContentType:@"image/jpeg" forKey:@"dialogImg"];
        }
        [request setCompletionBlock:^{
            NSString *responseString = [request responseString];
            NSMutableDictionary *jsonResult = [responseString JSONValue];
            if([jsonResult valueForKey:@"success"] == [NSNumber numberWithBool:YES]){
                [MobClick event:SEND_SMS];
                if (aSuccessBlock) {
                    aSuccessBlock([jsonResult valueForKey:@"result"]);
                }
                return;
            }
            NSString *errorInfo = [jsonResult valueForKey:@"errorInfo"];
            if (errorInfo == nil || [errorInfo isEqual:[NSNull null]] || [errorInfo isEqualToString:@""]) {
                errorInfo = SERVER_ERROR_INFO;
            }
            if (aFailureBlock) {
                aFailureBlock(errorInfo, YES);
            }
        }];
        [request setFailedBlock:^{
            [HttpRequestDelegate requestFailedHandle:request];
            if (aFailureBlock) {
                aFailureBlock(nil, YES);
            }
        }];
        if (nil != smsQueue && smsQueue) {
            request.userInfo = [NSDictionary dictionaryWithObject:dialogContentView forKey:REQUEST_USER_INFO_KEY];
            [smsQueue addOperation:request];
        } else {
            [request startAsynchronous];
        }
    } else {
        return NO;
        if (aFailureBlock) {
            aFailureBlock(nil, NO);
        }
    }
    return YES;
}

@end
