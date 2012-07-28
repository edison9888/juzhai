//
//  UserViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserViewController.h"
#import "JZData.h"
#import "CheckNetwork.h"
#import "CustomSegmentedControl.h"
#import "MenuButton.h"
#import "UserListCell.h"
#import "UserView.h"
#import "ASIHTTPRequest.h"
#import "HttpRequestSender.h"
#import "SBJson.h"
#import "MBProgressHUD.h"
#import "PostDetailViewController.h"
#import "Pager.h"
#import "PagerCell.h"
#import "SendPostBarButtonItem.h"
#import "UrlUtils.h"
#import "Constant.h"
#import "ListHttpRequestDelegate.h"

@interface UserViewController (Private)

- (void) loadListDataWithPage:(NSInteger)page;

@end

@implementation UserViewController

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
    _listHttpRequestDelegate.viewClassName = @"UserView";
    _listHttpRequestDelegate.listViewController = self;
    
    // Do any additional setup after loading the view from its nib.
    //中央切换按钮
    UIImage* dividerImage = [UIImage imageNamed:DIVIDER_LINE_IMAGE];
    _segmentedControl = [[CustomSegmentedControl alloc] initWithSegmentCount:2 segmentsize:CGSizeMake(60, dividerImage.size.height) dividerImage:dividerImage tag:ORDER_BY_ACTIVE delegate:self];
    self.navigationItem.titleView = _segmentedControl;
    
    //右侧性别按钮
    _genderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _genderButton.tag = QUERY_GENDER_ALL;
    UIImage *genderImage = [UIImage imageNamed:[NSString stringWithFormat:@"sex_%d_link.png", _genderButton.tag]];
    UIImage *activeGenderImage = [UIImage imageNamed:[NSString stringWithFormat:@"sex_%d_hover.png", _genderButton.tag]];
    _genderButton.frame = CGRectMake(0, 0, genderImage.size.width, genderImage.size.height);
    [_genderButton setBackgroundImage:genderImage forState:UIControlStateNormal];
    [_genderButton setBackgroundImage:activeGenderImage forState:UIControlStateHighlighted];
    [_genderButton addTarget:self action:@selector(selectGender:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: _genderButton];
    
    self.navigationItem.leftBarButtonItem = [[SendPostBarButtonItem alloc] initWithOwnerViewController:self];
    
    //隐藏下方线条
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    self.tableView.separatorColor = [UIColor clearColor];
    
    //设置背景图
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BG_IMG]];
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    if (_data != nil) {
        [self.tableView reloadData];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _data = nil;
    _listHttpRequestDelegate = nil;
    _genderButton = nil;
    _segmentedControl = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark local method

-(IBAction)selectGender:(id)sender{
    //弹框选择性别
    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                                  initWithTitle:@"筛选" 
                                  delegate:self 
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"全部", @"宅男", @"宅女", nil];
    [actionSheet showInView:self.tabBarController.view];
}

- (void) loadListDataWithPage:(NSInteger)page{
    if(page <= 0)
        page = 1;
    NSString *orderType;
    if (_segmentedControl.tag == ORDER_BY_ACTIVE) {
        orderType = @"online";
    } else {
        orderType = @"new";
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:orderType, @"orderType", [NSNumber numberWithInt:page], @"page", nil];
    NSInteger gender = _genderButton.tag;
    if (gender <= 1) {
        [params setObject:[NSNumber numberWithInt:gender] forKey:@"gender"];
    }
    ASIHTTPRequest *request = [HttpRequestSender getRequestWithUrl:[UrlUtils urlStringWithUri:@"post/showposts"] withParams:params];
    if (request) {
        
//        [request setCompletionBlock:^{
//            // Use when fetching text data
//            NSString *responseString = [request responseString];
//            NSMutableDictionary *jsonResult = [responseString JSONValue];
//            if([jsonResult valueForKey:@"success"] == [NSNumber numberWithBool:YES]){
//                //reload
//                _data = [JZData loadPager:[[jsonResult valueForKey:@"result"] valueForKey:@"pager"] withOldData:_data];
//                NSMutableArray *userViewList = [[jsonResult valueForKey:@"result"] valueForKey:@"userViewList"];
//                for (int i = 0; i < userViewList.count; i++) {
//                    id userView = [NSClassFromString(@"UserView") convertFromDictionary:[userViewList objectAtIndex:i]];
//                    [_data addObject:userView withIdentity:[userView uid]];
//                }
//                [self doneLoadingTableViewData];
//            }
//        }];
//        [request setFailedBlock:^{
//            [self doneLoadingTableViewData];
//        }];
        
        [request setDelegate:_listHttpRequestDelegate];
        [request startAsynchronous];
    }
}

