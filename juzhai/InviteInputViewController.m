//
//  InviteInputViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-8-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InviteInputViewController.h"
#import "Constant.h"
#import "RectButton.h"
#import "CustomTextView.h"
#import "CustomNavigationController.h"
#import "HttpRequestSender.h"
#import "UrlUtils.h"

@interface InviteInputViewController ()

@end

@implementation InviteInputViewController

@synthesize navigationBar;
@synthesize textView;
@synthesize navTitle;

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
    navigationBar.topItem.title = navTitle;
    // Do any additional setup after loading the view.
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
    
    _saveButton = [[RectButton alloc] initWithWidth:45.0 buttonText:@"邀请" CapLocation:CapLeftAndRight];
    [_saveButton addTarget:self action:@selector(sendShare:) forControlEvents:UIControlEventTouchUpInside];
    navigationBar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_saveButton];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BG_IMG]];
    
    textView.backgroundImage = [[UIImage imageNamed:@"send_input_bgxy"] stretchableImageWithLeftCapWidth:7 topCapHeight:7];
    textView.font = DEFAULT_FONT(15);
    textView.textColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f];
    textView.text = @"刚发现一个小清新的脱宅社区，蛮有新意的；周末不想宅在家的朋友可以来试试哦~";
    [textView performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.5];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)back:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)sendShare:(id)sender
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.textView.text, @"content", nil];
    ASIFormDataRequest *request = [HttpRequestSender postRequestWithUrl:[UrlUtils urlStringWithUri:@"home/invite"] withParams:params];
    [request startAsynchronous];
    [self back:nil];
}

@end
