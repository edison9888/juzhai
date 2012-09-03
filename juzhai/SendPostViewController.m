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
#import "UIImage+UIImageExt.h"
#import "NSString+Chinese.h"

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
@synthesize infoView;
@synthesize remainLengthLabel;

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
    [textView becomeFirstResponder];
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
    
    imageView.layer.cornerRadius = 3.0;
    imageView.layer.masksToBounds = YES;
    
    _categoryId = [[[BaseData getCategories] objectAtIndex:0] categoryId];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    self.navigationBar = nil;
    self.textView = nil;
    self.imageView = nil;
    self.timeButton = nil;
    self.placeButton = nil;
    self.imageButton = nil;
    self.categoryButton = nil;
    _image = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    _image = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)back:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect infoViewFrame = infoView.frame;
    infoViewFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + infoViewFrame.size.height);
    
    CGRect textViewFrame = textView.frame;
    textViewFrame.size.height = infoViewFrame.origin.y - 10 - textView.frame.origin.y;
    
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	infoView.frame = infoViewFrame;
    textView.frame = textViewFrame;
	
	// commit animations
	[UIView commitAnimations];
}

- (IBAction)timeButtonClick:(id)sender
{
    if (nil == _datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
    }
    
    CustomActionSheet *actionSheet = [[CustomActionSheet alloc] initWithHeight:_datePicker.frame.size.height withSheetTitle:@"拒宅时间" withCancelTitle:@"清空" withDoneTitle:nil delegate:self];
    actionSheet.tag = DATE_ACTION_SHEET_TAG;
    [actionSheet.view addSubview: _datePicker];
    [actionSheet showInView:self.view];
}

- (IBAction)placeButtonClick:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"输入地点" message:@"\n\n" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = PLACE_ALERT_VIEW_TAG;
    
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
        
    }
    [alertView addSubview:_placeField];
    [alertView show];
}

- (IBAction)imageButtonClick:(id)sender
{
    UIActionSheet *actionSheet = nil;
    if (_image != nil) {
        actionSheet = [[UIActionSheet alloc] 
                       initWithTitle:@"上传图片" 
                       delegate:self 
                       cancelButtonTitle:@"取消"
                       destructiveButtonTitle:nil
                       otherButtonTitles:@"用户相册", @"拍照", @"清除照片", nil];
    } else {
        actionSheet = [[UIActionSheet alloc] 
                       initWithTitle:@"上传图片" 
                       delegate:self 
                       cancelButtonTitle:@"取消"
                       destructiveButtonTitle:nil
                       otherButtonTitles:@"用户相册", @"拍照", nil];
    }
    [actionSheet showInView:self.view];
}

- (IBAction)categoryButtonClick:(id)sender
{
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
    if ([textView.text chineseLength] > TEXT_MAX_LENGTH || [textView.text chineseLength] < TEXT_MIN_LENGTH) {
        [MessageShow error:@"发布内容请控制在2~80字以内" onView:self.view];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"afc" message:
//                              @"abc" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil]; 
//        [alert performSelector:@selector(show) withObject:nil afterDelay:0.1];
        return;
    }
    if (!_postService) {
        _postService = [[PostService alloc] init];
    }
    [_postService sendPost:textView.text withDate:_time withPlace:_place withImage:_image  withCategory:_categoryId onView:self.view withSuccessCallback:^{
        [self performSelector:@selector(back:) withObject:nil afterDelay:1];
    }];
}

- (IBAction)emptyText:(id)sender
{
    textView.text = @"";
}

#pragma mark - 
#pragma mark Custom Action Sheet Delegate

- (void) done:(CustomActionSheet *)actionSheet{
    if (actionSheet.tag == DATE_ACTION_SHEET_TAG) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        _time = [dateFormatter stringFromDate:_datePicker.date];
        [timeButton setBackgroundImage:[UIImage imageNamed:@"send_jz_icon_time_done"] forState:UIControlStateNormal];
    } else if (actionSheet.tag == CATEGORY_ACTION_SHEET_TAG) {
        NSInteger row = [_categoryPicker selectedRowInComponent:0];
        Category *category = [[BaseData getCategories] objectAtIndex:row];
        _categoryId = category.categoryId;
        [categoryButton setBackgroundImage:[UIImage imageNamed:@"send_jz_icon_fenlei_done"] forState:UIControlStateNormal];
    }
//    [textView becomeFirstResponder];
}

- (void)docancel:(CustomActionSheet *)actionSheet
{
    if (actionSheet.tag == DATE_ACTION_SHEET_TAG) {
        [timeButton setBackgroundImage:[UIImage imageNamed:@"send_jz_icon_time_link"] forState:UIControlStateNormal];
        _time = nil;
    }
//    [textView becomeFirstResponder];
}

#pragma mark - 
#pragma mark Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        _image = nil;
        imageView.image = nil;
        imageView.hidden = YES;
        [imageButton setBackgroundImage:[UIImage imageNamed:@"send_jz_icon_photo_link"] forState:UIControlStateNormal];
        return;
    }
    if(buttonIndex != [actionSheet cancelButtonIndex]){
        UIImagePickerControllerSourceType sourceType;
        if(buttonIndex == 0){
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }else if (buttonIndex == 1) {
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
//        [textView becomeFirstResponder];
    }
}

#pragma mark -
#pragma mark Image Picker Controller Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    _image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.imageView.image = _image;
    self.imageView.hidden = NO;
    [imageButton setBackgroundImage:[UIImage imageNamed:@"send_jz_icon_photo_done"] forState:UIControlStateNormal];
    [self imagePickerControllerDidCancel:picker];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
//    [textView becomeFirstResponder];
}

#pragma mark -
#pragma mark Alert View Delegate

- (void)didPresentAlertView:(UIAlertView *)alertView {
    if (alertView.tag == PLACE_ALERT_VIEW_TAG) {
        [_placeField becomeFirstResponder];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == PLACE_ALERT_VIEW_TAG) {
        if (buttonIndex != [alertView cancelButtonIndex]) {
            //验证字数
            _place = @"";
            NSString *value = [_placeField.text stringByTrimmingCharactersInSet: 
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSInteger textLength = [value chineseLength];
            if (textLength > PLACE_MAX_LENGTH) {
                _lastPlaceErrorInput = value;
                [MessageShow error:PLACE_MAX_ERROR_TEXT onView:alertView];
                return;
            }else {
                _lastPlaceErrorInput = nil;
                _place = value;
                if ([value isEqualToString:@""]) {
                    [placeButton setBackgroundImage:[UIImage imageNamed:@"send_jz_icon_didian_link"] forState:UIControlStateNormal];
                } else {
                    [placeButton setBackgroundImage:[UIImage imageNamed:@"send_jz_icon_didian_done"] forState:UIControlStateNormal];
                }
            }
        }
    }
//    [textView becomeFirstResponder];
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    [textView becomeFirstResponder];
//}

#pragma mark -
#pragma mark Text View Delegate

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *value = [self.textView.text stringByTrimmingCharactersInSet: 
                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _saveButton.enabled = ![value isEqualToString:@""];
    NSInteger remainLength = TEXT_MAX_LENGTH - [value chineseLength];
    remainLengthLabel.text = [NSString stringWithFormat:@"%d", remainLength/2];
    if (remainLength < 0) {
        remainLengthLabel.textColor = [UIColor redColor];
    } else {
        remainLengthLabel.textColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f];
    }
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
