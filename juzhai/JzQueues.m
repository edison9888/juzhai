//
//  JzQueues.m
//  juzhai
//
//  Created by JiaJun Wu on 12-9-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JzQueues.h"
#import "ASINetworkQueue.h"

@implementation JzQueues

@synthesize dialogContentQueue = _dialogContentQueue;

static JzQueues *jzQueues;

- (id)init
{
    self = [super init];
    if (self) {
//        _dialogContentQueue = [ASINetworkQueue queue];
//        _dialogContentQueue.maxConcurrentOperationCount = 1;
//        _dialogContentQueue.delegate = self;
//        _dialogContentQueue.requestDidStartSelector = @selector(requestDidStartSelector:);
//        //设置代理
//        [_dialogContentQueue go];
    }
    return self;
}

+ (JzQueues *) sharedQueues{
    @synchronized(jzQueues){
        if (!jzQueues) {
            jzQueues = [[JzQueues alloc] init];
        }
        return jzQueues;
    }
}

@end
