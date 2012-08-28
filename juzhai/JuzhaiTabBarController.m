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
#import "CheckNetwork.h"
#import "AppDelegate.h"
#import "UserContext.h"
#import "UserView.h"
#import "AuthorizeExpiredViewController.h"
#import "AuthorizeBindViewController.h"

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
    
    [self startNotice];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locationManager.distanceFilter = 50.0;
    [_locationManager startUpdatingLocation];
    
    UINavigationController *viewController = [self.viewControllers objectAtIndex:0];
    UserView *userView = [UserContext getUserView];
    if (userView.tpId.intValue > 0 && userView.tokenExpired) {
        if (nil == _authorizeExpiredViewController) {
            _authorizeExpiredViewController = [[AuthorizeExpiredViewController alloc] initWithNibName:@"AuthorizeViewController" bundle:nil];
            _authorizeExpiredViewController.hidesBottomBarWhenPushed = YES;
        }
        _authorizeExpiredViewController.tpId = userView.tpId.intValue;
        [viewController pushViewController:_authorizeExpiredViewController animated:YES];
    } else if (userView.tpId.intValue <= 0) {
        if (nil == _authorizeBindViewController) {
            _authorizeBindViewController = [[AuthorizeBindViewController alloc] initWithNibName:@"AuthorizeBindViewController" bundle:nil];
            _authorizeBindViewController.hidesBottomBarWhenPushed = YES;
        }
        [viewController pushViewController:_authorizeBindViewController animated:YES];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [_locationManager stopUpdatingLocation];
    _locationManager = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)startNotice
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (nil == delegate.noticeTimer || ![delegate.noticeTimer isValid]) {
        delegate.noticeTimer = [NSTimer timerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(notice) userInfo:nil repeats:YES];
    }
    [[NSRunLoop currentRunLoop] addTimer:delegate.noticeTimer forMode:NSDefaultRunLoopMode];
}

- (void)notice
{
    UITabBarItem *messageTabBar = [[self.tabBar items] objectAtIndex:3];
    __unsafe_unretained __block ASIHTTPRequest *request = [HttpRequestSender backgroundGetRequestWithUrl:[UrlUtils urlStringWithUri:@"dialog/notice/nums"] withParams:nil];
    if (request != nil) {
        [request setTimeOutSeconds:4];
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
        [request startAsynchronous];;
    }
}

#pragma mark -
#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //纬度
    CLLocationDegrees latitude = newLocation.coordinate.latitude;
    //经度
    CLLocationDegrees longitude = newLocation.coordinate.longitude;
    
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
        [manager stopUpdatingLocation];
    }
}

@end
