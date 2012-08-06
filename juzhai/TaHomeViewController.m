//
//  HomeViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TaHomeViewController.h"
#import "Constant.h"
#import <QuartzCore/QuartzCore.h>
#import "UserView.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "ASIHTTPRequest.h"
#import "HttpRequestSender.h"
#import "SBJson.h"
#import "MBProgressHUD.h"
#import "JZData.h"
#import "PostView.h"
#import "PostListCell.h"
#import "PostDetailViewController.h"
#import "ProfileSettingViewController.h"
#import "UserContext.h"
#import "Pager.h"
#import "InterestUserViewController.h"
#import "PagerCell.h"
#import "SendPostBarButtonItem.h"
#import "MessageShow.h"
#import "UrlUtils.h"
#import "CheckNetwork.h"
#import "ListHttpRequestDelegate.h"
#import "DialogContentViewController.h"
#import "UIImage+UIImageExt.h"
#import "UIViewController+MJPopupViewController.h"
#import "WholeImageViewController.h"

@interface TaHomeViewController ()

@end

@implementation TaHomeViewController

@synthesize userView = _userView;
@synthesize logoView;
@synthesize nicknameLabel;
@synthesize infoLabel;
@synthesize postTableView;
@synthesize postCountLabel;
@synthesize interestButton;
@synthesize cancelInterestButton;
@synthesize smsButton;

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
    _data = [[JZData alloc] init];
    _listHttpRequestDelegate = [[ListHttpRequestDelegate alloc] init];
    _listHttpRequestDelegate.jzData = _data;
    _listHttpRequestDelegate.viewClassName = @"PostView";
    _listHttpRequestDelegate.listViewController = self;
    
    self.title = [NSString stringWithFormat:@"%@的拒宅", _userView.nickname];

    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [postTableView setTableFooterView:view];
    self.postTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BG_IMG]];
    self.postTableView.separatorColor = [UIColor colorWithRed:0.71f green:0.71f blue:0.71f alpha:1.00f];
    _tableView = self.postTableView;
    
    postCountLabel.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: TABLE_HEAD_BG_IMAGE]];
    postCountLabel.font=[UIFont fontWithName:DEFAULT_FONT_FAMILY size:12];
    postCountLabel.textColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f];
    
    
    _isMe = _userView.uid.intValue == [UserContext getUserView].uid.intValue;
    
    logoView.layer.masksToBounds = YES;
    logoView.layer.cornerRadius = 5.0;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *imageURL = [NSURL URLWithString:(_userView.bigLogo)];
    [manager downloadWithURL:imageURL delegate:self options:0 success:^(UIImage *image) {
        logoView.image = [image imageByScalingAndCroppingForSize:CGSizeMake(logoView.frame.size.width*2, logoView.frame.size.height*2)];
        if (_userView.hasLogo) {
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoClick:)];
            [logoView addGestureRecognizer:singleTap];
        }
    } failure:nil];
    
    nicknameLabel.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:14.0];
    if(_userView.gender.intValue == 0){
        nicknameLabel.textColor = FEMALE_NICKNAME_COLOR;
    }else {
        nicknameLabel.textColor = MALE_NICKNAME_COLOR;
    }
    nicknameLabel.text = _userView.nickname;
    
    infoLabel.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:12.0];
    infoLabel.textColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f];;
    infoLabel.text = [_userView basicInfo];
    CGSize infoLabelSize = [infoLabel.text sizeWithFont:infoLabel.font constrainedToSize:infoLabel.frame.size lineBreakMode:UILineBreakModeWordWrap];
    infoLabel.frame = CGRectMake(infoLabel.frame.origin.x, 68 - infoLabelSize.height, infoLabelSize.width, infoLabelSize.height);
    
    if (_isMe) {
        interestButton.hidden = YES;
        interestButton.enabled = NO;
        cancelInterestButton.hidden = YES;
        cancelInterestButton.enabled = NO;
        smsButton.hidden = YES;
        smsButton.enabled = NO;
    } else {
        smsButton.hidden = NO;
        smsButton.enabled = YES;
        if ([self.userView.hasInterest boolValue]) {
            cancelInterestButton.hidden = NO;
            cancelInterestButton.enabled = YES;
            interestButton.hidden = YES;
            interestButton.enabled = NO;
        }else {            
            cancelInterestButton.hidden = YES;
            cancelInterestButton.enabled = NO;
            interestButton.hidden = NO;
            interestButton.enabled = YES;
        }
    }
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.logoView = nil;
    self.nicknameLabel = nil;
    self.infoLabel = nil;
    self.postTableView = nil;
    self.postCountLabel = nil;
    self.interestButton = nil;
    self.cancelInterestButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)logoClick:(UIGestureRecognizer *)gestureRecognizer {  
    _wholeImageViewController = [[WholeImageViewController alloc] init];
    _wholeImageViewController.image = logoView.image;
    _wholeImageViewController.imageUrl = _userView.originalLogo;
    _wholeImageViewController.delegate = self;
    [self presentPopupViewController:_wholeImageViewController animationType:MJPopupViewAnimationFade];
}

-(void)doneLoadingTableViewData{
    [super doneLoadingTableViewData];
    postCountLabel.text = [NSString stringWithFormat:TABLE_HEAD_TITLE, _data.pager.totalResults];
}

