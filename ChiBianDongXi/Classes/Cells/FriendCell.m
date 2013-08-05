//
//  FriendCell.m
//  ChiBianDongXi
//
//  Created by lanou on 13-7-11.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import "FriendCell.h"
#import "AsynImageView.h"
#import "POIShareInfo.h"
#import "POIInfo.h"
#import "UserInfo.h"
#import "CommentInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "NetConnectionMacro.h"
#import "NetworkConnection.h"
#import "FriendViewController.h"

#define kClearance 10
#define kUserImageX 10
#define kUserImageY 10
#define kImageWidth 100
#define kImageHeight 100
#define kFontOfSize 13.0

@implementation FriendCell
- (void)dealloc
{
    [_screenNameLabel release];
    [_weiboTimeLabel release];
    [_shareContentLabel release];
    [_shareImage release];
    [_userImage release];
    [_poiNameLabel release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
//        self.oneView = [[UIView alloc] init];
        
//      User Avator ==================
        self.userImage = [[AsynImageView alloc] initWithFrame:CGRectMake(kUserImageX, kUserImageY, 30, 30)];
        _userImage.backgroundColor = [UIColor clearColor];
        [self addSubview:self.userImage];
        [_userImage release];
        
//      User Name   ==================
        self.screenNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kClearance, 145, 30)];
        _screenNameLabel.backgroundColor = [UIColor clearColor];
        _screenNameLabel.font = [UIFont systemFontOfSize:kFontOfSize];
        [self addSubview:_screenNameLabel];
        [_screenNameLabel release];
        
//      Comment Image ================
        self.shareImage = [[AsynImageView alloc] init];
                  self.shareImage.frame =  CGRectMake(150,50,kImageWidth,kImageHeight);
        _shareImage.backgroundColor = [UIColor clearColor];
        [self addSubview:self.shareImage];
        [self.shareImage release];
        
//      Comment Content
        self.shareContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 50, 130, 70)];
        _shareContentLabel.backgroundColor = [UIColor clearColor];
        _shareContentLabel.font = [UIFont systemFontOfSize:kFontOfSize];
        _shareContentLabel.numberOfLines = 0;
        _shareContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:_shareContentLabel];
        [_shareContentLabel release];
        
        self.weiboTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 160, 130, 30)];
        _weiboTimeLabel.backgroundColor = [UIColor clearColor];
        _weiboTimeLabel.font = [UIFont systemFontOfSize:kFontOfSize];
        [self addSubview:_weiboTimeLabel];
        [_weiboTimeLabel release];
        
        self.poiNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 160, 110, 30)];
        _poiNameLabel.backgroundColor = [UIColor clearColor];
        _poiNameLabel.font = [UIFont systemFontOfSize:kFontOfSize];
        _poiNameLabel.numberOfLines = 0;
        _poiNameLabel.lineBreakMode =NSLineBreakByCharWrapping;
        [self addSubview:_poiNameLabel];
        [_poiNameLabel release];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (UIView * aView in self.subviews)
    {
        [aView removeFromSuperview];
    }
    
    POIShareInfo * poiShareInfo = [[POIShareInfo alloc] init];
    poiShareInfo = self.commentInfo.poiShareInfo;
    
    POIInfo * poiInfo = [[POIInfo alloc] init];
    poiInfo = self.commentInfo.poiInfo;
    
    _screenNameLabel.text = poiShareInfo.screenName;
