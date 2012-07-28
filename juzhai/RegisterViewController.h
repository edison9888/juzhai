//
//  RegisterViewController.h
//  juzhai
//
//  Created by JiaJun Wu on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TpLoginDelegate;

@interface RegisterViewController : UIViewController <UITableViewDataSource>
{
    NSArray *_registerFormCells;
    TpLoginDelegate *_tpLoginDelegate;
}

@property (nonatomic, strong) IBOutlet UITableView *registerFormTableView;
@property (strong,nonatomic) IBOutlet UITableView *tpLoginTableView;

@property (nonatomic, strong) IBOutlet UITextField *accountField;
@property (nonatomic, strong) IBOutlet UITextField *nicknameField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;
@property (nonatomic, strong) IBOutlet UITextField *confirmPwdField;
@property (nonatomic, strong) IBOutlet UITableViewCell *accountCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *nicknameCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *passwordCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *confirmPwdCell;


-(IBAction) goLogin:(id)sender;
-(IBAction) backgroundTap:(id)sender;
-(IBAction) accountFieldDoneEditing:(id)sender;
-(IBAction) nicknameFieldDoneEditing:(id)sender;
-(IBAction) passwordFieldDoneEditing:(id)sender;
-(IBAction) confirmPwdFieldDoneEditing:(id)sender;
-(IBAction) regist:(id)sender;
@end
