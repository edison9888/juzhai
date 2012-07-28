//
//  HomeViewController.h
//  juzhai
//
//  Created by JiaJun Wu on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshHeaderViewController.h"

@class UserView;
@class JZData;
@class ProfileSettingViewController;
@class InterestUserViewController;
@class ListHttpRequestDelegate;

#define INTEREST_COUNT_BUTTON_IMAGE @"my_jz_fans_btn.png"
#define INTEREST_COUNT_BUTTON_HIGHLIGHT_IMAGE @"my_jz_fans_btn_hover.png"
#define INTEREST_COUNT_BUTTON_CAP_WIDTH 4.0
#define TABLE_HEAD_BG_IMAGE @"my_jz_title_bg.png"
#define TABLE_HEAD_TITLE @"    共 %d 条拒宅"

@interface TaHomeViewController : EGORefreshHeaderViewController <UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>
{
    JZData *_data;
    BOOL _isMe;
    ListHttpRequestDelegate *_listHttpRequestDelegate;
}

@property (strong, nonatomic) UserView *userView;

@property (strong, nonatomic) IBOutlet UIImageView *logoView;
@property (strong, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *postCountLabel;
@property (strong, nonatomic) IBOutlet UITableView *postTableView;
@property (strong, nonatomic) IBOutlet UIButton *interestButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelInterestButton;
@property (strong, nonatomic) IBOutlet UIButton *smsButton;

- (IBAction)interestUser:(id)sender;
- (IBAction)cancelInterestUser:(id)sender;
- (IBAction)sendSms:(id)sender;

@end
