//
//  BaseData.h
//  juzhai
//
//  Created by JiaJun Wu on 12-6-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CATEGORY_FILE_NAME @"category.plist"
#define PROFESSION_FILE_NAME @"profession.plist"
#define PROVINCE_FILE_NAME @"province.plist"

@interface BaseData : NSObject

@property (strong,nonatomic) NSMutableArray *categoryArray;
@property (strong,nonatomic) NSMutableArray *professionArray;
@property (strong,nonatomic) NSMutableArray *provinceArray;
@property (strong,nonatomic) NSMutableDictionary *citiesDictionary;

+ (NSArray *)getCategories;
+ (NSArray *)getProfessions;
+ (NSArray *)getProvinces;
+ (NSArray *)getCitiesWithProvinceId:(NSInteger)provinceId;
+ (NSInteger) indexOfProvinces:(NSInteger)provinceId;
+ (NSInteger) indexOfCities:(NSInteger)cityId withProvinceId:(NSInteger)provinceId;
@end
