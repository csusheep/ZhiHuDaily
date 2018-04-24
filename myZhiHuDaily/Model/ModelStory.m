//
//  ModelStroy.m
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import "ModelStory.h"
#import "MJExtension.h"

@implementation ModelStory


+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.images forKey:@"images"];
    [aCoder encodeInteger:self.type forKey:@"type"];
    [aCoder encodeObject:self.ga_prefix forKey:@"ga_prefix"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeBool:self.multipic forKey:@"multipic"];
    [aCoder encodeBool:self.readed forKey:@"readed"];
    
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    _ID = [aDecoder decodeObjectForKey:@"ID"];
    _images = [aDecoder decodeObjectForKey:@"images"];
    _type = [aDecoder decodeIntegerForKey:@"type"];
    _ga_prefix = [aDecoder decodeObjectForKey:@"ga_prefix"];
    _title = [aDecoder decodeObjectForKey:@"title"];
    _multipic = [aDecoder decodeBoolForKey:@"multipic"];
    _readed = [aDecoder decodeBoolForKey:@"readed"];
    
    return self;
}// NS_DESIGNATED_INITIALIZER



@end
