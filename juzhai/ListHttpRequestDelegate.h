//
//  ListHttpRequestDelegate.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HttpRequestSender.h"
@class JZData;

@interface ListHttpRequestDelegate : HttpRequestDelegate

@property (strong, nonatomic) JZData *jzData;
@property (strong, nonatomic) NSString *viewClassName;
@property (strong, nonatomic) id listViewController;
@property (nonatomic) BOOL addToHead;

@end
