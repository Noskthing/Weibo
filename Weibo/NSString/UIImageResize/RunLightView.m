//
//  RunLightView.m
//  RunLight
//
//  Created by Lee on 15/9/14.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "RunLightView.h"


@interface RunLightView ()
{
    UIFont * _font;
    CGFloat _duration;
    NSString * _title;
    UILabel * _label;
    CGSize _size;
    NSTimer * _timer;
}

@end

@implementation RunLightView

-(instancetype)initWithFrame:(CGRect)frame andUIFont:(UIFont *)font animationDuration:(CGFloat)duration labelTitle:(NSString *)title 
{
    if (self = [super initWithFrame:frame])
    {
        _title = title;
        _font = font;
        _duration = duration;
        self.clipsToBounds = YES;
        [self creatLabel];
    }
    
    return self;
}

-(void)creatLabel
{
    
    CGSize maxSize = CGSizeMake(MAXFLOAT, self.frame.size.height);
    
    
    CGSize size = [_title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_font} context:nil].size;
    _size = size;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, size.width, size.height)];
    label.text = _title;
    _label = label;
    label.numberOfLines = 1;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = _font;
    [self addSubview:label];
    
    [self startTimew];
    
}

-(void)createAnimation
{
    [UIView animateWithDuration:_duration animations:^{
        CGRect rectFinsh = CGRectMake(-_size.width, 0, _size.width, _size.height);
        _label.frame = rectFinsh;
    } completion:^(BOOL finished) {
        _label.frame = CGRectMake(self.frame.size.width, 0, _size.width, _size.height);
    }];
}

-(void)startTimew{
    _timer = [NSTimer timerWithTimeInterval:_duration target:self selector:@selector(createAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}


@end
