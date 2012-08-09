//
//  SendPostViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SendPostViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomActionSheet.h"
#import "NSString+Chinese.h"
#import "MessageShow.h"
#import "RectButton.h"
#import "PostService.h"
#import "CustomNavigationController.h"
#import "Constant.h"
#import "BaseData.h"
#import "Category.h"

@interface SendPostViewController ()

@end

@implementation SendPostViewController

@synthesize navigationBar;
@synthesize textView;
@synthesize imageView;
@synthesize timeButton;
@synthesize placeButton;
@synthesize imageButton;
@synthesize categoryButton;
@synthesize timeLabel;
@synthesize placeLabel;
@synthesize categoryLabel;
@synthesize timeDelButton;
@synthesize placeDelButton;
@synthesize imageDelButton;
@synthesize infoView;

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
    
    // Do any additional setup after loading the view.
    if (IOS_VERSION >= 5.0){
        [navigationBar setBackgroundImage:TOP_BG_IMG forBarMetrics:UIBarMetricsDefault];
    } else {
        infoView.frame = CGRectMake(infoView.frame.origin.x, infoView.frame.origin.y + 36, infoView.frame.size.width, infoView.frame.size.height);
        textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, textView.frame.size.height + 36);
    }
    
    UIImage *backImage = [UIImage imageNamed:BACK_NORMAL_PIC_NAME];
    UIImage *activeBackImage = [UIImage imageNamed:BACK_HIGHLIGHT_PIC_NAME];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton setBackgroundImage:activeBackImage forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    navigationBar.topItem.leftBarButtonItem = backItem;
    
    _saveButton = [[RectButton alloc] initWithWidth:45.0 buttonText:@"发布" CapLocation:CapLeftAndRight];
    [_saveButton addTarget:self action:@selector(sendPost:) forControlEvents:UIControlEventTouchUpInside];
    _saveButton.enabled = NO;
    navigationBar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_saveButton];
    
    textView.font = DEFAULT_FONT(17);
    textView.textColor = [UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f];
    textView.delegate = self;
    
    timeLabel.font = DEFAULT_FONT(12);
    placeLabel.font = DEFAULT_FONT(12);
    categoryLabel.font = DEFAULT_FONT(12);
    timeLabel.textColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f];
    placeLabel.textColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f];
    categoryLabel.textColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f];
    
    Category *category = [[BaseData getCategories] objectAtIndex:0];
    categoryLabel.text = category.name;
    categoryLabel.tag = category.categoryId;
    
    [textView performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.5];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.navigationBar = nil;
    self.textView = nil;
    self.imageView = nil;
    self.timeButton = nil;
    self.placeButton = nil;
    self.imageButton = nil;
    self.categoryButton = nil;
    self.timeLabel = nil;
    self.placeLabel = nil;
    self.categoryLabel = nil;
    self.timeDelButton = nil;
    self.placeDelButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)back:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)timeButtonClick:(id)sender
{
    [textView resignFirstResponder];
    if (nil == _datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
    }
    
    CustomActionSheet *actionSheet = [[CustomActionSheet alloc] initWithHeight:_datePicker.frame.size.height withSheetTitle:@"拒宅时间" delegate:self];
    actionSheet.tag = DATE_ACTION_SHEET_TAG;
    [actionSheet.view addSubview: _datePicker];
    [actionSheet showInView:self.view];
}

- (IBAction)placeButtonClick:(id)sender
{
    [textView resignFirstResponder];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"输入地点" message:@"\n\n" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    if (_placeField == nil) {
        _placeField = [[UITextField alloc] initWithFrame:CGRectMake(15.0f, 51.0f, 254.0f, 30.0f)];
        _placeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _placeField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _placeField.placeholder = @"输入地点";
        _placeField.borderStyle = UITextBorderStyleRoundedRect;
    }
    if (_lastPlaceErrorInput != nil && ![_lastPlaceErrorInput isEqualToString:@""]) {
        _placeField.text = _lastPlaceErrorInput;
    }else {
        _placeField.text = placeLabel.text;
    }
    [alertView addSubview:_placeField];
    [alertView show];
}

- (IBAction)imageButtonClick:(id)sender
{
    [textView resignFirstResponder];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                                  initWithTitle:@"上传图片" 
                                  delegate:self 
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"用户相册", @"拍照", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)categoryButtonClick:(id)sender
{
    [textView resignFirstResponder];
    if (nil == _categoryPicker) {
        _categoryPicker = [[UIPickerView alloc] init];
        _categoryPicker.dataSource = self;
        _categoryPicker.delegate = self;
        _categoryPicker.showsSelectionIndicator = YES;
    }
    CustomActionSheet *actionSheet = [[CustomActionSheet alloc] initWithHeight:_categoryPicker.frame.size.height withSheetTitle:@"拒宅分类" delegate:self];
    actionSheet.tag = CATEGORY_ACTION_SHEET_TAG;
    [actionSheet.view addSubview: _categoryPicker];
    [actionSheet showInView:self.view];
}

