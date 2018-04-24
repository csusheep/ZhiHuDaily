//
//  ModelDetailNews.h
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelStoryDetail : NSObject <NSCoding>

@property(nonatomic, copy) NSString *body;
@property(nonatomic, copy) NSString *image_source;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *image;
@property(nonatomic, copy) NSString *share_url;
@property(nonatomic, strong) NSArray  *js;
@property(nonatomic, copy) NSString *ga_prefix;
@property(nonatomic, assign) NSInteger type;
@property(nonatomic, strong) NSNumber *ID;
@property(nonatomic, strong) NSArray *css;

@end
