//
//  EmotionView.m
//  JustForFunOfLee
//
//  Created by apple on 16/1/8.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "EmotionView.h"
#import "UIView+Additions.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@class LeeKeyboard;
@interface EmotionView ()
{
    //表情视图背景
    UIView * _bgView;
    //表情点击block
    EmotionDidSeletcedBlock _block;
    //底部栏视图
    UIView * _bottomView;
    //单个视图尺寸
    CGFloat _width;
    CGFloat _height;
    //创建放大表情视图
    UIImageView * _enlargeView;
    //被放大表情
    UIImageView * _contentView;
    //保存表情数组
    NSArray * _emotions;
    NSArray * _emotionNames;
}
@end

static const CGFloat emotionScale = 0.14;
@implementation EmotionView

#pragma mark   -初始化
-(instancetype)init
{
    if (self = [super init])
    {
        _isFirstTimeMoveToSuperView = YES;
        self.clipsToBounds = NO;
    }
    return self;
}

-(void)setEmotionDidSeletcedBlock:(EmotionDidSeletcedBlock)block
{
    _block = block;
}

-(void)setBottomView:(UIView *)view
{
    _bottomView = view;
}

-(void)setImageNames:(NSArray *)names
{
    //计算每个表情视图的大小
    _width = _bgView.width/7;
    _height = _bgView.height/3;
    
    _emotions = names;
    
    [names enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @autoreleasepool
        {
            CGFloat row = (idx + 1)%7==0?idx/7-1:idx/7;
            CGFloat column = idx%7;
            
            [self createEmotionViewWithColumn:column row:row imageName:names[idx] tag:idx];
        }
    }];
    
    //删除视图
    [self createEmotionViewWithColumn:6 row:2 imageName:@"compose_emotion_delete" tag:20];
}

#pragma mark  -根据行列创建表情视图
-(void)createEmotionViewWithColumn:(NSInteger)column row:(NSInteger)row imageName:(NSString *)imageName tag:(NSInteger)tag
{
    UIView * emotionView = [[UIView alloc] initWithFrame:CGRectMake(column * _width, row * _height, _width, _height)];
    [_bgView addSubview:emotionView];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(emotionScale * _width, emotionScale * _width, (1 - 2 * emotionScale) * _width, (1 - 2 * emotionScale) * _width)];
    imageView.tag = tag;
    
    if ((column + 7 * row) == 20)
    {
        imageView.image = [UIImage imageNamed:imageName];
    }
    else
    {
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageName]];
    }
    
    imageView.userInteractionEnabled = YES;
    //点击手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTouch:)];
    [imageView addGestureRecognizer:tap];
    
    [emotionView addSubview:imageView];
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    if (_isFirstTimeMoveToSuperView)
    {
        //创建子视图背景
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width -20, self.frame.size.height - 40)];
        [self addSubview:_bgView];
        
        //获取表情字典
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary * expression = [defaults objectForKey:@"expression"];
        NSArray * keys = [expression allKeys];
        if (expression)
        {
            NSInteger page = self.tag/5;
            if ( page > 0)
            {
                NSArray * arr = [keys subarrayWithRange:NSMakeRange((page - 1) * 21 + 112, 21)];
                _emotionNames = arr;
                NSMutableArray * values = [NSMutableArray array];
                [arr enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [values addObject:expression[obj]];
                }];
                [self setImageNames:[values copy]];
            }
            else
            {
                [self setImageNames:@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]];
            }
        }
 
        //添加长按手势
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTouch:)];
        [_bgView addGestureRecognizer:longPress];
        
        //底部视图加载
        if(_bottomView)
        {
            _bottomView.frame = CGRectMake(0, CGRectGetMaxY(_bgView.frame) + 5, self.frame.size.width, 20);
            [self addSubview:_bottomView];
        }
        _isFirstTimeMoveToSuperView = NO;
        
        //创建放大表情视图
        //宽高缩放比例
        CGFloat widthScale = 1.5;
        CGFloat heightScale = 2.1;
        UIImageView * enlargeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _width * widthScale, _height * heightScale)];
        _enlargeView = enlargeView;
        enlargeView.image = [UIImage imageNamed:@"emoticon_keyboard_magnifier"];
        //确定锚点
        enlargeView.layer.anchorPoint = CGPointMake(0.5, 1);
        enlargeView.hidden = YES;
        [_bgView addSubview:enlargeView];
        
        //放大表情视图
        //视图边距
        CGFloat widthSpace = 14;
        CGFloat topSpace = 8;
         _contentView = [[UIImageView alloc] initWithFrame:CGRectMake(widthSpace, topSpace, _width * widthScale - 2 * widthSpace, _width * widthScale - 2 * widthSpace)];
        [enlargeView addSubview:_contentView];
    }
}

#pragma mark   -表情点击手势
-(void)handleTouch:(UITapGestureRecognizer *)tap
{
    UIImageView * imageView = (UIImageView *)tap.view;
    NSLog(@"tag = %ld   name = %@",tap.view.tag,_emotionNames[tap.view.tag]);
    if (_block)
    {
        _block(imageView.image,_emotionNames[tap.view.tag]);
    }
}

-(void)longPressTouch:(UILongPressGestureRecognizer *)longPress
{
    CGPoint point = [longPress locationInView:_bgView];
    
    NSInteger column = point.x/_width + 1;
    NSInteger row = point.y/_height + 1;
    
    NSInteger num = 7 * (row - 1) + column - 1;
    
    if((column + (row - 1) * 7) < 21 && column != 0 && row != 0)
    {
        _enlargeView.hidden = NO;
        //将视图上移一部分  避免手指覆盖到放大的表情
        _enlargeView.layer.position = CGPointMake(column * _width - _width/2,row * _height - 10);
        [_contentView sd_setImageWithURL:[NSURL URLWithString:_emotions[num]]];
        
        if (longPress.state == UIGestureRecognizerStateEnded)
        {
            _enlargeView.hidden = YES;
        }
    }
    else
    {
        _enlargeView.hidden = YES;
    }
    
    
    
    NSLog(@"第%ld行 第%ld列",(long)row,(long)column);
}
@end
