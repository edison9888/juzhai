//
//  Pager.h
//  juzhai
//
//  Created by JiaJun Wu on 12-6-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pager : NSObject

@property (nonatomic) NSInteger currentPage;
@property (nonatomic) BOOL hasNext;
@property (nonatomic) BOOL hasPre;
@property (nonatomic) NSInteger maxResult;
@property (nonatomic) NSInteger totalPage;
@property (nonatomic) NSInteger totalResults;

+ (id)pagerConvertFromDictionary:(NSDictionary *)info;
- (void)updatePagerFromDictionary:(NSDictionary *)info;
- (NSInteger)nextPage;
@end
