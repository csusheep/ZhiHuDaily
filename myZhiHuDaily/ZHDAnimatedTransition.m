//
//  ZHDAnimatedTransition.m
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import "ZHDAnimatedTransition.h"

@implementation ZHDAnimatedTransition

// This is used for percent driven interactive transitions, as well as for container controllers that have companion animations that might need to
// synchronize with the main animation.
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.2;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC    = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC      = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    BOOL nextPage               = ([transitionContext initialFrameForViewController:toVC].origin.y < [transitionContext finalFrameForViewController:toVC].origin.y);
    CGFloat travelDistance      = [transitionContext containerView].bounds.size.height;
    CGAffineTransform transForm = CGAffineTransformMakeTranslation(0, nextPage ? -travelDistance : travelDistance);
    
    [[transitionContext containerView] addSubview:toVC.view];
    toVC.view.alpha     = 0;
    toVC.view.transform = transForm;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]  delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        fromVC.view.transform = CGAffineTransformInvert(transForm);
        fromVC.view.alpha     = 0;
        toVC.view.transform   = CGAffineTransformIdentity;
        toVC.view.alpha       = 1;
    } completion:^(BOOL finished) {
        fromVC.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
