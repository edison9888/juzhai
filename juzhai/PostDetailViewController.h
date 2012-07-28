//
//  PostDetailViewController.h
//  juzhai
//
//  Created by JiaJun Wu on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserView;
@class HomeViewController;

#define POST_DEFAULT_HEIGHT_GAP 10.0
#define POST_INFO_ICON_HEIGHT_GAP 4.0

@interface PostDetailViewController : UIViewController
{
    BOOL _isMe;
}

@property (strong, nonatomic) UserView *userView;
@property (strong, nonatomic) IBOutlet UIImageView *logoView;
@property (strong, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userInfoLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *postScrollView;
@property (strong, nonatomic) IBOutlet UIView *postInfoView;
@property (strong, nonatomic) IBOutlet UIImageView *postImageView;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *timeIconView;
@property (strong, nonatomic) IBOutlet UIImageView *addressIconView;
@property (strong, nonatomic) IBOutlet UIImageView *categoryIconView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) IBOutlet UIButton *responseButton;
@property (strong, nonatomic) IBOutlet UIButton *sendMessageButton;

- (IBAction)goToUserHome:(id)sender;
- (IBAction)respPost:(id)sender;
- (IBAction)smsHis:(id)sender;
@end
