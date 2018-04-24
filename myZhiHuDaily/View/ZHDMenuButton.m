//
//  ZHDMenuButton.m
//  myZhiHuDaily
//
//  Created by 刘 晓东 on 16/4/28.
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import "ZHDMenuButton.h"

static const CGFloat KSImageScale = 1.0f;

@implementation ZHDMenuButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - 设置按钮内部图片和文字的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat W = contentRect.size.width;
    CGFloat H = contentRect.size.height * KSImageScale;
    return CGRectMake(0, 0, W, H );
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat W = contentRect.size.width;
    CGFloat H = contentRect.size.height * KSImageScale;
    CGFloat y = contentRect.size.height - H + H;
    return CGRectMake(0, y, W, H);
}

@end
