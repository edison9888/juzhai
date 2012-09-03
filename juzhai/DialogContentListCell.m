//
//  DialogContentListCell.m
//  juzhai
//
//  Created by JiaJun Wu on 12-7-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DialogContentListCell.h"
#import "Constant.h"
#import <QuartzCore/QuartzCore.h>
#import "DialogContentView.h"
#import "UserContext.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UserView.h"
#import "DetailTextView.h"
#import "NSDate+BeforeShowType.h"
#import "TaHomeViewController.h"
#import "UIImage+UIImageExt.h"
#import "UIViewController+MJPopupViewController.h"
#import "DialogContentViewController.h"

@implementation DialogContentListCell

@synthesize targetUser;

@synthesize hisLogoView;
@synthesize myLogoView;
@synthesize bubbleView;
@synthesize contentBgView;
@synthesize imageView;
@synthesize dialogContentTextView;
@synthesize timeLabel;
@synthesize warning;

+ (id) cellFromNib
{
    DialogContentListCell *cell = nil;
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DialogContentListCell" owner:self options:nil];
    for(id oneObject in nib){
        if([oneObject isKindOfClass:[DialogContentListCell class]]){
            cell = (DialogContentListCell *) oneObject;
        }
    }
    [cell setBackground];
    return cell;
}

- (void)setBackground
{
//    UIImage *image = [UIImage imageNamed:CONTENT_BG_IMAGE_NAME];
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.frame.size.width, image.size.height + 30.0), NO, 0.0);
//    [image drawInRect:CGRectMake(0.0, 0 + 30.0, image.size.width, image.size.height)];
//    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    [image stretchableImageWithLeftCapWidth:HIS_BG_CAP_WIDTH topCapHeight:HIS_BG_CAP_HEIHGT];
//    
//    UIColor * color = [UIColor colorWithPatternImage:image];
//    dialogContentTextView.backgroundColor = color;
}

- (void)redrawn:(DialogContentView *)dialogContentView
{
    _dialogContentView = dialogContentView;
    _isMe = dialogContentView.senderUid == [UserContext getUid];
    
    [self redrawnLogo];
//    [self redrawnImg];
    [self redrawnDialogText];
    [self redrawnTime];
}

- (void)logoClick:(UIGestureRecognizer *)gestureRecognizer {
    TaHomeViewController *taHomeViewController = [[TaHomeViewController alloc] initWithNibName:@"TaHomeViewController" bundle:nil];
    taHomeViewController.hidesBottomBarWhenPushed = YES;
    taHomeViewController.userView = targetUser;
    UIViewController *viewController = (UIViewController *)self.nextResponder.nextResponder.nextResponder;
    [viewController.navigationController pushViewController:taHomeViewController animated:YES];
}

- (void)imageClick:(UIGestureRecognizer *)gestureRecognizer {
    [[self.superview.superview viewWithTag:GROWING_TEXT_VIEW_TAG] resignFirstResponder];
    _wholeImageViewController = [[WholeImageViewController alloc] init];
    _wholeImageViewController.image = imageView.image;
    _wholeImageViewController.imageUrl = _dialogContentView.imgUrl;
    _wholeImageViewController.delegate = self;
    UIViewController *viewController = (UIViewController *)self.nextResponder.nextResponder.nextResponder;
    [viewController presentPopupViewController:_wholeImageViewController animationType:MJPopupViewAnimationFade];
}

+ (CGFloat)heightForCell:(DialogContentView *)dialogContentView
{
    CGSize dialogContentSize = [dialogContentView.content sizeWithFont:DEFAULT_FONT(14) constrainedToSize:CGSizeMake(TEXT_MAX_WIDTH, TEXT_MAX_HEIGHT) lineBreakMode:UILineBreakModeWordWrap];
    return 10 + (dialogContentView.hasImg ? dialogContentSize.height + CONTENT_TEXT_VIEW_MARGIN + 50 : dialogContentSize.height) + CONTENT_TEXT_VIEW_MARGIN*2 + 10 + 12 + 10;
}

- (void)redrawnLogo
{
    UIImageView *logoView;
    NSString *logoUrl;
    //头像
    if (_isMe) {
        hisLogoView.hidden = YES;
        myLogoView.hidden = NO;
        logoView = myLogoView;
        logoUrl = [UserContext getUserView].bigLogo;
    }else {
        hisLogoView.hidden = NO;
        myLogoView.hidden = YES;
        logoView = hisLogoView;
        logoUrl = targetUser.bigLogo;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoClick:)];
        [hisLogoView addGestureRecognizer:singleTap];
    }
    
    logoView.image = [UIImage imageNamed:FACE_LOADING_IMG];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *imageURL = [NSURL URLWithString:logoUrl];
    [manager downloadWithURL:imageURL delegate:self options:0 success:^(UIImage *image) {
        UIImage *resultImage = [image imageByScalingAndCroppingForSize:CGSizeMake(logoView.frame.size.width*2, logoView.frame.size.height*2)];
        logoView.image = [resultImage createRoundedRectImage:8.0];
    } failure:nil];
}

- (void)redrawnImg
{
    
}

