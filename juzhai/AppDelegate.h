//
//  AppDelegate.h
//  juzhai
//
//  Created by JiaJun Wu on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//test
#define UMENG_APP_KEY @"501f7cc852701524f500000e"
//product
//#define UMENG_APP_KEY @"502369be52701578c2000003"

//#define UMENG_CHANNEL_ID @"App Store"
//#define UMENG_CHANNEL_ID @"tongbu"
//#define UMENG_CHANNEL_ID @"91store"
#define UMENG_CHANNEL_ID @"local"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSTimer *noticeTimer;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
