//
//  LBWScrollTitleView.m
//  test
//
//  Created by feerie luxe on 16/4/15.
//  Copyright © 2016年 NN. All rights reserved.
//

#import "LBWScrollTitleView.h"

@interface LBWScrollTitleView ()<UIScrollViewDelegate>
{
    CGFloat _titleViewWidth;
    
    UIView * _scrollModuleView;
    
    TitleViewDidSelectedBlock _titleViewDidSelectedBlock;
}
@end

@implementation LBWScrollTitleView


#pragma mark     初始化方法
-(void)setTitleViewDidSelectedBlock:(TitleViewDidSelectedBlock)block
{
    _titleViewDidSelectedBlock = block;
}

#pragma mark     根据主UIScrollView的偏移量进行位置的修改
-(void)moveScrollModule:(CGFloat)scale
{
    _scrollModuleView.layer.position = CGPointMake(_titleViewWidth/2 + self.frame.size.width * scale, self.frame.size.height);
}


#pragma mark     创建每一个titleView
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    self.backgroundColor = [UIColor whiteColor];
    
    if (_titles)
    {
        CGFloat width = self.contentSize.width?self.contentSize.width:self.frame.size.width;
        
        //计算每一个titleButton的长度
        _titleViewWidth = width/_titles.count;
        
        [_titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(idx * _titleViewWidth, 0, _titleViewWidth, self.frame.size.height)];
            btn.tag = idx;
            [btn addTarget:self action:@selector(titleViewisTouched:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:obj forState:UIControlStateNormal];
            [btn setTitleColor:self.titleViewTextColor?self.titleViewTextColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self addSubview:btn];
        }];
    }
    
    [self createScrollModule];
}

#pragma mark    创建滑动小模块
-(void)createScrollModule
{
    //确定位置
    _scrollModuleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _titleViewWidth * (_scrollModuleWidthScale?_scrollModuleWidthScale:1), _scrollModuleHeight?_scrollModuleHeight:8)];
    _scrollModuleView.backgroundColor = _scrollModuleColor?_scrollModuleColor:[UIColor redColor];
    _scrollModuleView.layer.anchorPoint = CGPointMake(0.5, 1);
    _scrollModuleView.layer.position = CGPointMake(_titleViewWidth/2, self.frame.size.height);
    [self addSubview:_scrollModuleView];
}

#pragma mark     titleView被点击执行的方法
-(void)titleViewisTouched:(UIButton *)btn
{
    
    if (_titleViewDidSelectedBlock)
    {
        NSLog(@"ssssss");
        _titleViewDidSelectedBlock(btn.tag);
    }
}
@end
