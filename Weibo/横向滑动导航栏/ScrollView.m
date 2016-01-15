
//
//  ScrollView.m
//  test
//
//  Created by mac on 15/9/16.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "ScrollView.h"


@interface ScrollView ()<UIScrollViewDelegate>
{
    NSArray * _views;
    OffsetChangeBlock _block;
}

@end
@implementation ScrollView

#pragma mark -初始化方法
-(void)setOffsetChangeBlock:(OffsetChangeBlock)block views:(NSArray *)arr
{
    _block = block;
    _views = arr;
}



#pragma mark -按比例偏移
-(void)scrollWithScale:(CGFloat)scale
{
    CGPoint offSet = CGPointMake(scale*self.contentSize.width, 0);
    [UIView animateWithDuration:0.5 animations:^{
        self.contentOffset = offSet;
    }];
    
}



#pragma mark -布局Views
-(void)layoutSubviews
{
    //设置scrollView基本属性
    self.contentSize = CGSizeMake(self.frame.size.width *_views.count, self.frame.size.height);
    self.delegate = self;
    self.pagingEnabled = YES;
    
    //布局
    for (int i = 0; i<_views.count; i++)
    {
        UIView * view = _views[i];
        view.frame = CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:view];
    }
}

#pragma mark -代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //获取滚动视图偏移量
    CGPoint offSet = self.contentOffset;
    
    CGFloat scale = offSet.x/self.contentSize.width;
    
    _block(scale);
    
}

@end
