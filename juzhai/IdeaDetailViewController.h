//
//  IdeaDetailViewController.h
//  juzhai
//
//  Created by JiaJun Wu on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class IdeaView;
@class IdeaUsersViewController;

#define IDEA_DEFAULT_HEIGHT_GAP 10.0
#define IDEA_INFO_ICON_HEIGHT_GAP 4.0

@interface IdeaDetailViewController : UIViewController <UIActionSheetDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>
{
    NSInteger _shareToSmsButtonIdex;
    NSInteger _shareToMailButtonIdex;
    NSInteger _shareToThirdparyButtonIdex;
}

@property (strong, nonatomic) IdeaView *ideaView;
@property (strong, nonatomic) IBOutlet UIScrollView *contentView;
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *timeIconView;
@property (strong, nonatomic) IBOutlet UIImageView *addressIconView;
@property (strong, nonatomic) IBOutlet UIImageView *categoryIconView;
@property (strong, nonatomic) IBOutlet UIImageView *personIconView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *personLabel;
@property (strong, nonatomic) IBOutlet UIButton *moreButton;
@property (strong, nonatomic) IBOutlet UIButton *postIdeaButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *showUsersButton;

- (IBAction)moreIdea:(id)sender;
- (IBAction)postIdea:(id)sender;
- (IBAction)showUsedUsers:(id)sender;
- (IBAction)openShareLog:(id)sender;

@end
