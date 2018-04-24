//
//  SplashScreenController.h
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHDSplashScreenController : UIViewController

@property(nonatomic, strong, readwrite) UIImageView *splashImage;
@property(nonatomic, strong, readwrite) UILabel *provenance;

+(void) loadSplash;

@end
