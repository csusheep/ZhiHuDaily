//
//  lxd_ParallaxTableViewHeader.h
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void (^Callback)(NSInteger index);

@interface lxd_ParallaxTableViewHeader : UIView

@property (nonatomic, weak) UIViewController *dumyVC;
@property (nonatomic, assign) BOOL autoScroll;
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;


-(instancetype) initWithFrame:(CGRect)frame  tapCallback: (Callback) block;

-(void)setAdWithImgUrls:(NSArray *)imgUrls andTitles:(NSArray *) titles;

@end
