//
//  ZHDDetailViewController.m
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import "ZHDDetailViewController.h"
#import "ModelManager.h"
#import "ZHDHttpProxy.h"
#import <MJRefresh.h>
#import "UIImageView+WebCache.h"
#import "LXDActivityIndicator.h"

@interface ZHDDetailViewController()<UIScrollViewDelegate, UIWebViewDelegate>
{
    CGFloat _headHeight;
    NSInteger _webViewH;
    CGRect _initialFrame;
    CGFloat _defaultViewHeight;
}

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIImageView *storyImageView;

@property (nonatomic, strong) UILabel *storyTitle;

@property (nonatomic, weak) UIViewController *contrainerVC;

@property (nonatomic, strong) LXDActivityIndicator * activityIndiCator;



@end

@implementation ZHDDetailViewController


- (instancetype) initWithStory:(ModelStory *)story {
    self = [super init];
    if (self) {
        _story = story;
    }
    return self;
}

- (void) willMoveToParentViewController:(UIViewController *)parent {
    
    if (nil == parent) {
        return;
    }
    self.contrainerVC = parent;
    PKLog(@"willMoveToParentViewController: %@", parent);
    
    
    __weak typeof(_webView.scrollView) wscrollview = _webView.scrollView;
    __weak typeof(self) wself = self;
    _webView.scrollView.mj_header.refreshingBlock = ^{
        [wscrollview.mj_header endRefreshing];
        __strong  typeof(self) swself = wself;
        if ([swself.contrainerVC respondsToSelector:@selector(gotoPrevViewController)]) {
           [swself.contrainerVC performSelector:@selector(gotoPrevViewController)];
            PKLog(@"responds to selector gotoPrevViewController");
        }
    };
    
    _webView.scrollView.mj_footer.refreshingBlock = ^{
        [wscrollview.mj_footer endRefreshing];
        __strong  typeof(self) swself = wself;
        if ([swself.contrainerVC respondsToSelector:@selector(gotoNextViewController)]) {
            [swself.contrainerVC performSelector:@selector(gotoNextViewController)];
            PKLog(@"responds to selector gotoNextViewController");
        }
    };
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    CGRect mainSreenBounds = [[UIScreen mainScreen] bounds];
    _headHeight            = 220;
    _webViewH              = mainSreenBounds.size.height;

    _storyImageView               = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mainSreenBounds.size.width, _headHeight)];
    _storyImageView.contentMode   = UIViewContentModeScaleAspectFill;
    _storyImageView.clipsToBounds = YES;
    
    _storyTitle               = [[UILabel alloc] init];
    _storyTitle.numberOfLines = 0;
    _storyTitle.font          = [UIFont boldSystemFontOfSize:22];
    _storyTitle.textColor     = [UIColor whiteColor];
    
    [_storyImageView addSubview:_storyTitle];
    [_storyTitle setTranslatesAutoresizingMaskIntoConstraints:NO];

    NSLayoutConstraint *constraintLeft   = [NSLayoutConstraint constraintWithItem:_storyTitle attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_storyImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.0];
    NSLayoutConstraint *constraintRight  = [NSLayoutConstraint constraintWithItem:_storyTitle attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_storyImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10.0];
    NSLayoutConstraint *constraintBottom = [NSLayoutConstraint constraintWithItem:_storyTitle attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_storyImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-15.0];
    NSArray *constrainArrray             = [NSArray arrayWithObjects:constraintLeft, constraintRight, constraintBottom, nil];
    [_storyImageView addConstraints:constrainArrray];

    _initialFrame       = _storyImageView.frame;
    _defaultViewHeight  = _initialFrame.size.height;
    
    _webView                             = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, mainSreenBounds.size.width, mainSreenBounds.size.height)];
    _webView.delegate                    = self;
    _webView.scrollView.delegate         = self;
    _webView.scrollView.decelerationRate = 1.0;
    _webView.scrollView.contentInset     = UIEdgeInsetsMake(-20, 0, 0, 0);

    [self.view addSubview:_webView];
    [_webView.scrollView addSubview:_storyImageView];
    
    __weak typeof(_webView.scrollView) wscrollview = _webView.scrollView;
    
    _webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [wscrollview.mj_header endRefreshing];
    }];
    _webView.scrollView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        [wscrollview.mj_footer endRefreshing];
    }];
    
    _activityIndiCator = [[LXDActivityIndicator alloc] initWithTintColor:[UIColor grayColor]];
    _activityIndiCator.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2);
    
    [self.view addSubview:_activityIndiCator];
    [_activityIndiCator startAnimating];
    
    [self loadHTML];
    
    self.story.readed = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY           = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1;
    _initialFrame.size.height = _defaultViewHeight + offsetY;
    _initialFrame.origin.y    = -offsetY;
    _storyImageView.frame     = _initialFrame;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    PKLog(@"webViewDidFinishLoad");
}

- (void)loadHTML {
    if (0 == _story.ID) {
        PKLog(@"_storyID is invalid") ;
    }
    
    NSString *templatePath = [[NSBundle mainBundle] pathForResource:@"template" ofType:@"html"];
    NSMutableString *html  = [[NSMutableString alloc] initWithContentsOfFile:templatePath encoding:NSUTF8StringEncoding error:nil];

    [[ZHDHttpProxy SharedProxy] requestStoryDetailByID:[_story.ID integerValue] withBlock:^(id data) {
        ModelStoryDetail *detail = (ModelStoryDetail *)data;
        [_storyImageView sd_setImageWithURL:[NSURL URLWithString:detail.image]];
        _storyTitle.text = detail.title;
        
        PKLog(@"replace begin") ;
        [html replaceOccurrencesOfString:@"lxd_key_body" withString:detail.body options:NSCaseInsensitiveSearch range:NSMakeRange(0, html.length)];
        [html replaceOccurrencesOfString:@"lxd_key_css" withString:detail.css[0] options:NSCaseInsensitiveSearch range:NSMakeRange(0, html.length)];
        PKLog(@"replace end") ;
        
        PKLog(@"loadHTMLString begin");
        [_webView loadHTMLString:html baseURL:nil];
        [self stopAI];
        PKLog(@"loadHTMLString end");
        
    } Failure:^(NSError *error) {
        [self stopAI];
    }];
}

- (void)stopAI {
    [_activityIndiCator stopAnimating];
    [_activityIndiCator removeFromSuperview];
    _activityIndiCator = nil;
}


@end
