//
//  LBWScrollComponentView.h
//  test
//
//  Created by feerie luxe on 16/4/13.
//  Copyright © 2016年 NN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBWScrollComponentView : UIView

//滑动视图
@property(nonatomic,strong)UIScrollView * scrollView;


+(instancetype)lbwScrollComponentViewWithFrame:(CGRect)frame;


#pragma mark    scrollView各个时期的操作  交由子类执行
/** 即将翻页 */
-(void)scrollViewWillTurnPage NS_REQUIRES_SUPER;
/** 翻页结束 */
-(void)scrollViewDidTurnPage NS_REQUIRES_SUPER;
/** 左翻页 */
-(void)scrollViewDidTurnPageToLeft NS_REQUIRES_SUPER;
/** 右翻页 */
-(void)scrollViewDidTurnPageToRight NS_REQUIRES_SUPER;

#pragma mark    辅助功能的一些方法
/** 清除scrollView上所有子视图 */
-(void)clearScrollView;
@end
