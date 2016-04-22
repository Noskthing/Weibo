//
//  LBWScrollComponentView.m
//  test
//
//  Created by feerie luxe on 16/4/13.
//  Copyright © 2016年 NN. All rights reserved.
//

#import "LBWScrollComponentView.h"

@interface LBWScrollComponentView ()<UIScrollViewDelegate>

@end

@implementation LBWScrollComponentView

#pragma mark    初始化方法
+(instancetype)lbwScrollComponentViewWithFrame:(CGRect)frame
{
    LBWScrollComponentView * view = [[LBWScrollComponentView alloc] initWithFrame:frame];
    return view;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //创建UIScrollView
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_scrollView];
        //三倍宽
        _scrollView.contentSize = CGSizeMake(frame.size.width * 3, frame.size.height);
        //翻页
        _scrollView.pagingEnabled = YES;
        //偏移量
        _scrollView.contentOffset = CGPointMake(frame.size.width, 0);
        //滚动条永远关闭
        _scrollView.showsVerticalScrollIndicator = FALSE;
        _scrollView.showsHorizontalScrollIndicator = FALSE;
        //代理
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor redColor];
        
//        UIPageControl * pageController = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - 50, frame.size.width, 50)];
//        pageController.numberOfPages = 4;
//        [self addSubview:pageController];
    }
    return self;
}

#pragma mark  辅助功能方法
-(void)clearScrollView
{
    [_scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}

#pragma mark      偏移代理函数
-(void)scrollViewWillTurnPage
{
    NSLog(@"开始翻页");
}

-(void)scrollViewDidTurnPage
{
    NSLog(@"翻页结束");
    _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
}

-(void)scrollViewDidTurnPageToLeft
{
    NSLog(@"右翻页");
}

-(void)scrollViewDidTurnPageToRight
{
    NSLog(@"左翻页");
}

#pragma mark     代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //获取偏移量
    CGPoint offSet= scrollView.contentOffset;
    //根据偏移量修改_currentPage
    //换页
    if(fabs(offSet.x - self.frame.size.width) >= self.frame.size.width)
    {
        [self scrollViewWillTurnPage];
        //右翻页
        if(offSet.x >= self.frame.size.width *2)
        {
            [self scrollViewDidTurnPageToLeft];
        }
        //左翻页
        else
        {
            [self scrollViewDidTurnPageToRight];
        }
        [self scrollViewDidTurnPage];
    }
}
@end
