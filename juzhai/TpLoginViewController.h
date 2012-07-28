//
//  TpLoginViewController.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BACK_NORMAL_PIC_NAME @"back_btn_link.png"
#define BACK_HIGHLIGHT_PIC_NAME @"back_btn_hover.png"

@interface TpLoginViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (strong, nonatomic) NSString *webTitle;
@property (nonatomic) NSInteger tpId;

@end
