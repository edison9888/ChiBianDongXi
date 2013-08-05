//
//  TagCell.m
//  ChiBianDongXi 2.0
//
//  Created by  lanou on 13-7-19.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import "TagCell.h"
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

@implementation TagCell

-(id)initWithIdentifier:(NSString *)identifier
{
    self = [super initWithIdentifier:identifier];
    if (self)
    {
        self.reuseIdentifier = identifier;
        self.clipsToBounds = YES;
        self.defaultImageView = [[AsynImageView alloc] init];
        self.authorImageView = [[AsynImageView alloc] init];
        self.poiNameLabel = [[UILabel alloc] init];
        self.textLabel = [[UILabel alloc] init];
        self.imageView.userInteractionEnabled = YES;
        self.authorImageView.userInteractionEnabled = YES;
        self.defaultImageView.userInteractionEnabled = YES;
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
        
        CGFloat newHeight = self.tagArticlesInfo.defaultImageSize.height * (kImageWidth / self.tagArticlesInfo.defaultImageSize.width);
        
        self.defaultImageView.frame = CGRectMake(kMarginLeft, kMarginTop, kImageWidth, newHeight);
        
        self.authorImageView.frame = CGRectMake(kMarginLeft + 2.5,
                                                kMarginTop + newHeight + 10,
                                                kAuthorImageWidth,
                                                kAuthorImageHeight);
        
        //        self.authorNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft + kAuthorImageWidth + 15,
        //                                                                         kMarginTop + newHeight + 10,
        //                                                                         kAuthorNameWidth,
        //                                                                         kAuthorImageHeight)];
        
        self.poiNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft + kAuthorImageWidth + 15,
                                                                      kMarginTop + newHeight + 10,
                                                                      kAuthorNameWidth,
                                                                      kAuthorImageHeight)];
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft,
                                                                   kMarginTop + newHeight + 10 + kAuthorImageHeight + 10,
                                                                   kImageWidth,
                                                                   100)];
        
        //        self.authorNameLabel.text = self.articleInfo.userInfo.userName;
        self.poiNameLabel.text = self.tagArticlesInfo.poiName;
        self.textLabel.text = self.tagArticlesInfo.defaultText;
        
        [self addSubview:self.imageView];
        //        [self addSubview:self.authorNameLabel];
        [self addSubview:self.poiNameLabel];
        [self addSubview:self.defaultImageView];
        [self addSubview:self.authorImageView];
        [self addSubview:self.textLabel];
        
        //        self.authorNameLabel.font = [UIFont systemFontOfSize:kWeekendTextFontSize];
        //        self.authorNameLabel.backgroundColor = [UIColor clearColor];
        self.poiNameLabel.font = [UIFont systemFontOfSize:kWeekendTextFontSize];
        self.poiNameLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont systemFontOfSize:kWeekendTextFontSize];
        self.textLabel.numberOfLines = 0;
        self.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        
        CGSize size = [self.tagArticlesInfo.defaultText sizeWithFont:[UIFont systemFontOfSize:kWeekendTextFontSize] constrainedToSize:CGSizeMake(144, 100) lineBreakMode:NSLineBreakByCharWrapping];
        
        self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x,
                                          self.textLabel.frame.origin.y,
                                          self.textLabel.frame.size.width,
                                          size.height);
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.textLabel.frame.origin.y + self.textLabel.frame.size.height + 6);
        
        self.defaultImageView.urlString = [NSString stringWithFormat:@"%@/%d/%d/%@", kImageURL, (int)self.tagArticlesInfo.defaultImageSize.width, (int)self.tagArticlesInfo.defaultImageSize.height, self.tagArticlesInfo.defaultImageUrl];
        
        self.authorImageView.urlString = self.tagArticlesInfo.authorImage;
        
        self.cellHeight = self.frame.size.height + 6;
        
    }
}


+(CGFloat) cellHeight:(TagArticlesInfo *)tagArticlesInfo
{
    CGSize messageSize = [tagArticlesInfo.defaultText sizeWithFont:[UIFont systemFontOfSize:kWeekendTextFontSize] constrainedToSize:CGSizeMake(144, 100) lineBreakMode:NSLineBreakByCharWrapping];
    
    return  (tagArticlesInfo.defaultImageSize.height * kImageWidth) / tagArticlesInfo.defaultImageSize.width + messageSize.height + 70;
}

- (void)dealloc
{
    self.authorImageView = nil;
    self.defaultImageView = nil;
    self.authorNameLabel = nil;
    self.textLabel = nil;
    self.tagArticlesInfo = nil;
    self.poiNameLabel = nil;
    [super dealloc];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
