//
//  ZHDHttpProxy.h
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHDHttpClient.h"

typedef void (^ZHDHttpSuccessBlock)( id data);
typedef void (^ZHDHttpFailureBlock) (NSError * error);

@interface ZHDHttpProxy : NSObject

+(instancetype) SharedProxy;


- (void)requestWithURL:(NSString *)url
               method :(ZHDMethod) method
                 paras:(NSDictionary *)parasDict
                  type:(ZHDHttpResponseType)type
               success:(void(^)(AFHTTPRequestOperation* operation, id resultObject))success
               failure:(void(^)(NSError *requestErr))failure ;
- (void)requestWithURL2:(NSString *)url
                method :(ZHDMethod) method
                referer:(NSString *)refer
                  paras:(NSDictionary *)parasDict
                   type:(ZHDHttpResponseType)type
                success:(void(^)(AFHTTPRequestOperation* operation, id resultObject))success
                failure:(void(^)(NSError *requestErr))failure;


- (void)requestLastNews:(ZHDHttpSuccessBlock) success Failure:(ZHDHttpFailureBlock) failure;

- (void)requestStoriesByDate:(NSDate *)date withBlock:(ZHDHttpSuccessBlock)success Failure:(ZHDHttpFailureBlock) failure;

- (void)requestStoryDetailByID:(NSInteger )ID withBlock:(ZHDHttpSuccessBlock)success Failure:(ZHDHttpFailureBlock) failure;

- (void)requestThemeListwithBlock:(ZHDHttpSuccessBlock)success Failure:(ZHDHttpFailureBlock) failure;

- (void)setTimeOut:(NSTimeInterval)timeout;


@end
