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
        _bgView.clipsToBounds = YES;
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
        
        _jurisdiction = 0;
    }
    return self;
}

-(void)setJurisdiction:(NSInteger)jurisdiction
{
    _jurisdiction = jurisdiction;
    
    NSString * title;
    NSString * imageName;
    switch (_jurisdiction)
    {
        case 0:
        {
            title = @"公开";
            imageName = @"compose_publicbutton";
        }
            break;
        case 1:
        {
            title = @"好友圈";
            imageName = @"compose_friendcircle";
        }
            break;
        case 2:
        {
            title = @"仅自己可见";
            imageName = @"compose_myself";
        }
            break;
            
        default:
            break;
    }
    [self setDetailText:title imageName:imageName viewAlignment:viewAlignmentRight];
}

-(void)setMaskBtnDidSeletcedBlock:(maskBtnDidSeletcedBlock)block
{
    _block = block;
}

-(void)maskBtnTouch:(UIButton *)btn
{
    if (_block)
    {
        _block(_jurisdiction);
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

-(void)getCurrentAddress:(NSString *)address latitude:(float)lat longitude:(float)lon
{
    CGSize detailSize = [address sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(self.frame.size.width - self.frame.size.height * 2, self.frame.size.height)];
    //防止地址label过长越界
    if (detailSize.width >= self.frame.size.width - self.frame.size.height * 2.3)
    {
        detailSize.width = self.frame.size.width - self.frame.size.height * 2.3;
    }
    //禁maskBtn
    _maskBtn.userInteractionEnabled = NO;
    
    _detail.text = address;
    _detail.textColor = [UIColor colorWithRed:0.267f green:0.424f blue:0.635f alpha:1.00f];
    _detail.frame = CGRectMake(self.frame.size.height, 0, detailSize.width, self.frame.size.height);
    _bgView.frame = CGRectMake(0, 0, self.frame.size.height * 2.3 + detailSize.width, self.frame.size.height);
    _imageView.image = [UIImage imageNamed:@"compose_locatebutton_succeeded"];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(_bgView.frame.size.width - self.frame.size.height, 0, self.frame.size.height, self.frame.size.height)];
    [btn setImage:[UIImage imageNamed:@"compose_location_icon_delete"] forState:0];
    [btn addTarget:self action:@selector(cancelButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:btn];
    
    _lat = lat;
    _lon = lon;
}
//回复待选状态
-(void)cancelButtonTouch:(UIButton *)btn
{
    [btn removeFromSuperview];
    _maskBtn.userInteractionEnabled = YES;
    _lat = 0;
    _lon = 0;
    [self setDetailText:@"显示位置" imageName:@"compose_locatebutton_ready" viewAlignment:viewAlignmentLeft];
    [self changeTextColor:[UIColor colorWithRed:0.604f green:0.604f blue:0.604f alpha:1.00f]];
}
@end
