//
//  ConfigViewController.h
//  juzhai
//
//  Created by JiaJun Wu on 12-5-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileSettingViewController;
@class ProtocalViewController;
@class FeedbackViewController;
@class AuthorizeExpiredViewController;
@class UserView;

#define KeyCellTitle(key) [NSString stringWithFormat:@"config.%@", key]
#define KeySectionTitle(key) [NSString stringWithFormat:@"config.section.%d", key]

#define ACCOUNT_SECTION 0
#define ABOUT_SECTION 1
#define CACHE_SECTION 2
#define LOGOUT_SECTION 3

#define PROFILE_ROW 0
#define AUTHORIZE_ROW 1
#define PROTOCAL_ROW 0
#define FEEDBACK_ROW 1
#define UPGRADE_ROW 2

#define LOGOUT_ALERT_TAG 1
#define CLEAR_CACHE_ALERT_TAG 2
#define UPGRADE_ALERT_TAG 3

@interface ConfigViewController : UITableViewController<UIAlertViewDelegate>
{
    ProfileSettingViewController *_profileSettingViewController;
    ProtocalViewController *_protocalViewController;
    FeedbackViewController *_feedbackViewController;
    AuthorizeExpiredViewController *_authorizeExpiredViewController;
    NSString *_upgradeUrl;
}

@property (strong,nonatomic) NSDictionary *sections;

@end
