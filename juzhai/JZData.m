//
//  JZData.m
//  juzhai
//
//  Created by JiaJun Wu on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JZData.h"
#import "Pager.h"

@implementation JZData

@synthesize pager = _pager;

+ (id)loadPager:(NSDictionary *)pagerInfo withOldData:(JZData *)oldData
{
    if(!oldData){
        oldData = [[JZData alloc] initWithPager:[Pager pagerConvertFromDictionary:pagerInfo]];
    }else {
        [oldData.pager updatePagerFromDictionary:pagerInfo];
        if(oldData.pager.currentPage == 1){
            [oldData clear];
        }
    }
    return oldData;
}

- (void)loadPager:(NSDictionary *)pagerInfo
{
    if (!self.pager) {
        self.pager = [Pager pagerConvertFromDictionary:pagerInfo];
    } else {
        [self.pager updatePagerFromDictionary:pagerInfo];
        if(self.pager.currentPage == 1){
            [self clear];
        }
    }
}

- (id) init{
    self = [super init];
    if(self){
        _data = [[NSMutableArray alloc] init];
        _identitySet = [[NSMutableSet alloc] init];
    }
    return self;
}

- (id) initWithPager:(Pager *)pager{
    self = [self init];
    if(self){
        _pager = pager;
    }
    return self;
}

- (NSInteger) count
{
    return _data.count;
}

- (void) clear
{
    [_data removeAllObjects];
    [_identitySet removeAllObjects];
}

- (void) addObject:(id)object withIdentity:(id)identity
{
    if(identity == nil || ![_identitySet containsObject:identity]){
        [_data addObject:object];
        [_identitySet addObject:identity];
    }
}

- (void)insertObjectAtHead:(id)object withIdentity:(id)identity
{
    if(identity == nil || ![_identitySet containsObject:identity]){
        [_data insertObject:object atIndex:0];
        [_identitySet addObject:identity];
    }
}

- (void)addIdentity:(id)identity;
{
    [_identitySet addObject:identity];
}

- (void) addObject:(id)object
{
    [_data addObject:object];
}

- (void)insertObjectAtHead:(id)object
{
    [_data insertObject:object atIndex:0];
}

- (id)objectAtIndex:(NSUInteger)index
{
    return [_data objectAtIndex:index];
}

- (NSInteger) cellRows
{
    int count = [self count];
    if (_pager.hasNext) {
        count += 1;
    }
    return count;
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    [_data removeObjectAtIndex:index];
}

@end
