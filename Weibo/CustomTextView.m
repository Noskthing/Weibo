//
//  CustomTextView.m
//  JustForFunOfLee
//
//  Created by apple on 16/1/12.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "CustomTextView.h"
#import "UIImage+GIF.h"
#import "Define.h"

@interface CustomTextView ()<UITextViewDelegate>

@end
@implementation CustomTextView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(5,7,frame.size.width - 10, 20)];
        _label.text = @"分享新鲜事...";
        _label.enabled = NO;//lable必须设置为不可用
        _label.backgroundColor = [UIColor clearColor];
        _label.hidden = NO;
        [self addSubview:_label];
    }
    return self;
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    self.delegate = self;
    self.font = [UIFont boldSystemFontOfSize:17];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self judgeText];

}

//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    [self judgeText];
//    
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 4;// 字体的行间距
//    
//    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17],
//                                 NSParagraphStyleAttributeName:paragraphStyle};
//    
//    NSMutableAttributedString * tmpStr = [textView.attributedText mutableCopy];
//    [tmpStr addAttributes:attributes range:NSMakeRange(0, tmpStr.length)];
//    self.attributedText = [tmpStr copy];
//   
//}
//判读placeholder是否隐藏
-(void)judgeText
{
    if (self.attributedText.length != 0)
    {
        _label.hidden = YES;
    }
    else
    {
        _label.hidden = NO;
    }
}
@end
