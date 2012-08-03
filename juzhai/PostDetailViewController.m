//
//  PostDetailViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PostDetailViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "UserView.h"
#import "PostView.h"
#import "Constant.h"
#import "TaHomeViewController.h"
#import "UserContext.h"
#import "MBProgressHUD.h"
#import "HttpRequestSender.h"
#import "SBJson.h"
#import "MessageShow.h"
#import "UrlUtils.h"
#import "DialogContentViewController.h"

@interface PostDetailViewController ()
- (CGFloat) getViewOriginY:(UIView *)view byUpperView:(UIView *)upperView heightGap:(float)heightGap;
- (void) resetViewFrame;
@end

@implementation PostDetailViewController

@synthesize userView;
@synthesize logoView;
@synthesize nicknameLabel;
@synthesize userInfoLabel;
@synthesize postScrollView;
@synthesize postInfoView;
@synthesize postImageView;
@synthesize contentLabel;
@synthesize addressLabel;
@synthesize categoryLabel;
@synthesize timeLabel;
@synthesize timeIconView;
@synthesize addressIconView;
@synthesize categoryIconView;
@synthesize responseButton;
@synthesize sendMessageButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"拒宅详情";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    postScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BG_IMG]];
    
    _isMe = userView.uid.intValue == [UserContext getUid];
    
    //    logoView.image = [UIImage imageNamed:USER_DEFAULT_LOGO];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *imageURL = [NSURL URLWithString:userView.logo];
    [manager downloadWithURL:imageURL delegate:self options:0 success:^(UIImage *image) {
        logoView.image = image;
        logoView.layer.shouldRasterize = YES;
        logoView.layer.masksToBounds = YES;
        logoView.layer.cornerRadius = 5.0;
    } failure:nil];
    
    nicknameLabel.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:14.0];
    if(userView.gender.intValue == 0){
        nicknameLabel.textColor = FEMALE_NICKNAME_COLOR;
    }else {
        nicknameLabel.textColor = MALE_NICKNAME_COLOR;
    }
    nicknameLabel.text = userView.nickname;
    
    userInfoLabel.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:13.0];
    userInfoLabel.textColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f];
    userInfoLabel.text = [userView basicInfo];
    
    contentLabel.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:15.0];
    contentLabel.textColor = [UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f];
    contentLabel.text = [NSString stringWithFormat:@"%@：%@", userView.post.purpose, userView.post.content];
    CGSize contentSize = [contentLabel.text sizeWithFont:contentLabel.font constrainedToSize:CGSizeMake(300.0, 300.0) lineBreakMode:UILineBreakModeCharacterWrap];
    [contentLabel setFrame:CGRectMake(contentLabel.frame.origin.x, [self getViewOriginY:contentLabel byUpperView:nil heightGap:POST_DEFAULT_HEIGHT_GAP], contentSize.width, contentSize.height)];
    
    [postImageView setFrame:CGRectMake(postImageView.frame.origin.x, [self getViewOriginY:postImageView byUpperView:contentLabel heightGap:POST_DEFAULT_HEIGHT_GAP], postImageView.frame.size.width, postImageView.frame.size.height)];
    [postImageView setHidden:userView.post.bigPic == nil || [userView.post.bigPic isEqual:[NSNull null]] || [userView.post.bigPic isEqualToString:@""]];
    
    [timeIconView setFrame:CGRectMake(timeIconView.frame.origin.x, [self getViewOriginY:timeIconView byUpperView:nil heightGap:POST_INFO_ICON_HEIGHT_GAP], timeIconView.frame.size.width, timeIconView.frame.size.height)];
    timeIconView.hidden = ![userView.post hasTime];
    timeLabel.hidden = timeIconView.hidden;
    if(!timeLabel.hidden){
        timeLabel.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:12.0];
        timeLabel.text = userView.post.date;
        timeLabel.textColor = [UIColor colorWithRed:0.53f green:0.53f blue:0.53f alpha:1.00f];
        [timeLabel setFrame:CGRectMake(timeLabel.frame.origin.x, timeIconView.frame.origin.y, timeLabel.frame.size.width, timeLabel.frame.size.height)];
    }
    [addressIconView setFrame:CGRectMake(addressIconView.frame.origin.x, [self getViewOriginY:addressIconView byUpperView:timeIconView heightGap:POST_INFO_ICON_HEIGHT_GAP], addressIconView.frame.size.width, addressIconView.frame.size.height)];
    addressIconView.hidden = ![userView.post hasPlace];
    addressLabel.hidden = addressIconView.hidden;
    if(!addressLabel.hidden){
        addressLabel.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:12.0];
        addressLabel.text = userView.post.place;
        addressLabel.textColor = [UIColor colorWithRed:0.53f green:0.53f blue:0.53f alpha:1.00f];
        [addressLabel setFrame:CGRectMake(addressLabel.frame.origin.x, addressIconView.frame.origin.y, addressLabel.frame.size.width, addressLabel.frame.size.height)];
    }
    [categoryIconView setFrame:CGRectMake(categoryIconView.frame.origin.x, [self getViewOriginY:categoryIconView byUpperView:addressIconView heightGap:POST_INFO_ICON_HEIGHT_GAP], categoryIconView.frame.size.width, categoryIconView.frame.size.height)];
    categoryIconView.hidden = ![userView.post hasCategory];
    categoryLabel.hidden = categoryIconView.hidden;
    if(!categoryLabel.hidden){
        categoryLabel.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:12.0];
        categoryLabel.text = userView.post.categoryName;
        categoryLabel.textColor = [UIColor colorWithRed:0.53f green:0.53f blue:0.53f alpha:1.00f];
        [categoryLabel setFrame:CGRectMake(categoryLabel.frame.origin.x, categoryIconView.frame.origin.y, categoryLabel.frame.size.width, categoryLabel.frame.size.height)];
    }
    
    [responseButton setFrame:CGRectMake(responseButton.frame.origin.x, [self getViewOriginY:responseButton byUpperView:categoryIconView heightGap:POST_DEFAULT_HEIGHT_GAP], responseButton.frame.size.width, responseButton.frame.size.height)];
    
    [sendMessageButton setFrame:CGRectMake(sendMessageButton.frame.origin.x, [self getViewOriginY:sendMessageButton byUpperView:categoryIconView heightGap:POST_DEFAULT_HEIGHT_GAP], sendMessageButton.frame.size.width, sendMessageButton.frame.size.height)];
    
    if (_isMe) {
        responseButton.hidden = YES;
        responseButton.enabled = NO;
        sendMessageButton.hidden = YES;
        sendMessageButton.enabled = NO;
    } else {
        responseButton.hidden = NO;
        sendMessageButton.hidden = NO;
        sendMessageButton.enabled = YES;
        if (userView.post.hasResp.boolValue) {
            responseButton.enabled = NO;
        }else {
            responseButton.enabled = YES;
        }
    }
    
    if(!postImageView.hidden){
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        NSURL *imageURL = [NSURL URLWithString:userView.post.bigPic];
        [manager downloadWithURL:imageURL delegate:self options:0 success:^(UIImage *image) {
            NSInteger height = image.size.height;
            NSInteger width = image.size.width;
            postImageView.image = image;
            [postImageView setFrame:CGRectMake(postImageView.frame.origin.x, postImageView.frame.origin.y, width/2, height/2)];
            postImageView.layer.shouldRasterize = YES;
            postImageView.layer.masksToBounds = YES;
            postImageView.layer.cornerRadius = 5.0;
            //重新定位以下元素
            [self resetViewFrame];
            
        } failure:nil];
    }
    [self resetViewFrame];
}

