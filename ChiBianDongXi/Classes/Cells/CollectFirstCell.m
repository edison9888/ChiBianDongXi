//
//  CollectFirstCell.m
//  ChiBianDongXi 2.0
//
//  Created by  lanou on 13-7-12.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import "CollectFirstCell.h"
#import "CollectInfo.h"
#import "AsynImageView.h"
#define kImageURL                  @"http://img.91mahua.com/huohua_v2/imageinterfacev2/api/interface/image/disk/get"

@implementation CollectFirstCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //imageView
        self.collectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 90, 90)];
//              _collectImageView.backgroundColor = [UIColor blueColor];
        
        //poi label
        self.poiLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 200, 30)];
//                _poiLabel.backgroundColor = [UIColor blueColor];
        [_poiLabel setFont:[UIFont systemFontOfSize:27.0]];
        
        //per_capita label
        self.perCapitaLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 40, 200, 20)];
//              _perCapitaLabel.backgroundColor = [UIColor brownColor];
        [_perCapitaLabel setFont:[UIFont systemFontOfSize:15.0]];
        
        //address Label
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 60, 200, 20)];
//             _addressLabel.backgroundColor = [UIColor blueColor];
        [_addressLabel setFont:[UIFont systemFontOfSize:15.0]];
        
        //phone Label
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 80, 200, 20)];
//              _phoneLabel.backgroundColor = [UIColor brownColor];
        [_phoneLabel setFont:[UIFont systemFontOfSize:15.0]];
        
        [self addSubview:_poiLabel];
        [self addSubview:_perCapitaLabel];
        [self addSubview:_addressLabel];
        [self addSubview:_phoneLabel];
        [self addSubview:_collectImageView];
        
        [_collectImageView release];
        [_poiLabel release];
        [_perCapitaLabel release];
        [_addressLabel release];
        [_phoneLabel release];
        
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}



-(void)layoutSubviews
{

    NSString *fileName = [NSString stringWithFormat:@"%@",_collectInfo.poiImageurl];
    NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    self.path = [cacheDirectory stringByAppendingPathComponent:fileName];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:_path]) {
        _collectImageView.image = [UIImage imageWithContentsOfFile:_path];
    }
    _poiLabel.text = _collectInfo.poiName;
    
    _perCapitaLabel.text =[NSString stringWithFormat:@"人均:   %0.2f",_collectInfo.poiPerCapita];
    _addressLabel.text = [NSString stringWithFormat:@"地址:   %@",_collectInfo.poiAddress];
    _phoneLabel.text =[NSString stringWithFormat:@"电话:   %@",_collectInfo.poiPhone];
    
}

- (void)dealloc
{
    self.collectImageView = nil;
    self.poiLabel = nil;
    self.perCapitaLabel = nil;
    self.addressLabel = nil;
    self.phoneLabel = nil;
    self.collectInfo = nil;
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
