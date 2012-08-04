//
//  ProfessionEditorViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ProfessionEditorViewController.h"
#import "BaseData.h"
#import "Profession.h"
#import "RectButton.h"
#import "ProfileSettingViewController.h"
#import "MessageShow.h"
#import "Constant.h"
#import "ProfileValidation.h"

@interface ProfessionEditorViewController ()

@end

@implementation ProfessionEditorViewController

@synthesize cellIdentifier;
@synthesize textValue;
@synthesize professionPicker;
@synthesize professionField;
@synthesize tipsLabel;
@synthesize valueId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.    
    self.title = @"职业";
    
    _professionArray = [BaseData getProfessions];
    professionField.background = [[UIImage imageNamed:@"send_input_bgxy"] stretchableImageWithLeftCapWidth:7 topCapHeight:7];
    UILabel *paddingView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, professionField.frame.size.height)];
    paddingView.backgroundColor = [UIColor clearColor];
    professionField.leftView = paddingView;
    professionField.leftViewMode = UITextFieldViewModeAlways;
    professionField.textColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f];
    professionField.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:15];
    
    tipsLabel.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:15];
    tipsLabel.textColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f];
}

- (void) showTextField:(bool)isShow{
    professionField.hidden = !isShow;
    tipsLabel.hidden = !isShow;
    CGRect frame = professionPicker.frame;
    if (isShow) {
        frame.origin.y = 100;
        professionPicker.frame = frame;
//        [professionField becomeFirstResponder];
    } else {
        [professionField resignFirstResponder];
        frame.origin.y = 0;
        professionPicker.frame = frame;
    }
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (valueId == 0){
        [professionPicker selectRow:[_professionArray count] inComponent:0 animated:NO];
        [self showTextField:YES];
        professionField.text = textValue;
    }else {
        NSInteger index = 0;
        if (valueId > 0) {
            int i = 0;
            for (Profession *p in _professionArray) {
                if (p.professionId.intValue == valueId) {
                    index = i;
                    break;
                }
                i++;
            }
        }
        [professionPicker selectRow:index inComponent:0 animated:NO];
        [self showTextField:NO];
        professionField.text = @"";
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.cellIdentifier = nil;
    self.textValue = nil;
    self.professionPicker = nil;
    self.professionField = nil;
    self.tipsLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)backgroundTap:(id)sender
{
    [professionField resignFirstResponder];
}

-(IBAction)save:(id)sender{
    [professionField resignFirstResponder];
    if (professionField.hidden){
        NSInteger row = [professionPicker selectedRowInComponent:0];
        Profession *p = [_professionArray objectAtIndex:row];
        if(p != nil){
            [self.settingViewController saveSingleInfo:self.cellIdentifier withValue:p.name withValueId:p.professionId.intValue];
        }
    }else {
        //验证
        NSString *value = [professionField.text stringByTrimmingCharactersInSet: 
                           [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *errorInfo = [ProfileValidation validateProfession:value];
        if (errorInfo && ![errorInfo isEqualToString:nil]) {
            [MessageShow error:errorInfo onView:self.view];
            return;
        }
        [self.settingViewController saveSingleInfo:self.cellIdentifier withValue:value withValueId:0];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_professionArray count] + 1;
}

#pragma mark Picker Delegate Methods
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (row == [_professionArray count]) {
        return @"其它";
    }
    Profession *profession = (Profession *)[_professionArray objectAtIndex:row];
    return profession.name;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (row == [_professionArray count]) {
        [self showTextField:YES];
    }else {
        [professionField resignFirstResponder];
        [self showTextField:NO];
    }
}

@end
