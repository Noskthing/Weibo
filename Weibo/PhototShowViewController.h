//
//  PhototShowViewController.h
//  JustForFunOfLee
//
//  Created by 文丹 on 16/1/25.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhototShowViewController : UIViewController

//图片
@property (nonatomic,strong)NSArray * images;
//图片总量
@property (nonatomic,assign)NSUInteger count;
//当前图片
@property (nonatomic,assign)NSInteger num;

@end
