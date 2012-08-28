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
@synthesize loadingView;
@synthesize authorizeType;

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
    NSString *titleKey = [NSString stringWithFormat:@"tpLogin.%d.title", self.tpId];
    navigationBar.topItem.title = NSLocalizedString(titleKey, @"tpLoginTitle");
    
    if (IOS_VERSION >= 5.0){
        [navigationBar setBackgroundImage:TOP_BG_IMG forBarMetrics:UIBarMetricsDefault];
    }

    UIImage *backImage = [UIImage imageNamed:BACK_NORMAL_PIC_NAME];
    UIImage *activeBackImage = [UIImage imageNamed:BACK_HIGHLIGHT_PIC_NAME];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton setBackgroundImage:activeBackImage forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    navigationBar.topItem.leftBarButtonItem = backItem;
    
    loadingView.hidesWhenStopped = YES;
    
    NSString *uri;
    switch (authorizeType) {
        case AuthorizeLogin:
            uri = [NSString stringWithFormat:@"passport/tpLogin/%d", self.tpId];
            break;
        case AuthorizeExpired:
            uri = [NSString stringWithFormat:@"passport/authorize/expired/%d", self.tpId];
            break;
        case AuthorizeBind:
            uri = [NSString stringWithFormat:@"passport/authorize/bind/%d", self.tpId];
            break;
    }
    
    NSURL *requestUrl = [NSURL URLWithString:[UrlUtils urlStringWithUri:uri]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:requestUrl];
	[webView loadRequest:request];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.webView = nil;
    self.navigationBar = nil;
    self.loadingView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)back:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark AuthorizeLogin
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

#pragma mark AuthorizeExpired

- (void)authorize:(NSString *)query{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
	[hud showWhileExecuting:@selector(doAuthorize:) onTarget:self withObject:query animated:YES];
}

-(void) doAuthorize:(NSString *)query{
    LoginResult *loginResult = [[LoginService getInstance] authorize:self.tpId withQuery:query];
    if(loginResult.success){
        [self dismissModalViewControllerAnimated:YES];
    }else{
        [MessageShow error:loginResult.errorInfo onView:self.navigationController.view];
    }
}

#pragma mark AuthorizeExpired

- (void)bind:(NSString *)query{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
	[hud showWhileExecuting:@selector(doBind:) onTarget:self withObject:query animated:YES];
}

-(void) doBind:(NSString *)query{
    LoginResult *loginResult = [[LoginService getInstance] bind:self.tpId withQuery:query];
    if(loginResult.success){
        [self dismissModalViewControllerAnimated:YES];
    }else{
        [MessageShow error:loginResult.errorInfo onView:self.navigationController.view];
    }
}

#pragma mark - Web View Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSURL *requestUrl = [request URL];
    
    if (self.authorizeType == AuthorizeLogin) {
        if ([[requestUrl path] rangeOfString:@"/web/access"].length > 0) {
            [loadingView stopAnimating]; 
            [self login:requestUrl.query];
            return NO;
        }
    } else if (self.authorizeType == AuthorizeExpired) {
        if ([[requestUrl path] rangeOfString:@"/authorize/access"].length > 0) {
            [loadingView stopAnimating]; 
            [self authorize:requestUrl.query];
            return NO;
        }
    } else if (self.authorizeType == AuthorizeBind) {
        if ([[requestUrl path] rangeOfString:@"/authorize/bindAccess"].length > 0) {
            [loadingView stopAnimating]; 
            [self bind:requestUrl.query];
            return NO;
        }
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
