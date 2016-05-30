//
//  ImageOptionScrollView.h
//  JustForFunOfLee
//
//  Created by feerie luxe on 16/5/30.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OptionButtonDidSelevtedBlock)(NSInteger tag);
@interface ImageOptionScrollView : UIScrollView
@property (nonatomic,strong)NSArray * images;

-(void)setOptionButtonDidSelevtedBlock:(OptionButtonDidSelevtedBlock)block;
@end
