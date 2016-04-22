//
//  UIScrollView+ChainRecation.h
//  test
//
//  Created by feerie luxe on 16/4/15.
//  Copyright © 2016年 NN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBWScrollTitleView.h"

@interface UIScrollView (ChainRecation)

/** titleView */
@property (nonatomic,strong)LBWScrollTitleView * titleView;

/** 视图数组 */
@property (nonatomic,strong)NSArray * views;


@end
