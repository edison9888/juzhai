//
//  HomeViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "ProfileSettingViewController.h"
#import "InterestUserViewController.h"
#import "UserContext.h"
#import "UserView.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "Constant.h"
#import "SendPostBarButtonItem.h"
#import "UserPostViewController.h"
#import "RefreshButton.h"
#import "MBProgressHUD.h"
#import "HttpRequestSender.h"
#import "UrlUtils.h"
#import "SBJson.h"
#import "UIImage+UIImageExt.h"
#import "MessageShow.h"
#import "InviteInputViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize logoView;
@synthesize nicknameLabel;
@synthesize infoLabel;
@synthesize infoTableView;
@synthesize logoVerifyLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置分割线
    self.navigationItem.leftBarButtonItem = [[SendPostBarButtonItem alloc] initWithOwnerViewController:self];
    //右侧性别按钮
    UIButton *refreshButton = [[RefreshButton alloc] init];
    [refreshButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: refreshButton];
    
    self.infoTableView.separatorColor = [UIColor colorWithRed:0.71f green:0.71f blue:0.71f alpha:1.00f];
    self.infoTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BG_IMG]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.logoView = nil;
    self.nicknameLabel = nil;
    self.infoLabel = nil;
    self.infoTableView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UserView *userView = [UserContext getUserView];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *imageURL = [NSURL URLWithString:userView.rawLogo];
    [manager downloadWithURL:imageURL delegate:self options:0 success:^(UIImage *image) {
        UIImage *resultImage = [image imageByScalingAndCroppingForSize:CGSizeMake(logoView.frame.size.width*2, logoView.frame.size.height*2)];
        logoView.image = [resultImage createRoundedRectImage:8.0];
    } failure:nil];
    
    nicknameLabel.font = DEFAULT_FONT(14);
    if(userView.gender.intValue == 0){
        nicknameLabel.textColor = FEMALE_NICKNAME_COLOR;
    }else {
        nicknameLabel.textColor = MALE_NICKNAME_COLOR;
    }
    nicknameLabel.text = userView.nickname;
    
    infoLabel.font = DEFAULT_FONT(13);
    infoLabel.textColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f];
    infoLabel.text = [userView basicInfo];
    logoVerifyLabel.hidden = userView.logoVerifyState.intValue != 3;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)refresh
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.dimBackground = YES;
    hud.labelText = @"刷新中...";
    [hud showWhileExecuting:@selector(doRefresh) onTarget:self withObject:nil animated:YES];
}

- (void)doRefresh
{
    ASIHTTPRequest *request = [HttpRequestSender getRequestWithUrl:[UrlUtils urlStringWithUri:@"home/refresh"] withParams: nil];
    if (request != nil) {
        [request startSynchronous];
        NSError *error = [request error];
        if (!error && [request responseStatusCode] == 200){
            NSString *response = [request responseString];
            NSMutableDictionary *jsonResult = [response JSONValue];
            if([jsonResult valueForKey:@"success"] == [NSNumber numberWithBool:YES]){
                //保存成功
                [[UserContext getUserView] updateFromDictionary:[jsonResult valueForKey:@"result"]];
                [self viewWillAppear:YES];
                [self.infoTableView reloadData];
            }
        }else {
            [HttpRequestDelegate requestFailedHandle:request];
        }
    }
}

- (IBAction)editor:(id)sender{
    if (nil == _profileSettingViewController) {
        _profileSettingViewController = [[ProfileSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
        _profileSettingViewController.hidesBottomBarWhenPushed = YES;
    }
    [_profileSettingViewController initUserView:[UserContext getUserView]];
    [self.navigationController pushViewController:_profileSettingViewController animated:YES];
}

#pragma mark -
#pragma mark Table DataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 15;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *InfoListCellIdentifier = @"InfoListCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InfoListCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:InfoListCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    UserView *userView = [UserContext getUserView];
    NSString *title;
    switch (indexPath.section) {
        case 0:
            title = [NSString stringWithFormat:@"我的拒宅 (%d)", userView.postCount.intValue];
            break;
        case 1:
            title = [NSString stringWithFormat:@"我的关注 (%d)", userView.interestUserCount.intValue];
            break;
        case 2:
            title = [NSString stringWithFormat:@"我的粉丝 (%d)", userView.interestMeCount.intValue];
            break;
        case 3:
            title = @"邀请好友";
            break;
    }
    cell.textLabel.text = title;
    cell.textLabel.font = DEFAULT_FONT(15);
    cell.textLabel.textColor = [UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self goPostList:nil];
    } else if (indexPath.section == 1) {
        [self goInterestList:nil];
    } else if (indexPath.section == 2) {
        [self goInterestMeList:nil];
    } else if (indexPath.section == 3) {
        [self openShareLog:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (IBAction)goInterestList:(id)sender
{
    if ([UserContext getUserView].interestUserCount.intValue > 0) {
        if (nil == _interestUserViewController) {
            _interestUserViewController = [[InterestUserViewController alloc] init];
            _interestUserViewController.hidesBottomBarWhenPushed = YES;
        }
        _interestUserViewController.isInterest = YES;
        [self.navigationController pushViewController:_interestUserViewController animated:YES];
    }
}

- (IBAction)goInterestMeList:(id)sender
{
    if ([UserContext getUserView].interestMeCount.intValue > 0) {
        if (nil == _interestMeUserViewController) {
            _interestMeUserViewController = [[InterestUserViewController alloc] init];
            _interestMeUserViewController.hidesBottomBarWhenPushed = YES;
        }
        _interestMeUserViewController.isInterest = NO;
        [self.navigationController pushViewController:_interestMeUserViewController animated:YES];
    }
}

- (IBAction)goPostList:(id)sender
{
    if ([UserContext getUserView].postCount.intValue > 0) {
        if (nil == _userPostViewController) {
            _userPostViewController = [[UserPostViewController alloc] init];
            _userPostViewController.hidesBottomBarWhenPushed = YES;
        }
        [self.navigationController pushViewController:_userPostViewController animated:YES];
    }
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
        actionSheet = [[UIActionSheet alloc]initWithTitle:@"邀请好友" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"通过邮件邀请", @"通过短信邀请", nil];
        _shareToSmsButtonIdex = 1;
        _shareToMailButtonIdex = 0;
        _shareToThirdparyButtonIdex = -1;
    } else {
        actionSheet = [[UIActionSheet alloc]initWithTitle:@"邀请好友" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:[NSString stringWithFormat:@"通过%@邀请", tpChineseName], @"通过邮件邀请", @"通过短信邀请", nil];
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
        InviteInputViewController *inviteInputViewController = [[InviteInputViewController alloc] initWithNibName:@"InviteInputViewController" bundle:nil];
        inviteInputViewController.navTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        [self presentModalViewController:inviteInputViewController animated:YES];
    }
}

-(void)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    
    picker.body = [NSString stringWithFormat:@"刚发现一个小清新的脱宅社区，蛮有新意的；你也来试试吧。%@", @"http://www.51juzhai.com"];
    [self presentModalViewController:picker animated:YES];
}

//调出邮件发送窗口   
- (void)displayMailPicker   
{   
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];     
    mailPicker.mailComposeDelegate = self;     
    
    //设置主题     
    [mailPicker setSubject: @"发现一个不错的社区，蛮有新意的"];
    //    NSString *emailBody = @"<font color='red'>eMail</font> 正文";     
    NSString *emailBody = [NSString stringWithFormat:@"刚发现一个小清新的脱宅社区，蛮有新意的；周末不想宅在家的朋友可以来试试哦~ <a href=\"%@\">去看看</a>", @"http://www.51juzhai.com"];
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
