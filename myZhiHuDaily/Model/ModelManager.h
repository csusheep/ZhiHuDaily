//
//  ModelManager.h
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "ModelStoryDetail.h"
#import "ModelStory.h"
#import "ModelTopStory.h"
#import "ModelTheme.h"

#define kModelStory @"kModelStory"
#define kIndexPath @"kTempIndexPath"

@interface ModelSection : NSObject <NSCoding>

@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSArray *stories;

- (NSString*)dateString;

- (NSInteger) numberOfStories;

@end


@interface ModelSectionWithTopStories: NSObject <NSCoding>

@property (nonatomic, copy) NSDate *date;
@property (nonatomic, strong) NSArray *stories;
@property (nonatomic, strong) NSArray *topStories;

@end


@class ModelStory;

@interface ModelManager : NSObject

@property (nonatomic, copy) NSArray *zhdSections;
@property (nonatomic, copy) NSArray *topStories;
@property (nonatomic, copy) NSDate *earliestDate;

+ (instancetype)sharedModelManager;

- (void)addSection:(ModelSection * )section;

- (NSString *)stringFromDate:(NSDate *)date;

- (NSArray *)topStoriesImgUrls;

- (NSArray *)topStoriesTitles;

- (NSIndexPath *) getIndexPathByID:(NSNumber *)ID;

- (NSDictionary *) getStoryAndIndexPathByID:(NSNumber *)ID;

- (void)save;

- (void)load;



@end
