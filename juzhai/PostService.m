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
#import "MobClick.h"
#import "UserContext.h"

@implementation PostService

- (void) sendPost:(NSString *)content withDate:(NSString *)date withPlace:(NSString *)place withImage:(UIImage *)image withCategory:(NSInteger)catId onView:(UIView *)view withSuccessCallback:(PostBasicBlock)aSuccessBlock
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = @"发布中...";
    hud.yOffset = -77;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:content, @"content", place, @"place", date, @"dateString", [NSNumber numberWithInt:catId], @"categoryId", nil];
        __unsafe_unretained __block ASIFormDataRequest *request = [HttpRequestSender postRequestWithUrl:[UrlUtils urlStringWithUri:@"post/sendPost"] withParams:params];
        if (request) {
            if (image != nil) {
                CGFloat compression = 0.9f;
                CGFloat maxCompression = 0.1f;
                int maxFileSize = 0.1*1024*1024;
                
                NSData *imageData = UIImageJPEGRepresentation(image, compression);
                while ([imageData length] > maxFileSize && compression > maxCompression){
                    imageData = nil;
                    compression -= 0.2;
                    imageData = UIImageJPEGRepresentation(image, compression);
                }
                [request setData:imageData withFileName:@"postImg.jpg" andContentType:@"image/jpeg" forKey:@"postImg"];
            }
            [request setCompletionBlock:^{
                NSString *responseString = [request responseString];
                NSMutableDictionary *jsonResult = [responseString JSONValue];
                if([jsonResult valueForKey:@"success"] == [NSNumber numberWithBool:YES]){
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", [UserContext getUid]], @"uid", [NSString stringWithFormat:@"%d", image != nil], @"withPic", [NSString stringWithFormat:@"%d", ![date isEqualToString:@""]], @"withTime", [NSString stringWithFormat:@"%d", ![place isEqualToString:@""]], @"withPlace", nil];
                    [MobClick event:SEND_POST attributes:dict];
                    
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
    });
}

@end
