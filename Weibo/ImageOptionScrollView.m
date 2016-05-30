
//
//  ImageOptionScrollView.m
//  JustForFunOfLee
//
//  Created by feerie luxe on 16/5/30.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "ImageOptionScrollView.h"

@interface ImageOptionScrollView()
{
    OptionButtonDidSelevtedBlock _block;
}
@end

static CGFloat itemSpace = 8;
@implementation ImageOptionScrollView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

-(void)setImages:(NSArray *)images
{
    _images = images;
    
    CGFloat height = self.frame.size.height * 0.7;
    CGFloat width = (self.frame.size.width - 5 * itemSpace) / 4.5;
    self.contentSize = CGSizeMake(images.count >= 5 ? images.count * (width + itemSpace) + itemSpace : self.frame.size.width, height);
    
    for (NSInteger i = 0; i < images.count; i++)
    {
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake( i * (width + itemSpace) + itemSpace, self.frame.size.height * 0.15, width, height)];
        btn.backgroundColor = [UIColor redColor];
        btn.tag = i;
        [btn addTarget:self action:@selector(optionButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

-(void)setOptionButtonDidSelevtedBlock:(OptionButtonDidSelevtedBlock)block
{
    _block = block;
}

-(void)optionButtonTouched:(UIButton *)btn
{
    _block(btn.tag);
}
@end
