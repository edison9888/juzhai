//
//  PostService.h
//  juzhai
//
//  Created by JiaJun Wu on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PostBasicBlock)(void);

@interface PostService : NSObject

- (void) sendPost:(NSString *)content withDate:(NSString *)date withPlace:(NSString *)place withImage:(UIImage *)image withCategory:(NSInteger)catId onView:(UIView *)view withSuccessCallback:(PostBasicBlock)aSuccessBlock;

@end
