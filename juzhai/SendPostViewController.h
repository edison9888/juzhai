//
//  SendPostViewController.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomActionSheet.h"

@class PostService;

#define BACK_NORMAL_PIC_NAME @"back_btn_link.png"
#define BACK_HIGHLIGHT_PIC_NAME @"back_btn_hover.png"

#define PLACE_MAX_LENGTH 100
#define PLACE_MAX_ERROR_TEXT @"地点字数控制在50字以内"

#define CATEGORY_ACTION_SHEET_TAG 0
#define DATE_ACTION_SHEET_TAG 1

@interface SendPostViewController : UIViewController <CustomActionSheetDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIAlertViewDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIDatePicker *_datePicker;
    UIImage *_image;
    UITextField *_placeField;
    NSString *_lastPlaceErrorInput;
    UIButton *_saveButton;
    PostService *_postService;
    UIPickerView *_categoryPicker;
}

@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *timeButton;
@property (strong, nonatomic) IBOutlet UIButton *placeButton;
@property (strong, nonatomic) IBOutlet UIButton *imageButton;
@property (strong, nonatomic) IBOutlet UIButton *categoryButton;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *placeLabel;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) IBOutlet UIButton *timeDelButton;
@property (strong, nonatomic) IBOutlet UIButton *placeDelButton;
@property (strong, nonatomic) IBOutlet UIButton *imageDelButton;
@property (strong, nonatomic) IBOutlet UIView *infoView;

- (IBAction)timeButtonClick:(id)sender;
- (IBAction)placeButtonClick:(id)sender;
- (IBAction)imageButtonClick:(id)sender;
- (IBAction)categoryButtonClick:(id)sender;
- (IBAction)timeDel:(id)sender;
- (IBAction)placeDel:(id)sender;
- (IBAction)imageDel:(id)sender;

@end