- (void)redrawnDialogText
{
    //设置内容
    dialogContentTextView.text = _dialogContentView.content;
    dialogContentTextView.font = DEFAULT_FONT(14);
    dialogContentTextView.textColor = [UIColor blackColor];
    
//    [dialogContentTextView setText:_dialogContentView.content WithFont:DEFAULT_FONT(14) AndColor:[UIColor blackColor]];
    CGSize dialogContentSize = [_dialogContentView.content sizeWithFont:DEFAULT_FONT(14) constrainedToSize:CGSizeMake(TEXT_MAX_WIDTH, TEXT_MAX_HEIGHT) lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat startX = _isMe ? CONTENT_TEXT_VIEW_MARGIN : (CONTENT_TEXT_VIEW_MARGIN + ARROW_WIDTH);
    if (_dialogContentView.hasImg) {
        imageView.hidden = NO;
        imageView.frame = CGRectMake(startX, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height);
        //load图片
        if (_dialogContentView.image != nil) {
            [self dealImage:_dialogContentView.image];
        } else {
            imageView.image = [UIImage imageNamed:FACE_LOADING_IMG];
            if (_dialogContentView.imgUrl != nil && ![_dialogContentView.imgUrl isEqual:[NSNull null]] && ![_dialogContentView.imgUrl isEqualToString:@""]) {
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                NSURL *imageURL = [NSURL URLWithString:_dialogContentView.imgUrl];
                [manager downloadWithURL:imageURL delegate:self options:0 success:^(UIImage *image) {
                    _dialogContentView.image = image;
                    [self dealImage:image];
                } failure:nil];
            }
        }
    } else {
        imageView.hidden = YES;
    }
    
    [dialogContentTextView setFrame:CGRectMake(startX, !imageView.hidden ? CONTENT_TEXT_VIEW_MARGIN*2 + imageView.frame.size.height : CONTENT_TEXT_VIEW_MARGIN, dialogContentSize.width, dialogContentSize.height)];
    
    CGFloat contentViewWidth = (!imageView.hidden ? fmaxf(dialogContentSize.width, imageView.frame.size.width) : dialogContentSize.width) + CONTENT_TEXT_VIEW_MARGIN*2 + ARROW_WIDTH;
    CGFloat contentViewHeight = dialogContentSize.height + CONTENT_TEXT_VIEW_MARGIN*2 + (!imageView.hidden ? imageView.frame.size.height + CONTENT_TEXT_VIEW_MARGIN : 0);
    
    CGFloat contentViewX;
    if (_isMe) {
        contentViewX = 260 - contentViewWidth;
    } else {
        contentViewX = 60;
    }
    bubbleView.frame = CGRectMake(contentViewX, bubbleView.frame.origin.y, contentViewWidth, contentViewHeight);
    
    if (_isMe) {
        contentBgView.image = [[UIImage imageNamed:MY_BG_IMAGE_NAME] stretchableImageWithLeftCapWidth:MY_BG_CAP_WIDTH topCapHeight:MY_BG_CAP_HEIHGT];
    } else {
        contentBgView.image = [[UIImage imageNamed:HIS_BG_IMAGE_NAME] stretchableImageWithLeftCapWidth:HIS_BG_CAP_WIDTH topCapHeight:HIS_BG_CAP_HEIHGT];
    }
    contentBgView.frame = CGRectMake(0, 0, bubbleView.frame.size.width, bubbleView.frame.size.height);
    
    warning.frame = CGRectMake(contentViewX - 10 - warning.frame.size.width, warning.frame.origin.y, warning.frame.size.width, warning.frame.size.height);
    if (_dialogContentView.sendStatus == SendStatusWaiting) {
        warning.image = [UIImage imageNamed:@"waiting_icon"];
        warning.hidden = NO;
    } else if (_dialogContentView.sendStatus == SendStatusFailure) {
        warning.image = [UIImage imageNamed:@"failure_icon"];
        warning.hidden = NO;
    } else if (_dialogContentView.sendStatus == SendStatusSending) {
        warning.image = [UIImage imageNamed:@"sending_icon"];
        warning.hidden = NO;
    } else {
        warning.hidden = YES;
    }
}

- (void)redrawnTime
{
    CGRect containerFram = timeLabel.frame;
    containerFram.origin.y = bubbleView.frame.origin.y + bubbleView.frame.size.height + 10;
    timeLabel.frame = containerFram;
    timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:_dialogContentView.createTime] showBefore];
}

- (void)dealImage:(UIImage *)image
{
    UIImage *resultImage = [image imageByScalingAndCroppingForSize:CGSizeMake(imageView.frame.size.width*2, imageView.frame.size.height*2)];
    imageView.image = [resultImage createRoundedRectImage:8.0];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
    [imageView addGestureRecognizer:singleTap];
}

#pragma mark -
#pragma mark Whole Image View Delegate

- (void)cancelButtonClicked:(WholeImageViewController *)wholeImageViewController
{
    UIViewController *viewController = (UIViewController *)self.nextResponder.nextResponder.nextResponder;
    [viewController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    wholeImageViewController = nil;
}

@end
