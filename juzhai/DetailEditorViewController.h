//
//  DetailEditorViewController.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingViewController;

@interface DetailEditorViewController : UIViewController

@property (strong, nonatomic) SettingViewController *settingViewController;

- (IBAction)save:(id)sender;

@end
