//
//  ModelThemes.m
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import "ModelTheme.h"

@implementation ModelTheme

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             @"ThemeDescription" :@"description"
             };
}
@end



@implementation ModelThemes

+ (NSDictionary *)objectClassInArray
{
    return @{@"others" : @"ModelTheme"};
}

@end