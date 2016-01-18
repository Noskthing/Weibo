//
//  PostWordViewController.m
//  JustForFunOfLee
//
//  Created by apple on 16/1/7.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "PostWordViewController.h"
#import "UIView+Additions.h"
#import "LeeKeyboard.h"
#import "CustomTextView.h"
#import "StatusBtnView.h"
#import "ConnectDelegate.h"
#import "Define.h"
#import "LocationViewController.h"

@interface PostWordViewController ()<UIScrollViewDelegate>
{
    //背景视图下滑目标位置y坐标
    CGFloat _y;
    //发送按钮
    UIButton * _postBtn;
}
//自定义键盘的选择视图背景
@property (nonatomic,strong)UIView * bgView;
//输入视图
@property (nonatomic,strong)CustomTextView * textView;
//键盘按钮
@property (nonatomic,strong)UIButton * hideBtn;
//地址按钮
@property (nonatomic,strong)StatusBtnView * addressBtn;
//权限按钮
@property (nonatomic,strong)StatusBtnView * jurisdictionBtn;
@end

static const CGFloat customKeyBoardHeight = 46;
@implementation PostWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createNavigationBar];
    [self createUI];
    [self registerNotification];
}

-(void)dealloc
{
    [_textView removeObserver:self forKeyPath:@"text"];
    [_bgView removeObserver:self forKeyPath:@"frame"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLeeKeyBoardWillDisappear object:nil];
}

#pragma mark  -创建通知
-(void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification:) name:@"address" object:nil];
}

#pragma mark  -地址通知
-(void)getNotification:(NSNotification *)notification
{
    NSArray * arr = notification.object;
    [_addressBtn getCurrentAddress:arr[2] latitude:[arr[0] floatValue] longitude:[arr[1] floatValue]];
}

