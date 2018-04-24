//
//  SplashScreenController.m
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "UIDevice+Resolution.h"
#import "ZHDSplashScreenController.h"
#import "ZHDHttpProxy.h"
#import "UIImage+type.h"
#import "LXDMacros.h"

#import "ZHDHomeViewController.h"
#import "ZHDSlipMenuViewController.h"
#import "MMDrawerController.h"

#define DEFAULT_SPLASHIMAGE_DIR @"defaultSplash.png"
#define K_SPLASH_INFO_TEXT @"kSplashInfoText"
#define SPLASH_INFO_TEXT_DEFAULT @"Sheldon"

@interface ZHDSplashScreenController()

{
    NSString *splashImageDIR;
}

-(void)saveSplashImage:(UIImage*)image  atPath:(NSString *)path;

@end

@implementation ZHDSplashScreenController


+(void) loadSplash{
    
    ZHDSplashScreenController * splashVC = [[ZHDSplashScreenController alloc] init];

    UIViewController *rootVC             = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC              = nil;

    if ([rootVC isKindOfClass:[UINavigationController class]]) {
    UINavigationController *rootNav      = (UINavigationController *)rootVC;
    topVC                                = [rootNav topViewController];
    } else if ([rootVC isKindOfClass:[MMDrawerController class]]) {
    topVC                                = ((MMDrawerController *)rootVC).centerViewController;
        if ([topVC isKindOfClass:[UINavigationController class]]) {
    topVC                                = [((UINavigationController *)topVC) topViewController];
        }
    } else {
    topVC                                = rootVC;
    }
    [topVC addChildViewController:splashVC];
    [topVC.view addSubview:splashVC.view];
    [topVC.view bringSubviewToFront:splashVC.view];
    
}

- (void)viewDidLoad {

    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    _splashImage       = [[UIImageView alloc] init];
    _provenance        = [[UILabel alloc] init];
    [_provenance setTextAlignment:NSTextAlignmentCenter];
    [_provenance setTextColor:[UIColor whiteColor]];
    _provenance.font   = [UIFont systemFontOfSize:10];
    [_splashImage setClipsToBounds:YES];

    [self centeredSubView:_splashImage to:self.view];
    [self centerBottomSubView:_provenance to:self.view];

    NSArray *paths     = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = [paths objectAtIndex:0];
    splashImageDIR     = [document stringByAppendingPathComponent:DEFAULT_SPLASHIMAGE_DIR];
}

-(void)updateViewConstraints {
    [super updateViewConstraints];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    NSString *resulotion = nil;

    if ([UIDevice isRunningOniPhoneRetina]) {
    resulotion           = @"480*728";
    }else if ([UIDevice isRunningOniPhone5]){
    resulotion           = @"720*1184";
    }else if ([UIDevice isRunningOniPhone6]){
    resulotion           = @"720*1184";
    }else if ([UIDevice isRunningOniPhone6s]){
    resulotion           = @"1080*1776";
    }else{
    resulotion           = @"1080*1776";
    }

    NSString *splashImageUrl    = [NSString stringWithFormat:StartPicURL_SSL , resulotion];
    __weak __typeof(self) wself = self;
    
    [[ZHDHttpProxy SharedProxy] requestWithURL:splashImageUrl method:ZHDGET paras:nil type:ZHDHttpResponseType_Json success:^(AFHTTPRequestOperation *operation, id resultObject) {
        resultObject              = (NSDictionary*) resultObject;
        NSString *url             = [resultObject objectForKey:@"img"];
        NSString *splashImageInfo = [resultObject objectForKey:@"text"];
        [_provenance setText:splashImageInfo];
        _provenance.alpha         = 0;
        _splashImage.alpha        = 0;
        [_splashImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage: [UIImage imageNamed:@"Default-568h@2x.png"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [wself saveSplashImage:image atPath:splashImageDIR];
            kSaveRegister(K_SPLASH_INFO_TEXT, splashImageInfo);
        }];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:wself.view];
        [self doAnimation];
    } failure:^(NSError *requestErr) {
        UIWindow *window   = [UIApplication sharedApplication].keyWindow;
        _provenance.alpha  = 0;
        _splashImage.alpha = 0;
        UIImage* img       = nil;
        NSString *splashImageInfo = kGetRegister(K_SPLASH_INFO_TEXT);
        if (nil == splashImageInfo) {
            splashImageInfo = [NSString stringWithFormat:@"%@",SPLASH_INFO_TEXT_DEFAULT ];
        }

        if ([[NSFileManager defaultManager] fileExistsAtPath:splashImageDIR]) {
            img             = [UIImage imageWithContentsOfFile:splashImageDIR];
        }
        else{
            img             = [UIImage imageNamed:@"Default-568h@2x.png"];
        }
        [_provenance setText:splashImageInfo];
        [_splashImage setImage:img ];
        [window addSubview:wself.view];
        [self doAnimation];

    }];
}

- (void)doAnimation {
    __weak __typeof(self) wself = self;
    [UIView animateWithDuration:3 delay:.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _provenance.alpha      = 1.0;
        _splashImage.alpha     = 1.0;
        _splashImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1f, 1.1f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
             self.view.backgroundColor = [UIColor clearColor];
            _provenance.alpha      = 0;
            _splashImage.alpha     = 0;
            _splashImage.transform = CGAffineTransformScale(CGAffineTransformScale(CGAffineTransformIdentity, 1.1f, 1.1f), 1.11f, 1.11f);
        } completion:^(BOOL finished) {
            [wself.view removeFromSuperview];
            [wself removeFromParentViewController];
        }];
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)saveSplashImage:(UIImage*)image atPath:(NSString *)path{
    
    if (nil == image || nil == path) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *imgData = UIImagePNGRepresentation(image);
        if (nil == imgData) {
            imgData = UIImageJPEGRepresentation(image, 1.0);
        }
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:path]) {
            [fm removeItemAtPath:path error:nil];
        }
        [fm createFileAtPath:path contents:imgData attributes:nil];
    });
}

- (void)centerBottomSubView:(UIView*)subView to:(UIView*)view {

    [view addSubview:subView];
    [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20];

    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:300.0];

    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20.0];

    NSArray *constrainArrray        = [NSArray arrayWithObjects:constraint1,constraint2,constraint3,constraint4, nil];
    [view addConstraints:constrainArrray];

}

- (void)centeredSubView:(UIView*)subView to:(UIView*)view {
    
    [view addSubview:subView];
    [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];

    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];

    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];

    NSArray *constrainArrray        = [NSArray arrayWithObjects:constraint1,constraint2,constraint3,constraint4, nil];
    [view addConstraints:constrainArrray];
    
}


@end
