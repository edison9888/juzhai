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

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize logoView;
@synthesize nicknameLabel;
@synthesize infoLabel;
@synthesize infoTableView;

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
    
    logoView.layer.masksToBounds = YES;
    logoView.layer.cornerRadius = 5.0;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *imageURL = [NSURL URLWithString:userView.rawLogo];
    [manager downloadWithURL:imageURL delegate:self options:0 success:^(UIImage *image) {
        logoView.image = [image imageByScalingAndCroppingForSize:CGSizeMake(logoView.frame.size.width*2, logoView.frame.size.height*2)];
    } failure:nil];
    
    nicknameLabel.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:14];
    if(userView.gender.intValue == 0){
        nicknameLabel.textColor = FEMALE_NICKNAME_COLOR;
    }else {
        nicknameLabel.textColor = MALE_NICKNAME_COLOR;
    }
    nicknameLabel.text = userView.nickname;
    
    infoLabel.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:13.0];
    infoLabel.textColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f];
    infoLabel.text = [userView basicInfo];
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
    [hud showWhileExecuting:@selector(doRefresh) onTarget:self withObject:hud animated:YES];
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
                [self viewWillAppear:NO];
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
    cell.textLabel.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:15];
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
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (IBAction)goInterestList:(id)sender
{
    if ([UserContext getUserView].interestUserCount.intValue > 0) {
        if (nil == _interestUserViewController) {
            _interestUserViewController = [[InterestUserViewController alloc] initWithStyle:UITableViewStylePlain];
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
            _interestMeUserViewController = [[InterestUserViewController alloc] initWithStyle:UITableViewStylePlain];
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
            _userPostViewController = [[UserPostViewController alloc] initWithStyle:UITableViewStylePlain];
            _userPostViewController.hidesBottomBarWhenPushed = YES;
        }
        [self.navigationController pushViewController:_userPostViewController animated:YES];
    }
}

@end
