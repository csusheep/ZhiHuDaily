//
//  ZHDHttpClient.h
//  myZhiHuDaily
//
//  
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "ZHDCache.h"

typedef enum {
    ZHDHttpResponseType_Json,
    ZHDHttpResponseType_XML,
    ZHDHttpResponseType_JqueryJson,
    ZHDHttpResponseType_Common,
}ZHDHttpResponseType;

typedef NS_ENUM(NSInteger, ZHDMethod){
    ZHDGET,
    ZHDPOST
};

@interface ZHDHttpClient : AFHTTPRequestOperationManager

-(void)requestWithURL:(NSString *)url
               method:(ZHDMethod) method
               params:(NSDictionary* ) params
         responseType:(ZHDHttpResponseType)type
              success:(void(^)(AFHTTPRequestOperation * opration,id resultObject) )success
             failture:(void(^)(NSError *requestError))failure;



@end
