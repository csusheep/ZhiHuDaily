//
//  LXDActivityIndicator.h
//  zhihuActivityIndicator
//
//  Created by 刘 晓东 on 16/4/20.
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LXDActivityIndicatorProtocol <NSObject>

- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor;

@end


@interface LXDDefaultAnimation : NSObject <LXDActivityIndicatorProtocol>

- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor;

@end


@interface LXDActivityIndicator : UIView

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, assign) CGFloat size;
@property (nonatomic, weak) id<LXDActivityIndicatorProtocol> delegate;

- (instancetype)initWithTintColor:(UIColor *)tintColor;
- (instancetype)initWithTintColor:(UIColor *)tintColor size:(CGFloat)size;
- (instancetype)initWithTintColor:(UIColor *)tintColor size:(CGFloat)size animationDelegate:(id<LXDActivityIndicatorProtocol>)delegate;

- (void)startAnimating;
- (void)stopAnimating;

@end
