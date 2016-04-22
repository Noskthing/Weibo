//
//  LBWScrollViewWithArray.h
//  test
//
//  Created by feerie luxe on 16/4/13.
//  Copyright © 2016年 NN. All rights reserved.
//

#import "LBWScrollComponentView.h"
#import "LBWPageControl.h"


/** 轮播图点击触发的block  */
typedef void(^ScrollViewDidSelectedBlock)(NSInteger page);
@interface LBWScrollViewWithArray : LBWScrollComponentView

#pragma  mark 基础属性和方法
/** 轮播展示的视图数组  */
@property(nonatomic,strong)NSArray * __nonnull views;
/** 正在展示的视图下标 */
@property(nonatomic,assign)NSInteger  currentPage;

/** 初始化方法 */
+(instancetype _Nonnull)lbwScrollViewWithArrayFrame:(CGRect)frame andViews:(NSArray<UIView *>  * _Nonnull )views;
/** 传入视图点击的操作block */
-(void)setScrollViewDidSelectedBlock:(_Nonnull ScrollViewDidSelectedBlock)block;
/** 滑动到指定页面 */
-(void)scrollToPage:(NSInteger)page;
/** 重新布置scrollView */
-(void)configView;
/** 修改currentPage */
-(void)judgeCurrentPageAndChange:(NSInteger)currentPage;

#pragma mark  拓展属性
#pragma mark 标题Label
/** 标题Label  默认hidden = YES*/
@property(nonatomic,strong)UILabel * _Nonnull titleLabel;
/** 标题Label相对scrollView的比例 默认是0.2*/
@property(nonatomic,assign)CGFloat scaleOfTitleLabel;
/** 标题Label展示的标题数组*/
@property(nonatomic,strong)NSArray * _Nullable titles;

#pragma mark  页数指示器pageControl
/** 页数指示器pageControl 默认是hidden = YES */
@property(nonatomic,strong)LBWPageControl * _Nonnull pageControl;
/** 页数指示器pageControl相对scrollView的比例 默认是0.2*/
@property(nonatomic,assign)CGFloat scaleOfPageControl;
@end
