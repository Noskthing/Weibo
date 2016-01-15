//
//  ScrollView.h
//  test
//
//  Created by mac on 15/9/16.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^OffsetChangeBlock)(CGFloat scale);
@interface ScrollView : UIScrollView


/**
 设置 当scrollView发生偏移对应TitleView偏移量 需要展示的Views
 */
-(void)setOffsetChangeBlock:(OffsetChangeBlock)block views:(NSArray *)arr;

/**
 传入TitleView的偏移量比例   scrollView偏移相同比例
 */
-(void)scrollWithScale:(CGFloat)scale;
@end
