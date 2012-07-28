//
//  TpLoginDelegate.h
//  juzhai
//
//  Created by JiaJun Wu on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LOGO_VIEW_TAG 1
#define TITLE_VIEW_TAG 2

@interface TpLoginDelegate : NSObject <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_titleArray;
    NSArray *_logoImageArray;
    NSArray *_tpIdArray;
}
@end
