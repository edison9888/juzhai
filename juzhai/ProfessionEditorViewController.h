//
//  ProfessionEditorViewController.h
//  juzhai
//
//  Created by JiaJun Wu on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailEditorViewController.h"

@interface ProfessionEditorViewController : DetailEditorViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray *_professionArray;
}
@property (strong, nonatomic) NSString *textValue;
@property (nonatomic) NSInteger valueId;
@property (strong, nonatomic) NSString *cellIdentifier;

@property (strong, nonatomic) IBOutlet UIPickerView *professionPicker;
@property (strong, nonatomic) IBOutlet UILabel *tipsLabel;
@property (strong, nonatomic) IBOutlet UITextField *professionField;

- (IBAction)backgroundTap:(id)sender;

@end
