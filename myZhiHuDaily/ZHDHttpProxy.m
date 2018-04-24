//
//  ZHDHttpProxy.m
//  myZhiHuDaily
// 
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import "ZHDHttpProxy.h"
#import "ModelManager.h"

@interface ZHDHttpProxy()
{
    ZHDHttpClient *http_common;
    ZHDHttpClient *http_json;
}

@end

@implementation ZHDHttpProxy

+(instancetype)SharedProxy{
    static ZHDHttpProxy *client = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        client = [[ZHDHttpProxy alloc] init];
        [client setTimeOut:3.f];
    });
    return client;
}

-(instancetype) init{
    
    self = [super init];
    if (self) {
        http_common = [[ZHDHttpClient alloc] init];
        AFHTTPRequestSerializer *request_common = [[ AFHTTPRequestSerializer alloc] init];
        [http_common setRequestSerializer:request_common];
        
        http_json = [[ ZHDHttpClient alloc] init];
        AFJSONRequestSerializer *request_json = [[AFJSONRequestSerializer alloc] init];
        [http_json setRequestSerializer:request_json];
    }
    return  self;
    
}

- (void)requestWithURL:(NSString *)url
               method :(ZHDMethod) method
                 paras:(NSDictionary *)parasDict
                  type:(ZHDHttpResponseType)type
               success:(void(^)(AFHTTPRequestOperation* operation, id resultObject))success
               failure:(void(^)(NSError *requestErr))failure {
    
    if (ZHDHttpResponseType_Json == type) {
        [http_json requestWithURL:url method:method params:parasDict responseType:type success:success failture:failure];
    }else
    if (ZHDHttpResponseType_Common == type) {
        [http_common requestWithURL:url method:method params:parasDict responseType:type success:success failture:failure];
    }
}

- (void)requestWithURL2:(NSString *)url
                method :(ZHDMethod) method
                referer:(NSString *)refer
                  paras:(NSDictionary *)parasDict
                   type:(ZHDHttpResponseType)type
                success:(void(^)(AFHTTPRequestOperation* operation, id resultObject))success
                failure:(void(^)(NSError *requestErr))failure{
    
    if (ZHDHttpResponseType_Json == type) {
        [http_json.requestSerializer setValue:refer forKey:@"refer"];
        [http_json requestWithURL:url method:method params:parasDict responseType:type success:success failture:failure];
    }else
    if (ZHDHttpResponseType_Common == type) {
        [http_common.requestSerializer setValue:refer forKey:@"refer"];
        [http_common requestWithURL:url method:method params:parasDict responseType:type success:success failture:failure];
    }
}

- (void)requestLastNews:(ZHDHttpSuccessBlock) success Failure:(ZHDHttpFailureBlock) failure{
    
    [self requestWithURL:LatestNewsURL method:ZHDGET paras:nil type:ZHDHttpResponseType_Json success:^(AFHTTPRequestOperation *operation, id resultObject) {
        
        ModelSectionWithTopStories *sectionTopStories = [ModelSectionWithTopStories mj_objectWithKeyValues:resultObject];
        
        ModelSection *section = [[ModelSection alloc] init];
        section.date          = [sectionTopStories.date copy];
        section.stories       = [sectionTopStories.stories copy];
        
        [[ModelManager sharedModelManager] addSection:section];
        [ModelManager sharedModelManager].topStories = [sectionTopStories.topStories copy];
        [ModelManager sharedModelManager].earliestDate = section.date;
        dispatch_async(dispatch_get_main_queue(), ^{
            success(resultObject);
        });
        
    } failure:^(NSError *requestErr) {
        failure(requestErr);
    }];
 
}

- (void)requestStoriesByDate:(NSDate *)date withBlock:(ZHDHttpSuccessBlock)success Failure:(ZHDHttpFailureBlock) failure {
    
    if (nil == date) {
        NSError *error = [NSError errorWithDomain:@"date is empty" code:0 userInfo:nil];
        failure(error);
        return;
    }

    NSString *dateStr = [[ModelManager sharedModelManager] stringFromDate:date];
    NSString *url = [NSString stringWithFormat:NewsBeforeURL,dateStr];
    
    [self requestWithURL:url method:ZHDGET paras:nil type:ZHDHttpResponseType_Json success:^(AFHTTPRequestOperation *operation, id resultObject) {
        ModelSection *section                          = [ModelSection mj_objectWithKeyValues:resultObject];
        [[ModelManager sharedModelManager] addSection:section];
        [ModelManager sharedModelManager].earliestDate = section.date;
        success( section);
        
    } failure:^(NSError *requestErr) {
        failure(requestErr);
    }];
}

- (void)requestStoryDetailByID:(NSInteger )ID withBlock:(ZHDHttpSuccessBlock)success Failure:(ZHDHttpFailureBlock) failure{
    
    if (0 == ID) {
        NSError *error = [NSError errorWithDomain:@"ID is invalid" code:0 userInfo:nil];
        failure(error);
        return;
    }
    NSString *idStr      = [NSString stringWithFormat:@"%ld",(long)ID];
    NSString *url        = [NSString stringWithFormat:NewsContentURL,idStr];
    NSDictionary *params = @{kHttpAllowFetchCache:@YES,
                             kHttpAllowSaveCache:[NSNumber numberWithInteger:(ZHDCacheMemery | ZHDCacheDisk)]};
    [self requestWithURL:url method:ZHDGET paras:params type:ZHDHttpResponseType_Json success:^(AFHTTPRequestOperation *operation, id resultObject) {
        ModelStoryDetail *storyDetail = [ModelStoryDetail mj_objectWithKeyValues:resultObject];
        success( storyDetail);
    } failure:^(NSError *requestErr) {
        failure(requestErr);
    }];
}

- (void)requestThemeListwithBlock:(ZHDHttpSuccessBlock)success Failure:(ZHDHttpFailureBlock) failure{
    NSDictionary *params = @{kHttpAllowFetchCache:@NO,
                             kHttpAllowSaveCache:[NSNumber numberWithInteger:ZHDNoCache]};
    [self requestWithURL:NewsThemesURL method:ZHDGET paras:params type:ZHDHttpResponseType_Json success:^(AFHTTPRequestOperation *operation, id resultObject) {
        ModelThemes *themes = [ModelThemes mj_objectWithKeyValues:resultObject];
        success(themes);
    } failure:^(NSError *requestErr) {
        failure(requestErr);
    }];
}


- (void)setTimeOut:(NSTimeInterval)timeout {
    AFHTTPRequestOperationManager *manager    = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = timeout;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
}




@end
