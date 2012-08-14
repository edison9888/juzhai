//
//  UserPostViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserPostViewController.h"
#import "Constant.h"
#import "JZData.h"
#import "Pager.h"
#import "PagerCell.h"
#import "PostListCell.h"
#import "PostDetailViewController.h"
#import "UserContext.h"
#import "UserView.h"
#import "CheckNetwork.h"
#import "SBJson.h"
#import "HttpRequestSender.h"
#import "UrlUtils.h"
#import "PostView.h"
#import "ListHttpRequestDelegate.h"

@interface UserPostViewController ()

@end

@implementation UserPostViewController

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
    _postImageDictionary = [[NSMutableDictionary alloc] init];
    
    _data = [[JZData alloc] init];
    _listHttpRequestDelegate = [[ListHttpRequestDelegate alloc] init];
    _listHttpRequestDelegate.jzData = _data;
    _listHttpRequestDelegate.viewClassName = @"PostView";
    _listHttpRequestDelegate.listViewController = self;
    
    self.title = @"我的拒宅";
    
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
    // Release any retained subviews of the main view.
    _data = nil;
    _listHttpRequestDelegate = nil;
    _postImageDictionary = nil;
}

- (void)didReceiveMemoryWarning
{
    [_postImageDictionary removeAllObjects];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadListDataWithPage:(NSInteger)page
{
    if(page <= 0){
        page = 1;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:page], @"page", nil];
    ASIHTTPRequest *request = [HttpRequestSender getRequestWithUrl:[UrlUtils urlStringWithUri:@"home"] withParams:params];
    if (request) {
        [request setDelegate:_listHttpRequestDelegate];
        [request startAsynchronous];
    } else {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5];
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
        cell.postImageDictionary = _postImageDictionary;
    }
    if (indexPath.row < [_data count]) {
        PostView *postView = (PostView *)[_data objectAtIndex:indexPath.row];
        [cell redrawn:postView];
    }
    return cell;
}

//- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return [NSString stringWithFormat:TABLE_HEAD_TITLE, _data.pager.totalResults];
//}

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
        UserView *userView = [[UserContext getUserView] copy];
        userView.post = [_data objectAtIndex:indexPath.row];
        postDetailViewController.userView = userView;
        [self.navigationController pushViewController:postDetailViewController animated:YES];
    } else {
        [self loadListDataWithPage:[_data.pager nextPage]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
