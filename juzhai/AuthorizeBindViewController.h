//
//  AuthorizeBindViewController.h
//  juzhai
//
//  Created by JiaJun Wu on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TpLoginDelegate;

@interface AuthorizeBindViewController : UIViewController
{
    TpLoginDelegate *_tpLoginDelegate;
}
@property (strong,nonatomic) IBOutlet UITableView *tpLoginTableView;

@end
