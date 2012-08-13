//
//  CategoryTableViewController.m
//  juzhai
//
//  Created by JiaJun Wu on 12-5-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "BaseData.h"
#import "Category.h"
#import "Constant.h"

@interface CategoryTableViewController ()

@end

@implementation CategoryTableViewController

@synthesize rootController = _rootController;
@synthesize selectCategoryId;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.scrollEnabled = YES;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.12f green:0.31f blue:0.53f alpha:1.00f];
    self.tableView.separatorColor = [UIColor colorWithRed:0.15f green:0.39f blue:0.66f alpha:1.00f];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.rootController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [BaseData getCategories].count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = DEFAULT_FONT(14);
        cell.textLabel.backgroundColor = [UIColor clearColor];
        
        UIView *selectBgColorView = [[UIView alloc] init];
        selectBgColorView.backgroundColor = [UIColor colorWithRed:0.15f green:0.39f blue:0.66f alpha:1.00f];
        cell.selectedBackgroundView = selectBgColorView;
    }
    UIImageView *iconView;
    if(indexPath.row == 0){
        cell.textLabel.text = @"全部分类";
        cell.textLabel.tag = 0;
        NSString *iconImageName = (cell.textLabel.tag == selectCategoryId) ? @"ca_all_hover" : @"ca_all_link";
        iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconImageName]];
    }else {
        Category *category = [[BaseData getCategories] objectAtIndex:indexPath.row - 1];
        cell.textLabel.text = category.name;
        cell.textLabel.tag = category.categoryId;
        if (category.icon != nil && ![category.icon isEqual:[NSNull null]] && ![category.icon isEqualToString:@""]) {
            NSString *iconImageName = (cell.textLabel.tag == selectCategoryId) ? [NSString stringWithFormat:@"%@_hover", category.icon] : [NSString stringWithFormat:@"%@_link", category.icon];
            iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconImageName]];
        }
    }
    cell.accessoryView = iconView;
    if (cell.textLabel.tag == selectCategoryId) {
        cell.backgroundView = cell.selectedBackgroundView;
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_rootController performSelector:@selector(selectByCategory:) withObject:[tableView cellForRowAtIndexPath:indexPath]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

@end
