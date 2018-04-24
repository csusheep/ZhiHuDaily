//
//  ZHDDetailContainerViewContoller.h
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KDirection){
    KDirectionUp,
    KDirectionDown,
    KDirectionLeft,
    KDirectionRight
};

@interface ZHDDetailContainerViewContoller : UIViewController

@property(nonatomic, strong, readonly) UIViewController *showedViewController;

- (instancetype)initWithShowedViewController:(UIViewController *)showedViewController withIndexPath:(NSIndexPath *) indexPath;

- (void) gotoNextViewController;

- (void) gotoPrevViewController;

@end
