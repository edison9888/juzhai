//
//  LoginViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import "LoginService.h"
#import "RegisterViewController.h"
#import "MBProgressHUD.h"
#import "TpLoginDelegate.h"
#import "RectButton.h"
#import "MessageShow.h"

@implementation LoginViewController

@synthesize nameField;
@synthesize pwdField;
//@synthesize startController;
@synthesize loginFormTableView;
@synthesize tpLoginTableView;


-(IBAction)goRegister:(id)sender{
    RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registerViewController animated:YES];
}

-(void) doLogin{
    NSString *errorInfo = [[LoginService getInstance] useLoginName:[nameField text] byPassword:[pwdField text] byToken:nil];
    if(errorInfo == nil){
        [self performSelectorOnMainThread:@selector(redirect) withObject:nil waitUntilDone:NO];
    }else{
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        [MessageShow error:errorInfo onView:self.navigationController.view];
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

-(IBAction)login:(id)sender{
    [self backgroundTap:nil];
    
    if([[nameField text] isEqualToString:@""] || [[pwdField text] isEqualToString:@""]){
        [MessageShow error:@"请输入登录账号和密码" onView:self.navigationController.view];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.dimBackground = YES;
//    hud.labelText = @"登录中...";
	[hud showWhileExecuting:@selector(doLogin) onTarget:self withObject:nil animated:YES];
//    [self doLogin];
}

- (IBAction)nameFieldDoneEditing:(id)sender{
    [pwdField becomeFirstResponder];
    [sender resignFirstResponder];
}

- (IBAction)pwdFieldDoneEditing:(id)sender{
    [sender resignFirstResponder];
//    [LoginService useLoginName:[nameField text] byPassword:[pwdField text]];
    [self login:nil];
}

- (IBAction)backgroundTap:(id)sender{
    [self.nameField resignFirstResponder];
    [self.pwdField resignFirstResponder];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _tpLoginDelegate = [[TpLoginDelegate alloc] init];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title = @"帐号登录";
      
    RectButton *finishButton = [[RectButton alloc] initWithWidth:45.0 buttonText:@"完成" CapLocation:CapLeftAndRight];
    [finishButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:finishButton];
    
    [loginFormTableView setDelegate:self];
    [loginFormTableView setDataSource:self];
    loginFormTableView.backgroundView = nil;
    loginFormTableView.backgroundColor = [UIColor clearColor];
    loginFormTableView.opaque = NO;
    _loginFormCells = [[NSBundle mainBundle] loadNibNamed:@"LoginForm" owner:self options:nil];
    
    [tpLoginTableView setDataSource:_tpLoginDelegate];
    [tpLoginTableView setDelegate:_tpLoginDelegate];
    tpLoginTableView.backgroundView = nil;
    tpLoginTableView.backgroundColor = [UIColor clearColor];
    tpLoginTableView.opaque = NO;
    
    loginFormTableView.separatorColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
    tpLoginTableView.separatorColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table View Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    for(id oneObject in _loginFormCells){
        if([oneObject tag] == indexPath.row){
            return oneObject;
        }
    }
    return nil;
}

#pragma mark -
#pragma mark Table View Delegate



//#pragma mark -
//#pragma mark MBProgressHUDDelegate methods
//
//- (void)hudWasHidden:(MBProgressHUD *)hud {
//	// Remove HUD from screen when the HUD was hidded
//	[HUD removeFromSuperview];
//	HUD = nil;
//}
@end
