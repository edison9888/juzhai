//
//  IdeaListCell.m
//  juzhai
//
//  Created by JiaJun Wu on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "IdeaListCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "IdeaView.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "HttpRequestSender.h"
#import "SBJson.h"
#import "MessageShow.h"
#import "UrlUtils.h"
#import "UIImage+UIImageExt.h"
#import "MobClick.h"

@implementation IdeaListCell

@synthesize imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
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
    IdeaListCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"IdeaListCell" owner:self options:nil] lastObject];
    [cell setBackground];
    return cell;
}

-(void) setBackground{
    UIView *selectBgColorView = [[UIView alloc] init];
    selectBgColorView.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView = selectBgColorView;
}

- (void)drawRect:(CGRect)rect
{
    
}

- (void) redrawn:(IdeaView *)ideaView{
    _ideaView = ideaView;
//    imageView.layer.masksToBounds = YES;
//    imageView.layer.cornerRadius = 5.0;
    imageView.image = [UIImage imageNamed:SMALL_PIC_LOADING_IMG];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    if(![ideaView.bigPic isEqual:[NSNull null]]){
        NSURL *imageURL = [NSURL URLWithString:ideaView.bigPic];
        [manager downloadWithURL:imageURL delegate:self options:0 success:^(UIImage *image) {
            UIImage *resultImage = [image imageByScalingAndCroppingForSize:CGSizeMake(imageView.frame.size.width*2, imageView.frame.size.height*2)];
            imageView.image = [resultImage createRoundedRectImage:8.0];
        } failure:nil];
    }
    
    UILabel *contentLabel = (UILabel *)[self viewWithTag:IDEA_CONTENT_TAG];
    contentLabel.font = DEFAULT_FONT(14);
    contentLabel.textColor = [UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f];
    contentLabel.highlightedTextColor = [UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f];
    CGSize labelsize = [ideaView.content sizeWithFont:contentLabel.font constrainedToSize:CGSizeMake(190, 37) lineBreakMode:UILineBreakModeCharacterWrap];
    [contentLabel setFrame:CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y, labelsize.width, labelsize.height)];
    contentLabel.text = ideaView.content;
    
    UIButton *wantToButton = (UIButton *)[self viewWithTag:IDEA_WANT_TO_TAG];
    NSString *buttonTitle = [NSString stringWithFormat:@"想去 %d", ideaView.useCount];
    CGSize wgoButtonTitleSize = [buttonTitle sizeWithFont:DEFAULT_FONT(11) constrainedToSize:CGSizeMake(100.0f, 25.0f)lineBreakMode:UILineBreakModeHeadTruncation];
    [wantToButton setTitle:buttonTitle forState:UIControlStateNormal];
    [wantToButton setTitleColor:[UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f] forState:UIControlStateNormal];
    [wantToButton setTitleColor:[UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f] forState:UIControlStateDisabled];
    [wantToButton setTitleColor:[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.00f] forState:UIControlStateHighlighted];
    
    wantToButton.titleLabel.font = DEFAULT_FONT(11);
    
    wantToButton.enabled = !ideaView.hasUsed;
    UIImage *normalImg = [[UIImage imageNamed:NORMAL_WANT_BUTTON_IMAGE] stretchableImageWithLeftCapWidth:WANT_BUTTON_CAP_WIDTH topCapHeight:0.0];
    UIImage *highlightedImg = [[UIImage imageNamed:HIGHLIGHT_WANT_BUTTON_IMAGE] stretchableImageWithLeftCapWidth:WANT_BUTTON_CAP_WIDTH topCapHeight:0.0];
    UIImage *disabledImg = [[UIImage imageNamed:DISABLE_WANT_BUTTON_IMAGE] stretchableImageWithLeftCapWidth:WANT_BUTTON_CAP_WIDTH topCapHeight:0.0];
    [wantToButton setBackgroundImage:normalImg forState:UIControlStateNormal];
    [wantToButton setBackgroundImage:highlightedImg forState:UIControlStateHighlighted];
    [wantToButton setBackgroundImage:disabledImg forState:UIControlStateDisabled];
    
    wantToButton.frame = CGRectMake(320.0 - 10.0 - (normalImg.size.width + wgoButtonTitleSize.width), wantToButton.frame.origin.y, normalImg.size.width + wgoButtonTitleSize.width, wantToButton.frame.size.height);
    [wantToButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 20.0, 0.0, 0.0)];
}

+(CGFloat) heightForCell:(IdeaView *)IdeaView{
    return 90.0f;
}

-(IBAction)wantGo:(id)sender{
    UIView *coverView = self.superview.superview.superview.superview;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:coverView animated:YES];
    hud.labelText = @"操作中...";
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:_ideaView.ideaId], @"ideaId", nil];
    __unsafe_unretained __block ASIFormDataRequest *request = [HttpRequestSender postRequestWithUrl:[UrlUtils urlStringWithUri:@"post/sendPost"] withParams:params];
    if (request) {
        [request setCompletionBlock:^{
            NSString *responseString = [request responseString];
            NSMutableDictionary *jsonResult = [responseString JSONValue];
            if([jsonResult valueForKey:@"success"] == [NSNumber numberWithBool:YES]){
                [MobClick event:SEND_IDEA];
                _ideaView.hasUsed = YES;
                _ideaView.useCount = _ideaView.useCount + 1;
                UIButton *wantToButton = (UIButton *)[self viewWithTag:IDEA_WANT_TO_TAG];
                wantToButton.enabled = NO;
                [wantToButton setTitle:[NSString stringWithFormat:@"想去 %d", _ideaView.useCount] forState:UIControlStateNormal];
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"保存成功";
                [hud hide:YES afterDelay:1];
                return;
            }
            NSString *errorInfo = [jsonResult valueForKey:@"errorInfo"];
            NSLog(@"%@", errorInfo);
            if (errorInfo == nil || [errorInfo isEqual:[NSNull null]] || [errorInfo isEqualToString:@""]) {
                errorInfo = SERVER_ERROR_INFO;
            }
            [MBProgressHUD hideHUDForView:coverView animated:YES];
            [MessageShow error:errorInfo onView:coverView];
        }];
        [request setFailedBlock:^{
            [MBProgressHUD hideHUDForView:coverView animated:YES];
            [HttpRequestDelegate requestFailedHandle:request];
        }];
        [request startAsynchronous];
    } else {
        [MBProgressHUD hideHUDForView:coverView animated:YES];
    }
}

@end
