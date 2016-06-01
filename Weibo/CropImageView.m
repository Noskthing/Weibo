//
//  CropImageView.m
//  JustForFunOfLee
//
//  Created by feerie luxe on 16/5/31.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "CropImageView.h"

#define ColorWithRGB(R,G,B) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]
@interface CropImageView ()
{
    UIScrollView * _scrollView;
    
    CGSize _baseSize;
    
    OptionButtonDidSelectedBlock _block;
}
@end

@implementation CropImageView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = ColorWithRGB(239, 239, 239);
        self.clipsToBounds = YES;
        
        //创建分割线
        CGFloat space = (frame.size.width - 4)/3;
        
        for (NSInteger i = 0; i < 2; i++)
        {
            UIView * row = [[UIView alloc] initWithFrame:CGRectMake((space + 2) * i + space, 0, 2, frame.size.width)];
            row.backgroundColor = [UIColor whiteColor];
            [self addSubview:row];
            
            UIView * column = [[UIView alloc] initWithFrame:CGRectMake(0, (space + 2) * i + space, frame.size.width, 2)];
            column.backgroundColor = [UIColor whiteColor];
            [self addSubview:column];
        }
        
        //创建底部蒙版
        UIView * maskView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.width, frame.size.width, frame.size.height - frame.size.width)];
        maskView.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5];
        [self addSubview:maskView];
        
        //底部Button
        UIButton * check = [[UIButton alloc] initWithFrame:CGRectMake(0, frame.size.height - 49, frame.size.width/2, 49)];
        check.tag = 10;
        check.backgroundColor = [UIColor whiteColor];
        [check addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [check setImage:[UIImage imageNamed:@"camera_edit_check"] forState:UIControlStateNormal];
        [self addSubview:check];
        
        UIButton * cancel = [[UIButton alloc] initWithFrame:CGRectMake( frame.size.width/2, frame.size.height - 49, frame.size.width/2, 49)];
        cancel.backgroundColor = [UIColor whiteColor];
        cancel.tag = 20;
        [cancel addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [cancel setImage:[UIImage imageNamed:@"camera_edit_cross"] forState:UIControlStateNormal];
        [self addSubview:cancel];
    }
    
    return self;
}

-(void)setOptionButtonDidSelectedBlock:(OptionButtonDidSelectedBlock)block
{
    _block = block;
}

-(void)setImage:(UIImage *)image
{
//    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
//    _scrollView.contentSize = CGRectMake(0, 0, image.scale >=1?self.frame.size.width:self.frame.size.width/image.scale, image.scale >= 1?self.frame.size.width * image.scale : self.frame.size.width).size;
//    [self insertSubview:_scrollView atIndex:0];
//    NSLog(@"scale is %f ---%f",image.size.width,image.size.height);
    
    CGFloat scale = image.size.height/image.size.width;
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scale >=1.0?self.frame.size.width:self.frame.size.width/scale, scale >= 1.0?self.frame.size.width * scale : self.frame.size.width)];
    imageView.image = image;
    imageView.userInteractionEnabled = YES;
    _baseSize = imageView.frame.size;
    [self insertSubview:imageView atIndex:0];
    
    // 添加拖动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self  action:@selector(handlePan:)];
    [imageView addGestureRecognizer:panGestureRecognizer];
    
    //添加捏合手势
    imageView.multipleTouchEnabled = YES;
    UIPinchGestureRecognizer* gesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImage:)];
    [imageView addGestureRecognizer:gesture];
}

#pragma mark   手势实现
- (void)handlePan:(UIPanGestureRecognizer*) recognizer
{
    CGPoint translation = [recognizer translationInView:self];
    
//    NSLog(@"translation.x is %f,translation.y is %f",translation.x,translation.y);
    
    
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        CGPoint point = recognizer.view.center;
        
        //center合法性确认
        if (point.x > _baseSize.width/2 + 10)
        {
            point.x = _baseSize.width/2 + 10;
        }
        else
        {
            if ( (_baseSize.width/2 - point.x) > (_baseSize.width - self.frame.size.width + 10))
            {
                point.x = self.frame.size.width - _baseSize.width/2 - 10;
            }
        }
        
        if (point.y > _baseSize.height/2 + 10)
        {
            point.y = _baseSize.height/2 + 10;
        }
        else
        {
            if ((_baseSize.height/2 - point.y) > (_baseSize.height - self.frame.size.width + 10))
            {
                point.y = self.frame.size.width - _baseSize.height/2 - 10;
            }
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            recognizer.view.center = point;
        }];
        
    }
    else
    {
        recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    }
    
    [recognizer setTranslation:CGPointZero inView:self];
    
}

- (void) scaleImage:(UIPinchGestureRecognizer*)gesture

{
    
    CGFloat scale = gesture.scale;
    
    CGRect rect = gesture.view.frame;
    rect.size = CGSizeMake(_baseSize.width * scale, _baseSize.height * scale);
    
    gesture.view.frame = rect;
    
//    NSLog(@"scale is %f",scale);
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        _baseSize = gesture.view.frame.size;
    }
    
}

#pragma mark     点击事件
-(void)buttonTouched:(UIButton *)btn
{
    switch (btn.tag)
    {
        case 10:
        {
            
        }
            break;
            
        case 20:
        {
            _block(nil);
        }
            break;
        default:
            break;
    }
}
@end
