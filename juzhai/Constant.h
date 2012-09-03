//
//  Constant.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define DEFAULT_FONT_FAMILY @"MicrosoftYaHei"
//#define DEFAULT_FONT(fontSize) [UIFont fontWithName:@"AppleGothic" size:fontSize]
#define DEFAULT_FONT(fontSize) [UIFont systemFontOfSize:fontSize + 1]
#define DEFAULT_BOLD_FONT(fontSize) [UIFont boldSystemFontOfSize:fontSize + 1];

#define FACE_LOADING_IMG @"face_loading"
#define SMALL_PIC_LOADING_IMG @"small_pic_loading"
#define BIG_PIC_LOADING_IMG @"big_pic_loading"
#define APP_BG_IMG @"app_bg"
#define BASE_DOMAIN @"m.51juzhai.com"
#define BASE_URL [NSString stringWithFormat:@"http://%@/",BASE_DOMAIN]
#define MALE_NICKNAME_COLOR [UIColor colorWithRed:0.24f green:0.51f blue:0.76f alpha:1.00f]
#define FEMALE_NICKNAME_COLOR [UIColor colorWithRed:1.00f green:0.40f blue:0.60f alpha:1.00f]

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]


@interface Constant : NSObject

+ (NSString *)appVersion;

@end