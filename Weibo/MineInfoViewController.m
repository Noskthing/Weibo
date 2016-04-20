//
//  MineInfoViewController.m
//  Weibo
//
//  Created by apple on 15/12/11.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import "MineInfoViewController.h"
#import "MineScrollView.h"
#import "UIImageView+WebCache.h"
#import "LBWScrollView.h"
#import "Define.h"
#import "UIView+Additions.h"
#import "ConnectDelegate.h"

@interface MineInfoViewController ()<UIScrollViewDelegate>
{
    
    
    NSString * _title;
    UIImage * _searchImage;
    UIImage * _networkImage;
}

@property (nonatomic,strong)UIView * navgationBg;


@property (nonatomic,strong)UIImageView * bgView;
@property (nonatomic,strong)MineScrollView * scrollView;
@property (nonatomic,strong)UIBarButtonItem * searchWhite;
@property (nonatomic,strong)UIBarButtonItem * searchBlack;
@property (nonatomic,strong)UIBarButtonItem * moreWhite;
@property (nonatomic,strong)UIBarButtonItem * moreBlack;
@property (nonatomic,strong)UIBarButtonItem * searching;
@end

static const CGFloat bgViewHeight = 250;

static const CGFloat titleViewHeight = 35;
@implementation MineInfoViewController

#pragma mark   -懒加载
-(MineScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [MineScrollView mineScrollView];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

-(UIImageView *)bgView
{
    if (!_bgView)
    {
        _bgView = [[UIImageView alloc] init];
    }
    return _bgView;
}
-(UIView *)navgationBg
{
    if (!_navgationBg)
    {
        _navgationBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        _navgationBg.hidden = YES;
        _navgationBg.userInteractionEnabled = YES;
        [self.navigationController.view insertSubview:_navgationBg belowSubview:self.navigationController.navigationBar];
    }
    return _navgationBg;
}

-(UIBarButtonItem *)searchWhite
{
    if (!_searchWhite)
    {
        _searchWhite = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userinfo_navigationbar_search"]]];
    }
    return _searchWhite;
}

-(UIBarButtonItem *)searchBlack
{
    if (!_searchBlack)
    {
        _searchBlack = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userinfo_tabicon_search"]]];
    }
    return _searchBlack;
}

-(UIBarButtonItem *)moreWhite
{
    if (!_moreWhite)
    {
        _moreWhite = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userinfo_navigationbar_more"]]];
    }
    return _moreWhite;
}

-(UIBarButtonItem *)moreBlack
{
    if (!_moreBlack)
    {
        _moreBlack = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userinfo_tabicon_more"]]];
    }
    return _moreBlack;
}

-(UIBarButtonItem *)searching
{
    if (!_searching)
    {
        _searching = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableview_loading"]]];
    }
    return _searching;
}

#pragma mark   -操作隐去tabbr及上面自定义控件
-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]])
        {
            obj.hidden = YES;
        }
    }];
    self.tabBarController.tabBar.hidden = YES;
    [self changeNavgationBar];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.tabBarController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]])
        {
            obj.hidden = NO;
        }
    }];
    
    [self.navigationController.navigationBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")])
        {
            obj.hidden = NO;
        }
    }];
    
    self.tabBarController.tabBar.hidden = NO;
    [_navgationBg removeFromSuperview];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}


#pragma mark   -对navgationbar的操作实现自定义效果
//不可设navgationbar hidden   否则所有子视图全部隐去
-(void)changeNavgationBar
{
    //背景色设为透明
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    //移除磨砂效果背景图
    [self.navigationController.navigationBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")])
        {
            obj.hidden = YES;
        }
    }];
    //字体颜色定义
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //左侧barItem
    self.navigationItem.rightBarButtonItems = @[self.moreWhite,self.searchWhite];
}


