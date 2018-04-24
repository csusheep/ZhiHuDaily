//
//  Utility.m
//  HaveDate
//
//  Created by 刘 晓东 on 15/8/31.
//  Copyright (c) 2015年 刘 晓东. All rights reserved.
//

#import "Utility.h"

static NSString * const flagStr = @"if_First_At_Version_%@";
static NSString * const isLoggedInFlagStr = @"if_Logged_In";

@implementation Utility

+(BOOL)isFirstAtThisVersion{
    BOOL result = YES;
    NSString *flag = [NSString stringWithFormat:flagStr,[[[NSBundle mainBundle] infoDictionary] objectForKey : (NSString *)kCFBundleVersionKey]];
    
    NSNumber *flagNum = [[NSUserDefaults standardUserDefaults] objectForKey:flag];
    if (nil != flagNum) {
        result = [flagNum boolValue];
    }
    return result;
}

+(void)setFirstOpened:(BOOL)first{
    NSString *flag = [NSString stringWithFormat:flagStr,[[[NSBundle mainBundle] infoDictionary] objectForKey : (NSString *)kCFBundleVersionKey]];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:first] forKey:flag];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isLoggedIn{
    BOOL result = NO;
    NSNumber *flagNum = [[NSUserDefaults standardUserDefaults] objectForKey:isLoggedInFlagStr];
    if (nil != flagNum) {
        result = [flagNum boolValue];
    }
    return result;
}
+(void)setLoggedIn:(BOOL)flagBool{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:flagBool] forKey:isLoggedInFlagStr];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
