//
//  PageControlView.m
//  JustForFunOfLee
//
//  Created by apple on 16/1/8.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "PageControlView.h"

@interface PageControlView ()
{
    NSInteger _count;
    
    NSInteger _page;
}
@end

#define kPageCountViewTag 909

@implementation PageControlView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _count = 222;
        _page = 222;
    }
    return self;
}

-(void)setPageCount:(NSInteger)count andCurrentPage:(NSInteger)page
{
    CGFloat space = 10;
    CGFloat width = 5;
    CGFloat height = 2;
    
    //计算初始位置的x
    CGFloat initX = (self.frame.size.width - (width + space) * count + space) /2;
    
    if (_count != count)
    {
        [self removeAllSubviews];
        if (count == 0)
        {
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height)];
            label.textColor = [UIColor colorWithRed:0.839f green:0.839f blue:0.839f alpha:1.00f];
            label.text = @"最近使用的表情";
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
        }
        else
        {
            for (NSInteger i = 0 ; i < count; i ++)
            {
                UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
                view.layer.anchorPoint = CGPointMake(0, 0.5);
                view.layer.position = CGPointMake(i * (width + space) + initX, self.frame.size.height/2);
                view.tag = kPageCountViewTag  + i;
                //            NSLog(@"i == %ld   page == %ld",(long)i,(long)page);
                if (i == page)
                {
                    view.backgroundColor = [UIColor orangeColor];
                }
                else
                {
                    view.backgroundColor = [UIColor colorWithRed:0.839f green:0.839f blue:0.839f alpha:1.00f];
                }
                [self addSubview:view];
            }
        }
    }
    else
    {
        if (_count != 0)
        {
            //一定要加这个判断！
            //scrollView滚动时会多次调用代理方法  导致else部分被频繁调用  当页面还未切换的时候会修改了原先的页码标注
            if(_page != page)
            {
                UIView * currentView = [self viewWithTag:page + kPageCountViewTag];
                currentView.backgroundColor = [UIColor orangeColor];
                
                UIView * invaildView = [self viewWithTag:_page + kPageCountViewTag];
                invaildView.backgroundColor = [UIColor colorWithRed:0.839f green:0.839f blue:0.839f alpha:1.00f];
            }
        }
    }

    _page = page;
    _count = count;

}

#pragma mark   -移除所有子视图
-(void)removeAllSubviews
{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}

@end
