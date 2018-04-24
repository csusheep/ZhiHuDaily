//
//  ZHDDetailContainerViewContoller.m
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import "ZHDDetailContainerViewContoller.h"
#import "ZHDDetailViewController.h"
#import "ModelManager.h"
#import "ZHDAnimatedTransition.h"
#import "ZHDDetailContainerVCContext.h"

typedef struct indexpath {
    NSInteger section;
    NSInteger row;
}ZHDIndexpath ;

@interface ZHDDetailContainerViewContoller()

{
    ZHDIndexpath _ipath;
}

@property (nonatomic, strong) UIView *menu;
@property (nonatomic, strong) UIView *privateContainerView;
@property (nonatomic, strong) UIViewController *firstShowedVC;

@end

@implementation ZHDDetailContainerViewContoller

- (instancetype)initWithShowedViewController:(UIViewController *)showedViewController withIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(showedViewController);
    NSParameterAssert(indexPath);
    self =  [super init];
    if (self) {
        self.firstShowedVC = showedViewController;
        _ipath.row         = indexPath.row;
        _ipath.section     = indexPath.section;
    }
    return self;
}

- (void)loadView {
    // Add  container and buttons views.
    UIView *rootView         = [[UIView alloc] init];
    rootView.backgroundColor = [UIColor blackColor];
    rootView.opaque          = YES;
    
    self.privateContainerView                 = [[UIView alloc] init];
    self.privateContainerView.backgroundColor = [UIColor blackColor];
    self.privateContainerView.opaque          = YES;
    
    [self.privateContainerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [rootView addSubview:self.privateContainerView];

    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateContainerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateContainerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateContainerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateContainerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    self.view = rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showedViewController = self.firstShowedVC;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.view bringSubviewToFront:self.navigationController.navigationBar];
}

- (void)setShowedViewController:(UIViewController *)showedViewController {
    NSParameterAssert(showedViewController);
    [self _transitionToChildViewController:showedViewController nextPage:NO];
    _showedViewController = showedViewController;
}

- (void) gotoNextViewController {
    [self _transitionToChildViewController:[self nextViewController] nextPage:YES];
}

- (void) gotoPrevViewController {
    [self _transitionToChildViewController:[self prevViewController] nextPage:NO];
}


- (void)_transitionToChildViewController:(UIViewController *)toViewController nextPage:(BOOL)nextPage {
    if (nil == toViewController) {
        return;
    }
    UIViewController *fromViewController = ([self.childViewControllers count] > 0 ? self.childViewControllers[0] : nil);
    if (toViewController == fromViewController || ![self isViewLoaded]) {
        return;
    }
    
    UIView *toView          = toViewController.view;
    [toView setTranslatesAutoresizingMaskIntoConstraints:YES];
    toView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    toView.frame            = self.privateContainerView.bounds;
    
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    
    if (!fromViewController) { // for the initial
        [self.privateContainerView addSubview:toView];
        [toViewController didMoveToParentViewController:self];
        return;
    }
    //animate
    id<UIViewControllerAnimatedTransitioning> animator = [[ZHDAnimatedTransition alloc] init];
    ZHDDetailContainerVCContext *transitionContext = [[ZHDDetailContainerVCContext alloc] initWithFromViewController:fromViewController toViewController:toViewController goingDown:nextPage];
    transitionContext.animated        = YES;
    transitionContext.interactive     = NO;
    transitionContext.completionBlock = ^(BOOL didComplete){
        [fromViewController.view removeFromSuperview];
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
        if ([animator respondsToSelector:@selector(animationEnded:)]) {
            [animator animationEnded:didComplete];
        }
    };
    [animator animateTransition:transitionContext];
}

- (UIViewController *) nextViewController{
    
    ModelManager *mm  = [ModelManager sharedModelManager];
    NSArray *sections = mm.zhdSections;
    NSInteger section = _ipath.section;
    ModelSection *ms  = [sections objectAtIndex:section];
    NSInteger row     = _ipath.row + 1;
    ZHDDetailViewController *tmpVC = nil;
    if (row > ms.stories.count -1 ) {
        section = section + 1;
        if (section > sections.count - 1) {
            tmpVC = nil;
        } else {
            ModelSection *ms     = [sections objectAtIndex:section];
            row                  = 0;
            ModelStory *tmpStory = [ms.stories objectAtIndex:row];
            tmpVC                = [[ZHDDetailViewController alloc] initWithStory:tmpStory];
            _ipath.section       = section;
            _ipath.row           = row;
        }
    } else {
        ModelSection *ms     = [sections objectAtIndex:section];
        ModelStory *tmpStory = [ms.stories objectAtIndex:row];
        tmpVC                = [[ZHDDetailViewController alloc] initWithStory:tmpStory ];
        _ipath.row           = row;
    }
    return tmpVC;
}

- (UIViewController *) prevViewController{
    
    ModelManager *mm  = [ModelManager sharedModelManager];
    NSArray *sections = mm.zhdSections;
    NSInteger section = _ipath.section;
    NSInteger row     = _ipath.row - 1;
    ZHDDetailViewController *tmpVC = nil;

    if (row < 0) {
        section = section - 1;
        if (section < 0) {
            tmpVC   = nil;
            section = 0;
            row     = 0;
        } else {
            ModelSection *ms     = [sections objectAtIndex:section];
            row                  = [ms.stories count] - 1;
            ModelStory *tmpStory = [ms.stories objectAtIndex:row];
            tmpVC                = [[ZHDDetailViewController alloc] initWithStory:tmpStory ];
            _ipath.section       = section;
            _ipath.row           = row;
        }
    } else {
        ModelSection *ms     = [sections objectAtIndex:section];
        ModelStory *tmpStory = [ms.stories objectAtIndex:row];
        tmpVC                = [[ZHDDetailViewController alloc] initWithStory:tmpStory ];
        _ipath.section       = section;
        _ipath.row           = row;
    }
    return tmpVC;
}

@end
