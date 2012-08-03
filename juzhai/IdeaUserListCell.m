//
//  IdeaUserListCell.m
//  juzhai
//
//  Created by JiaJun Wu on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IdeaUserListCell.h"
#import "UserView.h"
#import <QuartzCore/QuartzCore.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import "Constant.h"
#import "IdeaUserView.h"
#import "MBProgressHUD.h"
#import "HttpRequestSender.h"
#import "SBJson.h"
#import "MessageShow.h"
#import "UserContext.h"
#import "UrlUtils.h"

@implementation IdeaUserListCell

@synthesize userLogoView;
@synthesize nicknameLabel;
@synthesize infoLabel;
@synthesize sendDateButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (id) cellFromNib
{
    IdeaUserListCell *cell = nil;
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IdeaUserListCell" owner:self options:nil];
    for(id oneObject in nib){
        if([oneObject isKindOfClass:[IdeaUserListCell class]]){
            cell = (IdeaUserListCell *) oneObject;
        }
    }
    [cell setBackground];
    return cell;
}

- (void) redrawn:(IdeaUserView *)ideaUserView
{
    _ideaUserView = ideaUserView;
    userLogoView.image = [UIImage imageNamed:FACE_LOADING_IMG];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *imageURL = [NSURL URLWithString:ideaUserView.userView.smallLogo];
    [manager downloadWithURL:imageURL delegate:self options:0 success:^(UIImage *image) {
        userLogoView.image = image;
        userLogoView.layer.shouldRasterize = YES;
        userLogoView.layer.masksToBounds = YES;
        userLogoView.layer.cornerRadius = 5.0;
    } failure:nil];
    
    nicknameLabel.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:12.0];
    if(ideaUserView.userView.gender.intValue == 0){
        nicknameLabel.textColor = FEMALE_NICKNAME_COLOR;
        nicknameLabel.highlightedTextColor = FEMALE_NICKNAME_COLOR;
    }else {
        nicknameLabel.textColor = MALE_NICKNAME_COLOR;
        nicknameLabel.highlightedTextColor = MALE_NICKNAME_COLOR;
    }
    nicknameLabel.text = ideaUserView.userView.nickname;
    
    infoLabel.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:12.0];
    infoLabel.textColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f];
    infoLabel.highlightedTextColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f];
    infoLabel.text = [ideaUserView.userView basicInfo];
    
    if (ideaUserView.userView.uid.intValue == [UserContext getUid]) {
        sendDateButton.hidden = YES;
        sendDateButton.enabled = NO;
    }else {
        sendDateButton.hidden = NO;
        sendDateButton.enabled = YES;
    }
}

- (void) setBackground
{
    UIView *selectBgColorView = [[UIView alloc] init];
    selectBgColorView.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView = selectBgColorView;
}
+ (CGFloat) heightForCell:()objView
{
    return 60.0;
}

- (IBAction)dateHim:(id)sender
{
    UIView *coverView = self.superview;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:coverView animated:YES];
    hud.labelText = @"操作中...";
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:_ideaUserView.ideaId], @"ideaId", _ideaUserView.userView.uid, @"targetUid", nil];
        __unsafe_unretained __block ASIFormDataRequest *request = [HttpRequestSender postRequestWithUrl:[UrlUtils urlStringWithUri:@"dialog/sendDate"] withParams:params];
        if (request) {
            [request setCompletionBlock:^{
                [MBProgressHUD hideHUDForView:coverView animated:YES];
                NSString *responseString = [request responseString];
                NSMutableDictionary *jsonResult = [responseString JSONValue];
                if([jsonResult valueForKey:@"success"] == [NSNumber numberWithBool:YES]){
                    ((UIButton *)sender).enabled = NO;
                    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.labelText = @"发送成功";
                    [hud hide:YES afterDelay:1];
                    return;
                }
                NSString *errorInfo = [jsonResult valueForKey:@"errorInfo"];
                NSLog(@"%@", errorInfo);
                if (errorInfo == nil || [errorInfo isEqual:[NSNull null]] || [errorInfo isEqualToString:@""]) {
                    errorInfo = SERVER_ERROR_INFO;
                }
                [MBProgressHUD hideHUDForView:coverView animated:YES];
                [MessageShow error:errorInfo onView:coverView];
            }];
            [request setFailedBlock:^{
                [MBProgressHUD hideHUDForView:coverView animated:YES];
                [HttpRequestDelegate requestFailedHandle:request];
            }];
            [request startAsynchronous];
        } else {
            [MBProgressHUD hideHUDForView:coverView animated:YES];
        }
//    });
}

@end
