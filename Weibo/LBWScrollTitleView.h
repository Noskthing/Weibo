//
//  LBWScrollTitleView.h
//  test
//
//  Created by feerie luxe on 16/4/15.
//  Copyright © 2016年 NN. All rights reserved.
//

#import <UIKit/UIKit.h>


/** titleView被点击时执行的block*/
typedef void(^TitleViewDidSelectedBlock)(NSInteger idx);

@interface LBWScrollTitleView : UIScrollView

@property(nonatomic,copy)NSArray <NSString *>* titles;

/** 滑动小模块高度 默认为8*/
@property(nonatomic,assign)CGFloat scrollModuleHeight;
/** 滑动小模块颜色 默认为红色*/
@property(nonatomic,strong)UIColor * scrollModuleColor;
/** 滑动小模块宽度占每个titleView的比例  默认为1 */
@property(nonatomic,assign)CGFloat scrollModuleWidthScale;

/** titleView字体颜色 默认为黑色*/
@property(nonatomic,strong)UIColor * titleViewTextColor;

/** 滑动小模块随主UIScrollView滑动 */
-(void)moveScrollModule:(CGFloat)scale;
/** 传入block */
-(void)setTitleViewDidSelectedBlock:(TitleViewDidSelectedBlock)block;

#pragma mark   。。。。先写着吧  我也不知道有卵用
//-(void)titleViewDidScroll;
//-(void)titleViewWillScroll;
@end
