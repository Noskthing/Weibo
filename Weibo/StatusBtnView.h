//
//  StatusBtnView.h
//  JustForFunOfLee
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    viewAlignmentLeft,
    viewAlignmentRight
} viewAlignment;
typedef void(^maskBtnDidSeletcedBlock)(NSInteger jurisdiction);
@interface StatusBtnView : UIView

@property (nonatomic,assign)float lon;
@property (nonatomic,assign)float lat;
@property (nonatomic,assign)int jurisdiction;

-(void)setDetailText:(NSString *)text imageName:(NSString *)imageName viewAlignment:(viewAlignment)alignment;
-(void)setMaskBtnDidSeletcedBlock:(maskBtnDidSeletcedBlock)block;
-(void)changeTextColor:(UIColor *)color;
-(void)getCurrentAddress:(NSString *)address latitude:(float)lat longitude:(float)lon;
@end
