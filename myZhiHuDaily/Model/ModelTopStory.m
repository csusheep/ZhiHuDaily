//
//  ModelTopStory.m
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import "ModelTopStory.h"

@implementation ModelTopStory

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeInteger:self.type forKey:@"type"];
    [aCoder encodeObject:self.ga_prefix forKey:@"ga_prefix"];
    [aCoder encodeObject:self.title forKey:@"title"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    _ID = [aDecoder decodeObjectForKey:@"ID"];
    _image = [aDecoder decodeObjectForKey:@"image"];
    _type = [aDecoder decodeIntegerForKey:@"type"];
    _ga_prefix = [aDecoder decodeObjectForKey:@"ga_prefix"];
    _title = [aDecoder decodeObjectForKey:@"title"];
    return self;
}// NS_DESIGNATED_INITIALIZER

@end
