//
//  LeeScrollViewWithArray.h
//  掌厨
//
//  Created by Lee on 15/9/13.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^currentDidSelectedBlock)(NSInteger page);
typedef void(^ScrollToPageBlock)(NSInteger page);
@interface LeeScrollViewWithArray : UIScrollView


-(instancetype)initWithFrame:(CGRect)frame andArray:(NSArray *)views andTimerWithTimeInterval:(NSInteger)interval;
-(void)setCurrentDidSelectedBlock:(currentDidSelectedBlock)block;
-(void)scrollToPage:(NSInteger)page;
-(void)setScrollToPageBlock:(ScrollToPageBlock)block;
@end
