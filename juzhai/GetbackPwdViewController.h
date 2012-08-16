//
//  GetbackPwdViewController.h
//  juzhai
//
//  Created by user on 12-8-16.
//
//

#import <UIKit/UIKit.h>

@interface GetbackPwdViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *textField;

- (IBAction)getback:(id)sender;

@end
