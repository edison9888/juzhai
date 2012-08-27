//
//  FeedbackViewController.m
//  juzhai
//
//  Created by user on 12-8-16.
//
//

#import "FeedbackViewController.h"
#import "CustomTextView.h"
#import "Constant.h"
#import "RectButton.h"
#import "MBProgressHUD.h"
#import "DialogService.h"
#import "DialogContentView.h"
#import "MessageShow.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

@synthesize customTextView;

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
    self.title = @"意见反馈";
    
    self.customTextView.backgroundImage = [[UIImage imageNamed:@"send_input_bgxy"] stretchableImageWithLeftCapWidth:7 topCapHeight:7];
    self.customTextView.font = DEFAULT_FONT(15);
    self.customTextView.textColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f];
    
    RectButton *saveButton = [[RectButton alloc] initWithWidth:45.0 buttonText:@"发送" CapLocation:CapLeftAndRight];
    [saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BG_IMG]];
    
    [self.customTextView becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _dialogService = nil;
    self.customTextView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)save:(id)sender{
    if (_dialogService == nil) {
        _dialogService = [[DialogService alloc] init];
    }
    //验证
    NSString *value = [customTextView.text stringByTrimmingCharactersInSet:
                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
    hud.labelText = @"发送中...";
    hud.yOffset = -77;
    DialogContentView *view = [[DialogContentView alloc] init];
    view.content = value;
    view.receiverUid = 2;
    [_dialogService sendSms:view inQueue:nil onSuccess:^(NSDictionary *info) {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"发送成功";
        [hud hide:YES afterDelay:1];
        [self performSelector:@selector(back:) withObject:nil afterDelay:1];
        customTextView.text = @"";
    } onFailure:^(NSString *error, BOOL hasSent) {
        [MBProgressHUD hideHUDForView:self.tabBarController.view animated:YES];
        if (nil != error && ![error isEqualToString:@""]) {
            [MessageShow error:error onView:nil];
        }
    }];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
