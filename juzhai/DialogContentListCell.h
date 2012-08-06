//
//  DialogContentListCell.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListCell.h"
#import "WholeImageViewController.h"

@class DetailTextView;
@class UserView;
@class DialogContentView;


#define TEXT_FONT [UIFont fontWithName:DEFAULT_FONT_FAMILY size:14]
#define TEXT_MAX_WIDTH 175
#define TEXT_MAX_HEIGHT 1000
#define CONTENT_TEXT_VIEW_MARGIN 10
#define ARROW_WIDTH 5

#define MY_BG_IMAGE_NAME @"my_send_txt_bg.png"
#define MY_BG_CAP_HEIHGT 20
#define MY_BG_CAP_WIDTH 5

#define HIS_BG_IMAGE_NAME @"ta_send_txt_bg.png"
#define HIS_BG_CAP_HEIHGT 20
#define HIS_BG_CAP_WIDTH 8

@interface DialogContentListCell : UITableViewCell <ListCell, WholeImageViewDelegate>
{
    DialogContentView *_dialogContentView;
    BOOL _isMe;
    WholeImageViewController *_wholeImageViewController;
}

@property (strong, nonatomic) UserView *targetUser;

@property (strong, nonatomic) IBOutlet UIImageView *hisLogoView;
@property (strong, nonatomic) IBOutlet UIImageView *myLogoView;
@property (strong, nonatomic) IBOutlet UIView *bubbleView;
@property (strong, nonatomic) IBOutlet UIImageView *contentBgView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
//@property (strong, nonatomic) IBOutlet DetailTextView *dialogContentTextView;
@property (strong, nonatomic) IBOutlet UILabel *dialogContentTextView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@end
