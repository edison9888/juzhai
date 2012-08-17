//
//  TpLoginViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TpLoginViewController.h"
#import "LoginService.h"
#import "MessageShow.h"
#import "MBProgressHUD.h"
#import "UrlUtils.h"
#import "CustomNavigationController.h"
#import "Constant.h"
#import "LoginResult.h"

@interface TpLoginViewController ()

@end

@implementation TpLoginViewController

@synthesize webView;
@synthesize tpId;
@synthesize navigationBar;
@synthesize webTitle;
@synthesize loadingView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    navigationBar.topItem.title = webTitle;
    
    if (IOS_VERSION >= 5.0){
        [navigationBar setBackgroundImage:TOP_BG_IMG forBarMetrics:UIBarMetricsDefault];
    }

    UIImage *backImage = [UIImage imageNamed:BACK_NORMAL_PIC_NAME];
    UIImage *activeBackImage = [UIImage imageNamed:BACK_HIGHLIGHT_PIC_NAME];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton setBackgroundImage:activeBackImage forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backToLogin:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    navigationBar.topItem.leftBarButtonItem = backItem;
    
    loadingView.hidesWhenStopped = YES;
    
    NSURL *requestUrl = [NSURL URLWithString:[UrlUtils urlStringWithUri:[NSString stringWithFormat:@"passport/tpLogin/%d", tpId]]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:requestUrl];
	[webView loadRequest:request];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.webView = nil;
    self.navigationBar = nil;
    self.loadingView = nil;
    self.webTitle = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)backToLogin:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) doLogin:(NSString *)query{
    LoginResult *loginResult = [[LoginService getInstance] loginWithTpId:tpId withQuery:query];
    if(loginResult.success){
        [self performSelectorOnMainThread:@selector(redirect) withObject:nil waitUntilDone:NO];
    }else{
        [MessageShow error:loginResult.errorInfo onView:self.navigationController.view];
    }
}

- (void)redirect
{
    //判断是否过引导
    UIViewController *startController = [[LoginService getInstance] loginTurnToViewController];
    if(startController){
        self.view.window.rootViewController = startController;
        [self.view.window makeKeyAndVisible];
    }
}

- (void)login:(NSString *)query{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
	[hud showWhileExecuting:@selector(doLogin:) onTarget:self withObject:query animated:YES];
}

#pragma mark - Web View Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSURL *requestUrl = [request URL];
    if ([[requestUrl path] rangeOfString:@"/web/access"].length > 0) {
        [loadingView stopAnimating]; 
        [self login:requestUrl.query];
        return NO;
    }
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    loadingView.hidden = NO;
    [loadingView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [loadingView stopAnimating]; 
}

@end
