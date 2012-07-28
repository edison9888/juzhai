//
//  NicknameEditorViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NicknameEditorViewController.h"
#import "RectButton.h"
#import "ProfileSettingViewController.h"
#import "UserView.h"
#import <QuartzCore/QuartzCore.h>
#import "Constant.h"
#import "ProfileValidation.h"
#import "MessageShow.h"

@interface NicknameEditorViewController ()

@end

@implementation NicknameEditorViewController

@synthesize textField;
@synthesize tipsLabel;
@synthesize textValue;
@synthesize cellIdentifier;

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
    // Do any additional setup after loading the view from its nib.
    self.title = @"昵称";
    textField.background = [[UIImage imageNamed:@"send_input_bgxy"] stretchableImageWithLeftCapWidth:7 topCapHeight:7];
    UILabel *paddingView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, textField.frame.size.height)];
    paddingView.backgroundColor = [UIColor clearColor];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.textColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f];
    textField.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:15];
    
    tipsLabel.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:15];
    tipsLabel.textColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f];
}

- (void) viewWillAppear:(BOOL)animated{
    self.textField.text = self.textValue;
    [self.textField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.textField = nil;
    self.tipsLabel = nil;
    self.textValue = nil;
    self.cellIdentifier = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)save:(id)sender{
    //验证
    NSString *value = [textField.text stringByTrimmingCharactersInSet: 
                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *errorInfo = [ProfileValidation validateNickname:value];
    if (errorInfo && ![errorInfo isEqualToString:@""]) {
        [textField resignFirstResponder];
        [MessageShow error:errorInfo onView:self.view];
        return;
    }
    [self.settingViewController saveSingleInfo:self.cellIdentifier withValue:textField.text withValueId:0];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
