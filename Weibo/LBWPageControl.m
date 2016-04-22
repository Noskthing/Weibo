//
//  LBWPageControl.m
//  test
//
//  Created by feerie luxe on 16/4/14.
//  Copyright © 2016年 NN. All rights reserved.
//

#import "LBWPageControl.h"

//page之间的空隙
static CGFloat pageSpace = 10;
//page的边长
static CGFloat pageEdge = 7;

@interface LBWPageControl ()
{
    PageBtnDidSelectedBlock _pageBtnDidSelectedBlock;
    
    //上一个被点击的page下标
    NSInteger _lastPage;
}
@end

@implementation LBWPageControl

#pragma mark    初始化
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.numberOfPages = 0;
        self.currentPage = 0;
        self.offsetScale = 0.5;
        self.pageIndicatorTintColor = [UIColor whiteColor];
        self.currentPageIndicatorTintColor = [UIColor redColor];
        self.backgroundColor = [UIColor clearColor];
        
        _lastPage = LBWTag(0);
    }
    return self;
}


-(void)setPageBtnDidSelectedBlock:(PageBtnDidSelectedBlock)block
{
    _pageBtnDidSelectedBlock = block;
}

#pragma mark     创建page
-(void)setNumberOfPages:(NSInteger)numberOfPages
{
    if (numberOfPages > 0)
    {
        _numberOfPages = numberOfPages;
        [self layoutPages];
    }
    else if (numberOfPages < 0)
    {
        NSException *e = [NSException
                          exceptionWithName: @"numberOfPages can not smaller than 0"
                          reason: @"numberOfPages必须传大于等于0的整数"
                          userInfo: nil];
        @throw e;
    }
    else
    {
        
    }
}

#pragma mark     根据numberOfPages布局
-(void)layoutPages
{
    //计算边距
    CGFloat gap = (self.frame.size.width - (pageEdge + pageSpace) * _numberOfPages + pageSpace) * self.offsetScale;
    
    //依次创建page
    for (NSInteger i = 0; i< self.numberOfPages; i++)
    {
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, pageEdge, pageEdge)];
        btn.tag = LBWTag(i);
        btn.layer.cornerRadius = pageEdge/2;
        btn.backgroundColor = (i == 0?self.currentPageIndicatorTintColor:self.pageIndicatorTintColor);
        btn.layer.anchorPoint = CGPointMake(0, 0.5);
        [btn addTarget:self action:@selector(pageBtnDidSelected:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.position = CGPointMake(i * (pageEdge + pageSpace) + gap, self.frame.size.height/2);
        [self addSubview:btn];
        
    }
}

#pragma mark      page点击事件
-(void)pageBtnDidSelected:(UIButton *)btn
{
    NSInteger tag = btn.tag;
    NSLog(@"tag is %ld",(long)tag);
    if (_pageBtnDidSelectedBlock)
    {
        _pageBtnDidSelectedBlock(LBWPageFromTag(tag));
    }
    
    //转换
    [self changeColorWithCurrentBtnWithTag:tag];

}

#pragma mark     page切换 颜色转变
-(void)changeColorWithCurrentBtnWithTag:(NSInteger)tag
{
    NSLog(@"canshu is %ld",(long)tag);
    //点击的不是同一个btn
    if (tag != _lastPage)
    {
        UIButton * btn = [self viewWithTag:tag];
        
        //颜色转换
        UIButton * lastBtn = [self viewWithTag:_lastPage];
        lastBtn.backgroundColor = self.pageIndicatorTintColor;
        
        btn.backgroundColor = self.currentPageIndicatorTintColor;
        
        
        //保存pageNum
        _lastPage = tag;
    }
}
@end
