//
//  ConfigViewController.h
//  juzhai
//
//  Created by JiaJun Wu on 12-5-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileSettingViewController;

#define KeyCellTitle(key) [NSString stringWithFormat:@"config.%@", key]
#define KeySectionTitle(key) [NSString stringWithFormat:@"config.section.%d", key]

#define ACCOUNT_SECTION 0
#define ABOUT_SECTION 1
#define CACHE_SECTION 2
#define LOGOUT_SECTION 3

#define PROFILE_ROW 0
#define UPGRADE_ROW 2

#define LOGOUT_ALERT_TAG 1
#define CLEAR_CACHE_ALERT_TAG 2

@interface ConfigViewController : UITableViewController<UIAlertViewDelegate>
{
    ProfileSettingViewController *_profileSettingViewController;
}

@property (strong,nonatomic) NSDictionary *sections;

@end
