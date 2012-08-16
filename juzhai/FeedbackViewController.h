//
//  FeedbackViewController.h
//  juzhai
//
//  Created by user on 12-8-16.
//
//

#import <UIKit/UIKit.h>

@class CustomTextView;
@class DialogService;

@interface FeedbackViewController : UIViewController
{
    DialogService *_dialogService;
}

@property (strong, nonatomic) IBOutlet CustomTextView *customTextView;

@end
