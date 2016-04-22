//
//  LBWScrollViewWithTimer.m
//  test
//
//  Created by feerie luxe on 16/4/15.
//  Copyright © 2016年 NN. All rights reserved.
//

#import "LBWScrollViewWithTimer.h"


@interface LBWScrollViewWithTimer ()<UIScrollViewDelegate>
{
    NSTimer * _timer;
}
@end

@implementation LBWScrollViewWithTimer

#pragma mark   初始化
+(instancetype)lbwScrollViewWithTimerFrame:(CGRect)frame Views:(NSArray<UIView *> *)views andTimeInterval:(NSTimeInterval)time
{
    LBWScrollViewWithTimer * view = [[LBWScrollViewWithTimer alloc] initWithFrame:frame];
    
    //少于三个view 抛出异常
    if (views.count <3)
    {
        NSException *e = [NSException
                          exceptionWithName: @"views.count < 3"
                          reason: @"views的数量少于三张，不推荐使用LBWScrollView，可能会引起未知错误"
                          userInfo: nil];
        @throw e;
    }
    //初始化属性
    view.views = views;
    view.currentPage = 0;
    view.time = time;
    
    //页数指示器pageControl
    [view.pageControl setNumberOfPages:views.count];
    __weak LBWScrollViewWithArray * weakView = view;
    [view.pageControl setPageBtnDidSelectedBlock:^(NSInteger page) {
        [weakView scrollToPage:page];
    }];
    
    //配置视图
    [view configView];
    
    //开始定时器
    [view startScroll];
    
    return view;
}

#pragma mark    定时器相关
-(void)startScroll
{
    if (_time)
    {
        _timer = [NSTimer timerWithTimeInterval:self.time target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

-(void)autoScroll
{
    //执行偏移动画
    CGFloat offSet = self.frame.size.width * 2;
    [self.scrollView setContentOffset:CGPointMake(offSet, 0) animated:YES];

    //重新布置视图
    [self configView];
}

#pragma mark     scrollView代理方法
//视图将要滚动  停止计时器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(_time)
    {
        [_timer invalidate];
    }
}


//视图将要停止滚动   重新配置计时器
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (_time)
    {
        [self startScroll];
    }
}

@end
