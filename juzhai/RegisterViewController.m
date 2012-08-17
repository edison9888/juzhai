//
//  RegisterViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "TpLoginDelegate.h"
#import "RectButton.h"
#import "MBProgressHUD.h"
#import "MessageShow.h"
#import "ASIHTTPRequest.h"
#import "HttpRequestSender.h"
#import "SBJson.h"
#import "LoginUser.h"
#import "UserContext.h"
#import "UserView.h"
#import "LoginService.h"
#import "UrlUtils.h"
#import "MobClick.h"
#import "Constant.h"

@implementation RegisterViewController

@synthesize accountField;
@synthesize nicknameField;
@synthesize passwordField;
@synthesize confirmPwdField;
@synthesize accountCell;
@synthesize nicknameCell;
@synthesize passwordCell;
@synthesize confirmPwdCell;
@synthesize registerFormTableView;
@synthesize tpLoginTableView;


-(IBAction)accountFieldDoneEditing:(id)sender{
    [sender resignFirstResponder];
    [self.nicknameField becomeFirstResponder];
}

-(IBAction)nicknameFieldDoneEditing:(id)sender{
    [sender resignFirstResponder];
    [self.passwordField becomeFirstResponder];
}

-(IBAction)passwordFieldDoneEditing:(id)sender{
    [sender resignFirstResponder];
    [self.confirmPwdField becomeFirstResponder];
}

-(IBAction)confirmPwdFieldDoneEditing:(id)sender{
    [sender resignFirstResponder];
    [self regist:nil];
}

-(void)doRegister{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:accountField.text,@"account",nicknameField.text,@"nickname", passwordField.text,@"pwd", confirmPwdField.text,@"confirmPwd", nil];
    ASIHTTPRequest *request = [HttpRequestSender postRequestWithUrl:[UrlUtils urlStringWithUri:@"passport/register"] withParams:params];
    if (request) {
        [request startSynchronous];
        NSError *error = [request error];
        NSString *errorInfo = SERVER_ERROR_INFO;
        if (!error && [request responseStatusCode] == 200){
            NSString *response = [request responseString];
            NSMutableDictionary *jsonResult = [response JSONValue];
            if([jsonResult valueForKey:@"success"] == [NSNumber numberWithBool:YES]){
                
                [MobClick event:LOCAL_REGISTER];
                
                //TODO 注册成功
                LoginUser *loginUser = [[LoginUser alloc] initWithAccount:accountField.text password:passwordField.text];
                [[LoginService getInstance] loginSuccess:loginUser withJson:jsonResult withCookies:request.responseCookies];
                
                UIViewController *startController = [[LoginService getInstance] loginTurnToViewController];
                if(startController){
                    self.view.window.rootViewController = startController;
                    [self.view.window makeKeyAndVisible];
                }
                return;
            }else{
                errorInfo = [jsonResult valueForKey:@"errorInfo"];
            }
        }else{
            NSLog(@"error: %@", [request responseStatusMessage]);
        }
        [MessageShow error:errorInfo onView:self.navigationController.view];
    }
}

-(IBAction)regist:(id)sender{
    [self backgroundTap:nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.dimBackground = YES;
    //    hud.labelText = @"注册中...";
	[hud showWhileExecuting:@selector(doRegister) onTarget:self withObject:nil animated:YES];
}

- (IBAction)backgroundTap:(id)sender{
    [self.accountField resignFirstResponder];
    [self.nicknameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.confirmPwdField resignFirstResponder];
}

-(IBAction)goLogin:(id)sender{
//    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _registerFormCells = [[NSArray alloc] initWithObjects:self.accountCell, self.nicknameCell, self.passwordCell, self.confirmPwdCell, nil];
    
    //右侧最新最热切换  
    RectButton *finishButton = [[RectButton alloc] initWithWidth:45.0 buttonText:@"完成" CapLocation:CapLeftAndRight];
    [finishButton addTarget:self action:@selector(regist:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:finishButton];
    
    self.title = @"帐号注册";
    
    registerFormTableView.dataSource = self;
    registerFormTableView.backgroundView = nil;
    registerFormTableView.backgroundColor = [UIColor clearColor];
    registerFormTableView.opaque = NO;
    
    //    [tpLoginTableView setDelegate:self];
    [tpLoginTableView setDataSource:_tpLoginDelegate];
    tpLoginTableView.backgroundView = nil;
    tpLoginTableView.backgroundColor = [UIColor clearColor];
    tpLoginTableView.opaque = NO;
    
    registerFormTableView.separatorColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
    tpLoginTableView.separatorColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BG_IMG]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _registerFormCells = nil;
    _tpLoginDelegate = nil;
    self.registerFormTableView = nil;
    self.tpLoginTableView = nil;
    
    self.accountField = nil;
    self.nicknameField = nil;
    self.passwordField = nil;
    self.confirmPwdField = nil;
    self.accountCell = nil;
    self.nicknameCell = nil;
    self.passwordCell = nil;
    self.confirmPwdCell = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table View Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [_registerFormCells objectAtIndex:indexPath.row];
}

@end
