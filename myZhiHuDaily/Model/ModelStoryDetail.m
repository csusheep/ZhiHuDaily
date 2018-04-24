//
//  ModelDetailNews.m
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import "ModelStoryDetail.h"
#import "MJExtension.h"

@implementation ModelStoryDetail

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.body forKey:@"body"];
    [aCoder encodeObject:self.image_source forKey:@"image_source"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:self.share_url forKey:@"share_url"];
    [aCoder encodeObject:self.js forKey:@"js"];
    [aCoder encodeObject:self.ga_prefix forKey:@"ga_prefix"];
    [aCoder encodeInteger:self.type forKey:@"type"];
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.css forKey:@"css"];
    
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    _body = [aDecoder decodeObjectForKey:@"body"];
    _image_source = [aDecoder decodeObjectForKey:@"image_source"];
    _title = [aDecoder decodeObjectForKey:@"title"];
    _image = [aDecoder decodeObjectForKey:@"image"];
    _share_url = [aDecoder decodeObjectForKey:@"share_url"];
    _js = [aDecoder decodeObjectForKey:@"js"];
    _ga_prefix = [aDecoder decodeObjectForKey:@"ga_prefix"];
    _type = [aDecoder decodeIntegerForKey:@"type"];
    _ID = [aDecoder decodeObjectForKey:@"ID"];
    _css = [aDecoder decodeObjectForKey:@"css"];
    
    return self;
}

@end
