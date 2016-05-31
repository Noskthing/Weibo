//
//  UIImage+Addition.h
//  03-QQ聊天界面
//
//  Created by vera on 15/8/15.
//  Copyright (c) 2015年 vera. All rights reserved.
//

#import <UIKit/UIKit.h>


enum {
    enSvCropClip,               // the image size will be equal to orignal image, some part of image may be cliped
    enSvCropExpand,             // the image size will expand to contain the whole image, remain area will be transparent
};
typedef NSInteger SvCropMode;
@interface UIImage (Addition)

/**
 *  返回一个拉伸后的图片
 *
 *  @return <#return value description#>
 */
- (UIImage *)resizeImage;

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;

/*
 * @brief rotate image with radian
 */
- (UIImage*)rotateImageWithRadian:(CGFloat)radian cropMode:(SvCropMode)cropMode;
@end
