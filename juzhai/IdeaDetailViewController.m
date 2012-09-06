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
#import "UIImage+UIImageExt.h"
#import "MobClick.h"
#import "ShareIdeaInputViewController.h"
#import "UserContext.h"
#import "UserView.h"

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
    
    contentLabel.font = DEFAULT_FONT(15);
    contentLabel.textColor = [UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f];
    contentLabel.text = self.ideaView.content;
    CGSize contentSize = [contentLabel.text sizeWithFont:contentLabel.font constrainedToSize:CGSizeMake(300.0, 300.0) lineBreakMode:UILineBreakModeCharacterWrap];
    [contentLabel setFrame:CGRectMake(contentLabel.frame.origin.x, [self getViewOriginY:contentLabel byUpperView:nil heightGap:IDEA_DEFAULT_HEIGHT_GAP], contentSize.width, contentSize.height)];

    imageView.image = [UIImage imageNamed:BIG_PIC_LOADING_IMG];
    [imageView setFrame:CGRectMake(imageView.frame.origin.x, [self getViewOriginY:imageView byUpperView:contentLabel heightGap:IDEA_DEFAULT_HEIGHT_GAP], imageView.frame.size.width, imageView.frame.size.height)];
    [imageView setHidden:[ideaView.bigPic isEqual:[NSNull null]]];
    
    //time
    [timeIconView setFrame:CGRectMake(timeIconView.frame.origin.x, [self getViewOriginY:timeIconView byUpperView:nil heightGap:IDEA_INFO_ICON_HEIGHT_GAP], timeIconView.frame.size.width, timeIconView.frame.size.height)];
    timeIconView.hidden = ![ideaView hasTime];
    timeLabel.hidden = timeIconView.hidden;
    if(!timeLabel.hidden){
        timeLabel.font = DEFAULT_FONT(12);
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
        addressLabel.font = DEFAULT_FONT(12);
        addressLabel.text = ideaView.place;
        addressLabel.textColor = [UIColor colorWithRed:0.53f green:0.53f blue:0.53f alpha:1.00f];
        [addressLabel setFrame:CGRectMake(addressLabel.frame.origin.x, addressIconView.frame.origin.y, addressLabel.frame.size.width, addressLabel.frame.size.height)];
    }
    
    //category
    [categoryIconView setFrame:CGRectMake(categoryIconView.frame.origin.x, [self getViewOriginY:categoryIconView byUpperView:addressIconView heightGap:IDEA_INFO_ICON_HEIGHT_GAP], categoryIconView.frame.size.width, categoryIconView.frame.size.height)];
    categoryIconView.hidden = ![ideaView hasCategory];
    categoryLabel.hidden = categoryIconView.hidden;
    if(!categoryLabel.hidden){
        categoryLabel.font = DEFAULT_FONT(12);
        categoryLabel.text = ideaView.categoryName;
        categoryLabel.textColor = [UIColor colorWithRed:0.53f green:0.53f blue:0.53f alpha:1.00f];
        [categoryLabel setFrame:CGRectMake(categoryLabel.frame.origin.x, categoryIconView.frame.origin.y, categoryLabel.frame.size.width, categoryLabel.frame.size.height)];
    }
    
    //person
    [personIconView setFrame:CGRectMake(personIconView.frame.origin.x, [self getViewOriginY:personIconView byUpperView:categoryIconView heightGap:IDEA_INFO_ICON_HEIGHT_GAP], personIconView.frame.size.width, personIconView.frame.size.height)];
    personIconView.hidden = ![ideaView hasPerson];
    personLabel.hidden = personIconView.hidden;
    if(!personLabel.hidden){
        personLabel.font = DEFAULT_FONT(12);
        personLabel.text = [NSString stringWithFormat:@"共有 %d 人想去", self.ideaView.useCount];
        personLabel.textColor = [UIColor colorWithRed:0.53f green:0.53f blue:0.53f alpha:1.00f];
        [personLabel setFrame:CGRectMake(personLabel.frame.origin.x, personIconView.frame.origin.y, personLabel.frame.size.width, personLabel.frame.size.height)];
    }
    
    [postIdeaButton setFrame:CGRectMake(postIdeaButton.frame.origin.x, [self getViewOriginY:postIdeaButton byUpperView:personIconView heightGap:IDEA_DEFAULT_HEIGHT_GAP], postIdeaButton.frame.size.width, postIdeaButton.frame.size.height)];
    postIdeaButton.enabled = !ideaView.hasUsed;
    
    [shareButton setFrame:CGRectMake(shareButton.frame.origin.x, [self getViewOriginY:shareButton byUpperView:personIconView heightGap:IDEA_DEFAULT_HEIGHT_GAP], shareButton.frame.size.width, shareButton.frame.size.height)];
    
    self.showUsersButton.hidden = ![ideaView hasPerson];
    self.showUsersButton.enabled = [ideaView hasPerson];
    
    if(!imageView.hidden){
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        NSURL *imageURL = [NSURL URLWithString:ideaView.bigPic];
        [manager downloadWithURL:imageURL delegate:self options:0 success:^(UIImage *image) {
            NSInteger width = image.size.width;
            NSInteger height = image.size.height;
            imageView.image = [image createRoundedRectImage:8.0];
            [imageView setFrame:CGRectMake(imageView.frame.origin.x, [self getViewOriginY:imageView byUpperView:contentLabel heightGap:IDEA_DEFAULT_HEIGHT_GAP], width/2, height/2)];
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
        [request setCompletionBlock:^{
            NSString *responseString = [request responseString];
            NSMutableDictionary *jsonResult = [responseString JSONValue];
            if([jsonResult valueForKey:@"success"] == [NSNumber numberWithBool:YES]){
                [MobClick event:SEND_IDEA];
                ideaView.hasUsed = YES;
                ideaView.useCount = ideaView.useCount + 1;
                UIButton *wantToButton = (UIButton *)sender;
                wantToButton.enabled = NO;
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"保存成功";
                [hud hide:YES afterDelay:2];
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
    } else {
        [MBProgressHUD hideHUDForView:self.contentView animated:YES];
    }
}

- (IBAction)showUsedUsers:(id)sender
{
    IdeaUsersViewController *ideaUsersViewController = [[IdeaUsersViewController alloc] init];
    ideaUsersViewController.ideaView = ideaView;
    [self.navigationController pushViewController:ideaUsersViewController animated:YES];
}

- (IBAction)openShareLog:(id)sender
{
    NSString *tpName = [UserContext getUserView].tpName;
    NSString *tpChineseName;
    if ([TP_NAME_WEIBO isEqualToString:tpName]) {
        tpChineseName = @"新浪微博";
    } else if ([TP_NAME_DOUBAN isEqualToString:tpName]) {
        tpChineseName = @"豆瓣社区";
    } else if ([TP_NAME_QQ isEqualToString:tpName]){
        tpChineseName = @"QQ社区";
    }
    UIActionSheet *actionSheet;
    if (nil == tpChineseName || [tpChineseName isEqualToString:@""]) {
        actionSheet = [[UIActionSheet alloc]initWithTitle:@"分享拒宅好主意" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"分享到邮件", @"分享到短信", nil];
        _shareToSmsButtonIdex = 1;
        _shareToMailButtonIdex = 0;
        _shareToThirdparyButtonIdex = -1;
    } else {
        actionSheet = [[UIActionSheet alloc]initWithTitle:@"分享拒宅好主意" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:[NSString stringWithFormat:@"分享到%@", tpChineseName], @"分享到邮件", @"分享到短信", nil];
        _shareToSmsButtonIdex = 2;
        _shareToMailButtonIdex = 1;
        _shareToThirdparyButtonIdex = 0;
    }
    [actionSheet showInView:self.tabBarController.view];
}

#pragma mark - 
#pragma mark Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == _shareToSmsButtonIdex) {
        Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
        if (messageClass != nil) {
            // Check whether the current device is configured for sending SMS messages
            if ([messageClass canSendText]) {
                [self displaySMSComposerSheet];
            }
            else {
                [MessageShow error:@"设备没有短信功能" onView:self.tabBarController.view];
            }
        } else {
            [MessageShow error:@"iOS版本过低,iOS4.0以上才支持程序内发送短信" onView:self.tabBarController.view];
        }
    } else if (buttonIndex == _shareToMailButtonIdex) {
        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));    
        if (!mailClass) {  
            [MessageShow error:@"当前系统版本不支持应用内发送邮件功能，您可以使用mailto方法代替" onView:self.tabBarController.view];
        }else if (![mailClass canSendMail]) {
            [MessageShow error:@"用户没有设置邮件账户" onView:self.tabBarController.view]; 
        } else {
            [self displayMailPicker];
        }
    } else if (buttonIndex == _shareToThirdparyButtonIdex) {
        ShareIdeaInputViewController *shareIdeaInputViewController = [[ShareIdeaInputViewController alloc] initWithNibName:@"ShareIdeaInputViewController" bundle:nil];
        shareIdeaInputViewController.ideaView = self.ideaView;
        shareIdeaInputViewController.navTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        [self presentModalViewController:shareIdeaInputViewController animated:YES];
    }
}

-(void)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    
    picker.body = [self.ideaView shareSmsText];
    [self presentModalViewController:picker animated:YES];
}

//调出邮件发送窗口   
- (void)displayMailPicker   
{   
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];     
    mailPicker.mailComposeDelegate = self;     
    
    //设置主题     
    [mailPicker setSubject: @"分享拒宅好主意"];
//    NSString *emailBody = @"<font color='red'>eMail</font> 正文";     
    NSString *emailBody = [self.ideaView shareMailText];
    [mailPicker setMessageBody:emailBody isHTML:YES];     
    [self presentModalViewController: mailPicker animated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Result: SMS sending canceled");
            break;
        case MessageComposeResultSent:
            NSLog(@"Result: SMS sent");
            break;
        case MessageComposeResultFailed:
            [MessageShow error:@"短信发送失败" onView:self.tabBarController.view];
            break;
        default:
            NSLog(@"Result: SMS not sent");
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - 实现 MFMailComposeViewControllerDelegate    
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error   
{   
    //关闭邮件发送窗口   
    [self dismissModalViewControllerAnimated:YES];
}

@end
