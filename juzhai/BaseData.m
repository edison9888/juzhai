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

+ (NSArray *)loadArrayData:(NSString *)fileName withUrl:(NSString *)url;
+ (NSDictionary *)loadDictionaryData:(NSString *)fileName withUrl:(NSString *)url;
+ (NSString *)dataFilePath:(NSString *)fileName;
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

+ (NSArray *)loadArrayData:(NSString *)fileName withUrl:(NSString *)url
{
    NSString *path = [self dataFilePath:fileName];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    if (array == nil || array.count <= 0) {
        //http load
        ASIHTTPRequest *request = [HttpRequestSender backgroundGetRequestWithUrl:[UrlUtils urlStringWithUri:url] withParams:nil];
        if (request != nil) {
            [request startSynchronous];
            NSError *error = [request error];
            if (!error && [request responseStatusCode] == 200){
                NSString *responseString = [request responseString];
                NSMutableDictionary *jsonResult = [responseString JSONValue];
                if([[jsonResult valueForKey:@"success"] boolValue]){
                    array = [jsonResult objectForKey:@"result"];
                    //save to plist
                    [array writeToFile:path atomically:YES];
                }
            }
        }
    }
    return array;
}

+ (NSDictionary *)loadDictionaryData:(NSString *)fileName withUrl:(NSString *)url
{
    NSString *path = [self dataFilePath:fileName];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    if (dic == nil || dic.count <= 0) {
        //http load
        ASIHTTPRequest *request = [HttpRequestSender backgroundGetRequestWithUrl:[UrlUtils urlStringWithUri:url] withParams:nil];
        [request startSynchronous];
        NSError *error = [request error];
        if (!error && [request responseStatusCode] == 200){
            NSString *responseString = [request responseString];
            NSMutableDictionary *jsonResult = [responseString JSONValue];
            if([[jsonResult valueForKey:@"success"] boolValue]){
                dic = [jsonResult objectForKey:@"result"];
                //save to plist
                [dic writeToFile:path atomically:YES];
            }
        }
    }
    return dic;
}

+ (NSArray *)getCategories{
    BaseData *baseData = [BaseData sharedData];
    if(!baseData.categoryArray){
        NSArray *array = [BaseData loadArrayData:CATEGORY_FILE_NAME withUrl:@"base/categoryList"];
        baseData.categoryArray = [[NSMutableArray alloc] initWithCapacity:array.count];
        for(NSDictionary *dic in array){
            NSInteger categoryId = [[dic objectForKey:@"categoryId"] intValue];
            NSString *name = [dic objectForKey:@"name"];
            NSString *icon = [dic objectForKey:@"icon"];
            [baseData.categoryArray addObject:[[Category alloc] initWithCategoryId:categoryId withName:name withIcon:icon]];
        }
    }
    return baseData.categoryArray;
}

+ (NSArray *)getProfessions{
    BaseData *baseData = [BaseData sharedData];
    if(!baseData.professionArray){
        NSArray *array = [BaseData loadArrayData:PROFESSION_FILE_NAME withUrl:@"base/professionList"];
        baseData.professionArray = [[NSMutableArray alloc] initWithCapacity:array.count];
        for(NSDictionary *dic in array){
            NSDecimalNumber *pId = nil;
            for(NSDecimalNumber *key in [dic allKeys]){
                pId = key;
            }
            [baseData.professionArray addObject:[[Profession alloc] initWithProfessionId:pId withName:[dic objectForKey:pId]]];
        }
    }
    return baseData.professionArray;
}

+ (NSArray *)getProvinces{
    BaseData *baseData = [BaseData sharedData];
    if(!baseData.provinceArray){
        NSDictionary *dic = [BaseData loadDictionaryData:PROVINCE_FILE_NAME withUrl:@"base/provinceCityList"];
        
        NSArray *provinceDicArray = [dic objectForKey:@"provinceList"];
        NSArray *cityDicArray = [dic objectForKey:@"cityList"];
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

+ (NSString *)dataFilePath:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

@end
