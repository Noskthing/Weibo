//
//  UIView+FirstTimeMoveToSuperView.m
//  test
//
//  Created by feerie luxe on 16/4/18.
//  Copyright © 2016年 NN. All rights reserved.
//

#import "UIView+FirstTimeMoveToSuperView.h"
#import <objc/runtime.h>

@implementation UIView (FirstTimeMoveToSuperView)

#pragma mark     关联对象
//static const char IsFirstTimeMoveToSuperViewKey = '\33';
//
//-(void)setIsFirstTmeMoveToSuperView:(BOOL)isFirstTmeMoveToSuperView
//{
//    //第三个参数必须为oc对象
//    objc_setAssociatedObject(self, &IsFirstTimeMoveToSuperViewKey, @(isFirstTmeMoveToSuperView), OBJC_ASSOCIATION_ASSIGN);
//}
//
//-(BOOL)isFirstTmeMoveToSuperView
//{
//    return [objc_getAssociatedObject(self, &IsFirstTimeMoveToSuperViewKey) boolValue];
//}
//
//
static const char FirstTimeMoveToSuperViewBlockKey = '\44';
-(void)setFirstTimeMoveToSuperViewBlock:(void (^)())FirstTimeMoveToSuperViewBlock
{
    objc_setAssociatedObject(self, &FirstTimeMoveToSuperViewBlockKey, FirstTimeMoveToSuperViewBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void (^)())FirstTimeMoveToSuperViewBlock
{
    return objc_getAssociatedObject(self, &FirstTimeMoveToSuperViewBlockKey);
}


#pragma mark     重写覆盖UIView方法
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    if(self.FirstTimeMoveToSuperViewBlock)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            self.FirstTimeMoveToSuperViewBlock();
        });
    }
}
@end
