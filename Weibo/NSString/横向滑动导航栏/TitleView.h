//
//  TitleView.h
//  test
//
//  Created by mac on 15/9/16.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^itemDidSelectedBlock)(CGFloat scale,NSInteger index);
@interface TitleView : UICollectionView


/**
 
 初始化TitleView各项属性  block返还点击偏移量和点击item的位置
 
 */
-(void)titleViewWithTitles:(NSArray *)titles scrollViewColor:(UIColor *)color itemDidSelectedBlock:(itemDidSelectedBlock)block;

/**
 
 设置跳转到第几个item
 
 */
-(void)changeTitlesViewCurrentNum:(NSInteger)index;


/**
 
 根据比例偏移
 
 */


-(void)scrollViewWithOffset:(CGFloat)scale;
@end
