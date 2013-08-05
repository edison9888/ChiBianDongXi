//
//  NetworkConnection.m
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/1/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#define TIMEOUT 15

#import "NetworkConnection.h"
#import "NetConnectionMacro.h"
#import "TagArticlesInfo.h"
#import "JSONKit.h"
#import "POIInfo.h"
#import "UserInfo.h"
#import "ArticleInfo.h"
#import "TopicInfo.h"
#import "CityInfo.h"
#import "DistrictInfo.h"
#import "LoginUserInfo.h"
#import "POIShareInfo.h"
#import "CommentList.h"
#import "Weekend.h"
#import "POIListInfo.h"
#import "TagList.h"
#import "TagInfo.h"
#import "POIShareList.h"
#import "CityList.h"
#import "SearchListInfo.h"



@implementation NetworkConnection

@synthesize connect = _connect;
@synthesize url = _url;
@synthesize receivedData = _receivedData;
@synthesize responseDic = _responseDic;
@synthesize responseString = _responseString;
@synthesize error = _error;
@synthesize methodName = _methodName;
@synthesize result = _result;

#pragma mark - NetworkConnection Methods

/*
 * 基础地址URL、功能地址URL、方法名、参数字典来初始化connection实例
 * 参数字典格式：方法名做为Key，具体请求参数做为Object，如果参数是多个还要做成一个字典
 * 如：{"getDistrict":{"city":"all"}}
 */
 -(void) initWithBaseUrl:(NSString *)baseUrl functionUrl:(NSString *)functionUrl methodUrl:(NSString *)methodUrl params:(NSDictionary *)aParamsDic
{
    if (self = [super init])
    {
        self.methodName = methodUrl;
        self.paramsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys: aParamsDic, methodUrl, nil];
        self.url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@/%@", baseUrl, functionUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
       
    }
    
    NSMutableURLRequest * request = [[[NSMutableURLRequest alloc] initWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIMEOUT] autorelease];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    
    NSDictionary * requestHeadDic = [NSDictionary dictionaryWithObjectsAndKeys:@"ios", @"platform",
                                                                               @"1.0", @"version",
                                                                               @"App Stroe",@"store", nil];
    
    NSDictionary * dataDic = [NSDictionary dictionaryWithObjectsAndKeys:self.paramsDic, @"request-body",
                              requestHeadDic, @"request-head", nil];
    NSData * data = [dataDic JSONData];//把字典转化为Data

    [request setHTTPBody:data];
    
    //如果反复调用，先取消上次请求
    if (self.connect)
    {
        [self cancelConnection];
    }
    self.connect = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
}


//异步请求接口并指定回调对象和回调方法
-(void) asynchronousGetWithTarget:(id)target callBack:(SEL)callBackAction
{
    [self asynchronousGetWithTarget:target callBack:callBackAction errorCallBack:nil];
}


//异步请求接口并指定回调对象和回调方法及错误回调
-(void) asynchronousGetWithTarget:(id)target callBack:(SEL)callBackAction errorCallBack:(SEL) errorAction
{
    _target = target;
    _callBackMethod = callBackAction;
    _errorCallBackMethod = errorAction;
    
    NSMutableURLRequest * request = [[[NSMutableURLRequest alloc] initWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIMEOUT] autorelease];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    
    NSDictionary * requestHeadDic = [NSDictionary dictionaryWithObjectsAndKeys:@"ios", @"platform",
                                                                                @"1.0", @"version",
                                                                                @"App Store",@"store", nil];
    
    NSDictionary * dataDic = [NSDictionary dictionaryWithObjectsAndKeys:self.paramsDic, @"request-body",
                                                                        requestHeadDic, @"request-head", nil];
    NSData * data = [dataDic JSONData];//把字典转化为Data
    [request setHTTPBody:data];
    
    //如果反复调用，先取消上次请求
    if (self.connect)
    {
        [self cancelConnection];
    }
    self.connect = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
}


#pragma mark - NSURLConnectionDataDelegate

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    self.receivedData = [NSMutableData dataWithCapacity:100];
    
    NSHTTPURLResponse * res = (NSHTTPURLResponse *)response;

    switch (res.statusCode)
    {
        case 200: // OK
            break;
        case 400: // BadRequest
        case 401: // Forbidden
        case 403: // Not Authorized
        case 404: // Not Found
        case 500: // Internal Server Error
        case 502: // Bad Gateway
        case 503: // Service Unavailable
            
        default:
        {
            UIAlertView * serverError = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                   message:@"服务器错误!"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"确认"
                                                         otherButtonTitles:nil, nil];
            [serverError show];
            [serverError release];
        }
        return;
    }
}


//拼接返回的Data
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}


//请求成功
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    self.responseString = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    self.responseDic = [self.receivedData objectFromJSONData];
    
    if (_target != nil && [_target respondsToSelector:_callBackMethod])
    {
        [_target performSelector:_callBackMethod withObject:self];
    }
//    NSLog(@"NetworkConnection = %@", [self.receivedData objectFromJSONData]);
    
    if (self.receivedData == nil)//数据为空时，网络连接错误
    {
        NSString * msg = [[[self.receivedData objectFromJSONData] objectForKey:@"response-head"] objectForKey:@"msg"];
        NSError * error = [NSError errorWithDomain:@"Error Message" code:-1 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil]];
        [self.delegate didFinishRequestUnsuccessful:self error:error];
    }
    else
    {
        if ([[[[self.receivedData objectFromJSONData] objectForKey:@"response-head"] objectForKey:@"result"] isEqual:@"success"])
        {

            self.result = [self parseJSONStringWithMethodName];
            [self.delegate didFinishRequestSuccessful:self result:self.result];
        }
        else
        {
            NSString * msg = [[[self.receivedData objectFromJSONData] objectForKey:@"response-head"] objectForKey:@"msg"];
            NSError * error = [NSError errorWithDomain:@"Error Message" code:-2 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil]];
            
            [self.delegate didFinishRequestUnsuccessful:self error:error];
        }

        
    }

    self.receivedData = nil;
    self.responseString = nil;
    self.responseDic = nil;
}

