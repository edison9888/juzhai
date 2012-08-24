//
//  JZData.h
//  juzhai
//
//  Created by JiaJun Wu on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pager.h"

@interface JZData : NSObject
{
    NSMutableSet *_identitySet;
    NSMutableArray *_data;
}

@property (strong, nonatomic) Pager *pager;

+ (id)loadPager:(NSDictionary *)pagerInfo withOldData:(JZData *)oldData;

- (void)loadPager:(NSDictionary *)pagerInfo;
- (id)initWithPager:(Pager *)pager;
- (NSInteger)count;
- (void)addObject:(id)object withIdentity:(id)identity;
- (void)insertObjectAtHead:(id)object withIdentity:(id)identity;
- (void)addObject:(id)object;
- (void)insertObjectAtHead:(id)object;
- (void)addIdentity:(id)identity;
- (void)clear;
- (id)objectAtIndex:(NSUInteger)index;
- (NSInteger) cellRows;
- (void)removeObjectAtIndex:(NSUInteger)index;
@end
