//
//  UIView+FirstTimeMoveToSuperView.h
//  test
//
//  Created by feerie luxe on 16/4/18.
//  Copyright © 2016年 NN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FirstTimeMoveToSuperView)

//@property(nonatomic,assign)BOOL isFirstTmeMoveToSuperView;

@property(nonatomic,copy)void(^FirstTimeMoveToSuperViewBlock)();
@end
