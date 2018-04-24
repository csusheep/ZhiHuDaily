//
//  ZHDHomeTitleBar.m
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import "ZHDHomeTitleBar.h"

@interface ZHDHomeTitleBar()

{
    CGFloat _statusBarHeight;
    UIView *_statusBar;
    CGRect _zhd_bounds;
}

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIColor *bgcolor;

@end

@implementation ZHDHomeTitleBar

- (instancetype)initWithFrame:(CGRect)frame {
     return [[ZHDHomeTitleBar alloc] initWithFrame:frame andStatusBarHeight:20 withBgColor:[UIColor colorWithRed:0.271 green:0.628 blue:1.000 alpha:1.000]];
}

-(instancetype)initWithFrame:(CGRect)frame andStatusBarHeight:(CGFloat) statusHeight {
    return [[ZHDHomeTitleBar alloc] initWithFrame:frame andStatusBarHeight:statusHeight withBgColor:[UIColor colorWithRed:0.271 green:0.628 blue:1.000 alpha:1.000]];
}

- (instancetype)initWithFrame:(CGRect)frame andStatusBarHeight:(CGFloat) statusHeight withBgColor:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
        _zhd_bounds      = self.bounds;
        _statusBarHeight = statusHeight;
        _bgcolor         = color;
        [self commonInit];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _zhd_bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)commonInit {
    _statusBar                  = [[UIView alloc] initWithFrame:self.bounds];
    _statusBar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _statusBar.backgroundColor  = _bgcolor;
    [self insertSubview:_statusBar atIndex:0];
}

- (void)zhd_setBackgroundColor:(UIColor *)backgroundColor {
    _statusBar.backgroundColor = backgroundColor;
    _bgcolor                   = backgroundColor;
}

- (void)zhd_hiddenBar {
    _statusBar.frame           = CGRectMake(0, 0, self.bounds.size.width, _statusBarHeight);
    _statusBar.backgroundColor = _bgcolor;
}

- (void)zhd_showBar {
    _statusBar.frame           = _zhd_bounds;
    _statusBar.backgroundColor = _bgcolor;
}

- (void)setTitleText:(NSString *)title {
    if (nil == _title) {
        _title                 = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width/2 - 50 , self.bounds.size.height/2, 100, 20)];
        _title.backgroundColor = [UIColor clearColor];
        _title.textColor       = [UIColor whiteColor];
        _title.textAlignment   = NSTextAlignmentCenter;
        
        [self addSubview:_title];
    }
    _title.text = title;
}

- (void)setLeftBtn:(UIButton *)leftBtn {
    if (leftBtn == _leftBtn) {
        return;
    }
    _leftBtn = leftBtn;
    [self insertSubview:_leftBtn atIndex:99];
}

@end
