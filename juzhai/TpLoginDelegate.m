//
//  TpLoginDelegate.m
//  juzhai
//
//  Created by JiaJun Wu on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TpLoginDelegate.h"
#import "Constant.h"
#import "TpLoginViewController.h"

@implementation TpLoginDelegate

- (id) init{
    self = [super init];
    if (self) {
        _titleArray = [[NSArray alloc] initWithObjects:@"用新浪微博帐号登录", @"用豆瓣帐号登录", @"用QQ帐号登录", nil];
        _logoImageArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"sina"], [UIImage imageNamed:@"db"], [UIImage imageNamed:@"qq"], nil];
        _tpIdArray = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:6], [NSNumber numberWithInt:7], [NSNumber numberWithInt:8], nil];
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *TpLoginCellIdentifier = @"TpLoginCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TpLoginCellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TpLoginCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 9, 25, 25)];
        imageView.tag = LOGO_VIEW_TAG;
        [cell addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 15, 200, 13)];
        titleLabel.tag = TITLE_VIEW_TAG;
        titleLabel.font = DEFAULT_FONT(13);
        titleLabel.textColor = [UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f];
        titleLabel.backgroundColor = [UIColor clearColor];
        [cell addSubview:titleLabel];
    }
    
    UIImageView *logoView = (UIImageView *)[cell viewWithTag:LOGO_VIEW_TAG];
    logoView.image = [_logoImageArray objectAtIndex:indexPath.row];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:TITLE_VIEW_TAG];
    titleLabel.text = [_titleArray objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TpLoginViewController *tpLoginViewController = [[TpLoginViewController alloc] initWithNibName:@"TpLoginViewController" bundle:nil];
    tpLoginViewController.webTitle = [_titleArray objectAtIndex:indexPath.row];
    tpLoginViewController.tpId = [[_tpIdArray objectAtIndex:indexPath.row] intValue];
    UIViewController *viewController = (UIViewController *)tableView.nextResponder.nextResponder;
    [viewController presentModalViewController:tpLoginViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
