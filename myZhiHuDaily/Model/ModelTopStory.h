//
//  ModelTopStory.h
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelTopStory : NSObject <NSCoding>

@property(nonatomic, strong) NSNumber *ID;
@property(nonatomic, strong) NSString *image;
@property(nonatomic, assign) NSInteger type;
@property(nonatomic, strong) NSString *ga_prefix;
@property(nonatomic, strong) NSString *title;



@end
