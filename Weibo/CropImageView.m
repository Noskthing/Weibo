//
//  CropImageView.m
//  JustForFunOfLee
//
//  Created by feerie luxe on 16/5/31.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "CropImageView.h"

@interface CropImageView ()
{
    UIScrollView * _scrollView;
}
@end

@implementation CropImageView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _scrollView = [[UIScrollView alloc] init];
        [self addSubview:_scrollView];
        
        //创建分割线
        CGFloat space = (frame.size.width - 4)/3;
        
        for (NSInteger i = 0; i < 2; i++)
        {
            UIView * row = [[UIView alloc] initWithFrame:CGRectMake((space + 2) * i + space, 0, 2, frame.size.width)];
            row.backgroundColor = [UIColor whiteColor];
            [self addSubview:row];
            
            UIView * column = [[UIView alloc] initWithFrame:CGRectMake(0, (space + 2) * i + space, frame.size.width, 2)];
            column.backgroundColor = [UIColor whiteColor];
            [self addSubview:column];
        }
    }
    
    return self;
}
@end
