//
//  UnusedViewController.m
//  Weibo
//
//  Created by apple on 15/11/30.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import "UnusedViewController.h"
#import "OtherView.h"
#import "AppDelegate.h"
#import "PostWordViewController.h"
#import "MineInfoViewController.h"

@interface UnusedViewController ()
{
    UIScreen * _screen;
    UIVisualEffectView * _effect;
    NSInteger _num;
    NSTimer * _timer;
    UIImageView * _cancelView;
    UITabBarController * _tabbr;
    UIView * _bgView;
    AppDelegate * _appDelegate;
}
@end

@implementation UnusedViewController


-(instancetype)init
{
    if (self = [super init])
    {
        [self initUI];
    }
    return self;
}

#pragma mark   -初始化UI
-(void)initUI
{
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _tabbr = (UITabBarController *)_appDelegate.window.rootViewController;
    
    //获取屏幕尺寸
    _screen = [UIScreen mainScreen];
    
    //设置点击事件
    _num = 0;
    
    //设置button覆盖第三个tabbr
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 45)];
    //btn背景
    [btn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_friend-1"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateSelected];
    btn.layer.position = CGPointMake(_screen.bounds.size.width/2, _screen.bounds.size.height -25);
    //    btn.backgroundColor = [UIColor orangeColor];
    [_appDelegate.window.rootViewController.view addSubview:btn];
    
    [btn addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark   -更多按钮点击时间
-(void)btnTouch:(UIButton *)sender
{
    
    if (sender.tag == 30)
    {
        [sender removeFromSuperview];
        for(NSInteger i = 10;i<21;i++)
        {
            OtherView * view = [_effect viewWithTag:i];
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect = view.frame;
                rect.origin.x += _screen.bounds.size.width;
                view.frame = rect;
            }];
        }
        _cancelView.layer.position = CGPointMake(_bgView.frame.size.width/2,_bgView.frame.size.height/2);
    }
    else
    {
        //毛玻璃背景效果
        _effect = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        _effect.frame =CGRectMake(0, 0, _screen.bounds.size.width, _screen.bounds.size.height);
        _effect.tag = 100;
        [_appDelegate.window addSubview:_effect];
        
        //标题文字图片
        UIImageView * titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share"]];
        titleImageView.frame = CGRectMake(0, 0, _screen.bounds.size.width/2, _screen.bounds.size.width/6);
        titleImageView.layer.position = CGPointMake(_screen.bounds.size.width/2, 100);
        [_effect addSubview:titleImageView];
        
        //标题动画
        _timer = [[NSTimer alloc] initWithFireDate:[NSDate distantPast] interval:0.03 target:self selector:@selector(createOtherView) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        
        //返回栏背景
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, _screen.bounds.size.height - 49, _screen.bounds.size.width, 49)];
        _bgView.backgroundColor = [UIColor whiteColor];
        
        _cancelView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        _cancelView.image = [UIImage imageNamed:@"tabbar_compose_background_icon_add"];
        _cancelView.layer.position = CGPointMake(_bgView.frame.size.width/2, _bgView.frame.size.height/2);
        [_bgView addSubview:_cancelView];
        //旋转动画
        [UIView animateWithDuration:0.2 animations:^{
            _cancelView.transform = CGAffineTransformMakeRotation(M_PI/4);
        } completion:^(BOOL finished) {
            //设置点击事件
            _cancelView.userInteractionEnabled = YES;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewTouch:)];
            [_cancelView addGestureRecognizer:tap];
        }];
        
        [_effect addSubview:_bgView];
    }
    
}

#pragma mark  -创建小视图并动画出现
-(void)createOtherView
{
    //停止计时器
    if (_num == 5)
    {
        [_timer invalidate];
        _timer = nil;
        [self createRightOtherView];
    }
    
    //计算每一个标题的大小
    CGFloat space = 10;
    CGFloat width = (_screen.bounds.size.width - 60 - space * 2)/3;
    CGFloat height = width + 30;
    
    //计算该标题是在几行几列
    NSInteger row = _num/3;  //行
    NSInteger column = _num%3;  //列
    
    //图片名字 和 标题数组
    NSArray * images = @[@"tabbar_compose_idea",@"tabbar_compose_photo",@"tabbar_compose_weibo",@"tabbar_compose_lbs",@"tabbar_compose_review",@"tabbar_compose_more"];
    NSArray * titles = @[@"文字",@"照片/视频",@"长微博",@"签到",@"点评",@"更多"];
    
    //创建视图
    OtherView * view = [[OtherView alloc] initWithFrame:CGRectMake(30 + column * (width + space),_screen.bounds.size.height  + row * height, width, height)];
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherViewTouch:)];
    [view addGestureRecognizer:tap];
    view.tag = _num + 10;
    
    [view setImage:[UIImage imageNamed:images[_num]] andTitle:titles[_num ]];
    [_effect addSubview:view];
    
    //开始动画
    [UIView animateWithDuration:0.25 animations:^{
        view.frame = CGRectMake(30 + column * (width + space), _screen.bounds.size.height - height * 2 - 210 + row * height , width, height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            view.frame = CGRectMake(30 + column * (width + space),_screen.bounds   .size.height - height * 2 - 190 + row * (height + 10) , width, height);
        }];
    }];
    
    
    //计数增加
    _num ++ ;
}


