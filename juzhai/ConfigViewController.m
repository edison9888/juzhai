//
//  ConfigViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-5-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ConfigViewController.h"
#import "LoginService.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "CustomNavigationController.h"
#import "ProfileSettingViewController.h"

@implementation ConfigViewController

@synthesize itemList;

-(void)loadView{
    [super loadView];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.itemList = [[NSMutableArray alloc] initWithObjects:@"个人资料设置", @"退出账号", nil];
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame style:UITableViewStyleGrouped];
}

-(void)doLogout{
    [[LoginService getInstance] logout];
    //跳转到登录
    self.view.window.rootViewController = [[LoginService getInstance] loginTurnToViewController];
    [self.view.window makeKeyAndVisible];
}

#pragma mark - Table View Data Source Methods

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 2;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.itemList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [itemList objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Table View Delegate Methods

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
        }
        case 1:{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定退出吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alertView show];
            break;
        }
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Alert View Delegate Methods

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.dimBackground = YES;
        hud.labelText = @"账号注销...";
        [hud showWhileExecuting:@selector(doLogout) onTarget:self withObject:nil animated:YES];
    }
}

@end
