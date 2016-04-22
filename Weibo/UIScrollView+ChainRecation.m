//
//  UIScrollView+ChainRecation.m
//  test
//
//  Created by feerie luxe on 16/4/15.
//  Copyright © 2016年 NN. All rights reserved.
//

#import "UIScrollView+ChainRecation.h"
#import <objc/runtime.h>

@interface UIScrollView ()<UIScrollViewDelegate>

@end

@implementation UIScrollView (ChainRecation)

#pragma mark  关联对象
static const char LBWScrollTitleViewKey = '\00';
-(void)setTitleView:(LBWScrollTitleView *)titleView
{
    //存储新titleView
    objc_setAssociatedObject(self, &LBWScrollTitleViewKey, titleView, OBJC_ASSOCIATION_RETAIN);
    
    //传入titleView被点击时执行的block
    __weak UIScrollView * weakSelf = self;
    NSLog(@"self.titleView is %@",self.titleView);
    [self.titleView setTitleViewDidSelectedBlock:^(NSInteger idx) {
        [weakSelf setContentOffset:CGPointMake(weakSelf.frame.size.width * idx, 0) animated:YES];
    }];

}

-(LBWScrollTitleView *)titleView
{
    return objc_getAssociatedObject(self, &LBWScrollTitleViewKey);
}


static const char LBWScrollViewsKey = '\11';

-(void)setViews:(NSArray *)views
{
    objc_setAssociatedObject(self, &LBWScrollViewsKey, views, OBJC_ASSOCIATION_COPY);
}

-(NSArray *)views
{
    return objc_getAssociatedObject(self, &LBWScrollViewsKey);
}


#pragma mark    属性设置
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    if (self.views)
    {
        //根据views的数量设置contentSize
        self.contentSize = CGSizeMake(self.views.count * self.frame.size.width, self.frame.size.height);
        
        //设置为自己的代理
        self.delegate = self;
        
        //属性设置
        self.pagingEnabled = YES;
        //滚动条永远关闭
        self.showsVerticalScrollIndicator = FALSE;
        self.showsHorizontalScrollIndicator = FALSE;
        
        //遍历views数组依次放置到uiscrollView上
        [self.views enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frame = CGRectMake(idx * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
            [self addSubview:obj];
        }];

    }
}

#pragma mark     代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scale = scrollView.contentOffset.x/scrollView.contentSize.width;
    
    [scrollView.titleView moveScrollModule:scale];
   
}
@end
