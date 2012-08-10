//
//  MessageShow.m
//  juzhai
//
//  Created by JiaJun Wu on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MessageShow.h"
#import "MBProgressHUD.h"

@implementation MessageShow

+(void) error:(NSString *)msg onView:(UIView *)view{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.mode = MBProgressHUDModeText;
//    hud.margin = 10.f;
//    hud.yOffset = 135.f;
//    hud.removeFromSuperViewOnHide = YES;
//    hud.labelText = msg;
//    [hud hide:YES afterDelay:1];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg message:
                          nil delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil]; 
    [alert show];
}

@end
