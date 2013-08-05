//
//  SearchInfoCell.m
//  ChiBianDongXi 2.0
//
//  Created by  lanou on 13-7-23.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import "SearchInfoCell.h"

#define kImageMargin 5
#define kLabelMargin 10
#define kTopMargin 5
#define kBottomMargin 5

#define kImageWidth 100
#define kImageHeight 100



@implementation SearchInfoCell

-(id)initWithIdentifier:(NSString *)identifier
{
    self = [super initWithIdentifier:identifier];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubControls];
        
    }
    return self;
}

-(void) initSubControls
{
    self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelMargin, 5, 135, 20)];
    
    self.poiNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kLabelMargin, 25, 135, 20)] autorelease];
    
    self.poiImageView    = [[[AsynImageView alloc] init] autorelease];
    
    self.shareNumLabel= [[[UILabel alloc] initWithFrame:CGRectMake(kLabelMargin, 280, 140, 30)] autorelease];
    
    
    self.weiboLabel   = [[[UILabel alloc] initWithFrame:CGRectMake(kLabelMargin, 310, 140, 20)] autorelease];
    
    
    self.addressLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kLabelMargin, 330, 55, 25)] autorelease];
    
    self.categoryLabel = [[[UILabel alloc] initWithFrame:CGRectMake(60, 330, 55, 25)] autorelease];
    
    self.priceLabel = [[[UILabel alloc] initWithFrame:CGRectMake(115, 330, 35, 25)] autorelease];
    
    self.poiIndo = [[POIInfo alloc] init];
    
    [self addSubview:_distanceLabel];
    [self addSubview:self.shareNumLabel];
    [self addSubview:self.weiboLabel];
    [self addSubview:self.addressLabel];
    [self addSubview:self.categoryLabel];
    [self addSubview:self.priceLabel];
    
    [self addSubview: self.poiImageView];
    [self addSubview:self.poiNameLabel];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    self.distanceLabel.text = [NSString stringWithFormat:@"%dKM",self.poiIndo.distance];
    
    self.poiNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.poiNameLabel.numberOfLines = 0;
    self.poiNameLabel.font = [UIFont systemFontOfSize:16.0];
    
    CGSize textSize = [self.poiIndo.poiName sizeWithFont:[UIFont systemFontOfSize:16.0]
                                       constrainedToSize:CGSizeMake(135, 200)
                                           lineBreakMode:NSLineBreakByWordWrapping];
    
    self.poiNameLabel.frame = CGRectMake(_poiNameLabel.frame.origin.x, _poiNameLabel.frame.origin.y, _poiNameLabel.frame.size.width, textSize.height);
    self.poiNameLabel.text = self.poiIndo.poiName;
    
    
    
    CGFloat newHeight = self.poiIndo.poiImageSize.height * (145/ self.poiIndo.poiImageSize.width);
    self.poiImageView.frame = CGRectMake(kImageMargin, 5*kTopMargin+textSize.height, 145, newHeight);
    //异步加载图片
    NSString *urlStr = @"http://img.91mahua.com/huohua_v2/imageinterfacev2/api/interface/image/disk/get";
    self.poiImageView.urlString = [NSString stringWithFormat:@"%@/%d/%d/%@",urlStr,(int)self.poiIndo.poiImageSize.width, (int)self.poiIndo.poiImageSize.height, self.poiIndo.poiImageId];
    
    self.shareNumLabel.frame = CGRectMake(kLabelMargin, 6*kTopMargin+textSize.height+newHeight, 140, 30);
    
    //    NSLog(@"%f", 3*kTopMargin+textSize.height+newHeight+60);
    self.shareNumLabel.text = self.poiIndo.poiShareNum ;
    self.shareNumLabel.font = [UIFont systemFontOfSize:22.0];
    self.shareNumLabel.textColor = [UIColor redColor];
    self.shareNumLabel.textAlignment = NSTextAlignmentCenter;
    
    
    self.weiboLabel.frame = CGRectMake(kLabelMargin, 6*kTopMargin+textSize.height+newHeight+30, 140, 15);
    self.weiboLabel.textAlignment = NSTextAlignmentCenter;
    self.weiboLabel.text = @"次微博推荐";
    self.weiboLabel.font = [UIFont systemFontOfSize:10.0];
    self.weiboLabel.textAlignment = NSTextAlignmentCenter;
    
    self.addressLabel.frame = CGRectMake(kLabelMargin, 6*kTopMargin+textSize.height+newHeight+50, 55, 25);
    self.addressLabel.font = [UIFont systemFontOfSize:11.0];
    self.addressLabel.text = self.poiIndo.poiDistrict;
    
    self.categoryLabel.frame = CGRectMake(60, 6*kTopMargin+textSize.height+newHeight+50, 55, 25);
    self.categoryLabel.font = [UIFont systemFontOfSize:11.0];
    self.categoryLabel.text = self.poiIndo.poiCategory;
    
    self.priceLabel.frame = CGRectMake(115, 6*kTopMargin+textSize.height+newHeight+50, 55, 25);
    self.priceLabel.font = [UIFont systemFontOfSize:11.0];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",self.poiIndo.poiAverageSpend];
    self.priceLabel.font = [UIFont systemFontOfSize:14.0];
    self.priceLabel.textColor = [UIColor redColor];
    
    self.cellHeight = 8*kTopMargin+textSize.height+newHeight+50;
    
    
}

+(CGFloat) cellHeight:(POIInfo *) poiInfo
{
    CGSize textSize = [poiInfo.poiName sizeWithFont:[UIFont systemFontOfSize:16.0]
                                  constrainedToSize:CGSizeMake(135, 200)
                                      lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat imageHeight = poiInfo.poiImageSize.height * (145/ poiInfo.poiImageSize.width);
    
    return (CGFloat)(textSize.height + imageHeight + 5*kTopMargin + 80);
    
}



- (void)dealloc
{
    [self.addressLabel release];
    [self.poiNameLabel release];
    [self.priceLabel release];
    [self.poiImageView release];
    [self.shareNumLabel release];
    [self.weiboLabel release];
    [self.poiIndo release];
    
    [super dealloc];
}

@end
