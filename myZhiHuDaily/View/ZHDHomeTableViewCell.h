//
//  ZHDHomeTableViewCell.h
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModelStory;

@interface ZHDHomeTableViewCell : UITableViewCell

@property(nonatomic,strong) UIImageView *storyImg;
@property(nonatomic, strong) UILabel *title;

-(void)setStory: (ModelStory *)story;

-(CGFloat)cellHeight;

@end
