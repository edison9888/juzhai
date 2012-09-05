//
//  AuthorizeBindViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AuthorizeBindViewController.h"
#import "Constant.h"
#import "UserContext.h"
#import "UserView.h"
#import "TpLoginDelegate.h"
#import "MBProgressHUD.h"

@interface AuthorizeBindViewController ()

@end

@implementation AuthorizeBindViewController

@synthesize tpLoginTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _tpLoginDelegate = [[TpLoginDelegate alloc] init];
        _tpLoginDelegate.isBind = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"授权设置";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BG_IMG]];
    
    [tpLoginTableView setDataSource:_tpLoginDelegate];
    [tpLoginTableView setDelegate:_tpLoginDelegate];
    tpLoginTableView.backgroundView = nil;
    tpLoginTableView.backgroundColor = [UIColor clearColor];
    tpLoginTableView.opaque = NO;
    tpLoginTableView.separatorColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.titleLabel.font = DEFAULT_BOLD_FONT(19);
    [backButton setTitle:@"下次再说" forState:UIControlStateNormal];
    [backButton setBackgroundImage:[[UIImage imageNamed:@"sq_back_btn"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(20, 260, 280, 40);
    [self.view addSubview:backButton];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.tpLoginTableView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([UserContext getUserView].tpId.intValue > 0)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"绑定成功";
        [hud hide:YES afterDelay:2];
        [self performSelector:@selector(back:) withObject:nil afterDelay:2];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
