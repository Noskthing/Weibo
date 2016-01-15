//
//  LeeScrollViewWithArray.m
//  掌厨
//
//  Created by Lee on 15/9/13.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "LeeScrollViewWithArray.h"

@interface LeeScrollViewWithArray()<UIScrollViewDelegate>
{
    NSArray * _views;
    NSInteger  _currentPage;
    currentDidSelectedBlock _block;
    ScrollToPageBlock _scrollBlock;
    NSTimer * _timer;
    NSInteger _interval;
}

@end

@implementation LeeScrollViewWithArray

#pragma mark -初始化
-(instancetype)initWithFrame:(CGRect)frame andArray:(NSArray *)views andTimerWithTimeInterval:(NSInteger)interval
{
    if (self = [super initWithFrame:frame])
    {
        //赋值
        _views = views;
        
        self.contentSize = CGSizeMake(frame.size.width * 3, self.frame.size.height);
        self.delegate = self;
        self.pagingEnabled = YES;
        self.contentOffset = CGPointMake(frame.size.width, 0);
        _currentPage = 0;
        [self configView];
        if (interval != 999)
        {
            _interval = interval;
            [self startTime];
        }
        
    }
    return self;
}

-(void)setCurrentDidSelectedBlock:(currentDidSelectedBlock)block
{
    _block = block;
}

-(void)setScrollToPageBlock:(ScrollToPageBlock)block
{
    _scrollBlock = block;
}

-(void)scrollToPage:(NSInteger)page
{
    if (page >= 0 || page <= _views.count)
    {
        _currentPage = page;
        [self configView];
    }
}

#pragma mark -根据_currentPage获得scrollView视图里子视图的各个下标
-(NSMutableArray *)currentImagesPageCount
{
    
    //初始化数组
    NSMutableArray * arr = [NSMutableArray array];
    
    //当前图片为数组第一张
    if (_currentPage == 0)
    {
        [arr addObject:@(_views.count - 1)];
        [arr addObject:@(_currentPage)];
        [arr addObject:@(_currentPage +1)];
    }
    
    //当前图片为数组最后一张
    if (_currentPage == (_views.count- 1))
    {
        [arr addObject:@(_currentPage - 1)];
        [arr addObject:@(_currentPage)];
        [arr addObject:@(0)];
    }
    
    [arr addObject:@(_currentPage - 1)];
    [arr addObject:@(_currentPage)];
    [arr addObject:@(_currentPage +1)];
    
    return arr;
}



#pragma mark -刷新方法
-(void)configView
{
    
    //清空父视图
    [self clearSubviews];
    
    //获取将要显示的图片下标
    NSArray * arr = [self currentImagesPageCount];
    
    //依次创建视图并加入滚动视图中
    for (int i = 0; i < 3; i++)
    {

        NSInteger page = [arr[i] intValue];
        UIView * view = _views[page];
        view.frame = CGRectMake(i *self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        if(i == 1)
        {
            UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelected:)];
            view.userInteractionEnabled = YES;
            [view addGestureRecognizer:ges];
        }
        [self addSubview:_views[page]];
    }
    
    //改变偏移量
    self.contentOffset = CGPointMake(self.frame.size.width, 0);
}

//当前子视图被点击
-(void)didSelected:(UITapGestureRecognizer *)ges
{
    if (_block)
    {
        _block(_currentPage);
    }
}

-(void)clearSubviews
{
    NSArray * arr = [self subviews];
    for (UIView * view in arr)
    {
        [view removeFromSuperview];
    }
}

//根据_currentPage判断变化后的值
-(void)changeCurrentPage:(NSInteger)changePage
{
    if(changePage == -1)
    {
        _currentPage = _views.count - 1;
    }
    else if (changePage == _views.count)
    {
        _currentPage = 0;
    }
    else
    {
        _currentPage = changePage;
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //获取滚动视图偏移量
    CGPoint offSet = self.contentOffset;
    
    //根据偏移量修改_currentPage
    if(offSet.x >= self.frame.size.width *2)
    {
        [self changeCurrentPage:_currentPage + 1];
        [self configView];
    }
    if(offSet.x <= 0)
    {
        [self changeCurrentPage:_currentPage - 1];
        [self configView];
    }
    if (_scrollBlock)
    {
        _scrollBlock(_currentPage);
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //获取滚动视图偏移量
    CGPoint offSet = self.contentOffset;
    
    //根据偏移量修改_currentPage
    if(offSet.x >= self.frame.size.width *2)
    {
        [self changeCurrentPage:_currentPage + 1];
        [self configView];
    }
    if(offSet.x <= 0)
    {
        [self changeCurrentPage:_currentPage - 1];
        [self configView];
    }
}

//视图将要滚动  停止计时器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(_interval)
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
