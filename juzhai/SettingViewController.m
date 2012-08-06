//
//  SettingViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "RectButton.h"
#import "UserView.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UserContext.h"
#import <QuartzCore/QuartzCore.h>
#import "NicknameEditorViewController.h"
#import "ProfessionEditorViewController.h"
#import "FeatureEditorViewController.h"
#import "MBProgressHUD.h"
#import "CustomActionSheet.h"
#import "BaseData.h"
#import "Province.h"
#import "City.h"
#import "HttpRequestSender.h"
#import "MessageShow.h"
#import "SBJson.h"
#import "Constant.h"
#import "CustomNavigationController.h"
#import "UIImage+UIImageExt.h"

@interface SettingViewController (Private)

- (void)doSave:(MBProgressHUD *)hud;
- (void)saveSuccess;
- (BOOL)validateSave;
- (NSDictionary *) getParams;
- (void) postNewLogo:(ASIFormDataRequest *)request;
- (NSString *)postUrl;

@end

@implementation SettingViewController

@synthesize logoImageView;
@synthesize nicknameLabel;
@synthesize birthLabel;
@synthesize genderLabel;
@synthesize featureLabel;
@synthesize professionLabel;
@synthesize locationLabel;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _provinceArray = [BaseData getProvinces];
    _cityArray = [BaseData getCitiesWithProvinceId:((Province *)[_provinceArray objectAtIndex:0]).provinceId];
    
    NSArray *settingCells = [[NSBundle mainBundle] loadNibNamed:@"ProfileSettingForm" owner:self options:nil];
    _cellDictionary = [[NSMutableDictionary alloc] initWithCapacity:settingCells.count];
    for (UITableViewCell *cell in settingCells) {
        [_cellDictionary setObject:cell forKey:cell.reuseIdentifier];
    }
    
    _saveButton = [[RectButton alloc] initWithWidth:45.0 buttonText:@"保存" CapLocation:CapLeftAndRight];
    [_saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    _saveButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_saveButton];
    
    self.tableView.separatorColor = [UIColor colorWithRed:0.71f green:0.71f blue:0.71f alpha:1.00f];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BG_IMG]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!_saveButton.enabled){
        UserView *userView = [UserContext getUserView];
        
        self.logoImageView.image = [UIImage imageNamed:FACE_LOADING_IMG];
        self.logoImageView.layer.masksToBounds = YES;
        self.logoImageView.layer.cornerRadius = 5.0;
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        NSURL *imageURL = [NSURL URLWithString:userView.rawLogo];
        [manager downloadWithURL:imageURL delegate:self options:0 success:^(UIImage *image) {
            self.logoImageView.image = [image imageByScalingAndCroppingForSize:CGSizeMake(self.logoImageView.frame.size.width*2, self.logoImageView.frame.size.height*2)];
        } failure:nil];
        if (userView.nickname && ![userView.nickname isEqual:[NSNull null]]) {
            self.nicknameLabel.text = userView.nickname;
        }
        if (userView.gender && ![userView.gender isEqual:[NSNull null]]) {
            self.genderLabel.text = userView.gender.intValue == 0 ? @"女" : @"男";
            self.genderLabel.tag = userView.gender.intValue;
        }
        if (userView.birthYear && ![userView.birthYear isEqual:[NSNull null]] && userView.birthYear.intValue > 0) {
            self.birthLabel.text = [NSString stringWithFormat:@"%d-%d-%d", userView.birthYear.intValue, userView.birthMonth.intValue, userView.birthDay.intValue];
        }
        if (userView.professionId && ![userView.professionId isEqual:[NSNull null]]) {
            self.professionLabel.tag = userView.professionId.intValue;
        }
        if (userView.profession && ![userView.profession isEqual:[NSNull null]]) {
            self.professionLabel.text = userView.profession;
        }
        if (userView.feature && ![userView.feature isEqual:[NSNull null]] && ![userView.feature isEqualToString:@""]) {
            self.featureLabel.text = userView.feature;
            self.featureLabel.tag = 1;
        }else {
            self.featureLabel.tag = 0;
        }
        if (userView.cityName && ![userView.cityName isEqual:[NSNull null]]) {
            self.locationLabel.text = userView.cityName;
            self.locationLabel.tag = userView.cityId.intValue;
        }
    }
    CGSize contentSize = [self.featureLabel.text sizeWithFont:self.featureLabel.font constrainedToSize:CGSizeMake(280.0, 640.0) lineBreakMode:UILineBreakModeCharacterWrap];
    self.featureLabel.frame = CGRectMake(self.featureLabel.frame.origin.x, self.featureLabel.frame.origin.y, contentSize.width, contentSize.height);
    
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) saveSingleInfo:(NSString *)cellIdentifier withValue:(NSString *)value withValueId:(NSInteger)valueId{
    UITableViewCell *cell = [_cellDictionary objectForKey:cellIdentifier];
    if(nil != cell){
        cell.detailTextLabel.text = value;
        cell.detailTextLabel.tag = valueId;
        _saveButton.enabled = YES;
        [self.tableView reloadData];
    }
}