#pragma mark   -创建主体UI
-(void)createUI
{

    //创建底部联动视图
//    UICollectionViewFlowLayout * layout  = [[UICollectionViewFlowLayout alloc] init];
//    TitleView * titleView = [[TitleView alloc] initWithFrame:CGRectMake(60, bgViewHeight, self.view.frame.size.width - 120, titleViewHeight) collectionViewLayout:layout];
//    //titleView背景
//    UIView * titleBgView = [[UIView alloc] initWithFrame:CGRectMake(0, bgViewHeight, self.view.frame.size.width, titleViewHeight)];
//    titleBgView.backgroundColor = [UIColor colorWithRed:0.961f green:0.961f blue:0.961f alpha:1];
//    [self.scrollView addSubview:titleBgView];
    
    
    UIView * view1 = [[UIView alloc] init];
    view1.backgroundColor = [UIColor yellowColor];
    UIView * view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor greenColor];
    UIView * view3 = [[UIView alloc] init];
    view3.backgroundColor = [UIColor redColor];

    
    NSArray * views = @[view1,view2,view3];
    
    //scollView背景
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, bgViewHeight + titleViewHeight, self.view.frame.size.width,self.view.frame.size.height - titleViewHeight)];
    scrollView.views = views;
    
    NSArray * arr = @[@"主页",@"微博",@"相册"];
    LBWScrollTitleView * titleView = [[LBWScrollTitleView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/5, bgViewHeight, self.view.frame.size.width * 3/5, titleViewHeight)];
    titleView.scrollModuleHeight = 3;
    titleView.scrollModuleColor = [UIColor orangeColor];
    titleView.titles = arr;
    
    scrollView.titleView = titleView;
    
    [self.scrollView addSubview:scrollView];
    [self.scrollView addSubview:titleView];
}

-(void)setUserInfoDict:(NSDictionary *)userInfo
{
    //背景视图
    self.bgView.frame = CGRectMake(0, 0, self.view.frame.size.width, bgViewHeight);
    if(userInfo[@"cover_image_phone"])
    {
        [self.bgView sd_setImageWithURL:[NSURL URLWithString:userInfo[@"cover_image_phone"]]];
    }
    else
    {
        self.bgView.image = [UIImage imageNamed:@"defaultBg"];
    }
    [self.view addSubview:self.bgView];
    
    //ScrollView视图
    self.scrollView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [self.scrollView setUserInfoDict:userInfo];
    [self.view addSubview:_scrollView];
    
    //导航栏标题
    _title = userInfo[@"name"];
}


#pragma mark  scrollView代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    UIColor * bgColor = [UIColor whiteColor];

    [self setNeedsStatusBarAppearanceUpdate];
    if(y >= 0)
    {
        _bgView.frame = CGRectMake(0, -y, self.view.frame.size.width,bgViewHeight);
        if (y < 50)
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            self.navgationBg.hidden = YES;
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            self.navigationItem.rightBarButtonItems = @[self.moreWhite,self.searchWhite];
            self.navigationItem.title = @"";
            self.navigationController.navigationBar.alpha = 1;
        }
        else
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            self.navgationBg.hidden = NO;
            self.navigationController.navigationBar.tintColor = [UIColor blackColor];
            self.navigationItem.rightBarButtonItems = @[self.moreBlack,self.searchBlack];
            if(_title)
            {
                self.navigationItem.title = _title;
            }
            if (y <= 150)
            {
                CGFloat scale = (y-100)/(bgViewHeight - y);
                self.navigationController.navigationBar.alpha = scale;
                self.navgationBg.backgroundColor = [bgColor colorWithAlphaComponent:scale];
            }
            else if (y <= bgViewHeight - 64)
            {
                self.navigationController.navigationBar.alpha = 1;
                self.navgationBg.backgroundColor = bgColor;
            }
            else
            {
                self.scrollView.contentOffset = CGPointMake(0, bgViewHeight - 64);
            }
        }

    }
    else
    {
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigationbar_icon_refresh_white"]];
        imageView.transform =  CGAffineTransformMakeRotation(M_PI_2 * y);
        imageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        UIBarButtonItem * rr = [[UIBarButtonItem alloc] initWithCustomView:imageView];
        self.navigationItem.rightBarButtonItems = @[rr];
        
        _bgView.frame = CGRectMake(0, 0, self.view.frame.size.width * (bgViewHeight - y)/bgViewHeight,bgViewHeight - y);
        _bgView.layer.position = CGPointMake(self.view.frame.size.width/2, (bgViewHeight - y)/2);
    }
        
}

#pragma mark    -请求数据
-(void)requestDataFromUrl:(NSString *)url
{
//     NSLog(@"%@",url);
    if (url)
    {
        ConnectDelegate * delegate = [ConnectDelegate standConnectDelegate];
        [delegate requestDataFromUrl:url andParseDataBlock:^(id obj) {
            NSDictionary * dict = obj;
            [self setUserInfoDict:dict];
        }];
    }
    else
    {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary * userInfo = [defaults objectForKey:@"userInfo"];
        
        [self setUserInfoDict:userInfo];
    }
}
#pragma mark   初始化数据
-(void)initData
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _searchImage = [UIImage imageNamed:@"userinfo_navigationbar_search"];
    _networkImage = [UIImage imageNamed:@"userinfo_navigationbar_more"];
    
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    NSDictionary * userInfo = [defaults objectForKey:@"userInfo"];
//    _title = userInfo[@"name"];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self changeNavgationBar];
    [self createUI];
    
}



@end