- (CGFloat) getViewOriginY:(UIView *)view byUpperView:(UIView *)upperView heightGap:(float)heightGap{
    if(upperView == nil){
        return view.frame.origin.y;
    }else {
        float y = upperView.frame.origin.y;
        return y + (upperView.hidden ? 0.0 : (upperView.frame.size.height + heightGap));
    }
}

- (void) resetViewFrame{
    [postInfoView setFrame:CGRectMake(postInfoView.frame.origin.x, [self getViewOriginY:postInfoView byUpperView:postImageView heightGap:POST_DEFAULT_HEIGHT_GAP], postInfoView.frame.size.width, responseButton.frame.origin.y + (responseButton.hidden ? 0.0 : responseButton.frame.size.height + POST_DEFAULT_HEIGHT_GAP))];
    
    [postScrollView setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, postInfoView.frame.origin.y + postInfoView.frame.size.height)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.logoView = nil;
    self.nicknameLabel = nil;
    self.userInfoLabel = nil;
    self.postScrollView = nil;
    self.postInfoView = nil;
    self.postImageView = nil;
    self.contentLabel = nil;
    self.addressLabel = nil;
    self.categoryLabel = nil;
    self.timeLabel = nil;
    self.timeIconView = nil;
    self.addressIconView = nil;
    self.categoryIconView = nil;
    self.responseButton = nil;
    self.sendMessageButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)goToUserHome:(id)sender{
    TaHomeViewController *taHomeViewController = [[TaHomeViewController alloc] initWithNibName:@"TaHomeViewController" bundle:nil];
    taHomeViewController.hidesBottomBarWhenPushed = YES;
    taHomeViewController.userView = self.userView;
    [self.navigationController pushViewController:taHomeViewController animated:YES];
}

