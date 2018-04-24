//
//  Utility.h
//  HaveDate
//
//  Created by 刘 晓东 on 15/8/31.
//  Copyright (c) 2015年 刘 晓东. All rights reserved.
//

#import <Foundation/Foundation.h>


#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

#define IS_IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define StatueBarHeight (IS_iOS7 ? 20:0)
#define NavigationbarHeight (IS_iOS7 ? 44:0)
#define ViewOriginY (IS_iOS7 ? 64:0)
#define RGB(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define kMBProgressTag 9999
#define IS_iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)

@interface Utility : NSObject

+(BOOL)isFirstAtThisVersion;

+(void)setFirstOpened:(BOOL)first;

+(BOOL)isLoggedIn;

+(void)setLoggedIn:(BOOL)flagBool;

@end
