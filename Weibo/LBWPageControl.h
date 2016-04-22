//
//  LBWPageControl.h
//  test
//
//  Created by feerie luxe on 16/4/14.
//  Copyright © 2016年 NN. All rights reserved.
//

#import <UIKit/UIKit.h>


#define LBWTag(tag) tag+10
#define LBWPageFromTag(tag) tag-10

typedef void(^PageBtnDidSelectedBlock)(NSInteger page);
@interface LBWPageControl : UIView


@property(nonatomic) NSInteger numberOfPages; //default is 0

@property(nonatomic) NSInteger currentPage; //default is 0.value pinned to 0..numberOfPages-1

@property(nullable, nonatomic,strong) UIColor *pageIndicatorTintColor;  //default is white

@property(nullable, nonatomic,strong) UIColor *currentPageIndicatorTintColor;  //default is gray

@property(nonatomic,assign)CGFloat offsetScale;  //default is 0.5

/** 传入page被点击时执行的block  */
-(void)setPageBtnDidSelectedBlock:(_Nonnull PageBtnDidSelectedBlock)block;
/** 根据tag切换page的颜色  */
-(void)changeColorWithCurrentBtnWithTag:(NSInteger)tag;
@end
