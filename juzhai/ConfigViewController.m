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
#import "Constant.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "MobClick.h"
#import "ProfileSettingViewController.h"
#import "UserContext.h"

@implementation ConfigViewController

@synthesize sections;

-(void)loadView{
    [super loadView];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
    self.sections = [NSDictionary dictionaryWithContentsOfFile:path];
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BG_IMG]];
}

- (void)doLogout
{
    [[LoginService getInstance] logout];
    //跳转到登录
    self.view.window.rootViewController = [[LoginService getInstance] loginTurnToViewController];
    [self.view.window makeKeyAndVisible];
}

- (void)clearCache
{
    SDImageCache *sdImageCache = [SDImageCache sharedImageCache];
    [sdImageCache clearDisk];
    [sdImageCache cleanDisk];
}

- (void)upgrade
{
    [MobClick checkUpdate];
}

#pragma mark - Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.sections objectForKey:[NSString stringWithFormat:@"%d", section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSArray *items = [self.sections objectForKey:[NSString stringWithFormat:@"%d", indexPath.section]];
    cell.textLabel.text = NSLocalizedString(KeyCellTitle([items objectAtIndex:indexPath.row]), @"cell title");
    return cell;
}

#pragma mark - Table View Delegate Methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(KeySectionTitle(section), @"section title");
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == LOGOUT_SECTION) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定退出吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertView.tag = LOGOUT_ALERT_TAG;
        [alertView show];
    } else if (indexPath.section == CACHE_SECTION) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要清除图片缓存吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertView.tag = CLEAR_CACHE_ALERT_TAG;
        [alertView show];
    } else if (indexPath.section == ABOUT_SECTION) {
        if (indexPath.row == UPGRADE_ROW) {
            [MobClick checkUpdate];
        }
    } else if (indexPath.section == ACCOUNT_SECTION) {
        if (indexPath.row == PROFILE_ROW) {
            if (nil == _profileSettingViewController) {
                _profileSettingViewController = [[ProfileSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
                _profileSettingViewController.hidesBottomBarWhenPushed = YES;
            }
            [_profileSettingViewController initUserView:[UserContext getUserView]];
            [self.navigationController pushViewController:_profileSettingViewController animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Alert View Delegate Methods

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex != [alertView cancelButtonIndex]){
        if (alertView.tag == LOGOUT_ALERT_TAG) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.dimBackground = YES;
            hud.labelText = @"账号注销...";
            [hud showWhileExecuting:@selector(doLogout) onTarget:self withObject:nil animated:YES];
        } else if (alertView.tag = CLEAR_CACHE_ALERT_TAG) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.dimBackground = YES;
            hud.labelText = @"清除图片缓存...";
            [hud showWhileExecuting:@selector(clearCache) onTarget:self withObject:nil animated:YES];
        }
    }
}

@end
