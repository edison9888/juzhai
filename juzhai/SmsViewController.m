//
//  SmsViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-7-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SmsViewController.h"
#import "JZData.h"
#import "SmsListCell.h"
#import "PagerCell.h"
#import "DialogView.h"
#import "Constant.h"
#import "HttpRequestSender.h"
#import "SBJson.h"
#import "TaHomeViewController.h"
#import "RectButton.h"
#import "MessageShow.h"
#import "UrlUtils.h"
#import "DialogContentViewController.h"
#import "ListHttpRequestDelegate.h"

@interface SmsViewController ()

@end

@implementation SmsViewController

- (void)viewDidLoad
{    
    _data = [[JZData alloc] init];
    _listHttpRequestDelegate = [[ListHttpRequestDelegate alloc] init];
    _listHttpRequestDelegate.jzData = _data;
    _listHttpRequestDelegate.viewClassName = @"DialogView";
    _listHttpRequestDelegate.listViewController = self;
    
    self.title = @"我的消息";
    
    _editButton = [[RectButton alloc] initWithWidth:45.0 buttonText:@"删除" CapLocation:CapLeftAndRight];
    [_editButton addTarget:self action:@selector(toggleEdit:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_editButton];
    
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController.tabBarItem.badgeValue != nil && _data != nil) {
        [_refreshHeaderView autoRefresh:_tableView];
    } else {
        [_tableView reloadData];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)doneLoadingTableViewData{
    [super doneLoadingTableViewData];
    self.navigationController.tabBarItem.badgeValue = nil;
}

- (void) loadListDataWithPage:(NSInteger)page
{
    if(page <= 0)
        page = 1;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:page], @"page", nil];
    ASIHTTPRequest *request = [HttpRequestSender getRequestWithUrl:[UrlUtils urlStringWithUri:@"dialog/dialogList"] withParams:params];
    if (request) {
        [request setDelegate:_listHttpRequestDelegate];
        [request startAsynchronous];
    } else {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5];
    }     
}

- (IBAction)toggleEdit:(id)sender{
    [_tableView setEditing:!_tableView.editing animated:YES];
    if(_tableView.editing)
        [_editButton setTitle:@"完成" forState:UIControlStateNormal];
    else
        [_editButton setTitle:@"删除" forState:UIControlStateNormal];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data cellRows];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_data.pager.hasNext && indexPath.row == [_data count]) {
        return [PagerCell dequeueReusablePagerCell:tableView];
    }
    static NSString *SmsListCellIdentifier = @"SmsListCellIdentifier";
    SmsListCell *cell = (SmsListCell *)[tableView dequeueReusableCellWithIdentifier:SmsListCellIdentifier];
    if(cell == nil){
        cell = [SmsListCell cellFromNib];
    }
    if (indexPath.row < [_data count]) {
        DialogView *dialogView = (DialogView *)[_data objectAtIndex:indexPath.row];
        [cell redrawn:dialogView];
    }
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [_data count])
        return YES;
    else
        return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DialogView *dialogView = (DialogView *)[_data objectAtIndex:indexPath.row];
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:dialogView.dialogId], @"dialogId", nil];
        __unsafe_unretained __block ASIFormDataRequest *request = [HttpRequestSender postRequestWithUrl:[UrlUtils urlStringWithUri:@"dialog/deleteDialog"] withParams:params];
        if (request) {
            [request setCompletionBlock:^{
                NSString *responseString = [request responseString];
                NSMutableDictionary *jsonResult = [responseString JSONValue];
                if([jsonResult valueForKey:@"success"] == [NSNumber numberWithBool:YES]){
                    NSUInteger row = [indexPath row];
                    [_data removeObjectAtIndex:row];
                    // Delete the row from the data source
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    return;
                }
                NSString *errorInfo = [jsonResult valueForKey:@"errorInfo"];
                NSLog(@"%@", errorInfo);
                if (errorInfo == nil || [errorInfo isEqual:[NSNull null]] || [errorInfo isEqualToString:@""]) {
                    errorInfo = SERVER_ERROR_INFO;
                }
                [MessageShow error:errorInfo onView:self.view];
            }];
            [request setFailedBlock:^{
                [HttpRequestDelegate requestFailedHandle:request];
            }];
            [request startAsynchronous];
        }
    }   
}

#pragma mark - Table view delegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_data.pager.hasNext && indexPath.row == [_data count]) {
        return PAGER_CELL_HEIGHT;
    }else {
        return [SmsListCell heightForCell:[_data objectAtIndex:indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [_data count]) {
        DialogView *dialogView = (DialogView *)[_data objectAtIndex:indexPath.row];
        DialogContentViewController *dialogContentViewController = [[DialogContentViewController alloc] initWithNibName:@"DialogContentViewController" bundle:nil];
        dialogContentViewController.hidesBottomBarWhenPushed = YES;
        dialogContentViewController.targetUser = dialogView.targetUser;
        [self.navigationController pushViewController:dialogContentViewController animated:YES];
    } else {
        [self loadListDataWithPage:[_data.pager nextPage]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
