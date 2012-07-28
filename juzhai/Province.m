//
//  Province.m
//  juzhai
//
//  Created by JiaJun Wu on 12-6-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Province.h"

@implementation Province

@synthesize provinceId;
@synthesize name;

- (id) initWithProvinceId:(NSInteger)pId withName:(NSString *)n{
    self = [super init];
    if(self){
        self.provinceId = pId;
        self.name = n;
    }
    return self;
}

@end
