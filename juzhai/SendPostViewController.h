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

#define TEXT_MAX_LENGTH 160
#define TEXT_MIN_LENGTH 4

#define PLACE_ALERT_VIEW_TAG 1

@interface SendPostViewController : UIViewController <CustomActionSheetDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIAlertViewDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIDatePicker *_datePicker;
    UITextField *_placeField;
    NSString *_lastPlaceErrorInput;
    UIButton *_saveButton;
    PostService *_postService;
    UIPickerView *_categoryPicker;
    
    NSString *_place;
    NSString *_time;
    UIImage *_image;
    NSInteger _categoryId;
}

@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *timeButton;
@property (strong, nonatomic) IBOutlet UIButton *placeButton;
@property (strong, nonatomic) IBOutlet UIButton *imageButton;
@property (strong, nonatomic) IBOutlet UIButton *categoryButton;
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UILabel *remainLengthLabel;

- (IBAction)timeButtonClick:(id)sender;
- (IBAction)placeButtonClick:(id)sender;
- (IBAction)imageButtonClick:(id)sender;
- (IBAction)categoryButtonClick:(id)sender;

- (IBAction)emptyText:(id)sender;

@end
