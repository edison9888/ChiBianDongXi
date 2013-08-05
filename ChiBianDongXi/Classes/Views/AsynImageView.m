//
//  AsynImageView.m
//  LessonImageLazyLoading
//
//  Created by Andy Gu on 6/30/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import "AsynImageView.h"

@implementation AsynImageView

@synthesize urlString = _urlString;
@synthesize imageDownloader = ImageDownloader;
@synthesize path = _path;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//重写urlString的Setter方法，在外界每次赋新值的时候，检测这张图片本地是否存在，如果不存在，下载器就去下载
-(void) setUrlString:(NSString *)urlString
{
    if (_urlString != urlString)
    {
        [_urlString release];
        _urlString = [urlString retain];
    }
    
    //文件的名字不能有 / 符号，所在要替换成 _
    NSString * fileName = [self.urlString stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString * cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    self.path = [cacheDirectory stringByAppendingPathComponent:fileName];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    //如果已经有值，给自己的image赋值，否则去下载
    if ([fileManager fileExistsAtPath:self.path])
    {
        self.image = [UIImage imageWithContentsOfFile:self.path];
    }
    else
    {
        self.image = nil;
        self.imageDownloader = [[[ImageDownloader alloc] init] autorelease];
        self.imageDownloader.delegate = self;
        self.imageDownloader.urlString = self.urlString;
        [self.imageDownloader startConnection];
    }
}


//完成下载后代理回调
-(void) finishedDownloadImageData:(ImageDownloader *)loader
{
    [loader.receivedData writeToFile:self.path atomically:YES];
    self.image = [UIImage imageWithContentsOfFile:self.path];
//    NSLog(@"self.image %@", self.image);
}
//回调错误
-(void) failedWithError:(NSError *)error
{
    NSLog(@"error = %@", error);
}

//取消下载
-(void) cancelDownload
{
    [self.imageDownloader cancelConnection];
}

#pragma mark - Dealloc
- (void)dealloc
{
    self.urlString = nil;
    self.imageDownloader = nil;
    self.path = nil;
    [super dealloc];
}

@end
