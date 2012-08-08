//
//  PostListCell.m
//  juzhai
//
//  Created by JiaJun Wu on 12-6-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PostListCell.h"
#import "PostView.h"
#import "Constant.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+UIImageExt.h"

@implementation PostListCell

@synthesize contentLabel;
@synthesize imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (id)cellFromNib
{
    PostListCell *cell = nil;
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PostListCell" owner:self options:nil];
    for(id oneObject in nib){
        if([oneObject isKindOfClass:[PostListCell class]]){
            cell = (PostListCell *) oneObject;
        }
    }
    [cell setBackground];
    return cell;
}

-(void) setBackground{
    self.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    UIView *selectBgColorView = [[UIView alloc] init];
    selectBgColorView.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView = selectBgColorView;
}

- (void) redrawn:(PostView *)postView{
    _postView = postView; 

    contentLabel.text = [NSString stringWithFormat:@"%@：%@", postView.purpose, postView.content];
    contentLabel.font = DEFAULT_FONT(14);
    contentLabel.textColor = [UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f];
    contentLabel.highlightedTextColor = [UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f];
    CGSize labelsize = [contentLabel.text sizeWithFont:contentLabel.font constrainedToSize:CGSizeMake(contentLabel.frame.size.width, 300.0) lineBreakMode:UILineBreakModeCharacterWrap];
    [contentLabel setFrame:CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y, labelsize.width, labelsize.height)];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    if(![postView.bigPic isEqual:[NSNull null]]){
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 5.0;
        imageView.image = [UIImage imageNamed:SMALL_PIC_LOADING_IMG];
        NSURL *postImageURL = [NSURL URLWithString:postView.bigPic];
        [imageView setFrame:CGRectMake(imageView.frame.origin.x, contentLabel.frame.origin.y + labelsize.height + 10.0, imageView.frame.size.width, imageView.frame.size.height)];
        [manager downloadWithURL:postImageURL delegate:self options:0 success:^(UIImage *image) {
            imageView.image = [image imageByScalingAndCroppingForSize:CGSizeMake(imageView.frame.size.width*2, imageView.frame.size.height*2)];
        } failure:nil];
        [imageView setHidden:NO];
    }else {
        [imageView setHidden:YES];
    }
}

+(CGFloat) heightForCell:(PostView *)postView{
    float height = 10.0;
    NSString *content = [NSString stringWithFormat:@"%@：%@", postView.purpose, postView.content];
    CGSize contentSize = [content sizeWithFont:DEFAULT_FONT(14) constrainedToSize:CGSizeMake(300, 300.0) lineBreakMode:UILineBreakModeCharacterWrap];
    height += contentSize.height + 10.0;
    if(![postView.bigPic isEqual:[NSNull null]]){
        height += 80.0;
    }
    return height;
}

@end
