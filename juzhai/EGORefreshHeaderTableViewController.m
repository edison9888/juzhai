//
//  EGORefreshTableHeaderViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EGORefreshHeaderTableViewController.h"

@interface EGORefreshHeaderTableViewController ()

@end

@implementation EGORefreshHeaderTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
        view.backgroundColor = [UIColor clearColor];
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
	}
    
    //请求数据
    [_refreshHeaderView autoRefresh:self.tableView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _refreshHeaderView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark self method
-(void)doneLoadingTableViewData{
    //reloading结束
	_reloading = NO;
    //告诉refreshHeaderView,已经完成loading
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    //让tableView 重新加载数据
	[self.tableView reloadData];
    //    [self.tableView reloadData
}

- (void)loadListDataWithPage:(NSInteger)page
{
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	//取数据
    _reloading = YES;
    //加载列表数据
    [self loadListDataWithPage:1];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	//正在reloading
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	//最后更新时间
	return [NSDate date]; // should return date data source was last changed
	
}

@end
