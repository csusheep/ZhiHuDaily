//
//  ZHDCache.h
//  
//
//  
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_OPTIONS(NSUInteger, ZHDCacheType){
    ZHDNoCache      = 1 <<  0,
    ZHDCacheMemery  = 1 <<  1,
    ZHDCacheDisk    = 1 <<  2,
};


typedef void(^ZHDCacheBlock)();
typedef void(^ZHDCacheSize)(NSUInteger fileCount, NSUInteger totalSize);

@interface ZHDCache : NSObject

@property (nonatomic, assign) NSUInteger maxMemoryCost;
@property (nonatomic, assign) NSTimeInterval maxCacheAge;
@property (nonatomic, assign) NSUInteger maxCacheSize;

+ (instancetype) sharedInstance;

- (void)storeResponse:(id)response Url:(NSString *)url withParam:(NSDictionary *)params toDisk:(BOOL) toDisk;
- (id)fetchResponseByUrl:(NSString *)url withParam:(NSDictionary *)params;

- (void)cleanMemory;

- (void)clearDisk;
- (void)clearDiskWitchBlock:(ZHDCacheBlock)block;

- (void)cleanDisk;
- (void)cleanDiskWithBlock:(ZHDCacheBlock)block;

- (NSUInteger)getUsedSizeOnDisk;

- (NSUInteger)getDiskCount;

- (void)calculateSizeWithBlock:(ZHDCacheSize)Block;


@end
