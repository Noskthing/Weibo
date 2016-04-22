//
//  LBWScrollViewWithArray.m
//  test
//
//  Created by feerie luxe on 16/4/13.
//  Copyright © 2016年 NN. All rights reserved.
//

#import "LBWScrollViewWithArray.h"

@interface LBWScrollViewWithArray ()
{
    ScrollViewDidSelectedBlock _scrollViewDidSelectedBlock;
}
@end

@implementation LBWScrollViewWithArray

#pragma mark    初始化
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //标题label
        self.scaleOfTitleLabel = 0.2;
        self.titleLabel.hidden = YES;
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height * (1 - self.scaleOfTitleLabel), frame.size.width,frame.size.height * self.scaleOfTitleLabel)];
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        
        //页数指示器pageControl
        self.scaleOfPageControl = 0.2;
        LBWPageControl * pageControl = [[LBWPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height * (1 - self.scaleOfPageControl), frame.size.width,frame.size.height * self.scaleOfPageControl)];
        pageControl.hidden = YES;
        self.pageControl = pageControl;
        [self addSubview:pageControl];
    }
    return self;
}

+(instancetype)lbwScrollViewWithArrayFrame:(CGRect)frame andViews:(NSArray * )views
{
    LBWScrollViewWithArray * view = [[LBWScrollViewWithArray alloc] initWithFrame:frame];
    
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
    
    //页数指示器pageControl
    [view.pageControl setNumberOfPages:views.count];
    __weak LBWScrollViewWithArray * weakView = view;
    [view.pageControl setPageBtnDidSelectedBlock:^(NSInteger page) {
        [weakView scrollToPage:page];
    }];
    
    //配置视图
    [view configView];
    
    return view;
}

-(void)setTitles:(NSArray *)titles
{
    if (titles.count == _views.count)
    {
        _titles = titles;
        [self configView];
    }
    else
    {
        NSException *e = [NSException
                          exceptionWithName: @"titles.count is not Equal to views.count"
                          reason: @"标题数组的数目和视图数组的数目不匹配，可能会引起未知错误"
                          userInfo: nil];
        @throw e;
    }
}

-(void)setScrollViewDidSelectedBlock:(_Nonnull ScrollViewDidSelectedBlock)block
{
    //添加点击手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDidSelected:)];
    self.userInteractionEnabled = YES;
    [self.scrollView addGestureRecognizer:tap];
    
    _scrollViewDidSelectedBlock = block;
}


#pragma mark    滑动到指定页码
-(void)scrollToPage:(NSInteger)page
{
    if (page >= 0 && page < _views.count)
    {
        _currentPage = page;
    }
    
    [self configView];
}

#pragma mark    根据当前图片下标布置视图
-(void)configView
{
    //放置_views数组为空时出现错误
    if(_views)
    {
        //移除现有的各种视图
        [self clearScrollView];
        
        //获取将要显示的图片下标
        NSArray * arr = [[self getCurrentPages] copy];
        
        
        //    NSLog(@"pageNum is %@",arr);
        //依次创建视图加载
        [arr enumerateObjectsUsingBlock:^(NSNumber  * _Nonnull number, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger page = [arr[idx] integerValue];
            id ins = _views[page];
            if ([ins isKindOfClass:[UIView class]])
            {
                UIView * view = ins;
                view.frame = CGRectMake(idx *self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
                [self.scrollView addSubview:view];
            }
            else
            {
                NSException *e = [NSException
                                  exceptionWithName: @"[view class] is not kind of UIView"
                                  reason: @"传入数组中包含非UIView的类"
                                  userInfo: nil];
                @throw e;
            }
        }];
        
        //修改titleLabel.text
        if (_titles)
        {
            _titleLabel.text = _titles[_currentPage];
        }
        
        //    切换pageControl页数
        [self.pageControl changeColorWithCurrentBtnWithTag:LBWTag(_currentPage)];

    }
}

#pragma mark   获取当前展示的三张视图的下标数组
-(NSArray *)getCurrentPages
{
    if (_currentPage == 0)
    {
        return @[@(_views.count - 1),@(0),@(1)];
    }
    else if (_currentPage == _views.count - 1)
    {
        return @[@(_currentPage - 1),@(_currentPage),@(0)];
    }
    else
    {
        return @[@(_currentPage - 1),@(_currentPage),@(_currentPage + 1)];
    }
}

#pragma mark     判定currentPage合法性及修改
-(void)judgeCurrentPageAndChange:(NSInteger)currentPage
{
    //倒翻到最后一页
    if (currentPage < 0)
    {
        _currentPage = _views.count - 1;
    }
    //从末尾翻到第一页
    else if(currentPage >= _views.count)
    {
        _currentPage = 0;
    }
    //默认情况  翻到下一页
    else
    {
        _currentPage = currentPage;
    }
    
}

#pragma mark    视图翻页时执行的操作
-(void)scrollViewWillTurnPage
{
    [super scrollViewWillTurnPage];
}

-(void)scrollViewDidTurnPageToLeft
{
    [super scrollViewDidTurnPageToLeft];
    
    //下一页
    [self judgeCurrentPageAndChange:_currentPage + 1];
}

-(void)scrollViewDidTurnPageToRight
{
    [super scrollViewDidTurnPageToRight];
    //上一页
    [self judgeCurrentPageAndChange:_currentPage - 1];
}

-(void)scrollViewDidTurnPage
{
    [super scrollViewDidTurnPage];
    
    NSLog(@"----currentPage is %ld",(long)_currentPage);
    //重新配置视图
    [self configView];
    
}

#pragma mark     视图被点击
-(void)scrollViewDidSelected:(UIView *)view
{
    if (_scrollViewDidSelectedBlock)
    {
        _scrollViewDidSelectedBlock(_currentPage);
    }
    else
    {
        NSLog(@"您点击了第%ld张视图",(long)_currentPage);
    }
}
@end
