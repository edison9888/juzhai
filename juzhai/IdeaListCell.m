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

@implementation IdeaListCell

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
    IdeaListCell *cell = nil;
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IdeaListCell" owner:self options:nil];
    for(id oneObject in nib){
        if([oneObject isKindOfClass:[IdeaListCell class]]){
            cell = (IdeaListCell *) oneObject;
        }
    }
    [cell setBackground];
    return cell;
}

-(void) setBackground{
    UIView *selectBgColorView = [[UIView alloc] init];
    selectBgColorView.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView = selectBgColorView;
}

- (void) redrawn:(IdeaView *)ideaView{
    _ideaView = ideaView;
    UIImageView *imageView = (UIImageView *)[self viewWithTag:IDEA_IMAGE_TAG];
    imageView.image = [UIImage imageNamed:SMALL_PIC_LOADING_IMG];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    if(![ideaView.pic isEqual:[NSNull null]]){
        NSURL *imageURL = [NSURL URLWithString:ideaView.pic];
        [manager downloadWithURL:imageURL delegate:self options:0 success:^(UIImage *image) {
            CGFloat imageHeight = image.size.height*(imageView.frame.size.width/image.size.width);
            if (imageHeight > imageView.frame.size.height) {
                UIGraphicsBeginImageContext(CGSizeMake(imageView.frame.size.width, imageView.frame.size.height));
                [image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageHeight)];
                UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                imageView.image = resultImage;
            } else {
                imageView.image = image;
            }
            
            imageView.layer.shouldRasterize = YES;
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 5.0;
        } failure:nil];
    }
    
    UILabel *contentLabel = (UILabel *)[self viewWithTag:IDEA_CONTENT_TAG];
    contentLabel.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:14.0];
    contentLabel.textColor = [UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f];
    contentLabel.highlightedTextColor = [UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f];
    CGSize labelsize = [ideaView.content sizeWithFont:contentLabel.font constrainedToSize:CGSizeMake(190, 37) lineBreakMode:UILineBreakModeCharacterWrap];
    [contentLabel setFrame:CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y, labelsize.width, labelsize.height)];
    contentLabel.text = ideaView.content;
    
    UIButton *wantToButton = (UIButton *)[self viewWithTag:IDEA_WANT_TO_TAG];
    NSString *buttonTitle = [NSString stringWithFormat:@"%d", ideaView.useCount];
    CGSize wgoButtonTitleSize = [buttonTitle sizeWithFont:[UIFont fontWithName:DEFAULT_FONT_FAMILY size:11.0] constrainedToSize:CGSizeMake(100.0f, 25.0f)lineBreakMode:UILineBreakModeHeadTruncation];
    [wantToButton setTitle:buttonTitle forState:UIControlStateNormal];
    [wantToButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    wantToButton.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_FAMILY size:11.0];
    
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
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:_ideaView.ideaId], @"ideaId", nil];
        __unsafe_unretained __block ASIFormDataRequest *request = [HttpRequestSender postRequestWithUrl:[UrlUtils urlStringWithUri:@"post/sendPost"] withParams:params];
        if (request) {
            [request setCompletionBlock:^{
                NSString *responseString = [request responseString];
                NSMutableDictionary *jsonResult = [responseString JSONValue];
                if([jsonResult valueForKey:@"success"] == [NSNumber numberWithBool:YES]){
                    _ideaView.hasUsed = YES;
                    _ideaView.useCount = _ideaView.useCount + 1;
                    UIButton *wantToButton = (UIButton *)[self viewWithTag:IDEA_WANT_TO_TAG];
                    wantToButton.enabled = NO;
                    [wantToButton setTitle:[NSString stringWithFormat:@"%d", wantToButton.titleLabel.text.intValue + 1] forState:UIControlStateNormal];
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
//    });
}

@end
