//
//  ImageDownloader.m
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/1/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import "ImageDownloader.h"


@implementation ImageDownloader

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

#pragma mark - StartConnection

//开始连接
-(void) startConnection
{
    NSURL * url = [NSURL URLWithString:self.urlString];
    NSURLRequest * request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    self.connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
}

#pragma mark - NSURLConnectionDataSource

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	self.receivedData = [NSMutableData data];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.receivedData appendData:data];
}


-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_delegate && [_delegate respondsToSelector:@selector(finishedDownloadImageData:)])
    {
        [_delegate finishedDownloadImageData:self];
    }
    self.receivedData = nil;
}


#pragma mark - CancelConnection

//取消连接
-(void) cancelConnection
{
    [_connection cancel];
    self.receivedData = nil;
    self.urlString = nil;
}



#pragma mark - Dealloc

- (void)dealloc
{
    [_connection release];
    [_urlString release];
    [_receivedData release];
    [super dealloc];
}

@end