- (void) initUserView:(UserView *)userView{
    if (nil != _saveButton) {
        _saveButton.enabled = NO;
        _locationPickerHasLoaded = NO;
        _newLogo = nil;
    }
}


- (BOOL)validateSave{
    return YES;
}

- (void)saveSuccess{
    
}

- (NSDictionary *)getParams{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.nicknameLabel.text, @"nickname", [NSNumber numberWithInt:self.genderLabel.tag], @"gender", self.birthLabel.text, @"birth", [NSNumber numberWithInt:self.professionLabel.tag], @"professionId", self.professionLabel.text, @"profession", [NSNumber numberWithInt:self.locationLabel.tag], @"cityId", nil];
    if (self.featureLabel.tag > 0) {
        [params setValue:self.featureLabel.text forKey:@"feature"];
    }
    
    return params;
}

- (void) postNewLogo:(ASIFormDataRequest *)request{
    if (_newLogo != nil) {
        CGFloat compression = 0.9f;
        CGFloat maxCompression = 0.1f;
        int maxFileSize = 2*1024*1024;
        
        NSData *imageData = UIImageJPEGRepresentation(_newLogo, compression);
        while ([imageData length] > maxFileSize && compression > maxCompression){
            compression -= 0.1;
            imageData = UIImageJPEGRepresentation(_newLogo, compression);
        }
        [request setData:imageData withFileName:@"logo.jpg" andContentType:@"image/jpeg" forKey:@"logo"];
    }
}

- (void)doSave:(MBProgressHUD *)hud{
    ASIFormDataRequest *request = [HttpRequestSender postRequestWithUrl:[self postUrl] withParams: [self getParams]];
    if (request) {
        [self postNewLogo:request];
        [request startSynchronous];
        NSError *error = [request error];
        NSString *errorInfo = SERVER_ERROR_INFO;
        if (!error && [request responseStatusCode] == 200){
            NSString *response = [request responseString];
            NSMutableDictionary *jsonResult = [response JSONValue];
            if([jsonResult valueForKey:@"success"] == [NSNumber numberWithBool:YES]){
                //保存成功
                _saveButton.enabled = NO;
                [[UserContext getUserView] updateFromDictionary:[jsonResult valueForKey:@"result"]];
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"保存成功";
                [self saveSuccess];
                return;
            }else{
                errorInfo = [jsonResult valueForKey:@"errorInfo"];
            }
            [MessageShow error:errorInfo onView:self.navigationController.view];
        }else{
            NSLog(@"error: %@", [request responseStatusMessage]);
            [HttpRequestDelegate requestFailedHandle:request];
        }
    }
}

- (IBAction)save:(id)sender{
    if ([self validateSave]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.dimBackground = YES;
        hud.labelText = @"保存中...";
        [hud showWhileExecuting:@selector(doSave:) onTarget:self withObject:hud animated:YES];
    }
}

