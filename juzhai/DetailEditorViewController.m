//
//  DetailEditorViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DetailEditorViewController.h"
#import "RectButton.h"
#import "Constant.h"

@interface DetailEditorViewController ()

@end

@implementation DetailEditorViewController

@synthesize settingViewController;

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
    
    RectButton *saveButton = [[RectButton alloc] initWithWidth:45.0 buttonText:@"保存" CapLocation:CapLeftAndRight];
    [saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BG_IMG]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.settingViewController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)save:(id)sender
{
    
}

@end
