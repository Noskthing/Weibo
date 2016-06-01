//
//  CropImageView.h
//  JustForFunOfLee
//
//  Created by feerie luxe on 16/5/31.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^OptionButtonDidSelectedBlock)(UIImage * image);
@interface CropImageView : UIView


-(void)setImage:(UIImage *)image;
-(void)setOptionButtonDidSelectedBlock:(OptionButtonDidSelectedBlock)block;
@end
