//
//  ZHDHomeTitleBar.h
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHDHomeTitleBar : UIView

- (instancetype)initWithFrame:(CGRect)frame andStatusBarHeight:(CGFloat) statusHeight withBgColor:(UIColor *)color;

- (instancetype)initWithFrame:(CGRect)frame andStatusBarHeight:(CGFloat) statusHeight;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)zhd_setBackgroundColor:(UIColor *)backgroundColor;

- (void)zhd_hiddenBar;

- (void)zhd_showBar;

- (void)setTitleText:(NSString *)title;

- (void)setLeftBtn:(UIButton *)leftBtn;

@end
