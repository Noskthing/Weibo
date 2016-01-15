//
//  StatusBtnView.m
//  JustForFunOfLee
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "StatusBtnView.h"
#import "NSString+Additions.h"

@interface StatusBtnView ()
{
    UIView * _bgView;
    UIImageView * _imageView;
    UILabel * _detail;
    UIButton * _maskBtn;
    maskBtnDidSeletcedBlock _block;
}
@end
@implementation StatusBtnView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        
        //背景视图
        _bgView = [[UIView alloc] initWithFrame:frame];
        _bgView.backgroundColor = [UIColor colorWithRed:0.965f green:0.965f blue:0.965f alpha:1.00f];
        _bgView.layer.cornerRadius = frame.size.height/2;
        [self addSubview:_bgView];
        
        //图标
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];
        [_bgView addSubview:_imageView];
        
        //描述文字
        _detail = [[UILabel alloc] init];
        _detail.font = [UIFont systemFontOfSize:15];
        _detail.textColor = [UIColor colorWithRed:0.604f green:0.604f blue:0.604f alpha:1.00f];
        [_bgView addSubview:_detail];
        
        //蒙版button
         _maskBtn = [[UIButton alloc] init];
        [_maskBtn addTarget:self action:@selector(maskBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_maskBtn];
    }
    return self;
}

-(void)setMaskBtnDidSeletcedBlock:(maskBtnDidSeletcedBlock)block
{
    _block = block;
}

-(void)maskBtnTouch:(UIButton *)btn
{
    if (_block)
    {
        _block();
    }
}

-(void)setDetailText:(NSString *)text imageName:(NSString *)imageName viewAlignment:(viewAlignment)alignment
{
    CGSize detailSize = [text sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(self.frame.size.width - self.frame.size.height * 1.5, self.frame.size.height)];
    _detail.text = text;
    _detail.frame = CGRectMake(self.frame.size.height, 0, detailSize.width, self.frame.size.height);
    
    _bgView.frame = CGRectMake(alignment == viewAlignmentLeft?0:(self.frame.size.width - self.frame.size.height * 1.5 - detailSize.width), 0, self.frame.size.height * 1.5 + detailSize.width, self.frame.size.height);
    _maskBtn.frame = CGRectMake(0, 0, _bgView.frame.size.width, _bgView.frame.size.height);
    _imageView.image = [UIImage imageNamed:imageName];
    
}

-(void)changeTextColor:(UIColor *)color
{
    _detail.textColor = color;
}

-(void)getCurrentAddress:(NSString *)address
{
    CGSize detailSize = [address sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(self.frame.size.width - self.frame.size.height * 2, self.frame.size.height)];
    _detail.text = address;
    _detail.frame = CGRectMake(self.frame.size.height, 0, detailSize.width, self.frame.size.height);
    _bgView.frame = CGRectMake(0, 0, self.frame.size.height * 1.5 + detailSize.width, self.frame.size.height);
    _imageView.image = [UIImage imageNamed:@"compose_locatebutton_succeeded"];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(_bgView.frame.size.width - self.frame.size.height, 0, self.frame.size.height, self.frame.size.height)];
    btn.backgroundColor = [UIColor redColor];
    [_bgView addSubview:btn];

}
@end
