//
//  EmotionView.h
//  JustForFunOfLee
//
//  Created by apple on 16/1/8.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import <UIKit/UIKit.h>

//表情点击block
typedef void(^EmotionDidSeletcedBlock)(UIImage * image,NSString * text);

@interface EmotionView : UIView

@property (nonatomic,assign)BOOL isFirstTimeMoveToSuperView;
-(void)setImageNames:(NSArray *)names;
-(void)setEmotionDidSeletcedBlock:(EmotionDidSeletcedBlock)block;
//表情键盘下部视图
-(void)setBottomView:(UIView *)view;
@end
