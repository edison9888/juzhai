//
//  InterestUserViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-6-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "InterestUserViewController.h"
#import "JZData.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UserView.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "HttpRequestSender.h"
#import "SBJson.h"
#import "Pager.h"
#import "TaHomeViewController.h"
#import "PagerCell.h"
#import "UrlUtils.h"
#import "CheckNetwork.h"
#import "ListHttpRequestDelegate.h"
#import "UIImage+UIImageExt.h"

@interface InterestUserViewController ()

@end

@implementation InterestUserViewController

@synthesize isInterest;

- (void)viewDidLoad
{
    _logoDictionary = [[NSMutableDictionary alloc] init];
    _data = [[JZData alloc] init];
    _listHttpRequestDelegate = [[ListHttpRequestDelegate alloc] init];
    _listHttpRequestDelegate.jzData = _data;
    _listHttpRequestDelegate.viewClassName = @"UserView";
    _listHttpRequestDelegate.listViewController = self;
    
    if (self.isInterest) {
        self.title = @"我的关注";
    } else {
        self.title = @"我的粉丝";
    }
    
    CGFloat tableHeight = self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height - (self.tabBarController.tabBar.hidden||self.hidesBottomBarWhenPushed ? 0 : self.tabBarController.tabBar.bounds.size.height);
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, tableHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //隐藏下方线条
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:view];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:APP_BG_IMG]];
    [self.view addSubview:imageView];
    [self.view addSubview:_tableView];
    
    _tableView.separatorColor = [UIColor colorWithRed:0.71f green:0.71f blue:0.71f alpha:1.00f];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _data = nil;
    _listHttpRequestDelegate = nil;
    _logoDictionary = nil;
}

- (void)didReceiveMemoryWarning
{
    [_logoDictionary removeAllObjects];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) loadListDataWithPage:(NSInteger)page{
    if(page <= 0)
        page = 1;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:page], @"page", nil];
    NSString *requestUrl = self.isInterest ? [UrlUtils urlStringWithUri:@"home/interestList"] : [UrlUtils urlStringWithUri:@"home/interestMeList"];
    
    ASIHTTPRequest *request = [HttpRequestSender getRequestWithUrl:requestUrl withParams:params];
    if (request) {
        [request setDelegate:_listHttpRequestDelegate];
        [request startAsynchronous];
    } else {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = _data.count;
    if (_data.pager.hasNext) {
        count += 1;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_data.pager.hasNext && indexPath.row == [_data count]) {
        return [PagerCell dequeueReusablePagerCell:tableView];
    }
    static NSString *InterestUserCellIdentifier = @"InterestUserCellCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InterestUserCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:InterestUserCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 1)];
        separatorView.backgroundColor = [UIColor whiteColor];
        [cell addSubview:separatorView];
        
        UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        logo.tag = INTEREST_USER_LOGO_TAG;
        [cell addSubview:logo];
        
        UILabel *nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 12, 150, 14)];
        nicknameLabel.backgroundColor = [UIColor clearColor];
        nicknameLabel.tag = INTEREST_USER_NICKNAME_TAG;
        [cell addSubview:nicknameLabel];
        
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 35, 200, 13)];
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.tag = INTEREST_USER_INFO_TAG;
        [cell addSubview:infoLabel];
        
        UIView *selectBgColorView = [[UIView alloc] init];
        selectBgColorView.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = selectBgColorView;
        cell.backgroundColor = [UIColor clearColor];
    }
    if (indexPath.row < [_data count]) {
        UserView *userView = [_data objectAtIndex:indexPath.row];
        
        UIImageView *logo = (UIImageView *)[cell viewWithTag:INTEREST_USER_LOGO_TAG];
        UIImage *logoImage = [_logoDictionary objectForKey:userView.uid];
        if (logoImage != nil) {
            logo.image = logoImage;
        } else {
            logo.image = [UIImage imageNamed:FACE_LOADING_IMG];
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            NSURL *imageURL = [NSURL URLWithString:userView.bigLogo];
            [manager downloadWithURL:imageURL delegate:self options:0 success:^(UIImage *image) {
                UIImage *resultImage = [image imageByScalingAndCroppingForSize:CGSizeMake(logo.frame.size.width*2, logo.frame.size.height*2)];
                logo.image = [resultImage createRoundedRectImage:8.0];
                [_logoDictionary setObject:logo.image forKey:userView.uid];
            } failure:nil];
        }
        
        UILabel *nicknameLabel = (UILabel *)[cell viewWithTag:INTEREST_USER_NICKNAME_TAG];
        nicknameLabel.font = DEFAULT_FONT(14);
        if(userView.gender.intValue == 0){
            nicknameLabel.textColor = FEMALE_NICKNAME_COLOR;
        }else {
            nicknameLabel.textColor = MALE_NICKNAME_COLOR;
        }
        nicknameLabel.text = userView.nickname;
        
        UILabel *infoLabel = (UILabel *)[cell viewWithTag:INTEREST_USER_INFO_TAG];
        infoLabel.font = DEFAULT_FONT(13);
        infoLabel.textColor = [UIColor grayColor];
        infoLabel.text = [userView basicInfo];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_data.pager.hasNext && indexPath.row == [_data count]) {
        return PAGER_CELL_HEIGHT;
    }else {
        return 60.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [_data count]) {
        TaHomeViewController *taHomeViewController = [[TaHomeViewController alloc] initWithNibName:@"TaHomeViewController" bundle:nil];
        taHomeViewController.hidesBottomBarWhenPushed = YES;
        taHomeViewController.userView = [_data objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:taHomeViewController animated:YES];
    } else {
        [self loadListDataWithPage:[_data.pager nextPage]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
