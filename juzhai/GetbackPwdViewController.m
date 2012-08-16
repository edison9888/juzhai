//
//  GetbackPwdViewController.m
//  juzhai
//
//  Created by user on 12-8-16.
//
//

#import "GetbackPwdViewController.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "HttpRequestSender.h"
#import "UrlUtils.h"
#import "SBJson.h"
#import "MessageShow.h"

@interface GetbackPwdViewController ()

@end

@implementation GetbackPwdViewController

@synthesize textField;

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
    self.title = @"找回密码";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BG_IMG]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)getback:(id)sender
{//验证
    NSString *value = [textField.text stringByTrimmingCharactersInSet:
                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (value.length <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请输入需要找回密码的登录账号" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.dimBackground = YES;
    hud.labelText = @"发送中...";
    hud.yOffset = -77;
	[hud showWhileExecuting:@selector(getbackFinish:) onTarget:self withObject:value animated:YES];
}

- (void)getbackFinish:(NSString *)email
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:email, @"account", nil];
    ASIFormDataRequest *request = [HttpRequestSender postRequestWithUrl:[UrlUtils urlStringWithUri:@"passport/getbackpwd"] withParams:params];
    if (request != nil) {
        [request startSynchronous];
        NSError *error = [request error];
        if (!error && [request responseStatusCode] == 200){
            NSString *response = [request responseString];
            NSMutableDictionary *jsonResult = [response JSONValue];
            if([jsonResult valueForKey:@"success"] == [NSNumber numberWithBool:YES]){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"邮件已发出" message:[NSString stringWithFormat:@"去%@收信", email] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [alertView show];
            }else{
                NSString *errorInfo = [jsonResult valueForKey:@"errorInfo"];
                if (errorInfo == nil || [errorInfo isEqual:[NSNull null]] || [errorInfo isEqualToString:@""]) {
                    errorInfo = SERVER_ERROR_INFO;
                }
                [MessageShow error:errorInfo onView:self.navigationController.view];
            }
        }else{
            [HttpRequestDelegate requestFailedHandle:request];
        }
    }
}

#pragma mark -
#pragma mark - Alert View Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
    textField.text = @"";
}

@end
