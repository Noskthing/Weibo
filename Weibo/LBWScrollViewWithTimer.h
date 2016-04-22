//
//  LBWScrollViewWithTimer.h
//  test
//
//  Created by feerie luxe on 16/4/15.
//  Copyright © 2016年 NN. All rights reserved.
//

#import "LBWScrollViewWithArray.h"

@interface LBWScrollViewWithTimer : LBWScrollViewWithArray

@property(nonatomic,assign)NSTimeInterval time;

/**  初始化方法 */
+(instancetype)lbwScrollViewWithTimerFrame:(CGRect)frame Views:(NSArray<UIView *>  *  )views andTimeInterval:(NSTimeInterval)time;
/**  开始执行操作 */
-(void)startScroll;
@end
