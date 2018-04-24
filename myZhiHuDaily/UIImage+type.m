//
//  UIImage.m
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import "UIImage+type.h"

@implementation UIImage(type)


+( kUIImageType )typeOfUIImageWithData: (NSData*)data{
    
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return UIImageTypeJEPG;
        case 0x89:
            return UIImageTypePNG;
        case 0x47:
            return UIImageTypeGIF;
        case 0x49:
        case 0x4D:
            return UIImageTypeTIFF;
    }
    return UIImageTypeUnkow;
    
}




@end
