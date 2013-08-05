//
//  AsynImageView.h
//  LessonImageLazyLoading
//
//  Created by Andy Gu on 6/30/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownloader.h"

/*
    本类主要作用，给一个ImageView一个URL，如果本地没有这张图片，就让下载器去下载图片
    下载器下完之后回调给这个ImageView，显示
 */

@interface AsynImageView : UIImageView<ImageDownloaderDelegate>

@property (strong, nonatomic) NSString * urlString;
@property (strong, nonatomic) ImageDownloader * imageDownloader;
@property (strong, nonatomic) NSString * path;

//取消下载
-(void) cancelDownload;

@end