#pragma mark - 
#pragma mark Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex] && _genderButton.tag != 2 - buttonIndex)
    {
        _genderButton.tag = 2 - buttonIndex;
        UIImage *genderImage = [UIImage imageNamed:[NSString stringWithFormat:@"sex_%d_link.png", _genderButton.tag]];
        UIImage *activeGenderImage = [UIImage imageNamed:[NSString stringWithFormat:@"sex_%d_hover.png", _genderButton.tag]];
        [_genderButton setBackgroundImage:genderImage forState:UIControlStateNormal];
        [_genderButton setBackgroundImage:activeGenderImage forState:UIControlStateHighlighted];
        //reload data
        [_refreshHeaderView autoRefresh:self.tableView];
    }
}

#pragma mark -
#pragma mark CustomSegmentedControlDelegate
- (UIButton*) buttonFor:(CustomSegmentedControl*)segmentedControl atIndex:(NSUInteger)segmentIndex;
{
    CapLocation location;
    if (segmentIndex == 0)
        location = CapLeft;
    else if (segmentIndex == segmentedControl.buttons.count - 1)
        location = CapMiddle;
    else
        location = CapRight;
    
    NSString *buttonText;
    switch (segmentIndex) {
        case ORDER_BY_ACTIVE:
            buttonText = @"活跃";
            break;
        case ORDER_BY_TIME:
            buttonText = @"最新";
            break;
    }
    UIButton* button = [[MenuButton alloc] initWithWidth:60 buttonText:buttonText CapLocation:location];
    if (segmentIndex == ORDER_BY_ACTIVE)
        button.selected = YES;
    return button;
}

- (void) touchDownAtSegmentIndex:(NSUInteger)segmentIndex
{
    if (segmentIndex == _segmentedControl.tag) {
        return;
    }
    _segmentedControl.tag = segmentIndex;
    //reload data
    [_refreshHeaderView autoRefresh:self.tableView];
}

#pragma mark -
#pragma mark Table View Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_data cellRows];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_data.pager.hasNext && indexPath.row == [_data count]) {
        return [PagerCell dequeueReusablePagerCell:tableView];
    }
    static NSString *UserListCellIdentifier = @"UserListCellIdentifier";
    UserListCell * cell = (UserListCell *)[tableView dequeueReusableCellWithIdentifier:UserListCellIdentifier];
    if(cell == nil){
        cell = [UserListCell cellFromNib];
    }
    if (indexPath.row < [_data count]) {
        UserView *userView = (UserView *)[_data objectAtIndex:indexPath.row];
        [cell redrawn:userView];
    }
    return cell;
}

#pragma mark -
#pragma mark Table View Delegate methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_data.pager.hasNext && indexPath.row == [_data count]) {
        return PAGER_CELL_HEIGHT;
    }else {
        return [UserListCell heightForCell:[_data objectAtIndex:indexPath.row]];        
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < [_data count]) {
        PostDetailViewController *postDetailViewController = [[PostDetailViewController alloc] initWithNibName:@"PostDetailViewController" bundle:nil];
        postDetailViewController.hidesBottomBarWhenPushed = YES;   
        postDetailViewController.userView = [_data objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:postDetailViewController animated:YES];
    } else {
        [self loadListDataWithPage:[_data.pager nextPage]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
