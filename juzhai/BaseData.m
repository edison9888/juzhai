//
//  BaseData.m
//  juzhai
//
//  Created by JiaJun Wu on 12-6-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseData.h"
#import "ASIHTTPRequest.h"
#import "HttpRequestSender.h"
#import "SBJson.h"
#import "Category.h"
#import "Profession.h"
#import "Province.h"
#import "City.h"
#import "UrlUtils.h"

@interface BaseData (Private)

+ (BaseData *)sharedData;

@end

@implementation BaseData

@synthesize categoryArray;
@synthesize professionArray;
@synthesize provinceArray;
@synthesize citiesDictionary;

static BaseData *baseData;

+ (BaseData *) sharedData{
    @synchronized(baseData){
        if (!baseData) {
            baseData = [[BaseData alloc]init];
        }
        return baseData;
    }
}

+ (NSArray *)getCategories{
    BaseData *baseData = [BaseData sharedData];
    if(!baseData.categoryArray){
        //http load
        __unsafe_unretained __block ASIHTTPRequest *request = [HttpRequestSender backgroundGetRequestWithUrl:[UrlUtils urlStringWithUri:@"base/categoryList"] withParams:nil];
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSMutableDictionary *jsonResult = [responseString JSONValue];
            if([jsonResult valueForKey:@"success"] == [NSNumber numberWithBool:YES]){
                NSArray *array = [jsonResult objectForKey:@"result"];
                baseData.categoryArray = [[NSMutableArray alloc] initWithCapacity:array.count];
                for(NSDictionary *dic in array){
                    NSDecimalNumber *cId = nil;
                    for(NSDecimalNumber *key in [dic allKeys]){
                        cId = key;
                    }
                    [baseData.categoryArray addObject:[[Category alloc] initWithCategoryId:cId withName:[dic objectForKey:cId]]];
                }
            }
        }];
        [request startAsynchronous];
    }
    return baseData.categoryArray;
}

+ (NSArray *)getProfessions{
    BaseData *baseData = [BaseData sharedData];
    if(!baseData.professionArray){
        //http load
        __unsafe_unretained __block ASIHTTPRequest *request = [HttpRequestSender backgroundGetRequestWithUrl:[UrlUtils urlStringWithUri:@"base/professionList"] withParams:nil];
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSMutableDictionary *jsonResult = [responseString JSONValue];
            if([jsonResult valueForKey:@"success"] == [NSNumber numberWithBool:YES]){
                NSArray *array = [jsonResult objectForKey:@"result"];
                baseData.professionArray = [[NSMutableArray alloc] initWithCapacity:array.count];
                for(NSDictionary *dic in array){
                    NSDecimalNumber *pId = nil;
                    for(NSDecimalNumber *key in [dic allKeys]){
                        pId = key;
                    }
                    [baseData.professionArray addObject:[[Profession alloc] initWithProfessionId:pId withName:[dic objectForKey:pId]]];
                }
            }
        }];
        [request startAsynchronous];
    }
    return baseData.professionArray;
}

+ (NSArray *)getProvinces{
    BaseData *baseData = [BaseData sharedData];
    if(!baseData.provinceArray){
        //http load
        __unsafe_unretained __block ASIHTTPRequest *request = [HttpRequestSender backgroundGetRequestWithUrl:[UrlUtils urlStringWithUri:@"base/provinceCityList"] withParams:nil];
        [request setCompletionBlock:^{
            // Use when fetching text data
            NSString *responseString = [request responseString];
            NSMutableDictionary *jsonResult = [responseString JSONValue];
            if([jsonResult valueForKey:@"success"] == [NSNumber numberWithBool:YES]){
                NSDictionary *result = [jsonResult objectForKey:@"result"];
                NSArray *provinceDicArray = [result objectForKey:@"provinceList"];
                NSArray *cityDicArray = [result objectForKey:@"cityList"];
                
                baseData.provinceArray = [[NSMutableArray alloc] initWithCapacity:provinceDicArray.count];
                baseData.citiesDictionary = [[NSMutableDictionary alloc] initWithCapacity:provinceDicArray.count];
                
                for (NSDictionary *provinceDic in provinceDicArray) {
                    NSInteger provinceId = [[provinceDic objectForKey:@"provinceId"] intValue];
                    NSString *provinceName = [provinceDic objectForKey:@"provinceName"];
                    [baseData.provinceArray addObject:[[Province alloc] initWithProvinceId:provinceId withName:provinceName]];
                }
                for (NSDictionary *cityDic in cityDicArray) {
                    NSInteger cityId = [[cityDic objectForKey:@"cityId"] intValue];
                    NSString *cityName = [cityDic objectForKey:@"cityName"];
                    NSInteger provinceId = [[cityDic objectForKey:@"provinceId"] intValue];
                    
                    NSMutableArray *cities = [baseData.citiesDictionary objectForKey:[NSNumber numberWithInt:provinceId]];
                    if (!cities) {
                        cities = [[NSMutableArray alloc] init];
                        [baseData.citiesDictionary setObject:cities forKey:[NSNumber numberWithInt:provinceId]];
                    }
                    [cities addObject:[[City alloc] initWithCityId:cityId withName:cityName withProvinceId:provinceId]];
                }
            }
        }];
        [request startAsynchronous];
    }
    return baseData.provinceArray;
}

+ (NSArray *)getCitiesWithProvinceId:(NSInteger)provinceId{
    BaseData *baseData = [BaseData sharedData];
    if(baseData.citiesDictionary){
        return [baseData.citiesDictionary objectForKey:[NSNumber numberWithInt:provinceId]];
    }
    return nil;
}

+ (NSInteger) indexOfProvinces:(NSInteger)provinceId{
    int i = 0;
    for (Province *province in [BaseData getProvinces]) {
        if (province.provinceId == provinceId) {
            return i;
        }
        i++;
    }
    return -1;
}

+ (NSInteger) indexOfCities:(NSInteger)cityId withProvinceId:(NSInteger)provinceId{
    int i = 0;
    for (City *city in [BaseData getCitiesWithProvinceId:provinceId]) {
        if (city.cityId == cityId) {
            return i;
        }
        i++;
    }
    return -1;
}

@end
