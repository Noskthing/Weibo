//
//  LeeScrollViewWithView.m
//  坑爹的疯狂
//
//  Created by Lee on 15/9/13.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "LeeScrollViewWithView.h"


@interface LeeScrollViewWithView ()<UIScrollViewDelegate>
{
    UIView * _view;
    
    getCurrentViewRightBlock _rightBlock;
    getCurrentViewLeftBlock _leftBlock;
    
    NSTimer * _timer;
    NSInteger _interval;
    
    UIView * _leftView;
    UIView * _rightView;
}

@end


@implementation LeeScrollViewWithView


#pragma mark -初始化方法
-(instancetype)initWithFrame:(CGRect)frame andView:(UIView *)view andTimerWithTimeInterval:(NSInteger)interval
{
    if (self = [super initWithFrame:frame])
    {
        //赋值
        _view = view;
        self.contentSize = CGSizeMake(frame.size.width * 3, self.frame.size.height);
        self.delegate = self;
        self.pagingEnabled = YES;
        self.contentOffset = CGPointMake(frame.size.width, 0);
        [self configView];
        if (interval)
        {
            _interval = interval;
            [self startTime];
        }
        
    }
    
    return self;
}

-(void)setgetCurrentViewLeftBlock:(getCurrentViewLeftBlock)leftBlock andgetCurrentViewRightBlock:(getCurrentViewRightBlock)rightBlock
{
    _leftBlock = leftBlock;
    _rightBlock = rightBlock;
}


-(void)setEmptyLeftView:(UIView *)leftView andRightView:(UIView *)rightView
{
    _leftView = leftView;
    _rightView = rightView;
}


#pragma mark -刷新方法
-(void)configView
{
    //移除父视图上所有的子视图
    [self clearSubviews];
    
    //添加当前视图
    UIView * view = _view;
    view.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:view];
    
    //设置左右视图的 frame
    CGRect rightRect = CGRectMake(self.frame.size.width * 2, 0, self.frame.size.width, self.frame.size.height);
    
    CGRect leftRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    
    //如果没有设置则使用系统自定义左右视图
    if (!_rightView)
    {
        UIView * emptyRightView = [[UIView alloc] initWithFrame:rightRect];
        [self addSubview:emptyRightView];
        
        UIView * emptyLeftView = [[UIView alloc] initWithFrame:leftRect];
        [self addSubview:emptyLeftView];
    }
    
    //将设置的左右视图加载进父视图
    _rightView.frame = rightRect;
    [self addSubview:_rightView];
    _leftView.frame = leftRect;
    [self addSubview:_leftView];
    
    //改变偏移量
    self.contentOffset = CGPointMake(self.frame.size.width, 0);
    
}

#pragma mark -清空父视图
-(void)clearSubviews
{
    NSArray * arr = [self subviews];
    for (UIView * view in arr)
    {
        [view removeFromSuperview];
    }
}

#pragma mark -定时器设置
-(void)startTime
{
    _timer = [NSTimer timerWithTimeInterval:_interval target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

-(void)autoScroll
{
    CGFloat offSet = self.frame.size.width * 2;
    [self setContentOffset:CGPointMake(offSet, 0) animated:YES];
}



#pragma mark -代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //获取滚动视图偏移量
    CGPoint offSet = self.contentOffset;
    
    
    //根据偏移量修改_currentPage
    if(offSet.x >= self.frame.size.width *2)
    {
        _view = _rightBlock();
        [self configView];
    }
    if(offSet.x <= 0)
    {
        _view = _leftBlock();
        [self configView];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //获取滚动视图偏移量
    CGPoint offSet = self.contentOffset;
    
    //根据偏移量修改_currentPage
    if(offSet.x >= self.frame.size.width *2)
    {
        _view = _rightBlock();
        [self configView];
    }
    if(offSet.x <= 0)
    {
        _view = _leftBlock();
        [self configView];
    }
}

//视图将要滚动  停止计时器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    if (_interval)
    {
        [_timer invalidate];
    }
}


//视图将要停止滚动   重新配置计时器
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (_interval)
    {
        [self startTime];
    }

}


@end
