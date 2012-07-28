//
//  JuzhaiTabBarController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JuzhaiTabBarController.h"
#import "HttpRequestSender.h"
#import "UrlUtils.h"
#import "SBJson.h"

@interface JuzhaiTabBarController ()

@end

@implementation JuzhaiTabBarController

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
}

- (void)viewDidAppear:(BOOL)animated
{
//    [self performSelector:@selector(startNoticeTimer) withObject:nil afterDelay:2];
    _noticeTimer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(notice) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_noticeTimer invalidate];
    _noticeTimer = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [_noticeTimer invalidate];
    _noticeTimer = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)startNoticeTimer
{
    _noticeTimer = [NSTimer timerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(notice) userInfo:nil repeats:YES];
    [_noticeTimer fire];
    [[NSRunLoop currentRunLoop] addTimer:_noticeTimer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run]; 
}

- (void)notice
{
    UITabBarItem *messageTabBar = [[self.tabBar items] objectAtIndex:3];
    __unsafe_unretained __block ASIHTTPRequest *request = [HttpRequestSender getRequestWithUrl:[UrlUtils urlStringWithUri:@"dialog/notice/nums"] withParams:nil];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSMutableDictionary *jsonResult = [responseString JSONValue];
        if([jsonResult valueForKey:@"success"] == [NSNumber numberWithBool:YES]){
            NSInteger num = [[jsonResult valueForKey:@"result"] intValue];
            if (num > 0) {
                messageTabBar.badgeValue = [NSString stringWithFormat:@"%d", num];
            } else {
                messageTabBar.badgeValue = nil;
            }
        }
    }];
    [request setFailedBlock:^{
        [HttpRequestDelegate requestFailedHandle:request];
    }];
    [request startAsynchronous];;
}

@end
