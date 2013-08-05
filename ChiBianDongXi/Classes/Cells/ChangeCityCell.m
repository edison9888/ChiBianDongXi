//
//  ChangeCityCell.m
//  ChiBianDongXi 2.0
//
//  Created by lanou on 13-7-12.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import "ChangeCityCell.h"
#import "CityInfo.h"

@implementation ChangeCityCell
- (void)dealloc
{
    [_cityIamge release];
    [_cityNameLabel release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSString *str = [NSString stringWithFormat:@"%d,jpg",1];
        self.cityIamge = [[UIImageView alloc]initWithImage:[UIImage imageNamed:str]];
        _cityIamge.backgroundColor=[UIColor grayColor];
        _cityIamge.frame = CGRectMake(10, 30, 300, 230);
        [self addSubview:_cityIamge];
        [_cityIamge release];
        
        self.cityNameLabel = [[UILabel alloc] init];
        _cityNameLabel.backgroundColor = [UIColor orangeColor];
        _cityNameLabel.font = [UIFont boldSystemFontOfSize:20.0];
        _cityNameLabel.textColor = [UIColor blackColor];
        [self addSubview:_cityNameLabel];
        [_cityNameLabel release];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.cityNameLabel.text = _cityName.cityName;
    _cityNameLabel.frame =CGRectMake(10, 0, 300, 30);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
