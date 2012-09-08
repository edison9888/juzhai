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
    _logoDictionary = [[NSMutableDictionary alloc] init];
    _postImageDictionary = [[NSMutableDictionary alloc] init];
    
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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height - self.tabBarController.tabBar.bounds.size.height) style:UITableViewStylePlain];
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
    
    _tableView.separatorColor = [UIColor clearColor];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locationManager.distanceFilter = 50.0;
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_data != nil) {
        [_tableView reloadData];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    _logoDictionary = nil;
    _postImageDictionary = nil;
    [_locationManager stopUpdatingLocation];
    _locationManager = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [_logoDictionary removeAllObjects];
    [_postImageDictionary removeAllObjects];
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
        [request setDelegate:_listHttpRequestDelegate];
        [request startAsynchronous];
    } else {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5];
    }
    [_locationManager startUpdatingLocation];
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
        [_refreshHeaderView autoRefresh:_tableView];
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
    [_refreshHeaderView autoRefresh:_tableView];
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
        cell.postImageDictionary = _postImageDictionary;
        cell.logoDictionary = _logoDictionary;
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

#pragma mark -
#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [manager stopUpdatingLocation];
    //纬度
    CLLocationDegrees latitude = newLocation.coordinate.latitude;
    //经度
    CLLocationDegrees longitude = newLocation.coordinate.longitude;
    //    NSLog(@"%g", latitude);
    //    NSLog(@"%g", longitude);
    if (oldLocation != nil) {
        //纬度
        CLLocationDegrees oldLatitude = newLocation.coordinate.latitude;
        //经度
        CLLocationDegrees oldLongitude = newLocation.coordinate.longitude;
        
        if (oldLatitude == latitude && oldLongitude == longitude) {
            return;
        }
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:longitude], @"longitude", [NSNumber numberWithDouble:latitude], @"latitude", nil];
    ASIHTTPRequest *request = [HttpRequestSender backgroundGetRequestWithUrl:[UrlUtils urlStringWithUri:@"home/updateloc"] withParams:params];
    if (request != nil) {
        [request startAsynchronous];;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorLocationUnknown) {
        //无法确定位置
    } else if (error.code == kCLErrorDenied) {
        //被拒绝
    }
    [manager stopUpdatingLocation];
}

@end
