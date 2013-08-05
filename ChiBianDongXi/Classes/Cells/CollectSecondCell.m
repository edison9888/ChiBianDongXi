//
//  CollectSecondCell.m
//  ChiBianDongXi 2.0
//
//  Created by  lanou on 13-7-12.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import "CollectSecondCell.h"

@implementation CollectSecondCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.collectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 90, 90)];
        
        self.poiLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 200, 30)];
        [_poiLabel setFont:[UIFont systemFontOfSize:27.0]];
        self.articleLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 45, 200, 60)];
        _articleLabel.numberOfLines = 0;
        [_articleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [self addSubview:_collectImageView];
        [self addSubview:_poiLabel];
        [self addSubview:_articleLabel];
        
        [_collectImageView release];
        [_poiLabel release];
        [_articleLabel release];
        
    }
    return self;
}

-(void)layoutSubviews
{
   
    NSString *fileName = [NSString stringWithFormat:@"%@",_collectInfo.articleImageurl];
    NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    self.path = [cacheDirectory stringByAppendingPathComponent:fileName];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:_path]) {
        _collectImageView.image = [UIImage imageWithContentsOfFile:_path];
    }
    _poiLabel.text = _collectInfo.poiName;
    _articleLabel.text = _collectInfo.articleContent;
}

- (void)dealloc
{
    self.collectInfo = nil;
    self.collectImageView = nil;
    self.poiLabel = nil;
    self.articleLabel = nil;
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
