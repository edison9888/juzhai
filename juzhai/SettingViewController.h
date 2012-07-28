//
//  SettingViewController.h
//  juzhai
//
//  Created by JiaJun Wu on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomActionSheet.h"

@class UserView;
@class RectButton;
@class NicknameEditorViewController;
@class ProfessionEditorViewController;
@class FeatureEditorViewController;
@class ASIFormDataRequest;

#define LOGO_ACTION_SHEET_TAG 0
#define BIRTH_ACTION_SHEET_TAG 1
#define GENDER_ACTION_SHEET_TAG 2
#define LOCATION_ACTION_SHEET_TAG 3

#define LOGO_CELL_IDENTIFIER @"LogoCell"
#define NICKNAME_CELL_IDENTIFIER @"NicknameCell"
#define GENDER_CELL_IDENTIFIER @"GenderCell"
#define BIRTH_CELL_IDENTIFIER @"BirthCell"
#define FEATURE_CELL_IDENTIFIER @"FeatureCell"
#define PROFESSION_CELL_IDENTIFIER @"ProfessionCell"
#define LOCATION_CELL_IDENTIFIER @"LocationCell"

#define PROVINCE_PICKER_COMPONENT 0
#define CITY_PICKER_COMPONENT 1

@interface SettingViewController : UITableViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIActionSheetDelegate, CustomActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSMutableDictionary *_cellDictionary;
    NSDictionary *_cellIdentifierDictionary;
    NSArray *_disableSelectCellIdentifiterArray;
    RectButton *_saveButton;
    NicknameEditorViewController *_nicknameEditorViewController;
    ProfessionEditorViewController *_professionEditorViewController;
    FeatureEditorViewController *_featureEditorViewController;
    UIImage *_newLogo;
    UIDatePicker *_datePicker;
    UIPickerView *_locationPicker;
    NSArray *_provinceArray;
    NSArray *_cityArray;
    BOOL _locationPickerHasLoaded;
}
@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (strong, nonatomic) IBOutlet UILabel *birthLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UILabel *professionLabel;
@property (strong, nonatomic) IBOutlet UILabel *featureLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

- (void) saveSingleInfo:(NSString *)cellIdentifier withValue:(NSString *)value withValueId:(NSInteger)valueId;
- (void) initUserView:(UserView *)userView;
- (IBAction)save:(id)sender;

@end
