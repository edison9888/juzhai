//
//  UserContext.m
//  juzhai
//
//  Created by JiaJun Wu on 12-6-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserContext.h"
#import "UserView.h"

@interface UserContext (Private)

- (void) _setUserView:(UserView *)userView;
- (UserView *) _getUserView;

@end

@implementation UserContext

static UserContext *sharedUserContextInstance = nil; 

+(UserContext *) sharedUserContext
{
    @synchronized(self) {
        if (sharedUserContextInstance == nil) {
            sharedUserContextInstance = [[self alloc] init];
        }
        return sharedUserContextInstance;
    }
}

- (void) _setUserView:(UserView *)userView{
    _userView = userView;
}

- (UserView *) _getUserView{
    return _userView;
}

+ (NSInteger) getUid{
    UserContext *userContext = [UserContext sharedUserContext];
    UserView *userView = [userContext _getUserView];
    if(userView){
        return userView.uid.intValue;
    }
    return 0;
}

+ (UserView *) getUserView{
    UserContext *userContext = [UserContext sharedUserContext];
    return [userContext _getUserView];
}

+ (void) setUserView:(UserView *)userView{
    UserContext *userContext = [UserContext sharedUserContext];
    return [userContext _setUserView:userView];
}

+(BOOL) hasLogin{
    return [self getUid] > 0;
}

+(void) logout{
    [self setUserView:nil];
}

+(BOOL) hasCompleteGuide{
    UserContext *userContext = [UserContext sharedUserContext];
    UserView *userView = [userContext _getUserView];
    if(userView){
        return userView.hasGuided.boolValue;
    }
    return NO;
}

@end
