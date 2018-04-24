//
//  ModelTheme.h
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelTheme : NSObject

@property (nonatomic, strong) NSNumber *color;
@property (nonatomic, strong) NSString *thumbnail;
@property (nonatomic, strong) NSString *ThemeDescription;
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL *subscribe;

@end


@interface ModelThemes : NSObject

@property (nonatomic, strong) NSNumber *limit;
@property (nonatomic, copy) NSArray *subscribed;
@property (nonatomic, copy) NSArray *others;

@end
