//
//  NetworkConnection.h
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/1/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

/*
    本类主要作用是用于网络请求
 */





#import <Foundation/Foundation.h>
@class POIInfo;
@class UserInfo;
@class ArticleInfo;
@class TopicInfo;
@class CityInfo;
@class DistrictInfo;
@class LoginUserInfo;
@class NetworkConnection;

@protocol NetworkConnectionDelegate <NSObject>

-(void) didFinishRequestSuccessful:(NetworkConnection *)connection result:(id)result;
-(void) didFinishRequestUnsuccessful:(NetworkConnection *)connection error:(NSError *)error;

@end

@interface NetworkConnection : NSObject<NSURLConnectionDataDelegate, NSURLConnectionDelegate>
{
    SEL _callBackMethod;       //回调方法
    SEL _errorCallBackMethod; //错误回调方法
    id  _target;              
}

@property (assign, nonatomic) id<NetworkConnectionDelegate> delegate;
@property (strong, nonatomic) NSURL           * url;             //url地址
@property (strong, nonatomic) NSURLConnection * connect;         //Connection实例
@property (strong, nonatomic) NSMutableData   * receivedData;    //返回数据Data
@property (strong, nonatomic) NSDictionary    * paramsDic;       //参数字典
@property (strong, nonatomic) NSDictionary    * responseDic;     //解析结果
@property (strong, nonatomic) NSString        * responseString;  //返回数据字符串
@property (strong, nonatomic) NSError         * error;           //error错误信息

@property (strong, nonatomic) NSString        * methodName;      //调用接口方法名称
@property (strong, nonatomic) id                result;          //返回结果
/*
 * 基础地址URL、功能地址URL、方法名、参数字典来初始化connection实例
 * 参数字典格式：方法名做为Key，具体请求参数做为Object，如果参数是多个还要做成一个字典
 * 如：{"getDistrict":{"city":"all"}}
 */
-(void) initWithBaseUrl:(NSString *)baseUrl functionUrl:(NSString *)functionUrl methodUrl:(NSString *)methodUrl params:(NSDictionary *)aParamsDic;


//异步请求接口并指定回调对象和回调方法
-(void) asynchronousGetWithTarget:(id)target callBack:(SEL)callBackAction;

//异步请求接口并指定回调对象和回调方法及错误回调
-(void) asynchronousGetWithTarget:(id)target callBack:(SEL)callBackAction errorCallBack:(SEL) errorAction;

//取消请求
-(void) cancelConnection;

-(id) parseJSONStringWithMethodName:(NSString *)methodName;



@end
