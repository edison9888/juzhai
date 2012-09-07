//
//  JzQueues.h
//  juzhai
//
//  Created by JiaJun Wu on 12-9-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ASINetworkQueue;
@interface JzQueues : NSObject

@property (readonly, strong, nonatomic) ASINetworkQueue *dialogContentQueue;

@end
