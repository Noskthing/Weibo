//
//  CameraWaterMarkView.m
//  JustForFunOfLee
//
//  Created by feerie luxe on 16/6/2.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "CameraWaterMarkView.h"

static CGFloat alpha = 0.6;

@interface  CameraWaterMarkView()
{
//    UIImageView * _zoomView;
}
@end

@implementation CameraWaterMarkView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _isHiddenOptionView = NO;
        self.userInteractionEnabled = YES;
        
        UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - 2, 2)];
        line1.backgroundColor = [UIColor whiteColor];
        line1.alpha = alpha;
        line1.hidden = _isHiddenOptionView;
        [self addSubview:line1];
        
        UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 2, 2, frame.size.height - 2)];
        line2.backgroundColor = [UIColor whiteColor];
        line2.alpha = alpha;
        line2.hidden = _isHiddenOptionView;
        [self addSubview:line2];
        
        UIView * line3 = [[UIView alloc] initWithFrame:CGRectMake(2, frame.size.height - 2, frame.size.width - 2, 2)];
        line3.backgroundColor = [UIColor whiteColor];
        line3.alpha = alpha;
        line3.hidden = _isHiddenOptionView;
        [self addSubview:line3];
        
        UIView * line4 = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width - 2, 0, 2, frame.size.height - 2)];
        line4.backgroundColor = [UIColor whiteColor];
        line4.alpha = alpha;
        line4.hidden = _isHiddenOptionView;
        [self addSubview:line4];
        
        
        
//
        
//
    }
    return self;
}

@end