#pragma mark  -创建导航UI
-(void)createNavigationBar
{
    //背景
    UIView * navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    navigationView.backgroundColor = [UIColor colorWithRed:0.961f green:0.961f blue:0.961f alpha:1.00f];
    navigationView.layer.borderColor = [UIColor colorWithRed:0.843f green:0.843f blue:0.843f alpha:1.00f].CGColor;
    navigationView.layer.borderWidth = 1;
    //阴影效果   仿真系统原生navigationbar
//    navigationView.layer.masksToBounds = NO;
////    navigationView.layer.cornerRadius = 8; // if you like rounded corners
//    navigationView.layer.shadowOffset = CGSizeMake(0, 0.5);
////    navigationView.layer.shadowRadius = 5;
//    navigationView.layer.shadowOpacity = 0.5;
    [self.view addSubview:navigationView];
    
    //取消button
    UIButton * cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 34, 40, 18)];
    [cancelBtn setTitleColor:[UIColor colorWithRed:0.220f green:0.220f blue:0.220f alpha:1.00f] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [cancelBtn setTitle:@"取消" forState:0];
    [cancelBtn addTarget:self action:@selector(cancelBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [navigationView addSubview:cancelBtn];
    
    //发微博标题
    UILabel * postWeibo = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    postWeibo.text = @"发微博";
    postWeibo.font = [UIFont systemFontOfSize:15];
    postWeibo.textAlignment = NSTextAlignmentCenter;
    postWeibo.layer.anchorPoint = CGPointMake(0.5, 0);
    postWeibo.layer.position = CGPointMake(self.view.width/2, 23);
    [navigationView addSubview:postWeibo];
    
    //用户标题
    UILabel * userName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 15)];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * userInfo = [defaults objectForKey:@"userInfo"];
    userName.text = userInfo[@"screen_name"];
    userName.font = [UIFont systemFontOfSize:13];
    userName.textColor = [UIColor grayColor];
    userName.textAlignment = NSTextAlignmentCenter;
    userName.layer.anchorPoint = CGPointMake(0.5, 0);
    userName.layer.position = CGPointMake(self.view.width/2, CGRectGetMaxY(postWeibo.frame) + 3);
    [navigationView addSubview:userName];
    
    //发布button
    UIButton * postBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 65,30, 50, 25)];
    _postBtn = postBtn;
    [postBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    postBtn.backgroundColor = [UIColor whiteColor];
    postBtn.layer.borderColor = [UIColor blackColor].CGColor;
    postBtn.layer.cornerRadius = 3;
    [postBtn setTitle:@"发布" forState:0];
    [postBtn addTarget:self action:@selector(postBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    postBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [navigationView addSubview:postBtn];
}


-(void)createUI
{
    //滑动背景图
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64)];
    scrollView.bounces = YES;
    scrollView.contentSize = CGSizeMake(self.view.width, self.view.height - 63);
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    //底部状态栏视图
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - customKeyBoardHeight, self.view.width, customKeyBoardHeight)];
    _bgView.backgroundColor = [UIColor colorWithRed:0.957f green:0.957f blue:0.957f alpha:1.00f];
    _bgView.layer.borderColor = [UIColor colorWithRed:0.843f green:0.843f blue:0.843f alpha:1.00f].CGColor;
    _bgView.layer.borderWidth = 1;
    [_bgView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:_bgView];
    
    //地址按钮
    StatusBtnView * btn = [[StatusBtnView alloc] initWithFrame:CGRectMake(10, CGRectGetMinY(_bgView.frame) - 30, self.view.width *2/3, 24)];
    _addressBtn = btn;
    [btn setDetailText:@"显示位置" imageName:@"compose_locatebutton_ready" viewAlignment:viewAlignmentLeft];
    [btn setMaskBtnDidSeletcedBlock:^{
        NSLog(@"aaaaaa");
        LocationViewController * locationVC = [[LocationViewController alloc] init];
        [self presentViewController:locationVC animated:YES completion:^{
            
        }];
    }];
    [self.view addSubview:btn];
    
    //权限按钮
    _jurisdictionBtn = [[StatusBtnView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame), CGRectGetMinY(_bgView.frame) - 30, self.view.width - CGRectGetMaxX(btn.frame) - 10, 24)];
    [_jurisdictionBtn changeTextColor:[UIColor colorWithRed:0.392f green:0.525f blue:0.702f alpha:1.00f]];
    [_jurisdictionBtn setDetailText:@"公开" imageName:@"compose_publicbutton" viewAlignment:viewAlignmentRight];
    [self.view addSubview:_jurisdictionBtn];
    
    //初始化
    _y = self.view.height - customKeyBoardHeight;
    NSArray * btnImages = @[@"compose_toolbar_picture",@"compose_mentionbutton_background",@"compose_trendbutton_background",@"compose_emoticonbutton_background",@"message_add_background"];
    NSArray * btnHightLightImages = @[@"compose_toolbar_picture_highlighted",@"compose_mentionbutton_background_highlighted",@"compose_trendbutton_background_highlighted",@"compose_emoticonbutton_background_highlighted",@"message_add_background_highlighted"];
    
    CGFloat btnWidth = self.view.width/5;
    for (int i = 0; i < 5; i ++)
    {
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(i * btnWidth, 0, btnWidth, customKeyBoardHeight)];
        btn.tag = 200 + i;
        [btn setImage:[UIImage imageNamed:btnImages[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:btnHightLightImages[i]] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(customKeyBoardBarButtonsDidSelected:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:btn];
        
        if (i == 3)
        {
            UIButton * hideBtn = [[UIButton alloc] initWithFrame:CGRectMake(i * btnWidth, 0, btnWidth, customKeyBoardHeight)];
            hideBtn.backgroundColor = [UIColor colorWithRed:0.957f green:0.957f blue:0.957f alpha:1.00f];
            _hideBtn = hideBtn;
            hideBtn.tag = 205;
            hideBtn.hidden = YES;
            [hideBtn setImage:[UIImage imageNamed:@"compose_keyboardbutton_background"] forState:UIControlStateNormal];
            [hideBtn setImage:[UIImage imageNamed:@"compose_keyboardbutton_background_highlighted"] forState:UIControlStateHighlighted];
            [hideBtn addTarget:self action:@selector(customKeyBoardBarButtonsDidSelected:) forControlEvents:UIControlEventTouchUpInside];
            [_bgView addSubview:hideBtn];
        }
    }
    
    //输入视图
    _textView = [[CustomTextView alloc] initWithFrame:CGRectMake(0,5, self.view.width, 160)];
    [_textView addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [scrollView addSubview:_textView];
}

#pragma mark   -UIButton点击事件
- (void)cancelBtnTouch:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLeeKeyBoardWillDisappear object:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)postBtnTouch:(UIButton *)sender
{
    NSString * str = _textView.text;
    [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString * access_token = NSUserDefaultsObjectForKey(@"access_token");
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:@{@"access_token":access_token,@"status":str}];
    if (_addressBtn.lon!= 0 && _addressBtn.lat !=0)
    {
        [dict setObject:@(_addressBtn.lat) forKey:@"lat"];
        [dict setObject:@(_addressBtn.lon) forKey:@"long"];
    }
    
    ConnectDelegate * connect = [ConnectDelegate standConnectDelegate];
    [connect requestDataFromUrl:@"https://api.weibo.com/2/statuses/update.json" parameters:[dict copy] andParseDataBlock:^(id obj) {
        if (obj)
        {
            NSLog(@"obj = %@",obj);
        }
    }];
}

