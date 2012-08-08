//
//  CustomIdeaListCell.m
//  juzhai
//
//  Created by JiaJun Wu on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomIdeaListCell.h"
#import "Constant.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "IdeaView.h"
#import "UIImage+UIImageExt.h"

@implementation CustomIdeaListCell

@synthesize ideaView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reset
{
    _ideaPic = nil;
    self.ideaView = nil;
}

- (void)addAllSubView
{
    
}

#define IMAGE_WIDTH 100
#define IMAGE_HEIGHT 70
#define TOP_OFFSET 10
#define LEFT_OFFSET 10
- (void)drawRect:(CGRect)rect
{
    CGRect picRect = CGRectMake(LEFT_OFFSET, TOP_OFFSET, IMAGE_WIDTH, IMAGE_HEIGHT);
    if (_ideaPic == nil) {
        _ideaPic = [UIImage imageNamed:SMALL_PIC_LOADING_IMG];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        if(![self.ideaView.bigPic isEqual:[NSNull null]]){
            NSURL *imageURL = [NSURL URLWithString:ideaView.bigPic];
            [manager downloadWithURL:imageURL delegate:self options:0 success:^(UIImage *image) {
                _ideaPic = [image imageByScalingAndCroppingForSize:CGSizeMake(IMAGE_WIDTH * 2, IMAGE_HEIGHT * 2)];
                _ideaPic = [_ideaPic createRoundedRectImage:5.0];
                [self setNeedsDisplayInRect:picRect];
//                [self setNeedsDisplay];
            } failure:nil];
        }
    }
//    [[UIColor clearColor] set];
//    UIRectFill(picRect);
//    [[UIBezierPath bezierPathWithRoundedRect:picRect cornerRadius:5.0] addClip];
    [_ideaPic drawInRect:picRect];
}

@end
