//
//  PopOverView.h
//  JustForFunOfLee
//
//  Created by apple on 16/1/4.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopOverView : UIView

@property (nonatomic,strong)UIImage * image;

-(instancetype)initWithFrame:(CGRect)frame backgroundImage:(UIImage *)image;
@end
