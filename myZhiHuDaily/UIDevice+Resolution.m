//
//  UIDevice+Resolution.m
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import "UIDevice+Resolution.h"
#import <UIKit/UIKit.h>

@implementation UIDevice(Resolution)

+(UIDeviceResolution)currentResolution{
    PKLog(@"to-do");
    return nil;
}


+(BOOL)isRunningOniPhoneRetina{
  return   [UIDevice foo:CGSizeMake(640, 960)];
}

+(BOOL)isRunningOniPhone5{
    return   [UIDevice foo:CGSizeMake(640, 1136)];
}

+(BOOL)isRunningOniPhone6{
    return   [UIDevice foo:CGSizeMake(750, 1334)];
}

+(BOOL)isRunningOniPhone6s{
    return   [UIDevice foo:CGSizeMake(1242, 2208)];
}

+(BOOL)foo:(CGSize) size{
    
  return  [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(size, [[UIScreen mainScreen] currentMode].size) : NO;
    
}


@end