//请求失败
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.error = error;
    NSLog(@"%@",error);
    if (_target != nil && [_target respondsToSelector:_errorCallBackMethod])
    {
        [_target performSelector:_errorCallBackMethod withObject:self];
    }
    self.error = nil;
}

-(id) parseJSONStringWithMethodName
{
    id result;
    if ([self.methodName isEqualToString:KGetHomePage])
    {
        NSDictionary * dic = [[[self.receivedData objectFromJSONData] objectForKey:@"response-body"] objectForKey:KGetHomePage];
        Weekend * weekend = [[[Weekend alloc] initWithDictionary:dic] autorelease];
        return weekend;
    }
    
    if ([self.methodName isEqualToString:KGetArticleDetail])
    {
        NSDictionary * dic = [[[self.receivedData objectFromJSONData] objectForKey:@"response-body"]
                              objectForKey:KGetArticleDetail];
        ArticleInfo * articleInfo = [[[ArticleInfo alloc] initWithDictionary:dic] autorelease];
        return articleInfo;
    }
    
    if ([self.methodName isEqualToString:KGetPoiList])
    {
        
        NSDictionary * dic = [[self.receivedData objectFromJSONData] objectForKey:@"response-body"];
               
        POIListInfo * poiListInfo = [[POIListInfo alloc] initWithDictionary:dic];
        
        return poiListInfo;
    }
    
    if ([self.methodName isEqualToString:KGetTopicDetail])
    {
        NSDictionary * dic = [[[self.receivedData objectFromJSONData] objectForKey:@"response-body"]
                              objectForKey:KGetTopicDetail];

        result = [[[TopicInfo alloc] initWithDictionary:dic] autorelease];
    }
    
    if ([self.methodName isEqualToString:KSearchByKeyWord])
    {
        NSDictionary * dic = [[self.receivedData objectFromJSONData] objectForKey:@"response-body"];
        SearchListInfo * searchListInfo = [[SearchListInfo alloc] initWithDictionary:dic];
        return searchListInfo;
  
    }
    
    if ([self.methodName isEqualToString:KSearchByTag])
    {
        NSDictionary *dic = [[[self.receivedData objectFromJSONData] objectForKey:@"response-body"] objectForKey:KSearchByTag];
        TagArticlesInfo *tagArticlesInfo = [[TagArticlesInfo alloc] initWithDictionary:dic];
        return tagArticlesInfo;
    }
    if ([self.methodName isEqualToString:KSinaUserLogin])
    {
        NSDictionary * dic = [[[self.receivedData objectFromJSONData] objectForKey:@"response-body"] objectForKey:KSinaUserLogin];
        LoginUserInfo * loginUserInfo = [[[LoginUserInfo alloc] initWithDic:dic] autorelease];
        return loginUserInfo;
    }
    if ([self.methodName isEqualToString:KGetFriendFeed])
    {
        NSDictionary * dic = [[[self.receivedData objectFromJSONData] objectForKey:@"response-body"] objectForKey:KGetFriendFeed];
        CommentList * commentList = [[[CommentList alloc] initWithDictionary:dic] autorelease];
        return commentList;
    }
    if ([self.methodName isEqualToString:KCreateCommnet])
    {
        
    }
    if ([self.methodName isEqualToString:KGetFavorite])
    {
        
    }
    if ([self.methodName isEqualToString:KGetPoiShareList])
    {
        NSDictionary * dic = [[[self.receivedData objectFromJSONData] objectForKey:@"response-body"] objectForKey:KGetPoiShareList];
        POIShareList *poiShareList = [[POIShareList alloc] initWithDictionary:dic];
        return poiShareList;
    }
    if ([self.methodName isEqualToString:KGetRecommendShareList])
    {
        NSDictionary * dic = [[[self.receivedData objectFromJSONData] objectForKey:@"response-body"] objectForKey:KGetRecommendShareList];
        POIShareList *poiShareList = [[POIShareList alloc] initWithDictionary:dic];
        return poiShareList;
    }
    
    if ([self.methodName isEqualToString:KGetDistrict])
    {
        NSDictionary * dic = [[[self.receivedData objectFromJSONData] objectForKey:@"response-body"] objectForKey:KGetDistrict];
        CityList *cityList = [[CityList alloc] initWithDictionary:dic];
        return cityList;
    }
    if ([self.methodName isEqualToString:KCreaterFavorite])
    {
        
    }
    if ([self.methodName isEqualToString:KDeleteFavorite])
    {
        
    }
    if ([self.methodName isEqualToString:KGetTagList])
    {
        NSDictionary * dic = [[[self.receivedData objectFromJSONData] objectForKey:@"response-body"] objectForKey:KGetTagList];
        
        TagList * tagList = [[TagList alloc] initWithDictionary:dic];
        
        return tagList;
    }
    return result;
}


//取消请求
-(void) cancelConnection
{
    [self.connect cancel];
    self.connect = nil;
}


#pragma mark - Dealloc
- (void)dealloc
{
    [_connect release];
    self.result = nil;
    [_url release];
    [_receivedData release];
    [_responseDic release];
    [_responseString release];
    [_error release];
    [super dealloc];
}

@end