-(void)customKeyBoardBarButtonsDidSelected:(UIButton *)btn
{
    switch (btn.tag)
    {
        case 200:
        {
            
        }
            break;
        case 201:
        {
            
        }
            break;
        case 202:
        {
            
        }
            break;
        case 203:
        {
            _y = self.view.height - customKeyBoardHeight - leeKeyBoardHeight;
            
            //隐藏系统键盘
            [_textView resignFirstResponder];
            //弹出自定义表情键盘
            [[NSNotificationCenter defaultCenter] postNotificationName:kLeeKeyBorardWillAppear object:_textView userInfo:nil];
            [UIView animateWithDuration:leeKeyBoardAnimationDuration animations:^{
                CGRect rect = _bgView.frame;
                rect.origin.y = self.view.height - customKeyBoardHeight - leeKeyBoardHeight;
                _bgView.frame = rect;
            }];
            
            _hideBtn.hidden = NO;
        }
            break;
        case 204:
        {
            
        }
            break;
        case 205:
        {
            //隐藏自定义表情键盘
            [[NSNotificationCenter defaultCenter] postNotificationName:kLeeKeyBoardWillDisappear object:_textView userInfo:nil];
            //修改状态栏下滑目标位置
            _y = self.view.height - customKeyBoardHeight - leeKeyBoardHeight;
            //出现系统键盘
            [_textView becomeFirstResponder];
        }
            break;
        default:
            break;
    }
}

#pragma mark  -观察者模式
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"text"])
    {
        if (_textView.text.length == 0)
        {
            _textView.label.hidden = NO;
            _postBtn.backgroundColor = [UIColor whiteColor];
            [_postBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        else
        {
            _textView.label.hidden = YES;
            _postBtn.backgroundColor = [UIColor orangeColor];
            [_postBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    else if ([keyPath isEqualToString:@"frame"])
    {
        _addressBtn.frame = CGRectMake(10, CGRectGetMinY(_bgView.frame) - 30, self.view.width *2/3, 24);
        _jurisdictionBtn.frame = CGRectMake(CGRectGetMaxX(_addressBtn.frame), CGRectGetMinY(_bgView.frame) - 30, self.view.width - CGRectGetMaxX(_addressBtn.frame) - 10, 24);
    }
}

-(void)keyBoardWillAppear:(NSNotification *)notification
{
    //1.获取动画
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //2.获取键盘弹出后的坐标
    CGRect frameForKeyboardEnd = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration animations:^{
        CGRect rect = _bgView.frame;
        rect.origin.y = self.view.height - rect.size.height - frameForKeyboardEnd.size.height;
        _bgView.frame = rect;
    } completion:^(BOOL finished) {
        
    }];
    
    //隐藏键盘按钮
    _hideBtn.hidden = YES;
}

-(void)keyBoardWillDisappear:(NSNotification *)notification
{
    //1.获取动画
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        CGRect rect = _bgView.frame;
        rect.origin.y = _y;
        _bgView.frame = rect;
    } completion:^(BOOL finished) {
        _y = self.view.height - customKeyBoardHeight;
    }];
}

#pragma mark  -监听滑动视图  收回键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLeeKeyBoardWillDisappear object:nil];
    [_textView resignFirstResponder];
    
    [UIView animateWithDuration:leeKeyBoardAnimationDuration animations:^{
        CGRect rect = _bgView.frame;
        rect.origin.y = self.view.height - customKeyBoardHeight;
        _bgView.frame = rect;
    }];
}
@end
