//
//  UIDevice+Resolution.h
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM( NSUInteger){
    // iPhone 1,3,3GS 标准分辨率(320x480px)
    UIDevice_iPhoneStandardRes      = 1,
    // iPhone 4,4S 高清分辨率(640x960px)
    UIDevice_iPhoneHiRes            ,
    // iPhone 5 ,6高清分辨率(640x1136px)
    UIDevice_iPhoneTallerHiRes      ,
    // iPhone 6s 高清分辨率()
    UIDevice_iPhoneTallerPlusHiRes  ,
    // iPad 1,2 标准分辨率(1024x768px)
    UIDevice_iPadStandardRes        ,
    // iPad 3 High Resolution(2048x1536px)
    UIDevice_iPadHiRes              = 5
    
} UIDeviceResolution;

@interface UIDevice(Resolution)


+(UIDeviceResolution)currentResolution;


+(BOOL)isRunningOniPhoneRetina;

+(BOOL)isRunningOniPhone5;

+(BOOL)isRunningOniPhone6;

+(BOOL)isRunningOniPhone6s;


@end
