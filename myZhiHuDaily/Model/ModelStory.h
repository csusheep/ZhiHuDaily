//
//  ModelStroy.h
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelStory : NSObject <NSCoding>

@property(nonatomic, strong) NSNumber *ID;
@property(nonatomic, strong) NSArray *images;
@property(nonatomic, assign) NSInteger type;
@property(nonatomic, strong) NSString *ga_prefix;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, assign) BOOL multipic;
@property (nonatomic, assign) BOOL readed;


@end
