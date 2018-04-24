//
//  ZHDHttpClient.m
//  myZhiHuDaily
//
//  
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import <TouchJSON/NSDictionary_JSONExtensions.h>
#import "ZHDHttpClient.h"


@implementation ZHDHttpClient

-(void)requestWithURL:(NSString *)url
               method:(ZHDMethod) method
               params:(NSDictionary* ) params
         responseType:(ZHDHttpResponseType)type
              success:(void(^)(AFHTTPRequestOperation * opration, id resultObject) )success
             failture:(void(^)(NSError *requestError))failure {
    
    if ([[params objectForKey:kHttpAllowFetchCache] boolValue]) {
        
        id cacheObj = [[ZHDCache sharedInstance]fetchResponseByUrl:url withParam:params];
        if (cacheObj) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(nil,cacheObj);
            });
            return;
        }
    }
    
    int allowSaveCache = [[params objectForKey:kHttpAllowSaveCache] intValue];

    if (type == ZHDHttpResponseType_XML) {
        if (![self.responseSerializer isMemberOfClass:[AFXMLParserResponseSerializer class]])
        {
            AFXMLParserResponseSerializer *xmlParserSerializer = [[AFXMLParserResponseSerializer alloc] init];
            self.responseSerializer = xmlParserSerializer;
        }
    }
    else if (type == ZHDHttpResponseType_Json) {
        if(![self.responseSerializer isMemberOfClass:[AFJSONResponseSerializer class]])
        {
            AFJSONResponseSerializer *jsonParserSerializer = [[AFJSONResponseSerializer alloc] init];
            self.responseSerializer = jsonParserSerializer;
        }
    }
    else {
        if (![self.responseSerializer isMemberOfClass:[AFHTTPResponseSerializer class]])
        {
            AFHTTPResponseSerializer *httpParserSerializer = [[AFHTTPResponseSerializer alloc] init];
            self.responseSerializer = httpParserSerializer;
        }
    }

    if ([[NSUserDefaults standardUserDefaults] objectForKey:kZHDCookie])
    {
        [self.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:kZHDCookie] forHTTPHeaderField:@"Cookie"];
    }
    
    NSMutableDictionary *transferParas = [NSMutableDictionary dictionaryWithDictionary:params];

    NSString *requestURL = url;
    NSDictionary *baseParas = nil;

    if (baseParas && baseParas.allKeys.count > 0) {
        [transferParas setValuesForKeysWithDictionary:baseParas];
    }

    __weak typeof(self) weakSelf = self;
    
    if (ZHDGET == method) {
        [self GET:requestURL parameters:transferParas success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            if (!weakSelf) {
                return ;
            }
            if(type == ZHDHttpResponseType_Common) {
                responseObject = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            }
            else if (type == ZHDHttpResponseType_JqueryJson) {
                NSError* error   = nil;
                responseObject = [NSDictionary dictionaryWithJSONString:[self handleResponseJqueryJson:responseObject] error:&error];
            }
            
            if ((allowSaveCache & ZHDCacheMemery) || (allowSaveCache & ZHDCacheDisk)) {
                [[ZHDCache sharedInstance] storeResponse:responseObject Url:requestURL withParam:transferParas toDisk:(allowSaveCache & ZHDCacheDisk)? YES:NO];
            }
            success(operation, responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];
    }else if (ZHDPOST == method){
        [self POST:requestURL parameters:transferParas success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            if (!weakSelf) {
                return ;
            }
            if(type == ZHDHttpResponseType_Common) {
                responseObject = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            } else if (type == ZHDHttpResponseType_JqueryJson) {
                NSError* error   = nil;
                responseObject = [NSDictionary dictionaryWithJSONString:[self handleResponseJqueryJson:responseObject] error:&error];
            }
//  POST 请求的返回结果经常变动，所以不需要缓存。
//            if (allowSaveCache == ZHDCacheMemery || allowSaveCache == ZHDCacheDisk) {
//                [[ZHDCache sharedInstance] storeResponse:responseObject Url:requestURL withParam:transferParas toDisk:allowSaveCache == ZHDCacheMemery? NO:YES];
//            }
            success(operation, responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];
    }
}


- (NSString *)handleResponseJqueryJson:(id  _Nonnull)responseObject {
    NSString* result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSString* r      = nil;
    NSRange r1       = [result rangeOfString:@"("];
    if (r1.location == 0) {
        r = [result substringFromIndex:1];
        r = [[r substringToIndex:r.length - 1] stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    } else if(r1.length > 0) {
        r          = [result substringFromIndex:r1.location+1];
        NSRange r2 = [r rangeOfString:@")"];
        r          = [[r substringToIndex:r2.location] stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    } else {
        r = [result stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    }
    return r;
}

@end
