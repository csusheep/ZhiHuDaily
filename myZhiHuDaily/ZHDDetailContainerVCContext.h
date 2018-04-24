//
//  ZHDDetailContainerVCContext.h
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHDDetailContainerVCContext : NSObject <UIViewControllerContextTransitioning>

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController goingDown:(BOOL) goingDown;

@property (nonatomic, copy) void (^completionBlock)(BOOL didComplete);
@property (nonatomic, assign, getter = isAnimated) BOOL animated;
@property (nonatomic, assign, getter = isInteractive) BOOL interactive;

@end