#pragma mark -
#pragma mark Image Picker Controller Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    _newLogo = image;
    self.logoImageView.image = [image imageByScalingAndCroppingForSize:CGSizeMake(self.logoImageView.frame.size.width*2, self.logoImageView.frame.size.height*2)];
    _saveButton.enabled = YES;
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = [_cellIdentifierDictionary objectForKey:[NSNumber numberWithInt:(indexPath.section * 10 + indexPath.row)]];
    UITableViewCell *cell = [_cellDictionary objectForKey:cellIdentifier];
    if ([_disableSelectCellIdentifiterArray containsObject:cellIdentifier]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifiter = [_cellIdentifierDictionary objectForKey:[NSNumber numberWithInt:(indexPath.section * 10 + indexPath.row)]];
    if ([FEATURE_CELL_IDENTIFIER isEqual:cellIdentifiter]) {
        return 50.0 + self.featureLabel.frame.size.height;
    }else {
        return 44.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *cellIdentifiter = [_cellIdentifierDictionary objectForKey:[NSNumber numberWithInt:(indexPath.section * 10 + indexPath.row)]];
    if ([_disableSelectCellIdentifiterArray containsObject:cellIdentifiter]) {
        return;
    }
    
    //头像
    if([LOGO_CELL_IDENTIFIER isEqual:cellIdentifiter]){
        //弹框选择性别
        UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                                      initWithTitle:@"上传头像" 
                                      delegate:self 
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"用户相册", @"拍照", nil];
        actionSheet.tag = LOGO_ACTION_SHEET_TAG;
        [actionSheet showInView:self.view];
    } 
    //昵称
    else if ([NICKNAME_CELL_IDENTIFIER isEqual:cellIdentifiter]){
        if(_nicknameEditorViewController == nil){
            _nicknameEditorViewController = [[NicknameEditorViewController alloc] initWithNibName:@"NicknameEditorViewController" bundle:nil];
            _nicknameEditorViewController.settingViewController = self;
        }
        _nicknameEditorViewController.textValue = self.nicknameLabel.text;
        _nicknameEditorViewController.cellIdentifier = NICKNAME_CELL_IDENTIFIER;
        [self.navigationController pushViewController:_nicknameEditorViewController animated:YES];
    } 
    //生日
    else if ([BIRTH_CELL_IDENTIFIER isEqual:cellIdentifiter]) {
        if (nil == _datePicker) {
            _datePicker = [[UIDatePicker alloc] init];
            _datePicker.datePickerMode = UIDatePickerModeDate;
        }
        if (![self.birthLabel.text isEqualToString:@""]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            _datePicker.date = [dateFormatter dateFromString:self.birthLabel.text];
        }
        
        CustomActionSheet *actionSheet = [[CustomActionSheet alloc] initWithHeight:_datePicker.frame.size.height withSheetTitle:@"生日" delegate:self];
        actionSheet.tag = BIRTH_ACTION_SHEET_TAG;
        [actionSheet.view addSubview: _datePicker];
        [actionSheet showInView:self.view];
    }
    //职业
    else if ([PROFESSION_CELL_IDENTIFIER isEqual:cellIdentifiter]) {
        if (_professionEditorViewController == nil) {
            _professionEditorViewController = [[ProfessionEditorViewController alloc] initWithNibName:@"ProfessionEditorViewController" bundle:nil];
            _professionEditorViewController.settingViewController = self;
        }
        _professionEditorViewController.valueId = self.professionLabel.tag;
        _professionEditorViewController.textValue = self.professionLabel.text;
        _professionEditorViewController.cellIdentifier = PROFESSION_CELL_IDENTIFIER;
        [self.navigationController pushViewController:_professionEditorViewController animated:YES];
    }
    //简介
    else if ([FEATURE_CELL_IDENTIFIER isEqual:cellIdentifiter]) {
        if (_featureEditorViewController == nil) {
            _featureEditorViewController = [[FeatureEditorViewController alloc] initWithNibName:@"FeatureEditorViewController" bundle:nil];
            _featureEditorViewController.settingViewController = self;
        }
        if (self.featureLabel.tag > 0) {
            _featureEditorViewController.textValue = self.featureLabel.text;
        }
        _featureEditorViewController.cellIdentifier = FEATURE_CELL_IDENTIFIER;
        [self.navigationController pushViewController:_featureEditorViewController animated:YES];
    }
    //性别
    else if ([GENDER_CELL_IDENTIFIER isEqual:cellIdentifiter]) {
        //弹框选择性别
        UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                                      initWithTitle:nil 
                                      delegate:self 
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"女", @"男", nil];
        actionSheet.tag = GENDER_ACTION_SHEET_TAG;
        [actionSheet showInView:self.view];
    }
    //所在地
    else if ([LOCATION_CELL_IDENTIFIER isEqual:cellIdentifiter]){
        if (nil == _locationPicker) {
            _locationPicker = [[UIPickerView alloc] init];
            _locationPicker.dataSource = self;
            _locationPicker.delegate = self;
            _locationPicker.showsSelectionIndicator = YES;
        }
        if (!_locationPickerHasLoaded) {
            if ([UserContext getUserView].provinceId && ![[UserContext getUserView].provinceId isEqual:[NSNull null]] && [UserContext getUserView].provinceId.intValue > 0) {
                [_locationPicker selectRow:[BaseData indexOfProvinces:[UserContext getUserView].provinceId.intValue] inComponent:PROVINCE_PICKER_COMPONENT animated:YES];
                _cityArray = [BaseData getCitiesWithProvinceId:[UserContext getUserView].provinceId.intValue];
                if ([UserContext getUserView].cityId && ![[UserContext getUserView].cityId isEqual:[NSNull null]] && [UserContext getUserView].cityId.intValue > 0) {
                    [_locationPicker reloadComponent:CITY_PICKER_COMPONENT];
                    [_locationPicker selectRow:[BaseData indexOfCities:[UserContext getUserView].cityId.intValue withProvinceId:[UserContext getUserView].provinceId.intValue] inComponent:CITY_PICKER_COMPONENT animated:YES];
                }
            }
            _locationPickerHasLoaded = YES;
        }
        
        CustomActionSheet *actionSheet = [[CustomActionSheet alloc] initWithHeight:_locationPicker.frame.size.height withSheetTitle:@"所在地" delegate:self];
        actionSheet.tag = LOCATION_ACTION_SHEET_TAG;
        [actionSheet.view addSubview: _locationPicker];
        [actionSheet showInView:self.view];
    }
}

