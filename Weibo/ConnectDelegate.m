//
//  ConnectDelegate.m
//  Weibo
//
//  Created by apple on 15/12/2.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import "ConnectDelegate.h"

@interface ConnectDelegate ()
{
    AFNetworkReachabilityManager * _manager;
    AFHTTPSessionManager * _requestManager;
    
    ParseDataBlock  _block;
}
@end
@implementation ConnectDelegate

#pragma mark  -单例
+(instancetype)standConnectDelegate
{
    static dispatch_once_t onceToken;
    static ConnectDelegate * delegate = nil;
    
    dispatch_once(&onceToken, ^{
        delegate = [[ConnectDelegate alloc] init];
    });
    
    return delegate;
}

-(instancetype)init
{
    if (self = [super init])
    {
        _manager = [AFNetworkReachabilityManager sharedManager];
        
        _requestManager = [AFHTTPSessionManager manager];
        //设置数据传输类型
        _requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/html",nil];
    }
    return self;
}


#pragma mark  -网络监听
-(void)requestDataFromUrl:(NSString *)url andParseDataBlock:(ParseDataBlock)block
{
    _block = block;
    
    
    __weak ConnectDelegate * connect = self;
    
    [_manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable)
        {
            block(nil);
        }
        else
        {
            [connect requestDataFromUrl:url];
        }
    }];
    
    //开始网络监听
    [_manager startMonitoring];
}

-(void)requestDataFromUrl:(NSString *)url parameters:(id)parameters andParseDataBlock:(ParseDataBlock)block
{
    _block = block;
    
    
    __weak ConnectDelegate * connect = self;
    
    [_manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable)
        {
            block(nil);
        }
        else
        {
            [connect requestDataFromUrl:url parameters:parameters];
        }
    }];
    
    //开始网络监听
    [_manager startMonitoring];
}


#pragma mark  -get请求
-(void)requestDataFromUrl:(NSString *)url
{
    [_requestManager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _block(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _block(nil);
    }];
}

#pragma mark  -post请求
-(void)requestDataFromUrl:(NSString *)url parameters:(id)parameters
{
    [_requestManager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _block(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _block(nil);
    }];
}
@end
