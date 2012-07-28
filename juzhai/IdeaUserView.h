//
//  IdeaUserView.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataView.h"

@class UserView;

@interface IdeaUserView : NSObject <DataView>

@property (nonatomic) NSInteger ideaId;
@property (strong, nonatomic) UserView *userView;
@property (nonatomic) NSTimeInterval createTime;

@end