- (void) loadListDataWithPage:(NSInteger)page{
    if(page <= 0)
        page = 1;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:_userView.uid.intValue], @"uid", [NSNumber numberWithInt:page], @"page", nil];
    ASIHTTPRequest *request = [HttpRequestSender getRequestWithUrl:[UrlUtils urlStringWithUri:@"home"] withParams:params];
    if (request) {
        [request setDelegate:_listHttpRequestDelegate];
        [request startAsynchronous];
    } else {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5];
    }
}

- (IBAction)interestUser:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"操作中...";
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:_userView.uid, @"uid", nil];
        __unsafe_unretained __block ASIFormDataRequest *request = [HttpRequestSender postRequestWithUrl:[UrlUtils urlStringWithUri:@"home/interest"] withParams:params];
        if (request != nil) {
            [request setCompletionBlock:^{
                NSString *responseString = [request responseString];
                NSMutableDictionary *jsonResult = [responseString JSONValue];
                if([jsonResult valueForKey:@"success"] == [NSNumber numberWithBool:YES]){
                    _userView.hasInterest = [NSNumber numberWithInt:1];
                    interestButton.hidden = YES;
                    interestButton.enabled = NO;
                    cancelInterestButton.hidden = NO;
                    cancelInterestButton.enabled = YES;
                    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.labelText = @"关注成功";
                    [hud hide:YES afterDelay:1];
                    return;
                }
                NSString *errorInfo = [jsonResult valueForKey:@"errorInfo"];
                NSLog(@"%@", errorInfo);
                if (errorInfo == nil || [errorInfo isEqual:[NSNull null]] || [errorInfo isEqualToString:@""]) {
                    errorInfo = SERVER_ERROR_INFO;
                }
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MessageShow error:errorInfo onView:self.view];
            }];
            [request setFailedBlock:^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [HttpRequestDelegate requestFailedHandle:request];
            }];
            [request startAsynchronous];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
//    });
}

- (IBAction)cancelInterestUser:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定取消关注？" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (IBAction)sendSms:(id)sender
{
    DialogContentViewController *dialogContentViewController = [[DialogContentViewController alloc] initWithNibName:@"DialogContentViewController" bundle:nil];
    dialogContentViewController.hidesBottomBarWhenPushed = YES;
    dialogContentViewController.targetUser = _userView;
    [self.navigationController pushViewController:dialogContentViewController animated:YES];
}

#pragma mark -
#pragma mark Alert Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"操作中...";
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:_userView.uid, @"uid", nil];
            __unsafe_unretained __block ASIFormDataRequest *request = [HttpRequestSender postRequestWithUrl:[UrlUtils urlStringWithUri:@"home/removeInterest"] withParams:params];
            if (request != nil) {
                [request setCompletionBlock:^{
                    NSString *responseString = [request responseString];
                    NSMutableDictionary *jsonResult = [responseString JSONValue];
                    if([jsonResult valueForKey:@"success"] == [NSNumber numberWithBool:YES]){
                        _userView.hasInterest = [NSNumber numberWithInt:0];
                        cancelInterestButton.hidden = YES;
                        cancelInterestButton.enabled = NO;
                        interestButton.hidden = NO;
                        interestButton.enabled = YES;
                        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                        hud.mode = MBProgressHUDModeCustomView;
                        hud.labelText = @"取消成功";
                        [hud hide:YES afterDelay:1];
                        return;
                    }
                    NSString *errorInfo = [jsonResult valueForKey:@"errorInfo"];
                    NSLog(@"%@", errorInfo);
                    if (errorInfo == nil || [errorInfo isEqual:[NSNull null]] || [errorInfo isEqualToString:@""]) {
                        errorInfo = SERVER_ERROR_INFO;
                    }
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [MessageShow error:errorInfo onView:self.view];
                }];
                [request setFailedBlock:^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [HttpRequestDelegate requestFailedHandle:request];
                }];
                [request startAsynchronous];
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
//        });
    }
}

#pragma mark -
#pragma mark Table View Data Source

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count = _data.count;
    if (_data.pager.hasNext) {
        count += 1;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_data.pager.hasNext && indexPath.row == [_data count]) {
        return [PagerCell dequeueReusablePagerCell:tableView];
    }
    NSString *postListCellIdentifier = @"PostListCellIdentifier";
    PostListCell *cell = [tableView dequeueReusableCellWithIdentifier:postListCellIdentifier];
    if(cell == nil){
        cell = [PostListCell cellFromNib];
    }
    if (indexPath.row < [_data count]) {
        PostView *postView = (PostView *)[_data objectAtIndex:indexPath.row];
        [cell redrawn:postView];
    }
    return cell;
}

#pragma mark -
#pragma mark Table View Deletage

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_data.pager.hasNext && indexPath.row == [_data count]) {
        return PAGER_CELL_HEIGHT;
    }else {
        return [PostListCell heightForCell:[_data objectAtIndex:indexPath.row]];
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < [_data count]) {
        PostDetailViewController *postDetailViewController = [[PostDetailViewController alloc] initWithNibName:@"PostDetailViewController" bundle:nil];
        postDetailViewController.hidesBottomBarWhenPushed = YES;
        UserView *userView = [_userView copy];
        userView.post = [_data objectAtIndex:indexPath.row];
        postDetailViewController.userView = userView;
        [self.navigationController pushViewController:postDetailViewController animated:YES];
    } else {
        [self loadListDataWithPage:[_data.pager nextPage]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Whole Image View Delegate
- (void)cancelButtonClicked:(WholeImageViewController *)wholeImageViewController
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    wholeImageViewController = nil;
}

@end
