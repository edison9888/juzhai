//
//  IdeaDetailViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IdeaDetailViewController.h"
#import "Constant.h"
#import "CustomNavigationController.h"
#import "IdeaView.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "SBJson.h"
#import "HttpRequestSender.h"
#import "MBProgressHUD.h"
#import "MessageShow.h"
#import "IdeaUsersViewController.h"
#import "UrlUtils.h"

@interface IdeaDetailViewController ()
- (CGFloat) getViewOriginY:(UIView *)view byUpperView:(UIView *)upperView heightGap:(float)heightGap;
- (void) resetViewFrame;
@end

@implementation IdeaDetailViewController

@synthesize ideaView;
@synthesize contentView;
@synthesize infoView;
@synthesize imageView;
@synthesize contentLabel;
@synthesize addressLabel;
@synthesize categoryLabel;
@synthesize timeLabel;
@synthesize personLabel;
@synthesize timeIconView;
@synthesize addressIconView;
@synthesize categoryIconView;
@synthesize personIconView;
@synthesize moreButton;
@synthesize postIdeaButton;
@synthesize shareButton;
@synthesize showUsersButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"拒宅好主意";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BG_IMG]];
    
    contentLabel.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:15.0];
    contentLabel.textColor = [UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f];
    contentLabel.text = self.ideaView.content;
    CGSize contentSize = [contentLabel.text sizeWithFont:contentLabel.font constrainedToSize:CGSizeMake(300.0, 300.0) lineBreakMode:UILineBreakModeCharacterWrap];
    [contentLabel setFrame:CGRectMake(contentLabel.frame.origin.x, [self getViewOriginY:contentLabel byUpperView:nil heightGap:IDEA_DEFAULT_HEIGHT_GAP], contentSize.width, contentSize.height)];
    
    imageView.layer.shouldRasterize = YES;
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 5.0;
    imageView.image = [UIImage imageNamed:BIG_PIC_LOADING_IMG];
    [imageView setFrame:CGRectMake(imageView.frame.origin.x, [self getViewOriginY:imageView byUpperView:contentLabel heightGap:IDEA_DEFAULT_HEIGHT_GAP], imageView.frame.size.width, imageView.frame.size.height)];
    [imageView setHidden:[ideaView.bigPic isEqual:[NSNull null]]];
    
    //time
    [timeIconView setFrame:CGRectMake(timeIconView.frame.origin.x, [self getViewOriginY:timeIconView byUpperView:nil heightGap:IDEA_INFO_ICON_HEIGHT_GAP], timeIconView.frame.size.width, timeIconView.frame.size.height)];
    timeIconView.hidden = ![ideaView hasTime];
    timeLabel.hidden = timeIconView.hidden;
    if(!timeLabel.hidden){
        timeLabel.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:12.0];
        if ([ideaView hasStartTime] && [ideaView hasEndTime]) {
            timeLabel.text = [NSString stringWithFormat:@"%@ - %@", ideaView.startTime, ideaView.endTime];
        } else {
            timeLabel.text = ideaView.endTime;
        }
        
        timeLabel.textColor = [UIColor colorWithRed:0.53f green:0.53f blue:0.53f alpha:1.00f];
        [timeLabel setFrame:CGRectMake(timeLabel.frame.origin.x, timeIconView.frame.origin.y, timeLabel.frame.size.width, timeLabel.frame.size.height)];
    }
    
    //address
    [addressIconView setFrame:CGRectMake(addressIconView.frame.origin.x, [self getViewOriginY:addressIconView byUpperView:timeIconView heightGap:IDEA_INFO_ICON_HEIGHT_GAP], addressIconView.frame.size.width, addressIconView.frame.size.height)];
    addressIconView.hidden = ![ideaView hasPlace];
    addressLabel.hidden = addressIconView.hidden;
    if(!addressLabel.hidden){
        addressLabel.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:12.0];
        addressLabel.text = ideaView.place;
        addressLabel.textColor = [UIColor colorWithRed:0.53f green:0.53f blue:0.53f alpha:1.00f];
        [addressLabel setFrame:CGRectMake(addressLabel.frame.origin.x, addressIconView.frame.origin.y, addressLabel.frame.size.width, addressLabel.frame.size.height)];
    }
    
    //category
    [categoryIconView setFrame:CGRectMake(categoryIconView.frame.origin.x, [self getViewOriginY:categoryIconView byUpperView:addressIconView heightGap:IDEA_INFO_ICON_HEIGHT_GAP], categoryIconView.frame.size.width, categoryIconView.frame.size.height)];
    categoryIconView.hidden = ![ideaView hasCategory];
    categoryLabel.hidden = categoryIconView.hidden;
    if(!categoryLabel.hidden){
        categoryLabel.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:12.0];
        categoryLabel.text = ideaView.categoryName;
        categoryLabel.textColor = [UIColor colorWithRed:0.53f green:0.53f blue:0.53f alpha:1.00f];
        [categoryLabel setFrame:CGRectMake(categoryLabel.frame.origin.x, categoryIconView.frame.origin.y, categoryLabel.frame.size.width, categoryLabel.frame.size.height)];
    }
    
    //person
    [personIconView setFrame:CGRectMake(personIconView.frame.origin.x, [self getViewOriginY:personIconView byUpperView:categoryIconView heightGap:IDEA_INFO_ICON_HEIGHT_GAP], personIconView.frame.size.width, personIconView.frame.size.height)];
    personIconView.hidden = ![ideaView hasPerson];
    personLabel.hidden = personIconView.hidden;
    if(!personLabel.hidden){
        personLabel.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:12.0];
        personLabel.text = [NSString stringWithFormat:@"共有 %d 人想去", self.ideaView.useCount];
        personLabel.textColor = [UIColor colorWithRed:0.53f green:0.53f blue:0.53f alpha:1.00f];
        [personLabel setFrame:CGRectMake(personLabel.frame.origin.x, personIconView.frame.origin.y, personLabel.frame.size.width, personLabel.frame.size.height)];
    }
    
    moreButton.hidden = YES;
    moreButton.enabled = NO;
