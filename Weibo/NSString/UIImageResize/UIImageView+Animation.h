//
//  UIImageView+Animation.h
//  JustForFunOfLee
//
//  Created by feerie luxe on 16/5/31.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Animation)

+ (UIImageView *)rotate90DegreeWithImageView:(UIImageView *)imageView;

+ (UIImageView *)imageView:(UIImageView *)imageView rotation:(UIImageOrientation)orientation;
@end
