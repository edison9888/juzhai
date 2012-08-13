//
//  UserListCell.h
//  juzhai
//
//  Created by JiaJun Wu on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListCell.h"

@class UserView;

#define USER_LOGO_TAG 1
#define USER_NICKNAME_TAG 2
#define USER_INFO_TAG 3
#define POST_CONTENT_TAG 4
#define POST_IMAGE_TAG 5
#define RESPONSE_BUTTON_TAG 6

#define BG_PNG @"zber_item_bg.png"

#define NORMAL_RESP_BUTTON_IMAGE @"zber_xy_btn_link.png"
#define HIGHLIGHT_RESP_BUTTON_IMAGE @"zber_xy_btn_hover.png"
#define DISABLE_RESP_BUTTON_IMAGE @"zber_xy_btn_done.png"
#define WANT_BUTTON_CAP_WIDTH 26.0
#define BG_CAP_HEIHGT 20.0

@interface UserListCell : UITableViewCell <ListCell>
{
    UserView *_userView;
}

@property (strong, nonatomic) IBOutlet UIImageView *logoView;
@property (strong, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *onlineLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *respButton;

-(IBAction)respPost:(id)sender;

@end
