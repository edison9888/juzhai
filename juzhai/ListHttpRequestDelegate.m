//
//  ListHttpRequestDelegate.m
//  juzhai
//
//  Created by JiaJun Wu on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ListHttpRequestDelegate.h"
#import "SBJson.h"
#import "JZData.h"
#import "DataView.h"

@implementation ListHttpRequestDelegate

@synthesize jzData;
@synthesize viewClassName;
@synthesize listViewController;
@synthesize addToHead;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if(request.responseStatusCode != 200)
    {
        [self requestFailed:request];
        return;
    }
    NSString *responseString = [request responseString];
    NSMutableDictionary *jsonResult = [responseString JSONValue];
    if([[jsonResult valueForKey:@"success"] boolValue]){
        //reload
        [jzData loadPager:[[jsonResult valueForKey:@"result"] valueForKey:@"pager"]];
        NSMutableArray *viewList = [[jsonResult valueForKey:@"result"] valueForKey:@"list"];
        Class class = NSClassFromString(self.viewClassName);
        for (int i = 0; i < viewList.count; i++) {
            id view = [class convertFromDictionary:[viewList objectAtIndex:i]];
            if (addToHead) {
                [jzData insertObjectAtHead:view withIdentity:[view objIdentity]];
            } else {
                [jzData addObject:view withIdentity:[view objIdentity]];
            }
        }
        if (listViewController && [listViewController respondsToSelector:@selector(doneLoadingTableViewData)]) {
            [listViewController performSelector:@selector(doneLoadingTableViewData) withObject:nil];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (listViewController && [listViewController respondsToSelector:@selector(doneLoadingTableViewData)]) {
        [listViewController performSelector:@selector(doneLoadingTableViewData) withObject:nil];
    }
    [super requestFailed:request];
}


@end
