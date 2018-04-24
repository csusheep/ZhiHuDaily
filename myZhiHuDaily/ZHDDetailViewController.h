//
//  ZHDDetailViewController.h
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ModelStory;

@interface ZHDDetailViewController : UIViewController

@property (nonatomic, assign) NSInteger storyID;

@property (nonatomic, strong) ModelStory *story;

- (instancetype)initWithStory: (ModelStory *)story;

@end
