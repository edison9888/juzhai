//
//  PostService.m
//  juzhai
//
//  Created by JiaJun Wu on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PostService.h"
#import "SBJson.h"
#import "MBProgressHUD.h"
#import "HttpRequestSender.h"
#import "MessageShow.h"
#import "UrlUtils.h"

@implementation PostService

- (void) sendPost:(NSString *)content withDate:(NSString *)date withPlace:(NSString *)place withImage:(UIImage *)image withCategory:(NSInteger)catId onView:(UIView *)view withSuccessCallback:(PostBasicBlock)aSuccessBlock
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = @"发布中...";
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:content, @"content", place, @"place", date, @"dateString", [NSNumber numberWithInt:catId], @"categoryId", nil];
        __unsafe_unretained __block ASIFormDataRequest *request = [HttpRequestSender postRequestWithUrl:[UrlUtils urlStringWithUri:@"post/sendPost"] withParams:params];
        if (request) {
            if (image != nil) {
                CGFloat compression = 0.9f;
                CGFloat maxCompression = 0.1f;
                int maxFileSize = 2*1024*1024;
                
                NSData *imageData = UIImageJPEGRepresentation(image, compression);
                while ([imageData length] > maxFileSize && compression > maxCompression){
                    compression -= 0.1;
                    imageData = UIImageJPEGRepresentation(image, compression);
                }
                [request setData:imageData withFileName:@"postImg.jpg" andContentType:@"image/jpeg" forKey:@"postImg"];
            }
            [request setCompletionBlock:^{
                NSString *responseString = [request responseString];
                NSMutableDictionary *jsonResult = [responseString JSONValue];
                if([jsonResult valueForKey:@"success"] == [NSNumber numberWithBool:YES]){
                    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.labelText = @"发送成功";
                    [hud hide:YES afterDelay:1];
                    if(aSuccessBlock){
                        aSuccessBlock();
                    }
                    return;
                }
                NSString *errorInfo = [jsonResult valueForKey:@"errorInfo"];
                NSLog(@"%@", errorInfo);
                if (errorInfo == nil || [errorInfo isEqual:[NSNull null]] || [errorInfo isEqualToString:@""]) {
                    errorInfo = SERVER_ERROR_INFO;
                }
                [MBProgressHUD hideHUDForView:view animated:YES];
                [MessageShow error:errorInfo onView:view];
            }];
            [request setFailedBlock:^{
                [MBProgressHUD hideHUDForView:view animated:YES];
                [HttpRequestDelegate requestFailedHandle:request];
            }];
            [request startAsynchronous];
        } else {
            [MBProgressHUD hideHUDForView:view animated:YES];
        }
//    });
}

@end
