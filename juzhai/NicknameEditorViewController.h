//
//  NicknameEditorViewController.h
//  juzhai
//
//  Created by JiaJun Wu on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailEditorViewController.h"

@interface NicknameEditorViewController : DetailEditorViewController

@property (strong, nonatomic) NSString *textValue;
@property (strong, nonatomic) NSString *cellIdentifier;

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *tipsLabel;


@end
