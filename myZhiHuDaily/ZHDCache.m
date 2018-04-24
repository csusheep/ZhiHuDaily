//
//  ZHDCache.m
//  
//
// 
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import "ZHDCache.h"
#import "NSString+md5.h"

#define ZHDDOMAIN @"com.csusheep.zhd"
#define HTTPCACHE @"httpcache"

@interface ZHDCache() {
    NSFileManager *_fileManager;
}
@property(nonatomic ,strong) NSCache *memCache;
@property(nonatomic, strong) NSString *diskCachePath;
@property(nonatomic, strong) dispatch_queue_t IOqueue;

@end

@implementation ZHDCache

+ (instancetype) sharedInstance {
    
    static dispatch_once_t once;
    static ZHDCache * instance = nil;
    
    dispatch_once(&once, ^{
        instance = [self new];
    });
    
    return  instance;
}

- (id)init{
    
    return [self initWithSpaceName:HTTPCACHE];
}


- (id)initWithSpaceName:(NSString*) name{
    if ( (self = [super init]) ) {
        NSString * spaceName = [ZHDDOMAIN stringByAppendingString:name];
        
        _IOqueue       = dispatch_queue_create([ZHDDOMAIN UTF8String], DISPATCH_QUEUE_SERIAL);
        _memCache      = [[NSCache alloc] init];
        _memCache.name = spaceName;

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _diskCachePath = [paths[0] stringByAppendingString:spaceName];
        
        dispatch_sync(_IOqueue, ^{
            _fileManager = [[NSFileManager alloc] init];
        });
        
        _maxCacheAge = 60 * 60 * 24 * 7; // 1 week
        
        
#if TARGET_OS_IPHONE
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanMemory)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanDisk)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(backgroundCleanDisk)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
#endif
        
    }
    return  self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)setMaxMemoryCost:(NSUInteger)maxCacheSize{
    self.memCache.totalCostLimit = maxCacheSize;
}

-(NSUInteger)maxMemoryCost{
    return self.memCache.totalCostLimit;
}

- (void)storeResponse:(id)response Url:(NSString *)url withParam:(NSDictionary *)params toDisk:(BOOL) toDisk {
    
    if ([response isKindOfClass:[NSDictionary class]]) {
        
        NSString * key = [self getKeyFromURL:url withParams:params];
        [self.memCache setObject:response forKey:key];
        
        if (toDisk) {
            NSDictionary *cacheDic = (NSDictionary *)response;
            NSData *cacheData = [NSKeyedArchiver archivedDataWithRootObject:cacheDic];
            if (cacheData) {
                if (![_fileManager fileExistsAtPath:_diskCachePath]) {
                    [_fileManager createDirectoryAtPath:_diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
                }
                BOOL result = [_fileManager createFileAtPath:[self defaultCachePathForKey:key] contents:cacheData attributes:nil];
                NSLog(@"create filecache result is %d", result);
            }
        }
    }
    
}

- (id)fetchResponseByUrl:(NSString *)url withParam:(NSDictionary *)params {
    NSString *key = [self getKeyFromURL:url withParams:params];
    
    id response = nil;
    
    response = [self.memCache objectForKey:key];
    if (response) {
        return response;
    }
    
    response = [self diskCacheForKey:key];
    if (response) {
        [self.memCache setObject:response forKey:key];
    }
    
    return response;
}

- (id)diskCacheForKey:(NSString*) key {
    NSString *filepath = [self defaultCachePathForKey:key];
    NSData *cacheData = [NSData dataWithContentsOfFile:filepath];
    if (cacheData) {
        id cachObj = [NSKeyedUnarchiver unarchiveObjectWithData:cacheData];
        return cachObj;
    }else {
        return  nil;
    }
}

- (void)cleanMemory{
    [self.memCache removeAllObjects];
}


- (void)clearDisk {
    [self clearDiskWitchBlock:nil];
}

- (void)clearDiskWitchBlock:(ZHDCacheBlock)block
{
    dispatch_async(self.IOqueue, ^{
        [_fileManager removeItemAtPath:self.diskCachePath error:nil];
        [_fileManager createDirectoryAtPath:self.diskCachePath
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:NULL];
        
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block();
            });
        }
    });
}

