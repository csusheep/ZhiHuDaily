//
//  ModelManager.m
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import "ModelManager.h"
#import "ModelStory.h"
#import "ModelTopStory.h"

@implementation ModelSection

+ (NSDictionary *)objectClassInArray
{
    return @{@"stories" : @"ModelStory"
            };
}

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName
{
    // nickName -> nick_name
    return [propertyName mj_underlineFromCamel];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.stories forKey:@"stories"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    _date = [aDecoder decodeObjectForKey:@"date"];
    _stories = [aDecoder decodeObjectForKey:@"stories"];
    return self;
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if (property.type.typeClass == [NSDate class]) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat       = @"yyyyMMdd";
        return [fmt dateFromString:oldValue];
    }
    return oldValue;
}

-(NSInteger)numberOfStories {
    
    return _stories.count;
}

- (NSString*)dateString{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSLocale *zhLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [fmt setLocale:zhLocale];
    fmt.dateFormat = @"MM月dd日 EEEE";
    return  [fmt stringFromDate:_date];
}

@end


@implementation ModelSectionWithTopStories

+ (NSDictionary *)objectClassInArray
{
    return @{@"stories" : @"ModelStory",
             @"topStories" : @"ModelTopStory"};
}

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName
{
    // nickName -> nick_name
    return [propertyName mj_underlineFromCamel];
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if (property.type.typeClass == [NSDate class]) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat       = @"yyyyMMdd";
        return [fmt dateFromString:oldValue];
    }
    return oldValue;
}
@end


@interface ModelManager()
{
    NSMutableArray * _topStoriesList;
    NSMutableArray * _zhdSectionsList;
}

@end

@implementation ModelManager

+(instancetype)sharedModelManager
{
    static ModelManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ModelManager alloc] init];
    });
    return instance;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        _topStoriesList = [[NSMutableArray alloc] init];
        _zhdSectionsList = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_zhdSectionsList forKey:@"zhdSections"];
    [aCoder encodeObject:_topStoriesList forKey:@"topStories"];
    [aCoder encodeObject:self.earliestDate forKey:@"earliestDate"];

}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    _zhdSectionsList = [aDecoder decodeObjectForKey:@"zhdSections"];
    _topStoriesList  = [aDecoder decodeObjectForKey:@"topStories"];
    _earliestDate    = [aDecoder decodeObjectForKey:@"earliestDate"];

    return self;
}

- (void)save {
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:_zhdSectionsList forKey:@"zhdSectionsList"];
    [archiver encodeObject:_topStoriesList forKey:@"topStories"];
    
    [archiver finishEncoding];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/zhdSectionsList.plist"];
    [data writeToFile:path atomically:YES];

}

- (void)load {
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/zhdSectionsList.plist"];
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:path];
    if (data.length > 0) {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        [_zhdSectionsList addObjectsFromArray:[unarchiver decodeObjectForKey:@"zhdSectionsList"]];
        [_topStoriesList addObjectsFromArray:[unarchiver decodeObjectForKey:@"topStories"]];
        [unarchiver finishDecoding];
    }
}

-(void)addSection:(ModelSection * )section {
    if (nil != section ) {
        if (_zhdSectionsList.count > 0) {
            ModelSection *fistOldSection = _zhdSectionsList[0];
            if ([section.date isEqualToDate:fistOldSection.date]) { //the section date is same but the stories maybe diffrent
                BOOL isNew = NO;
                for (NSInteger i = section.stories.count - 1 ; i >= 0 ; i--)
                { //add the new stoies to scetions[0]
                    ModelStory *storyTmp = section.stories[i];
                    for (ModelStory *storyOld in fistOldSection.stories) {
                        isNew = YES;
                        if ([storyTmp.ID isEqualToNumber:storyOld.ID]) {
                            isNew = NO;
                            break;
                        }
                    }
                    if (isNew) {
                        NSMutableArray *tmpMutableArray = [fistOldSection.stories mutableCopy];
                        [tmpMutableArray insertObject:storyTmp atIndex:0];
                        fistOldSection.stories = tmpMutableArray;
                        
                    }
                }
            }else { // the new section
                [_zhdSectionsList addObject:section];
            }
        } else { // first time add a new section
             [_zhdSectionsList addObject:section];
        }
    [self orderSectionByDate];
    }
}

-(void)setTopStories:(NSArray *)topStories{
    _topStoriesList = [topStories copy];

}

- (NSDate *)earliestDate {
    
    NSDate *date = [NSDate date];
    if (_zhdSectionsList && _zhdSectionsList.count > 0) {
        ModelSection * ms = (ModelSection *)[_zhdSectionsList lastObject];
        date = ms.date;
    }
    return date;
}
         
- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    return  [fmt stringFromDate:date];
}

- (NSArray *)topStories {
    return [_topStoriesList copy];
}

- (NSArray *)zhdSections {
    return [_zhdSectionsList copy];
}

- (NSArray *)topStoriesImgUrls {
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    for (ModelTopStory *story in _topStoriesList) {
        [tmpArray addObject:story.image];
    }
    return tmpArray;
}

- (NSArray *)topStoriesTitles {
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    for (ModelTopStory *story in _topStoriesList) {
        [tmpArray addObject:story.title];
    }
    return tmpArray;
}

- (NSIndexPath *)getIndexPathByID:(NSNumber *)ID {
    NSIndexPath *tempIdexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    for (int section = 0;  section < self.zhdSections.count; section++) {
        ModelSection *modelSection = [self.zhdSections objectAtIndex:section] ;
        for (int row = 0; row < modelSection.stories.count; row ++) {
            ModelStory *medelStory = [ modelSection.stories objectAtIndex:row];
            if (ID == medelStory.ID) {
                tempIdexPath = [NSIndexPath indexPathForRow:row inSection:section];
                break;
            }
        }
    }
    return tempIdexPath;
}

- (NSDictionary *)getStoryAndIndexPathByID:(NSNumber *)ID {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSIndexPath *tempIdexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    for (int section = 0;  section < self.zhdSections.count; section++) {
        ModelSection *modelSection = [self.zhdSections objectAtIndex:section] ;
        for (int row = 0; row < modelSection.stories.count; row ++) {
            ModelStory *modelStory = [ modelSection.stories objectAtIndex:row];
            if (ID == modelStory.ID) {
                tempIdexPath = [NSIndexPath indexPathForRow:row inSection:section];
                [dic setObject:modelStory forKey:kModelStory];
                [dic setObject:tempIdexPath forKey:kIndexPath];
                break;
            }
        }
    }
    return dic;
}

- (void)orderSectionByDate {
    NSArray *tmpArray = [_zhdSectionsList copy];
    _zhdSectionsList  = [[tmpArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        ModelSection *section1 = (ModelSection*)obj1;
        ModelSection *section2 = (ModelSection*)obj2;
        
        NSComparisonResult result ;
        if (NSOrderedAscending == [section1.date compare:section2.date]) {
            result =  NSOrderedDescending;
        } else if (NSOrderedDescending == [section1.date compare:section2.date]) {
            result =  NSOrderedAscending;
        } else {
            result = [section1.date compare:section2.date];
        }
        return result;
    }] mutableCopy];
}

@end
