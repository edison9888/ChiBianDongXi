//
//  WeekendCell.m
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/10/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import "WeekendCell.h"
#import "NetConnectionMacro.h"
#import "UserInfo.h"

#define kCellWidth 158
#define kWeekendTextFontSize 15.0
#define kImageWidth 153
#define kMarginLeft 2.5
#define kMarginTop 2.5
#define kSpace 10
#define kAuthorImageWidth 35
#define kAuthorImageHeight 35
#define kAuthorNameWidth 110

@implementation WeekendCell

-(id)initWithIdentifier:(NSString *)identifier
{
    self = [super initWithIdentifier:identifier];
    if (self)
    {
        self.reuseIdentifier = identifier;
        self.clipsToBounds = YES;
        self.articleImageView = [[AsynImageView alloc] init];
        self.authorImageView = [[AsynImageView alloc] init];
        self.poiNameLabel = [[UILabel alloc] init];
        self.textLabel = [[UILabel alloc] init];
        self.imageView.userInteractionEnabled = YES;
        self.authorImageView.userInteractionEnabled = YES;
        self.articleImageView.userInteractionEnabled = YES;
        self.authorNameLabel.userInteractionEnabled = YES;
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
    
    if (!self.authorImageView.superview)
    {
        CGRect rect = self.frame;
        rect.origin.x = rect.origin.y = 0.0f;
        
        [self addSubview:self.authorImageView];

        CGFloat newHeight = self.articleInfo.articleImageSize.height * (kImageWidth / self.articleInfo.articleImageSize.width);
        
        self.articleImageView.frame = CGRectMake(kMarginLeft, kMarginTop, kImageWidth, newHeight);
        
        self.authorImageView.frame = CGRectMake(kMarginLeft + 2.5,
                                                kMarginTop + newHeight + 10,
                                                kAuthorImageWidth,
                                                kAuthorImageHeight);
                
        self.poiNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft + kAuthorImageWidth + 15,
                                                                         kMarginTop + newHeight + 10,
                                                                         kAuthorNameWidth,
                                                                         kAuthorImageHeight)];
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft,
                                                                   kMarginTop + newHeight + 10 + kAuthorImageHeight + 10,
                                                                   kImageWidth,
                                                                   100)];
        
        self.poiNameLabel.text = self.articleInfo.poiInfo.poiName;
        self.textLabel.text = self.articleInfo.articleIntroduction;
        
        [self addSubview:self.imageView];
        [self addSubview:self.poiNameLabel];
        [self addSubview:self.articleImageView];
        [self addSubview:self.authorImageView];
        [self addSubview:self.textLabel];
        
        self.poiNameLabel.font = [UIFont systemFontOfSize:kWeekendTextFontSize];
        self.poiNameLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont systemFontOfSize:kWeekendTextFontSize];
        self.textLabel.numberOfLines = 0;
        self.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        
        CGSize size = [self.articleInfo.articleIntroduction sizeWithFont:[UIFont systemFontOfSize:kWeekendTextFontSize] constrainedToSize:CGSizeMake(144, 100) lineBreakMode:NSLineBreakByCharWrapping];
        
        self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x,
                                          self.textLabel.frame.origin.y,
                                          self.textLabel.frame.size.width,
                                          size.height);
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.textLabel.frame.origin.y + self.textLabel.frame.size.height + 6);
        
        self.articleImageView.urlString = [NSString stringWithFormat:@"%@/%d/%d/%@", kImageURL, (int)self.articleInfo.articleImageSize.width, (int)self.articleInfo.articleImageSize.height, self.articleInfo.articleImageUrl];
        
        self.authorImageView.urlString = self.articleInfo.userInfo.userImageUrl;
        
        self.cellHeight = self.frame.size.height + 6;
        
    }
}


+(CGFloat) cellHeight:(ArticleInfo *) articleInfo
{
    CGSize messageSize = [articleInfo.articleIntroduction sizeWithFont:[UIFont systemFontOfSize:kWeekendTextFontSize] constrainedToSize:CGSizeMake(144, 100) lineBreakMode:NSLineBreakByCharWrapping];
    
    return  (articleInfo.articleImageSize.height * kImageWidth) / articleInfo.articleImageSize.width + messageSize.height + 70;
}


- (void)dealloc
{
    [self.articleImageView release];
    [self.authorImageView release];
    [self.authorNameLabel release];
    [self.poiNameLabel release];
    [self.textLabel release];
    [super dealloc];
}


@end
