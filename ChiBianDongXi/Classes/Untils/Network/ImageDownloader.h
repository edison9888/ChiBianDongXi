//
//  ImageDownloader.h
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/1/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ImageDownloader;

@protocol ImageDownloaderDelegate <NSObject>

-(void) finishedDownloadImageData:(ImageDownloader *)loader;
-(void) failedWithError:(NSError *)error;

@end

/*
 *本类主要作用
 *传入一个image的URL，异步下载图片，加载完成后代理回调给使用的人
 */
@interface ImageDownloader : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSURLConnection * connection;
@property (strong, nonatomic) id<ImageDownloaderDelegate> delegate;
@property (strong, nonatomic) NSString * urlString;
@property (strong, nonatomic) NSMutableData * receivedData;


//开始连接
-(void) startConnection;

//取消连接
-(void) cancelConnection;

@end

