//
//  ZHDHomeTableViewCell.m
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//
#import <SDWebImage/UIImageView+WebCache.h>
#import "ZHDHomeTableViewCell.h"
#import "ModelStory.h"

@interface ZHDHomeTableViewCell()

{
    UIImageView *_multipic;
}

@end

@implementation ZHDHomeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _storyImg               = [[UIImageView alloc] init];
        _storyImg.contentMode   = UIViewContentModeScaleAspectFill;
        _storyImg.clipsToBounds = YES;
        [self rightSubView:_storyImg to:self.contentView];
        _title                        = [[UILabel alloc] init];
        _title.textAlignment          = NSTextAlignmentLeft;
        _title.userInteractionEnabled = NO;
        _title.font                   = [UIFont boldSystemFontOfSize:16];
        _title.numberOfLines          = 0;
       // _title.scrollEnabled          = NO;
        [self.contentView addSubview:_title];
        [self setConstraintForTitleLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _multipic           = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ZHD.bundle/Home_Morepic.png"]];
        [self rightBottomSubView:_multipic to:_storyImg];
        _multipic.hidden    = YES;
    }
    return self;
}

-(void)setStory: (ModelStory *)story {
    [ _storyImg sd_setImageWithURL:[story.images objectAtIndex:0] placeholderImage:[UIImage imageNamed:@"ZHD.bundle/Management_Placeholder.png"]];
    if (story.readed) {
        _title.textColor = [UIColor grayColor];
    } else {
        _title.textColor = [UIColor blackColor];
    }
    [_title setText:story.title];
    
    if (story.multipic == YES) {
        _multipic.hidden = NO;
    }else{
        _multipic.hidden = YES;
    }
}

- (void)rightBottomSubView:(UIView*)subView to:(UIView*)view {
    [view addSubview:subView];
    [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    NSArray *constrainArrray        = [NSArray arrayWithObjects:constraint3,constraint4, nil];
    [view addConstraints:constrainArrray];
}

- (void)rightSubView:(UIView*)subView to:(UIView*)view {
    [view addSubview:subView];
    [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10];
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80]
    ;
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10];
    NSLayoutConstraint *constraint5 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:10];

    NSArray *constrainArrray        = [NSArray arrayWithObjects:constraint1,constraint3 ,constraint4,constraint5, nil];
    [view addConstraints:constrainArrray];
}

- (void)setConstraintForTitleLabel{
    [_title setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:_title attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_storyImg attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-15];
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:_title attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10]
    ;
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:_title attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10];
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:_title attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:10];

    NSArray *constrainArrray        = [NSArray arrayWithObjects:constraint1,constraint2 ,constraint3,constraint4, nil];
    [self.contentView addConstraints:constrainArrray];
}




@end