- (IBAction)respPost:(id)sender{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:postScrollView animated:YES];
    hud.labelText = @"操作中...";
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:userView.post.postId, @"postId", nil];
    __unsafe_unretained __block ASIFormDataRequest *request = [HttpRequestSender postRequestWithUrl:[UrlUtils urlStringWithUri:@"post/respPost"] withParams:params];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        if (request) {
            [request setCompletionBlock:^{
                NSString *responseString = [request responseString];
                NSMutableDictionary *jsonResult = [responseString JSONValue];
                if([jsonResult valueForKey:@"success"] == [NSNumber numberWithBool:YES]){
                    userView.post.hasResp = [NSNumber numberWithInt:1];
                    userView.post.respCnt = [NSNumber numberWithInt:(userView.post.respCnt.intValue + 1)];
                    UIButton *respButton = (UIButton *)sender;
                    respButton.enabled = NO;
                    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.labelText = @"ta看到会开心的";
                    [hud hide:YES afterDelay:1];
                    return;
                }
                NSString *errorInfo = [jsonResult valueForKey:@"errorInfo"];
                NSLog(@"%@", errorInfo);
                if (errorInfo == nil || [errorInfo isEqual:[NSNull null]] || [errorInfo isEqualToString:@""]) {
                    errorInfo = SERVER_ERROR_INFO;
                }
                [MBProgressHUD hideHUDForView:postScrollView animated:YES];
                [MessageShow error:errorInfo onView:postScrollView];
            }];
            [request setFailedBlock:^{
                [MBProgressHUD hideHUDForView:postScrollView animated:YES];
                [HttpRequestDelegate requestFailedHandle:request];
            }];
            [request startAsynchronous];
        } else {
            [MBProgressHUD hideHUDForView:postScrollView animated:YES];
        }
//    });
}

- (IBAction)smsHis:(id)sender
{
    DialogContentViewController *dialogContentViewController = [[DialogContentViewController alloc] initWithNibName:@"DialogContentViewController" bundle:nil];
    dialogContentViewController.hidesBottomBarWhenPushed = YES;
    dialogContentViewController.targetUser = userView;
    [self.navigationController pushViewController:dialogContentViewController animated:YES];
}

@end
