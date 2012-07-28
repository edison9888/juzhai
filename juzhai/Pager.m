//
//  Pager.m
//  juzhai
//
//  Created by JiaJun Wu on 12-6-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Pager.h"

@implementation Pager

@synthesize currentPage;
@synthesize hasNext;
@synthesize hasPre;
@synthesize maxResult;
@synthesize totalPage;
@synthesize totalResults;

+ (id) pagerConvertFromDictionary:(NSDictionary *)info{
    Pager *pager = [Pager alloc];
    [pager updatePagerFromDictionary:info];
    return pager;
}

- (void) updatePagerFromDictionary:(NSDictionary *)info{
    self.currentPage = [[info valueForKey:@"currentPage"] intValue];
    self.maxResult = [[info valueForKey:@"maxResult"] intValue];
    self.totalPage = [[info valueForKey:@"totalPage"] intValue];
    self.totalResults = [[info valueForKey:@"totalResults"] intValue];
    self.hasPre = [[info valueForKey:@"hasPre"] boolValue];
    self.hasNext = [[info valueForKey:@"hasNext"] boolValue];
}

- (NSInteger)nextPage
{
    return self.currentPage + 1;
}

@end
