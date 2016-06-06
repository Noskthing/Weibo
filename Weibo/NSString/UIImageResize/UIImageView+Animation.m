//
//  UIImageView+Animation.m
//  JustForFunOfLee
//
//  Created by feerie luxe on 16/5/31.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "UIImageView+Animation.h"

@implementation UIImageView (Animation)

+ (UIImageView *)rotate90DegreeWithImageView:(UIImageView *)imageView
{
    CABasicAnimation *animation = [ CABasicAnimation
                                   animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:imageView.layer.transform];
    
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:
                         
                         CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.3;
    animation.repeatCount = 1;
    [animation setAutoreverses:NO];
    //在图片边缘添加一个像素的透明区域，去图片锯齿
//    CGRect imageRrect = CGRectMake(0, 0,imageView.frame.size.width, imageView.frame.size.height);
//    UIGraphicsBeginImageContext(imageRrect.size);
//    [imageView.image drawInRect:CGRectMake(1,1,imageView.frame.size.width-2,imageView.frame.size.height-2)];
//    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    imageView.layer.transform = CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0);
    [imageView.layer addAnimation:animation forKey:nil];
    return imageView;
}

+(UIImageView *)imageView:(UIImageView *)imageView rotation:(UIImageOrientation)orientation
{
    CABasicAnimation *animation = [ CABasicAnimation
                                   animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:imageView.layer.transform];
    
    //围绕Z轴旋转，垂直与屏幕
    
    animation.duration = 0.3;
    animation.repeatCount = 1;
    
    switch (orientation)
    {
        case UIImageOrientationLeft:
            animation.toValue = [ NSValue valueWithCATransform3D:
                                 CATransform3DMakeRotation(M_PI_2 + M_PI, 0.0, 0.0, 1.0) ];
            imageView.layer.transform = CATransform3DMakeRotation(M_PI_2 + M_PI, 0.0, 0.0, 1.0);
            break;
        case UIImageOrientationRight:
            animation.toValue = [ NSValue valueWithCATransform3D:
                                 CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
            imageView.layer.transform = CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0);
            break;
        case UIImageOrientationDown:
            animation.toValue = [ NSValue valueWithCATransform3D:
                                 CATransform3DMakeRotation( M_PI, 0.0, 0.0, 1.0) ];
            imageView.layer.transform = CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0);
            break;
        case UIImageOrientationUp:
            animation.toValue = [ NSValue valueWithCATransform3D:
                                 CATransform3DMakeRotation(0, 0.0, 0.0, 1.0) ];
            imageView.layer.transform = CATransform3DMakeRotation(0, 0.0, 0.0, 1.0);
            break;
        default:
            
            break;
    }


    
    [imageView.layer addAnimation:animation forKey:nil];
    return imageView;
}
@end