//    [moreButton setFrame:CGRectMake(moreButton.frame.origin.x, [self getViewOriginY:moreButton byUpperView:categoryIconView heightGap:IDEA_DEFAULT_HEIGHT_GAP], moreButton.frame.size.width, moreButton.frame.size.height)];
    
    [postIdeaButton setFrame:CGRectMake(postIdeaButton.frame.origin.x, [self getViewOriginY:postIdeaButton byUpperView:personIconView heightGap:IDEA_DEFAULT_HEIGHT_GAP], postIdeaButton.frame.size.width, postIdeaButton.frame.size.height)];
    postIdeaButton.enabled = !ideaView.hasUsed;
    
    [shareButton setFrame:CGRectMake(shareButton.frame.origin.x, [self getViewOriginY:shareButton byUpperView:personIconView heightGap:IDEA_DEFAULT_HEIGHT_GAP], shareButton.frame.size.width, shareButton.frame.size.height)];
    
    self.showUsersButton.hidden = ![ideaView hasPerson];
    self.showUsersButton.enabled = [ideaView hasPerson];
    
    if(!imageView.hidden){
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        NSURL *imageURL = [NSURL URLWithString:ideaView.bigPic];
        [manager downloadWithURL:imageURL delegate:self options:0 success:^(UIImage *image) {
            NSInteger height = image.size.height;
            [imageView setFrame:CGRectMake(imageView.frame.origin.x, [self getViewOriginY:imageView byUpperView:contentLabel heightGap:IDEA_DEFAULT_HEIGHT_GAP], imageView.frame.size.width, height/2)];
            imageView.image = image;
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
    CGFloat infoViewHeight = postIdeaButton.frame.origin.y + postIdeaButton.frame.size.height;
    
    [infoView setFrame:CGRectMake(infoView.frame.origin.x, [self getViewOriginY:infoView byUpperView:imageView heightGap:IDEA_DEFAULT_HEIGHT_GAP], infoView.frame.size.width, infoViewHeight)];

    if (!self.showUsersButton.hidden) {
        //人列表按钮
        [showUsersButton setFrame:CGRectMake(showUsersButton.frame.origin.x, [self getViewOriginY:showUsersButton byUpperView:infoView heightGap:IDEA_DEFAULT_HEIGHT_GAP], showUsersButton.frame.size.width, showUsersButton.frame.size.height)];
        
        if (showUsersButton.frame.origin.y < (contentView.frame.size.height - showUsersButton.frame.size.height)) {
            [showUsersButton setFrame:CGRectMake(showUsersButton.frame.origin.x, contentView.frame.size.height - showUsersButton.frame.size.height, showUsersButton.frame.size.width, showUsersButton.frame.size.height)];
        }
    }
    
    [contentView setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, self.showUsersButton.hidden ? (infoView.frame.origin.y + infoView.frame.size.height) : (showUsersButton.frame.origin.y + showUsersButton.frame.size.height))];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.contentView = nil;
    self.infoView = nil;
    self.imageView = nil;
    self.contentLabel = nil;
    self.timeIconView = nil;
    self.addressIconView = nil;
    self.categoryIconView = nil;
    self.personIconView = nil;
    self.timeLabel = nil;
    self.addressLabel = nil;
    self.categoryLabel = nil;
    self.personLabel = nil;
    self.moreButton = nil;
    self.postIdeaButton = nil;
    self.shareButton = nil;
    self.showUsersButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)moreIdea:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)postIdea:(id)sender{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
    hud.labelText = @"操作中...";
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:ideaView.ideaId], @"ideaId", nil];
    __unsafe_unretained __block ASIFormDataRequest *request = [HttpRequestSender postRequestWithUrl:[UrlUtils urlStringWithUri:@"post/sendPost"] withParams:params];
    if (request) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [request setCompletionBlock:^{
                [MBProgressHUD hideHUDForView:self.contentView animated:YES];
                NSString *responseString = [request responseString];
                NSMutableDictionary *jsonResult = [responseString JSONValue];
                if([jsonResult valueForKey:@"success"] == [NSNumber numberWithBool:YES]){
                    ideaView.hasUsed = YES;
                    ideaView.useCount = ideaView.useCount + 1;
                    UIButton *wantToButton = (UIButton *)sender;
                    wantToButton.enabled = NO;
                    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.labelText = @"保存成功";
                    [hud hide:YES afterDelay:1];
                    return;
                }
                NSString *errorInfo = [jsonResult valueForKey:@"errorInfo"];
                NSLog(@"%@", errorInfo);
                if (errorInfo == nil || [errorInfo isEqual:[NSNull null]] || [errorInfo isEqualToString:@""]) {
                    errorInfo = SERVER_ERROR_INFO;
                }
                [MBProgressHUD hideHUDForView:self.contentView animated:YES];
                [MessageShow error:errorInfo onView:self.contentView];
            }];
            [request setFailedBlock:^{
                [MBProgressHUD hideHUDForView:self.contentView animated:YES];
                [HttpRequestDelegate requestFailedHandle:request];
            }];
            [request startAsynchronous];
//        });
    } else {
        [MBProgressHUD hideHUDForView:self.contentView animated:YES];
    }
}

- (IBAction)showUsedUsers:(id)sender
{
    IdeaUsersViewController *ideaUsersViewController = [[IdeaUsersViewController alloc] initWithStyle:UITableViewStylePlain];
    ideaUsersViewController.ideaView = ideaView;
    [self.navigationController pushViewController:ideaUsersViewController animated:YES];
}

@end
