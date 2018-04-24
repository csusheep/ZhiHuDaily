//
//  LXDActivityIndicator.m
//  zhihuActivityIndicator
//
//  Created by 刘 晓东 on 16/4/20.
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import "LXDActivityIndicator.h"

static const CGFloat kDefaultSize = 40.f;

@implementation LXDActivityIndicator

- (instancetype)initWithTintColor:(UIColor *)tintColor {
    return [self initWithTintColor:tintColor size:kDefaultSize];
}

- (instancetype)initWithTintColor:(UIColor *)tintColor size:(CGFloat)size {
    return [self initWithTintColor:tintColor size:size animationDelegate:nil];
}

- (instancetype)initWithTintColor:(UIColor *)tintColor size:(CGFloat)size animationDelegate:(id<LXDActivityIndicatorProtocol>)delegate {
    self = [super init];
    if (self) {
        _size      = size;
        _tintColor = tintColor;
        _delegate  = delegate;
    }
    return self;
}

- (void)startAnimating {
    [self setupAnimations];
    self.layer.speed = 1.f;
}

- (void)stopAnimating {
    self.layer.speed = 0.f;
}


- (void)setupAnimations {
    self.layer.sublayers = nil;
    
    id<LXDActivityIndicatorProtocol> animation = nil;
    if (_delegate) {
        animation = _delegate;
    } else {
        animation = [[LXDDefaultAnimation alloc]init ];
    }
    
    if ([animation respondsToSelector:@selector(setupAnimationInLayer:withSize:tintColor:)]) {
        [animation setupAnimationInLayer:self.layer withSize:CGSizeMake(_size, _size) tintColor:_tintColor];
        self.layer.speed = 0.f;
    }
}

@end




@implementation LXDDefaultAnimation

- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    
    CGFloat oX = (layer.bounds.size.width - size.width) / 2.0f;
    CGFloat oY = (layer.bounds.size.height - size.height) / 2.0f;
    
    CAShapeLayer *circleBG = [CAShapeLayer layer];
    circleBG.path          = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)].CGPath;
    circleBG.fillColor     = [UIColor clearColor].CGColor;
    circleBG.frame         = CGRectMake(oX, oY, size.width, size.height);
    circleBG.strokeColor   = [UIColor clearColor].CGColor;
    circleBG.lineWidth     = 5.0f;
    circleBG.anchorPoint   = CGPointMake(0.5f, 0.5f);
    circleBG.opacity       = 1.0f;
    circleBG.lineCap       = @"round";
    
    
    CGFloat ooX = (circleBG.bounds.size.width - size.width) / 2.0f;
    CGFloat ooY = (circleBG.bounds.size.height - size.height) / 2.0f;
    
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.path          = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)].CGPath;
    circle.fillColor     = [UIColor clearColor].CGColor;
    circle.frame         = CGRectMake(ooX, ooY, size.width, size.height);
    circle.strokeColor   = tintColor.CGColor;
    circle.lineWidth     = 5.0f;
    circle.anchorPoint   = CGPointMake(0.5f, 0.5f);
    circle.opacity       = 1.0f;
    circle.lineCap       = @"round";
    //circle.strokeEnd     = 0.75f;

    
    CAKeyframeAnimation *strokeEndAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.beginTime            = CACurrentMediaTime();
    strokeEndAnimation.duration             = 1.f;
    strokeEndAnimation.keyTimes             = @[@(0.f), @(.125f), @(.75f), @(1.f)];
    strokeEndAnimation.values               = @[@(0.0f),@(0.0f), @(1.f), @(1.f)];
    
    strokeEndAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
    strokeEndAnimation.repeatCount    = HUGE_VALF;
    
    CAKeyframeAnimation *strokeStartAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.duration             = 1.f;
    strokeStartAnimation.keyTimes             = @[@(0.f), @(.125f), @(.55f), @(1.f)];
    strokeStartAnimation.values               = @[@(0.f), @(0.f), @(0.f), @(1.f)];
    strokeStartAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
    strokeStartAnimation.repeatCount = HUGE_VALF;


    CAKeyframeAnimation *transformKeyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    transformKeyAnimation.beginTime = CACurrentMediaTime();
    transformKeyAnimation.duration = 8.f;
    transformKeyAnimation.values =@[[NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)], [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI/180*90, 0, 0, 1)] ,[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI/180*180, 0, 0, 1)], [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI/180*270, 0, 0, 1)], [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI/180*360, 0, 0, 1)]];
    transformKeyAnimation.repeatCount = HUGE_VALF;
    
    [circleBG addSublayer:circle];
    [layer addSublayer:circleBG];
    
    [circle addAnimation:strokeEndAnimation forKey:@"strokeEndAnimation"];
    [circle addAnimation:strokeStartAnimation forKey:@"strokeStartAnimation"];
    [circleBG addAnimation:transformKeyAnimation forKey:@"animation"];
}

@end