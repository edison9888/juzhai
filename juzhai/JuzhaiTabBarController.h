//
//  JuzhaiTabBarController.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define TIMER_INTERVAL 5

@interface JuzhaiTabBarController : UITabBarController <CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
}
@end