- (void)cleanDisk{
    [self cleanDiskWithBlock:nil];
    
}
- (void)cleanDiskWithBlock:(ZHDCacheBlock)block{
    dispatch_async(self.IOqueue, ^{
        NSURL *diskCacheURL = [NSURL fileURLWithPath:self.diskCachePath isDirectory:YES];
        NSArray *resouceKeys = @[NSURLIsDirectoryKey, NSURLContentModificationDateKey, NSURLTotalFileAllocatedSizeKey];
        
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtURL:diskCacheURL includingPropertiesForKeys:resouceKeys options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:NULL];
        
        NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow: -(self.maxCacheAge)];
        NSMutableDictionary *cachedFiles = [NSMutableDictionary dictionary];
        NSUInteger currentCacheSize = 0;
        NSMutableArray *urlsToBeDelete = [[NSMutableArray alloc] init];
        
        
        for (NSURL *fileURL in fileEnumerator) {
            NSDictionary *resultValues = [fileURL resourceValuesForKeys:resouceKeys error:NULL];
            
            if ([resultValues[NSURLIsDirectoryKey] boolValue]) {
                continue;
            }
            
            NSDate *modificationDate = resultValues[NSURLContentModificationDateKey];
            if ([[modificationDate laterDate:expirationDate] isEqualToDate:expirationDate]) {
                [urlsToBeDelete addObject:fileURL];
                continue;
            }
            
            NSNumber *totalAllocatedSize = resultValues[NSURLTotalFileAllocatedSizeKey];
            currentCacheSize += [totalAllocatedSize unsignedIntegerValue];
            [cachedFiles setObject:resultValues forKey:fileURL];
        }
        
        [urlsToBeDelete enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_fileManager removeItemAtURL:(NSURL*)obj error:NULL];
        }];
        
        
        if (self.maxCacheSize > 0 && currentCacheSize > self.maxCacheSize) {
            const NSUInteger desiredCacheSize = self.maxCacheSize / 2;
            
            NSArray *sortedFiles = [cachedFiles keysSortedByValueWithOptions:NSSortConcurrent
                                                            usingComparator:^NSComparisonResult(id obj1, id obj2) {
                                                                return [obj1[NSURLContentModificationDateKey] compare:obj2[NSURLContentModificationDateKey]];
                                                            }];
            
            for (NSURL *fileURL in sortedFiles) {
                if ([_fileManager removeItemAtURL:fileURL error:nil]) {
                    NSDictionary *resourceValues = cachedFiles[fileURL];
                    NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
                    currentCacheSize -= [totalAllocatedSize unsignedIntegerValue];
                    
                    if (currentCacheSize < desiredCacheSize) {
                        break;
                    }
                }
            }
        }
        
        
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block();
            });
        }
        
    });
}

- (NSUInteger)getUsedSizeOnDisk{
    __block NSUInteger size = 0;
    dispatch_sync(self.IOqueue, ^{
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:self.diskCachePath];
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [self.diskCachePath stringByAppendingPathComponent:fileName];
            NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            size += [attrs fileSize];
        }
    });
    return size;
}

- (NSUInteger)getDiskCount{
    __block NSUInteger count = 0;
    dispatch_sync(self.IOqueue, ^{
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:self.diskCachePath];
        count = [[fileEnumerator allObjects] count];
    });
    return count;
}

- (void)calculateSizeWithBlock:(ZHDCacheSize)Block{
    
    
    NSURL *diskCacheURL = [NSURL fileURLWithPath:self.diskCachePath isDirectory:YES];
    
    dispatch_async(self.IOqueue, ^{
        NSUInteger fileCount = 0;
        NSUInteger totalSize = 0;
        
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtURL:diskCacheURL
                                                   includingPropertiesForKeys:@[NSFileSize]
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                 errorHandler:NULL];
        
        for (NSURL *fileURL in fileEnumerator) {
            NSNumber *fileSize;
            [fileURL getResourceValue:&fileSize forKey:NSURLFileSizeKey error:NULL];
            totalSize += [fileSize unsignedIntegerValue];
            fileCount += 1;
        }
        
        if (Block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Block(fileCount, totalSize);
            });
        }
    });
}

- (void)backgroundCleanDisk {
    UIApplication *application = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    // Start the long-running task and return immediately.
    [self cleanDiskWithBlock:^{
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
}


- (NSString *)defaultCachePathForKey:(NSString *)key {
    return [self.diskCachePath stringByAppendingPathComponent:key];
}

- (NSString *)getKeyFromURL:(NSString *)URL withParams:(NSDictionary *) params {
    __block NSString * theKey = URL;
    if (params != nil) {
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                theKey = [theKey stringByAppendingString:key];
                theKey = [theKey stringByAppendingString:obj];
            }else
            if ([obj isKindOfClass:[NSNumber class]]) {
                theKey = [theKey stringByAppendingString:key];
                theKey = [theKey stringByAppendingString:[obj stringValue]];
            }
        }];
    }
    
    NSString * md5TheKey = [NSString md5: theKey];
    return md5TheKey;
}




@end
