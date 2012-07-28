//
//  UserContext.h
//  juzhai
//
//  Created by JiaJun Wu on 12-6-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserView;

@interface UserContext : NSObject
{
    UserView *_userView; 
}
+(NSInteger) getUid;
+(UserView *) getUserView;
+(void) setUserView:(UserView *)userView;
+(BOOL) hasLogin;
+(void) logout;
+(BOOL) hasCompleteGuide;

@end
