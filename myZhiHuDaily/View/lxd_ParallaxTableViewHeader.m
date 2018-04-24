//
//  lxd_ParallaxTableViewHeader.m
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import "lxd_ParallaxTableViewHeader.h"
#import "UIImageView+WebCache.h"

#define kPageControlH 20

@interface lxd_ParallaxTableViewHeader() <UIScrollViewDelegate>

{
    CGRect initialFrame;
    CGFloat defaultViewHeight;
}

@property (nonatomic, strong) UIScrollView *imgLayer;
@property (nonatomic, strong) UIScrollView *textLayer;
@property (nonatomic, strong) NSArray *imgURLStrs;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) NSUInteger numberPages;
@property (nonatomic, assign) NSInteger indexCurrent;

@property (nonatomic, strong) UIImageView *prevImgView;
@property (nonatomic, strong) UIImageView *currentImgView;
@property (nonatomic, strong) UIImageView *nextImgView;

@property (nonatomic, strong) UILabel *prevTitleLabel;
@property (nonatomic, strong) UILabel *currentTitleLabel;
@property (nonatomic, strong) UILabel *nextTitleLabel;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) Callback tapCallback;

@end


@implementation lxd_ParallaxTableViewHeader


-(instancetype) initWithFrame:(CGRect)frame  tapCallback: (Callback) block {
    self = [super initWithFrame:frame];
    if (self) {
        _indexCurrent = 0;
        self.tapCallback = block;
        [self customInit];
        [self setPanPressAction];
        
        initialFrame       = frame;
        defaultViewHeight  = initialFrame.size.height;
        
    }
    return self;
}

-(void)customInit{
    
    float selfWidth = CGRectGetWidth(self.bounds);
    float selfHeight = CGRectGetHeight(self.bounds);
    
    _imgLayer                                = [[UIScrollView alloc] initWithFrame:self.bounds];
    _imgLayer.pagingEnabled                  = YES;
    _imgLayer.bounces                        = NO;
    _imgLayer.showsHorizontalScrollIndicator = NO;
    _imgLayer.showsVerticalScrollIndicator   = NO;
    _imgLayer.delegate                       = self;

    _prevImgView    = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, selfWidth, selfHeight) ];
    _currentImgView = [[UIImageView alloc] initWithFrame:CGRectMake(selfWidth, 0, selfWidth, selfHeight) ];
    _nextImgView    = [[UIImageView alloc] initWithFrame:CGRectMake(selfWidth * 2, 0, selfWidth, selfHeight) ];
    
    _prevImgView.contentMode      = UIViewContentModeScaleAspectFill;
    _prevImgView.clipsToBounds    = YES;
    _currentImgView.contentMode   = UIViewContentModeScaleAspectFill;
    _currentImgView.clipsToBounds = YES;
    _nextImgView.contentMode      = UIViewContentModeScaleAspectFill;
    _nextImgView.clipsToBounds    = YES;
    
    UIFont *titleFont = [UIFont boldSystemFontOfSize:22];
    UIColor *titleColor = [UIColor whiteColor];
    
    _prevTitleLabel                  = [[UILabel alloc] init];
    _prevTitleLabel.numberOfLines    = 0;
    _prevTitleLabel.font             = titleFont;
    _prevTitleLabel.textColor        = titleColor;

    _currentTitleLabel               = [[UILabel alloc] init];
    _currentTitleLabel.numberOfLines = 0;
    _currentTitleLabel.font          = titleFont;
    _currentTitleLabel.textColor     = titleColor;

    _nextTitleLabel                  = [[UILabel alloc] init];
    _nextTitleLabel.numberOfLines    = 0;
    _nextTitleLabel.font             = titleFont;
    _nextTitleLabel.textColor        = titleColor;


    [_prevImgView addSubview:_prevTitleLabel];
    [_currentImgView addSubview:_currentTitleLabel];
    [_nextImgView addSubview:_nextTitleLabel];

    [self layoutTitleLables];

    [_imgLayer addSubview:_prevImgView];
    [_imgLayer addSubview:_currentImgView];
    [_imgLayer addSubview:_nextImgView];


    [self addSubview:_imgLayer];

    _pageControl =[[ UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - kPageControlH, self.frame.size.width, kPageControlH)];
    [self addSubview:_pageControl];
    if (_imgURLStrs.count <= 1) {
        _pageControl.hidden = YES;
    }
}

-(void)setAdWithImgUrls:(NSArray *)imgUrls andTitles:(NSArray *) titles {
    
    _imgURLStrs              = imgUrls;
    _titles                  = titles;
    _indexCurrent            = 0;
    _pageControl.currentPage = 0;
    [self loadView];
}

