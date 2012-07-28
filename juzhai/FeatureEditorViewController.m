//
//  FeatureEditorViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FeatureEditorViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RectButton.h"
#import "ProfileSettingViewController.h"
#import "ProfileValidation.h"
#import "MessageShow.h"
#import "Constant.h"
#import "CustomTextView.h"

@interface FeatureEditorViewController ()

@end

@implementation FeatureEditorViewController

@synthesize cellIdentifier;
@synthesize tipsLabel;
@synthesize textView;
@synthesize textValue;

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
    
    self.title = @"自我评价";
    
    textView.backgroundImage = [[UIImage imageNamed:@"send_input_bgxy"] stretchableImageWithLeftCapWidth:7 topCapHeight:7];
    
    textView.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:15];
    textView.textColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f];
    
    tipsLabel.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:15];
    tipsLabel.textColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f];
}

- (void) viewWillAppear:(BOOL)animated{
    [textView becomeFirstResponder];
    textView.text = textValue;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.cellIdentifier = nil;
    self.tipsLabel = nil;
    self.textView = nil;
    self.textValue = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)save:(id)sender{
    //验证
    NSString *value = [textView.text stringByTrimmingCharactersInSet: 
                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *errorInfo = [ProfileValidation validateFeature:value];
    if (errorInfo && ![errorInfo isEqualToString:@""]) {
        [MessageShow error:errorInfo onView:self.view];
        return;
    }
    
    NSInteger tag = [value isEqualToString:@""] ? 0 : 1;
    [self.settingViewController saveSingleInfo:self.cellIdentifier withValue:value withValueId:tag];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
