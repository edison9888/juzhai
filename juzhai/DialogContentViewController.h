//
//  DialogContentViewController.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextView.h"

@class JZData;
@class UserView;
@class DialogService;
@class ListHttpRequestDelegate;
@class GrowingTextView;

#define TIMER_INTERVAL 10

#define GROWING_TEXT_VIEW_TAG 1000

@interface DialogContentViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CustomTextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>
{
    UIPanGestureRecognizer *_singlePan;
    UITapGestureRecognizer *_singleTap;
    JZData *_data;
    DialogService *_dialogService;
    NSTimer *_timer;
    ListHttpRequestDelegate *_listHttpRequestDelegate;
    UIImage *_image;
    CGFloat _textViewOriginalX;
    CGFloat _textVieworiginalWidth;
}
@property (strong, nonatomic) UserView *targetUser;
@property (strong, nonatomic) IBOutlet UIView *inputAreaView;
@property (strong, nonatomic) IBOutlet UIImageView *inputAreaBgImageView;
@property (strong, nonatomic) IBOutlet UITableView *dialogContentTableView;
@property (strong, nonatomic) IBOutlet GrowingTextView *textView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)sendSms:(id)sender;
- (IBAction)imageButtonClick:(id)sender;

@end