-(void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    _pageControl.currentPageIndicatorTintColor = _currentPageIndicatorTintColor;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (_imgLayer) {
        [_imgLayer setFrame:self.bounds];
        
        CGRect imgRect          = _currentImgView.frame;
        imgRect.size.height     = self.bounds.size.height;
        [_currentImgView setFrame: imgRect];

        CGRect imgRectPrev      = _prevImgView.frame;
        imgRectPrev.size.height = self.bounds.size.height;
        [_prevImgView setFrame: imgRectPrev];

        CGRect imgRectNext      = _nextImgView.frame;
        imgRectNext.size.height = self.bounds.size.height;
        [_nextImgView setFrame: imgRectNext];
       
        if (_imgURLStrs.count <= 1) {
            _imgLayer.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
            [_imgLayer setContentOffset:CGPointMake(0, 0) animated:NO];
        } else {
            _imgLayer.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);
            [_imgLayer setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
        }
    }
    if (NO == _pageControl.hidden) {
        [_pageControl setFrame:CGRectMake(0, self.frame.size.height - kPageControlH, self.frame.size.width, kPageControlH)];
    }
}

- (void)setPanPressAction {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleActionForTapPressGesture:)];
    
    [self addGestureRecognizer:tapGesture];
}

- (void)_handleActionForTapPressGesture:(UITapGestureRecognizer *)gesture {
    if (_tapCallback) {
         _tapCallback(_indexCurrent);
    }
}

-(void)loadView {
    [self loadPageControl];
    [self loadImgLayer];
    [self loadTextLayer];
    [self setNeedsLayout];
}

-(void)loadPageControl {
    if (_pageControl) {
        if (_imgURLStrs.count > 1 ) {
            _pageControl.numberOfPages = _imgURLStrs.count;
            [_pageControl setCurrentPage:0];
            _pageControl.hidden = NO;
        }else{
            _pageControl.hidden = YES;
        }
    }
}

-(void)loadImgLayer {
    if (_indexCurrent >= (int)_imgURLStrs.count) {
        _indexCurrent = 0;
    }
    if (_indexCurrent < 0) {
        _indexCurrent = (int)_imgURLStrs.count - 1;
    }
    NSInteger prev = _indexCurrent - 1;
    if (prev < 0) {
        prev = (int)_imgURLStrs.count - 1;
    }
    NSInteger next = _indexCurrent + 1;
    if (next > _imgURLStrs.count - 1) {
        next = 0;
    }
    
    _pageControl.currentPage = _indexCurrent;
    NSString *prevStr        = [_imgURLStrs objectAtIndex:prev];
    NSString *curStr         = [_imgURLStrs objectAtIndex:_indexCurrent];
    NSString *nextStr        = [_imgURLStrs objectAtIndex:next];
    
    [_prevImgView sd_setImageWithURL: [NSURL URLWithString:prevStr]  ];
    [_currentImgView sd_setImageWithURL:[NSURL URLWithString:curStr]];
    [_nextImgView sd_setImageWithURL:[NSURL URLWithString:nextStr]];
    
    [_imgLayer setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
    
    
}

-(void)loadTextLayer{
    
    if (_indexCurrent >= (int)_titles.count) {
        _indexCurrent = 0;
    }
    if (_indexCurrent < 0) {
        _indexCurrent = (int)_titles.count - 1;
    }
    NSInteger prev = _indexCurrent - 1;
    if (prev < 0) {
        prev = (int)_titles.count - 1;
    }
    NSInteger next = _indexCurrent + 1;
    if (next > _titles.count - 1) {
        next = 0;
    }
    
    _pageControl.currentPage = _indexCurrent;
    NSString *prevStr = [_titles objectAtIndex:prev];
    NSString *curStr = [_titles objectAtIndex:_indexCurrent];
    NSString *nextStr = [_titles objectAtIndex:next];
    
    _prevTitleLabel.text = prevStr;
    _currentTitleLabel.text = curStr;
    _nextTitleLabel.text = nextStr;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == _imgLayer) {
        if (scrollView.contentOffset.x >= self.frame.size.width *2 ) {
            _indexCurrent++;
        }
        if (scrollView.contentOffset.x <= 0 ) {
            _indexCurrent--;
        }
    }
    [self loadView];
}

#pragma mark - constrains


- (void)layoutTitleLables {
    [self LeftBottomSubView:_prevTitleLabel to:_prevImgView];
    [self LeftBottomSubView:_currentTitleLabel to:_currentImgView];
    [self LeftBottomSubView:_nextTitleLabel to:_nextImgView];
}

- (void)LeftBottomSubView:(UIView*)subView to:(UIView*)view {
    
    [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *constraintLeft = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.0];
    
    NSLayoutConstraint *constraintRight = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10.0];
    
    NSLayoutConstraint *constraintBottom = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-15.0];
    
    NSArray *constrainArrray = [NSArray arrayWithObjects:constraintLeft, constraintRight, constraintBottom, nil];
    [view addConstraints:constrainArrray];
    
}

@end