//    NSLog(@"poiShareInfo.screenName  %@",poiShareInfo.screenName);
    
    _shareContentLabel.text = poiShareInfo.shareContent;
    
    _userImage.urlString = poiShareInfo.userImageUrl;
    
    _shareImage.urlString = poiShareInfo.sharePicUrl;
    
    _poiNameLabel.text = [NSString stringWithFormat:@"%@ >>",poiInfo.poiName];

    NSString * timeStr = poiShareInfo.weiboTime;
    NSString * month = [timeStr substringWithRange:NSMakeRange(4, 2)];
    NSString * day = [timeStr substringWithRange:NSMakeRange(6, 2)];
    NSString * date = [NSString stringWithFormat:@"%@月%@日",month,day];
    _weiboTimeLabel.text = date;
    
    CGSize textSize = [_shareContentLabel.text sizeWithFont:[UIFont systemFontOfSize:kFontOfSize] constrainedToSize:CGSizeMake(230, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat maxf = MAX(textSize.height, kImageHeight);
    
    //判断cell有没有图片，如果没有执行if，否则执行else
    if ([_shareImage.urlString isEqualToString:@""])
    {
        _shareContentLabel.frame = CGRectMake(10, 10 * 2 + 30, 230, textSize.height);
        
        _weiboTimeLabel.frame = CGRectMake(10, textSize.height + 10 * 3 + 20, 130, 20);
        
        _poiNameLabel.frame = CGRectMake(320 - 130 - 10 * 5, textSize.height + 10 * 3 + 20, 110, 20);
        _poiNameLabel.textAlignment = NSTextAlignmentRight;
        
        self.oneView = [[UIView alloc] init];
        _oneView.frame = CGRectMake(50, 10, 145 + 100 + 15, textSize.height + 20 + 20 + kClearance * 5 + [self.commentInfo.userInfoArray count] * 15);
        _oneView.backgroundColor = [UIColor whiteColor];
        _oneView.layer.shadowOffset = CGSizeMake(6, 5);
        _oneView.layer.shadowColor = [UIColor blackColor].CGColor;
        _oneView.layer.shadowOpacity = 1.0;
        [self addSubview:_oneView];
        [_oneView release];
        
        for (int i = 0 ; i < [self.commentInfo.userInfoArray count]; i++)
        {
            UserInfo * userInfo = [self.commentInfo.userInfoArray objectAtIndex:i];
            NSString * str = [NSString stringWithFormat:@"%@: %@",userInfo.userName,userInfo.userComment];
            
            UILabel * commentInfoLabel = [[UILabel alloc] init];
            commentInfoLabel.text = str;
            CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:kFontOfSize] constrainedToSize:CGSizeMake(235, 1000) lineBreakMode:NSLineBreakByCharWrapping];
            
            commentInfoLabel.frame=CGRectMake(10, i * 15 + size.height + 10 * 5 + 20 + 30, 235,15);
            commentInfoLabel.font = [UIFont systemFontOfSize:kFontOfSize];
            commentInfoLabel.numberOfLines = 0;
            commentInfoLabel.lineBreakMode = NSLineBreakByCharWrapping;
            
            if (_flag == TRUE)
            {
                commentInfoLabel.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1];
                _flag = FALSE;
            }
            else
            {
                commentInfoLabel.backgroundColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
                _flag = TRUE;
            }
            
            [_oneView addSubview:commentInfoLabel];
            [commentInfoLabel release];
        }
    }
    else
    {
        _shareContentLabel.frame = CGRectMake(10, 50, 130, textSize.height);
        
        _weiboTimeLabel.frame = CGRectMake(10, _shareContentLabel.frame.origin.y + maxf + 10, 130, 20);
        
        _poiNameLabel.frame = CGRectMake(320 - 130 - 10 * 5, _shareContentLabel.frame.origin.y + maxf + 10, 110, 20);
        _poiNameLabel.textAlignment = NSTextAlignmentRight;
        
        if (textSize.height > 100)
        {
            self.oneView = [[UIView alloc] init];
            _oneView.frame = CGRectMake(50, 10, 145 + 100 + 15, textSize.height + 20 + 20 + kClearance * 5 + [self.commentInfo.userInfoArray count] * 15);
            _oneView.backgroundColor = [UIColor whiteColor];
            _oneView.layer.shadowOffset = CGSizeMake(6, 5);
            _oneView.layer.shadowColor = [UIColor blackColor].CGColor;
            _oneView.layer.shadowOpacity = 1.0;
            [self addSubview:_oneView];
            [_oneView release];
            
            for (int i = 0 ; i < [self.commentInfo.userInfoArray count]; i++)
            {
                UserInfo * userInfo = [self.commentInfo.userInfoArray objectAtIndex:i];
                NSString * str = [NSString stringWithFormat:@"%@: %@",userInfo.userName,userInfo.userComment];
                
                UILabel * commentInfoLabel = [[UILabel alloc] init];
                commentInfoLabel.text = str;
                CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:kFontOfSize] constrainedToSize:CGSizeMake(235, 1000) lineBreakMode:NSLineBreakByCharWrapping];
                
                commentInfoLabel.frame=CGRectMake(10, maxf+20+20+30+i*15+size.height, 235,15);
                commentInfoLabel.font = [UIFont systemFontOfSize:kFontOfSize];
                commentInfoLabel.numberOfLines = 0;
                commentInfoLabel.lineBreakMode = NSLineBreakByCharWrapping;
                
                if (_flag == TRUE)
                {
                    commentInfoLabel.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1];
                    _flag = FALSE;
                }
                else
                {
                    commentInfoLabel.backgroundColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
                    _flag = TRUE;
                }
                
                [_oneView addSubview:commentInfoLabel];
                [commentInfoLabel release];
            }
        }
        else
        {
            self.oneView = [[UIView alloc] init];
            _oneView.frame = CGRectMake(50, 10, 145 + 100 + 15, 100 + 20 + 20 + kClearance * 5 + [self.commentInfo.userInfoArray count] * 15);
            _oneView.backgroundColor = [UIColor whiteColor];
            _oneView.layer.shadowOffset = CGSizeMake(6, 5);
            _oneView.layer.shadowColor = [UIColor blackColor].CGColor;
            _oneView.layer.shadowOpacity = 1.0;
            [self addSubview:_oneView];
            [_oneView release];
            
            for (int i = 0 ; i < [self.commentInfo.userInfoArray count]; i++)
            {
                UserInfo * userInfo = [self.commentInfo.userInfoArray objectAtIndex:i];
                NSString * str = [NSString stringWithFormat:@"%@: %@",userInfo.userName,userInfo.userComment];
                
                UILabel * commentInfoLabel = [[UILabel alloc] init];
                commentInfoLabel.text = str;
                CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:kFontOfSize] constrainedToSize:CGSizeMake(235, 1000) lineBreakMode:NSLineBreakByCharWrapping];
                
                commentInfoLabel.frame=CGRectMake(10, maxf+20+20+30+i*15+size.height, 235,15);
                commentInfoLabel.font = [UIFont systemFontOfSize:kFontOfSize];
                commentInfoLabel.numberOfLines = 0;
                commentInfoLabel.lineBreakMode = NSLineBreakByCharWrapping;
                
                if (_flag == TRUE)
                {
                    commentInfoLabel.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1];
                    _flag = FALSE;
                }
                else
                {
                    commentInfoLabel.backgroundColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
                    _flag = TRUE;
                }
                
                [_oneView addSubview:commentInfoLabel];
                [commentInfoLabel release];
            }
        }
    }
    
    [self addSubview:_userImage];
    [_oneView addSubview:_screenNameLabel];
    [_oneView addSubview:_shareImage];
    [_oneView addSubview:_shareContentLabel];
    [_oneView addSubview:_weiboTimeLabel];
    [_oneView addSubview:_poiNameLabel];
}

+ (CGFloat) cellHeight:(CommentInfo *)commentInfo
{
    return 100 + 30 + 20 + 10 * 5 + [commentInfo.userInfoArray count] * 15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
