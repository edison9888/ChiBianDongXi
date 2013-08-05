//
//  CollectInfo.h
//  Collect
//
//  Created by  lanou on 13-7-3.
//  Copyright (c) 2013年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class POIInfo;
@interface CollectInfo : NSObject
@property (nonatomic,assign) int id;
@property (nonatomic,retain) NSString *poiName;
@property (nonatomic,retain) NSString *poiCategory;
@property (nonatomic,retain) NSString *poiScore;
@property (nonatomic,assign) float poiPerCapita;
@property (nonatomic,retain) NSString *poiAddress;
@property (nonatomic,retain) NSString *poiPhone;
@property (nonatomic,retain) NSString *poiImageurl;
@property (nonatomic,retain) NSString *poiId;
@property (nonatomic,retain) NSString *articleId;
@property (nonatomic,retain) NSString *articleContent;
@property (nonatomic,retain) NSString *articleImageurl;
@property (nonatomic,retain) POIInfo *poiInfo;

-(id)initWithId:(int)aId poiName:(NSString *)aPoiName poiCategory:(NSString *)aPoiCategory poiScore:(NSString *)aPoiScore poiPerCapita:(float)aPoiPerCapita poiAddress:(NSString *)aPoiAddress poiPhone:(NSString *)aPoiPhone poiImageurl:(NSString *)aPoiImageurl poiId:(NSString *)aPoiId articleId:(NSString *)aArticelId articleContent:(NSString *)aArticelContent articleImageurl:(NSString *)aArticleImageurl;

-(id)initWithPoiName:(NSString *)aPoiName poiCategory:(NSString *)aPoiCategory poiScore:(NSString *)aPoiScore poiPerCapita:(float)aPoiPerCapita poiAddress:(NSString *)aPoiAddress poiPhone:(NSString *)aPoiPhone poiImageurl:(NSString *)aPoiImageurl poiId:(NSString *)aPoiId articleId:(NSString *)aArticelId articleContent:(NSString *)aArticelContent articleImageurl:(NSString *)aArticleImageurl;

-(id)initWithPoiName:(NSString *)aPoiName articleId:(NSString *)aArticelId articleContent:(NSString *)aArticelContent articleImageurl:(NSString *)aArticleImageurl;

-(id)initWithPoiName:(NSString *)aPoiName poiCategory:(NSString *)aPoiCategory poiScore:(NSString *)aPoiScore poiPerCapita:(float)aPoiPerCapita poiAddress:(NSString *)aPoiAddress poiPhone:(NSString *)aPoiPhone poiImageurl:(NSString *)aPoiImageurl poiId:(NSString *)aPoiId;
@end
