//
//  AuthorizeViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AuthorizeExpiredViewController.h"
#import "Constant.h"
#import "BigButton.h"
#import "TpLoginViewController.h"
#import "UserContext.h"
#import "UserView.h"

@interface AuthorizeExpiredViewController ()

@end

@implementation AuthorizeExpiredViewController

@synthesize tpId;
@synthesize label1;
@synthesize label2;

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
    self.title = @"授权设置";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BG_IMG]];
    
    NSString *labelKey1 = [NSString stringWithFormat:@"authorize.%d.title1",self.tpId];
    label1.text = NSLocalizedString(labelKey1, @"title1");
    
    NSString *labelKey2 = [NSString stringWithFormat:@"authorize.%d.title2",self.tpId];
    label2.text = NSLocalizedString(labelKey2, @"title2");
    
    BigButton *bigButton = [[BigButton alloc] initWithWidth:125 buttonText:@"重新授权" CapLocation:CapLeftAndRight];
    bigButton.titleLabel.font = DEFAULT_BOLD_FONT(19);
    bigButton.frame = CGRectMake(20, 90, 125, 40);
    [bigButton addTarget:self action:@selector(openAuthorize:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bigButton];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.titleLabel.font = DEFAULT_BOLD_FONT(19);
    [backButton setTitle:@"下次再说" forState:UIControlStateNormal];
    [backButton setBackgroundImage:[[UIImage imageNamed:@"sq_back_btn"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(172, 90, 125, 40);
    [self.view addSubview:backButton];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.label1 = nil;
    self.label2 = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(![UserContext getUserView].tokenExpired)
    {
        [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)openAuthorize:(id)sender
{
    TpLoginViewController *tpLoginViewController = [[TpLoginViewController alloc] initWithNibName:@"TpLoginViewController" bundle:nil];
    tpLoginViewController.tpId = self.tpId;
    tpLoginViewController.authorizeType = AuthorizeExpired;
    [self presentModalViewController:tpLoginViewController animated:YES];
}

@end
