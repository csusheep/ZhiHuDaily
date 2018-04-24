//
//  ZHDDetailContainerVCContext.m
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import "ZHDDetailContainerVCContext.h"

@interface ZHDDetailContainerVCContext ()

@property (nonatomic, strong) NSDictionary *viewContainers;
@property (nonatomic, assign) CGRect privateDisappearingFromRect;
@property (nonatomic, assign) CGRect privateAppearingFromRect;
@property (nonatomic, assign) CGRect privateDisappearingToRect;
@property (nonatomic, assign) CGRect privateAppearingToRect;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, assign) UIModalPresentationStyle presentationStyle;

@end

@implementation ZHDDetailContainerVCContext

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController goingDown:(BOOL) nextPage {
    self = [super init];
    if (self) {
        self.presentationStyle           = UIModalPresentationCustom;
        self.containerView               = fromViewController.view.superview;
        CGFloat travelDistance           = (nextPage ? -self.containerView.bounds.size.height : self.containerView.bounds.size.height);
        self.privateDisappearingFromRect = self.privateAppearingToRect = self.containerView.bounds;
        self.privateAppearingFromRect    = CGRectOffset(self.containerView.bounds, 0, -travelDistance);
        self.privateDisappearingToRect   = CGRectOffset(self.containerView.bounds, 0, travelDistance);
        self.viewContainers              = @{UITransitionContextFromViewControllerKey  : fromViewController,
                                             UITransitionContextToViewControllerKey    : toViewController,
                                             };
    }
    return self;
}


- (BOOL)transitionWasCancelled {
    return NO;
}

// It only makes sense to call these from an interaction controller that
// conforms to the UIViewControllerInteractiveTransitioning protocol and was
// vended to the system by a container view controller's delegate or, in the case
// of a present or dismiss, the transitioningDelegate.
- (void)updateInteractiveTransition:(CGFloat)percentComplete {}
- (void)finishInteractiveTransition {}
- (void)cancelInteractiveTransition {}

// This must be called whenever a transition completes (or is cancelled.)
// Typically this is called by the object conforming to the
// UIViewControllerAnimatedTransitioning protocol that was vended by the transitioning
// delegate.  For purely interactive transitions it should be called by the
// interaction controller. This method effectively updates internal view
// controller state at the end of the transition.
- (void)completeTransition:(BOOL)didComplete {
    if (self.completionBlock) {
        _completionBlock(didComplete);
    }
}


// Currently only two keys are defined by the
// system - UITransitionContextToViewControllerKey, and
// UITransitionContextFromViewControllerKey.
// Animators should not directly manipulate a view controller's views and should
// use viewForKey: to get views instead.
- (nullable __kindof UIViewController *)viewControllerForKey:(NSString *)key {
    return [self.viewContainers objectForKey:key];
}
// The frame's are set to CGRectZero when they are not known or
// otherwise undefined.  For example the finalFrame of the
// fromViewController will be CGRectZero if and only if the fromView will be
// removed from the window at the end of the transition. On the other
// hand, if the finalFrame is not CGRectZero then it must be respected
// at the end of the transition.
- (CGRect)initialFrameForViewController:(UIViewController *)vc {
    if (vc == [self viewControllerForKey:UITransitionContextToViewControllerKey]) {
        return self.privateAppearingFromRect;
    } else {
        return self.privateDisappearingFromRect;
    }
    
}
- (CGRect)finalFrameForViewController:(UIViewController *)vc {
    if (vc == [self viewControllerForKey:UITransitionContextToViewControllerKey]) {
        return self.privateAppearingToRect;
    } else {
        return self.privateDisappearingToRect;
    }
}

@end
