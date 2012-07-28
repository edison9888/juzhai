//
//  City.m
//  juzhai
//
//  Created by JiaJun Wu on 12-6-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "City.h"

@implementation City

@synthesize cityId;
@synthesize name;
@synthesize provinceId;

- (id) initWithCityId:(NSInteger)cId withName:(NSString *)n withProvinceId:(NSInteger)pId{
    self = [super init];
    if (self) {
        self.cityId = cId;
        self.name = n;
        self.provinceId = pId;
    }
    return self;
}

@end