#pragma mark - 
#pragma mark Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == [actionSheet cancelButtonIndex]){
        return;
    }
    if (actionSheet.tag == LOGO_ACTION_SHEET_TAG){
        UIImagePickerControllerSourceType sourceType;
        if(buttonIndex == 0){
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }else {
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
    } else if (actionSheet.tag == GENDER_ACTION_SHEET_TAG) {
        [self saveSingleInfo:GENDER_CELL_IDENTIFIER withValue:[actionSheet buttonTitleAtIndex:buttonIndex] withValueId:buttonIndex];
    }
}

#pragma mark - 
#pragma mark Custom Action Sheet Delegate

- (void) done:(CustomActionSheet *)actionSheet{
    if (actionSheet.tag == BIRTH_ACTION_SHEET_TAG) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [self saveSingleInfo:BIRTH_CELL_IDENTIFIER withValue:[dateFormatter stringFromDate:[_datePicker date]] withValueId:0];
    } else if (actionSheet.tag == LOCATION_ACTION_SHEET_TAG) {
        NSInteger cityRow = [_locationPicker selectedRowInComponent:CITY_PICKER_COMPONENT];
        City *city = [_cityArray objectAtIndex:cityRow];
        [self saveSingleInfo:LOCATION_CELL_IDENTIFIER withValue:city.name withValueId:city.cityId];
    }
}

#pragma mark - 
#pragma mark Picker Data Source Methods

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component == PROVINCE_PICKER_COMPONENT){
        return [_provinceArray count];
    }else{
        return [_cityArray count];
    }
}

#pragma mark Picker Delegate Methods

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(component == PROVINCE_PICKER_COMPONENT){
        return ((Province *)[_provinceArray objectAtIndex:row]).name;
    }else{
        return ((City *)[_cityArray objectAtIndex:row]).name;
    }
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(component == PROVINCE_PICKER_COMPONENT){
        Province *selectedProvince = [_provinceArray objectAtIndex:row];
        _cityArray = [BaseData getCitiesWithProvinceId:selectedProvince.provinceId];
        [pickerView reloadComponent:CITY_PICKER_COMPONENT];
        [pickerView selectRow:0 inComponent:CITY_PICKER_COMPONENT animated:YES];
    }
}

- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component == PROVINCE_PICKER_COMPONENT) {
        return 90;
    } else {
        return 200;
    }
}

#pragma mark -
#pragma mark Navigation Delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (IOS_VERSION >= 5.0){
        [navigationController.navigationBar setBackgroundImage:TOP_BG_IMG forBarMetrics:UIBarMetricsDefault];
    }
    navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

@end
