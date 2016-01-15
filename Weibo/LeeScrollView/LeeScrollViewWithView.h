//
//  LeeScrollViewWithView.h
//  坑爹的疯狂
//
//  Created by Lee on 15/9/13.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIView *(^getCurrentViewLeftBlock)();
typedef UIView *(^getCurrentViewRightBlock)();
@interface LeeScrollViewWithView : UIScrollView



-(instancetype)initWithFrame:(CGRect)frame andView:(UIView *)view andTimerWithTimeInterval:(NSInteger)interval;
-(void)setgetCurrentViewLeftBlock:(getCurrentViewLeftBlock)leftBlock
      andgetCurrentViewRightBlock:(getCurrentViewRightBlock)rightBlock;
-(void)setEmptyLeftView:(UIView *)leftView andRightView:(UIView *)rightView;
@end
