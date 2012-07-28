//
//  HttpRequestSender.h
//  juzhai
//
//  Created by JiaJun Wu on 12-5-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface HttpRequestSender : NSObject

+(ASIFormDataRequest *) postRequestWithUrl:(NSString *)url withParams:(NSDictionary *)params;
+(ASIHTTPRequest *) getRequestWithUrl:(NSString *)url withParams:(NSDictionary *)params;

@end

@interface HttpRequestDelegate : NSObject <ASIHTTPRequestDelegate>

+ (void) requestFailedHandle:(ASIHTTPRequest *)request;

@end