-(void)createRightOtherView
{
    //计算每一个标题的大小
    CGFloat space = 10;
    CGFloat width = (_screen.bounds.size.width - 60 - space * 2)/3;
    CGFloat height = width + 30;
    
    
    for (NSInteger i = 0; i< 5; i++)
    {
        //计算该标题是在几行几列
        NSInteger row = i/3;  //行
        NSInteger column = i%3;  //列
        
        //图片名字 和 标题数组
        NSArray * images = @[@"tabbar_compose_idea",@"tabbar_compose_photo",@"tabbar_compose_weibo",@"tabbar_compose_lbs",@"tabbar_compose_review"];
        NSArray * titles = @[@"文字",@"照片/视频",@"长微博",@"签到",@"点评"];
        
        //创建视图
        OtherView * view = [[OtherView alloc] initWithFrame:CGRectMake(30 + column * (width + space) + _screen.bounds.size.width,_screen.bounds.size.height - height * 2 - 190 + row * (height + 10) , width, height)];
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherViewTouch:)];
        [view addGestureRecognizer:tap];
        view.tag = i + 16;
        
        [view setImage:[UIImage imageNamed:images[i]] andTitle:titles[i]];
        [_effect addSubview:view];
    }
}

#pragma mark  -返回按钮点击事件
-(void)backViewTouch:(UITapGestureRecognizer *)tap
{
    //旋转动画
    //动画偏移比例仍然是比对原图 而不是动画过的坐标
    [UIView animateWithDuration:0.2 animations:^{
        _cancelView.transform = CGAffineTransformMakeRotation(0);
    }];
    
    _num--;
    [self getBackOtherView];
}


#pragma mark  -视图收回动画
-(void)getBackOtherView
{
    if (_num == -1)
    {
        _num = 0;
    }
    else
    {
        //根据tag获取view注意
        //        tag不要从0开始  给他加上一个基础值
        //        view默认tag = 0
        //        会出现不可知的bug
        OtherView * view = (OtherView *)[_effect viewWithTag:(_num+ 10)];
        
        NSInteger num = _num;
        __block CGRect rect = view.frame;
        [UIView animateWithDuration:0.03 animations:^{
            rect.origin.y -= 10;
            view.frame = rect;
        } completion:^(BOOL finished) {
            if(view.tag >= 10)
            {
                _num--;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getBackOtherView];
                });
            }
            [UIView animateWithDuration:0.25 animations:^{
                rect.origin.y += 500;
                view.frame = rect;
            } completion:^(BOOL finished) {
                if (num == 0)
                {
                    [_effect removeFromSuperview];
                }
            }];
        }];
        
        OtherView * view2 = (OtherView *)[_effect viewWithTag:(_num + 16)];
        __block CGRect rect2 = view2.frame;
        [UIView animateWithDuration:0.03 animations:^{
            rect2.origin.y -= 10;
            view2.frame = rect2;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 animations:^{
                rect2.origin.y += 500;
                view2.frame = rect2;
            }];
        }];
        
    }
    
}

#pragma mark  -OtherView点击事件
-(void)otherViewTouch:(UITapGestureRecognizer *)tap
{
    OtherView * otherView = (OtherView *)tap.view;
    NSLog(@"%ld",(long)otherView.tag);
    
    if (otherView.tag != 15)
    {
        //动画效果  完成动画以后移除该视图
        [UIView animateWithDuration:0.4 animations:^
         {
             otherView.alpha = 0;
             otherView.transform = CGAffineTransformMakeScale(1.3, 1.3);
         } completion:^(BOOL finished) {
             _num = 0;
             [_effect removeFromSuperview];
             
             switch (otherView.tag)
             {
                 case 10:
                 {
                     PostWordViewController * postViewController = [[PostWordViewController alloc] init];
                     [self presentViewController:postViewController animated:YES completion:^{
                         
                     }];
                 }
                     break;
                 case 11:
                 {
 
                 }
                     break;
                 case 12:
                 {
                     
                 }
                     break;
                 case 13:
                 {
                     
                 }
                     break;
                 case 14:
                 {
                     
                 }
                     break;
                 case 15:
                 {
                     
                 }
                     break;
                 case 16:
                 {
                     
                 }
                     break;
                 case 17:
                 {
                     
                 }
                     break;
                 case 18:
                 {
                     
                 }
                     break;
                 case 19:
                 {
                     
                 }
                     break;
                 case 20:
                 {
                     
                 }
                     break;
                 case 21:
                 {
                     
                 }
                     break;
                 default:
                     break;
             }
         }];
    }
    else
    {
        for(NSInteger i = 10;i<21;i++)
        {
            OtherView * view = [_effect viewWithTag:i];
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect = view.frame;
                rect.origin.x -= _screen.bounds.size.width;
                view.frame = rect;
            }];
        }
        _cancelView.layer.position = CGPointMake(_bgView.frame.size.width *3/4,_bgView.frame.size.height/2);
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        btn.tag = 30;
        [btn setImage:[UIImage imageNamed:@"navigationbar_back"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"navigationbar_back_highlighted"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.position = CGPointMake(_bgView.frame.size.width /4,_bgView.frame.size.height/2);
        [_bgView addSubview:btn];
    }
    
    
}


@end
