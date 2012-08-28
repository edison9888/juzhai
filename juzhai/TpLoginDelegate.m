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

@synthesize isBind;

- (id) init{
    self = [super init];
    if (self) {
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
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 25, 25)];
        imageView.tag = LOGO_VIEW_TAG;
        [cell addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 12, 200, 13)];
        titleLabel.tag = TITLE_VIEW_TAG;
        titleLabel.font = DEFAULT_FONT(14);
        titleLabel.textColor = [UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f];
        titleLabel.backgroundColor = [UIColor clearColor];
        [cell addSubview:titleLabel];
    }
    
    UIImageView *logoView = (UIImageView *)[cell viewWithTag:LOGO_VIEW_TAG];
    logoView.image = [_logoImageArray objectAtIndex:indexPath.row];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:TITLE_VIEW_TAG];
    NSString *titleKey = [NSString stringWithFormat:@"tpLogin.%d.title", [[_tpIdArray objectAtIndex:indexPath.row] intValue]];
    titleLabel.text = NSLocalizedString(titleKey, @"tpLoginTitle");
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TpLoginViewController *tpLoginViewController = [[TpLoginViewController alloc] initWithNibName:@"TpLoginViewController" bundle:nil];
    tpLoginViewController.tpId = [[_tpIdArray objectAtIndex:indexPath.row] intValue];
    tpLoginViewController.authorizeType = self.isBind ? AuthorizeBind : AuthorizeLogin;
    UIViewController *viewController = (UIViewController *)tableView.nextResponder.nextResponder;
    [viewController presentModalViewController:tpLoginViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

@end