- (IBAction)sendPost:(id)sender
{
    [textView resignFirstResponder];
    if (!_postService) {
        _postService = [[PostService alloc] init];
    }
    [_postService sendPost:textView.text withDate:timeLabel.text withPlace:placeLabel.text withImage:_image withCategory:categoryLabel.tag onView:self.view withSuccessCallback:^{
        [self performSelector:@selector(back:) withObject:nil afterDelay:1];
    }];
}

- (IBAction)timeDel:(id)sender
{
    timeLabel.text = @"";
    timeDelButton.hidden = YES;
    timeDelButton.enabled = NO;
}

- (IBAction)placeDel:(id)sender
{
    placeLabel.text = @"";
    placeDelButton.hidden = YES;
    placeDelButton.enabled = NO;
}

- (IBAction)imageDel:(id)sender
{
    _image = nil;
    imageView.image = nil;
    imageDelButton.hidden = YES;
    imageDelButton.enabled = NO;
}

#pragma mark - 
#pragma mark Custom Action Sheet Delegate

- (void) done:(CustomActionSheet *)actionSheet{
    if (actionSheet.tag == DATE_ACTION_SHEET_TAG) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        timeLabel.text = [dateFormatter stringFromDate:[_datePicker date]];
        timeDelButton.hidden = NO;
        timeDelButton.enabled = YES;
    } else if (actionSheet.tag == CATEGORY_ACTION_SHEET_TAG) {
        NSInteger row = [_categoryPicker selectedRowInComponent:0];
        Category *category = [[BaseData getCategories] objectAtIndex:row];
        categoryLabel.text = category.name;
        categoryLabel.tag = category.categoryId;
    }
    [textView becomeFirstResponder];
}

- (void)docancel:(CustomActionSheet *)actionSheet
{
    [textView becomeFirstResponder];
}

#pragma mark - 
#pragma mark Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != [actionSheet cancelButtonIndex]){
        UIImagePickerControllerSourceType sourceType;
        if(buttonIndex == 0){
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }else {
            if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }else {
                sourceType = UIImagePickerControllerSourceTypeCamera;
            }
        }
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];
    } else {
        [textView becomeFirstResponder];
    }
}

#pragma mark -
#pragma mark Image Picker Controller Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self imagePickerControllerDidCancel:picker];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    _image = image;
    self.imageView.image = image;
    imageDelButton.hidden = NO;
    imageDelButton.enabled = YES;
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
    [textView becomeFirstResponder];
}

#pragma mark -
#pragma mark Alert View Delegate

- (void)didPresentAlertView:(UIAlertView *)alertView {
    [_placeField becomeFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex != [alertView cancelButtonIndex]) {
		//验证字数
        NSString *value = [_placeField.text stringByTrimmingCharactersInSet: 
                           [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSInteger textLength = [value chineseLength];
        if (textLength > PLACE_MAX_LENGTH) {
            _lastPlaceErrorInput = value;
            [MessageShow error:PLACE_MAX_ERROR_TEXT onView:alertView];
            return;
        }else {
            _lastPlaceErrorInput = nil;
            placeLabel.text = value;
            if ([value isEqualToString:@""]) {
                placeDelButton.hidden = YES;
                placeDelButton.enabled = NO;
            } else {
                CGSize placeLabelSize = [placeLabel.text sizeWithFont:placeLabel.font constrainedToSize:CGSizeMake(177, 16)lineBreakMode:UILineBreakModeTailTruncation];
                placeLabel.frame = CGRectMake(placeLabel.frame.origin.x, placeLabel.frame.origin.y, placeLabelSize.width, placeLabelSize.height);
                placeDelButton.hidden = NO;
                placeDelButton.enabled = YES;
                placeDelButton.frame = CGRectMake(placeLabel.frame.origin.x + placeLabel.frame.size.width + 5, placeDelButton.frame.origin.y, placeDelButton.frame.size.width, placeDelButton.frame.size.height);
            }
        }
	}
    [textView becomeFirstResponder];
}

#pragma mark -
#pragma mark Text View Delegate

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *value = [self.textView.text stringByTrimmingCharactersInSet: 
                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _saveButton.enabled = ![value isEqualToString:@""];
}


#pragma mark - 
#pragma mark Picker Data Source Methods

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [[BaseData getCategories] count];
}

#pragma mark Picker Delegate Methods

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    Category *category = [[BaseData getCategories] objectAtIndex:row];
    return category.name;
}

#pragma mark -
#pragma mark Navigation Delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (IOS_VERSION >= 5.0) {
       [navigationController.navigationBar setBackgroundImage:TOP_BG_IMG forBarMetrics:UIBarMetricsDefault]; 
    }
    navigationController.navigationBar.barStyle = UIBarStyleDefault;
}


@end
