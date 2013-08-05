//
//  POIShareInfoCell.m
//  ChiBianDongXi
//
//  Created by  lanou on 13-7-10.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import "POIShareInfoCell.h"
#import "NetConnectionMacro.h"
#import "POIShareInfo.h"
#define kCellWidth 158
#define kWeekendTextFontSize 15.0
#define kImageWidth 153
#define kMarginLeft 2.5
#define kMarginTop 2.5
#define kSpace 10
#define kAuthorImageWidth 35
#define kAuthorImageHeight 35
#define kAuthorNameWidth 110
@implementation POIShareInfoCell

-(id)initWithIdentifier:(NSString *)identifier
{
    self = [super initWithIdentifier:identifier];

    if (self)
    {
        self.reuseIdentifier = identifier;
        self.clipsToBounds = YES;
        self.shareImageView = [[AsynImageView alloc] init];
        self.userImageView = [[AsynImageView alloc]init];
        self.screenNameLabel = [[UILabel alloc]init];
        self.textLabel = [[UILabel alloc]init];
        self.imageView.userInteractionEnabled = YES;
        self.shareImageView.userInteractionEnabled = YES;
        self.userImageView.userInteractionEnabled = YES;
        self.screenNameLabel.userInteractionEnabled = YES;
        self.textLabel.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor cyanColor];
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    

    
    for (UIView * aView in self.subviews)
    {
        [aView removeFromSuperview];
    }
    
    if (!self.userImageView.superview)
    {
        CGRect rect = self.frame;
        rect.origin.x = rect.origin.y = 0.0f;
        [self addSubview:self.userImageView];   
        if ([self.shareInfo.sharePicUrl isEqualToString:@""])
        {
            self.shareImageView.frame = CGRectZero;
        }
        else
        {
            self.shareImageView.frame = CGRectMake(kMarginLeft, kMarginTop, kImageWidth, kImageWidth);
        }
        
        self.userImageView.frame = CGRectMake(kMarginLeft + 2.5,
                                                kMarginTop + self.shareImageView.frame.size.height + 10,
                                                kAuthorImageWidth,
                                                kAuthorImageHeight);
        
        self.screenNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft + kAuthorImageWidth + 15,
                                                                      kMarginTop + self.shareImageView.frame.size.height + 10,
                                                                      kAuthorNameWidth,
                                                                     kAuthorImageHeight)];
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft,
                                                                   self.screenNameLabel.frame.origin.y + self.screenNameLabel.frame.size.height + 10,
                                                                   kImageWidth,
                                                                   100)];
        
        self.screenNameLabel.text = self.shareInfo.screenName;
        self.textLabel.text = self.shareInfo.shareContent;
        
        [self addSubview:self.imageView];
        [self addSubview:self.shareImageView];
        [self addSubview:self.userImageView];
        [self addSubview:self.screenNameLabel];
        [self addSubview:self.textLabel];

        self.screenNameLabel.font = [UIFont systemFontOfSize:kWeekendTextFontSize];
        self.screenNameLabel.backgroundColor = [UIColor clearColor];
        
        self.textLabel.font = [UIFont systemFontOfSize:kWeekendTextFontSize];
        self.textLabel.numberOfLines = 0;
        self.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        
        CGSize size = [self.shareInfo.shareContent sizeWithFont:[UIFont systemFontOfSize:kWeekendTextFontSize] constrainedToSize:CGSizeMake(144, 100) lineBreakMode:NSLineBreakByCharWrapping];
        
        self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x,
                                          self.textLabel.frame.origin.y,
                                          self.textLabel.frame.size.width,
                                          size.height);
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.textLabel.frame.origin.y + self.textLabel.frame.size.height + 6);
        
        self.shareImageView.urlString = self.shareInfo.sharePicUrl;
        
        self.userImageView.urlString = self.shareInfo.userImageUrl;
        self.cellHeight = self.frame.size.height + 6;
    }

}

+(CGFloat) cellHeight:(POIShareInfo *) aPOIShareInfo
{
    CGSize messageSize = [aPOIShareInfo.shareContent sizeWithFont:[UIFont systemFontOfSize:kWeekendTextFontSize]
                                                     constrainedToSize:CGSizeMake(144, 100)
                                                         lineBreakMode:NSLineBreakByCharWrapping];

    if ([aPOIShareInfo.sharePicUrl isEqualToString:@""]) {
        return messageSize.height + 65;
    }
    return  kImageWidth + messageSize.height + 70;
}


- (void)dealloc
{
    self.shareImageView = nil;
    self.userImageView = nil;
    self.screenNameLabel = nil;
    self.textLabel = nil;
    self.shareInfo = nil;
    [super dealloc];
}
@end
