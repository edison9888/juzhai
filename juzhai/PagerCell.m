//
//  PagerCell.m
//  juzhai
//
//  Created by JiaJun Wu on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PagerCell.h"
#import "Constant.h"

@implementation PagerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 13, 100, 14)];
        UIView *selectBgColorView = [[UIView alloc] init];
        selectBgColorView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
        self.selectedBackgroundView = selectBgColorView;
        _titleLabel.font = DEFAULT_FONT(14);
        _titleLabel.textColor = [UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
        
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_loadingView setCenter:CGPointMake(280, 20)];
        _loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView];
        
        [self reset];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    if (selected) {
        _titleLabel.text = @"加载更多";
        [_loadingView startAnimating];
    }
}

- (void)reset{
    _titleLabel.text = @"查看更多";
    [_loadingView stopAnimating];
}

+ (PagerCell *)dequeueReusablePagerCell:(UITableView *)tableView {
    static NSString *PagerCellIdentifier = @"PagerCellIdentifier";
    PagerCell *cell = [tableView dequeueReusableCellWithIdentifier:PagerCellIdentifier];
    if(cell == nil){
        cell = [[PagerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PagerCellIdentifier];
    } else {
        [cell reset];
    }
    return cell;
}

@end
