//
//  City.h
//  juzhai
//
//  Created by JiaJun Wu on 12-6-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject

@property (nonatomic) NSInteger cityId;
@property (strong, nonatomic) NSString *name;
@property (nonatomic) NSInteger provinceId;

- (id) initWithCityId:(NSInteger)cityId withName:(NSString *)name withProvinceId:(NSInteger)provinceId;

@end
