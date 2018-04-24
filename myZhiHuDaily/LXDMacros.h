//
//  LXDMacros.h
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#ifndef LXDMacros_h
#define LXDMacros_h
#pragma mark  ------------------------- version -------------------------

#define kGetVersion             [[NSUserDefaults standardUserDefaults] objectForKey:@"CFBundleShortVersionString"]
#define kSaveVersion(version)   [[NSUserDefaults standardUserDefaults] setObject:(version) forKey:@"CFBundleShortVersionString"];[[NSUserDefaults standardUserDefaults] synchronize]

#define kGetRegister(key)               [[NSUserDefaults standardUserDefaults] objectForKey:(key)]
#define kSaveRegister(key, value)       [[NSUserDefaults standardUserDefaults] setObject:(value) forKey:(key)];\
[[NSUserDefaults standardUserDefaults] synchronize]
#define kRemoveRegister(key)            [[NSUserDefaults standardUserDefaults] removeObjectForKey:(key)];\
[[NSUserDefaults standardUserDefaults] synchronize]

#endif /* LXDMacros_h */
