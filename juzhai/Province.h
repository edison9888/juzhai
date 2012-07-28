//
//  Province.h
//  juzhai
//
//  Created by JiaJun Wu on 12-6-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Province : NSObject

@property (nonatomic) NSInteger provinceId;
@property (strong, nonatomic) NSString *name;

- (id) initWithProvinceId:(NSInteger)provinceId withName:(NSString *)name;

@end
