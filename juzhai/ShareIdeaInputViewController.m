//
//  ShareIdeaInputViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-8-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShareIdeaInputViewController.h"
#import "RectButton.h"
#import "CustomNavigationController.h"
#import "Constant.h"
#import "CustomTextView.h"
#import "IdeaView.h"

@interface ShareIdeaInputViewController ()

@end

@implementation ShareIdeaInputViewController

@synthesize navigationBar;
@synthesize ideaView;
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
    
    _saveButton = [[RectButton alloc] initWithWidth:45.0 buttonText:@"分享" CapLocation:CapLeftAndRight];
    [_saveButton addTarget:self action:@selector(sendShare:) forControlEvents:UIControlEventTouchUpInside];
    navigationBar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_saveButton];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BG_IMG]];
    
    textView.backgroundImage = [[UIImage imageNamed:@"send_input_bgxy"] stretchableImageWithLeftCapWidth:7 topCapHeight:7];
    textView.font = DEFAULT_FONT(15);
    textView.textColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f];
    textView.text = [self.ideaView shareThirdpartyText];
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
    
}

@end
