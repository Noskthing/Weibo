//
//  PopOverView.m
//  JustForFunOfLee
//
//  Created by apple on 16/1/4.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "PopOverView.h"
#import "UIImage+Addition.h"

@implementation PopOverView

#pragma mark  -初始化操作
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.hidden = YES;
        self.alpha = 0;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame backgroundImage:(UIImage *)image
{
    PopOverView * popOverView = [[PopOverView alloc] initWithFrame:frame];
    
    
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    bgView.image = [image resizeImage];
    [popOverView addSubview:bgView];

    return popOverView;
}


@end
