//
//  ProfileSettingViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ProfileSettingViewController.h"
#import "UrlUtils.h"

@interface ProfileSettingViewController ()

@end

@implementation ProfileSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设置个人资料";
    
    _cellIdentifierDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:LOGO_CELL_IDENTIFIER, [NSNumber numberWithInt:0], NICKNAME_CELL_IDENTIFIER, [NSNumber numberWithInt:10], GENDER_CELL_IDENTIFIER, [NSNumber numberWithInt:11], BIRTH_CELL_IDENTIFIER, [NSNumber numberWithInt:12], FEATURE_CELL_IDENTIFIER, [NSNumber numberWithInt:20], LOCATION_CELL_IDENTIFIER, [NSNumber numberWithInt:21], PROFESSION_CELL_IDENTIFIER, [NSNumber numberWithInt:22], nil];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *)postUrl{
    return [UrlUtils urlStringWithUri:@"profile/save"];
}

#pragma mark -
#pragma mark Table View Data Source

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 3;
            break;
    }
    return 0;
}

@end
