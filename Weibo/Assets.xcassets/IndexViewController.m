//
//  IndexViewController.m
//  Weibo
//
//  Created by apple on 15/11/30.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import "IndexViewController.h"
#import "OtherView.h"
#import "WeiboSDK.h"
#import "WeboTypeHeaderView.h"
#import "WeiboTypeTableView.h"
#import "ConnectDelegate.h"
#import "WeiboModel.h"
#import "WeiBoTableView.h"
#import "UIView+Additions.h"
#import "WeiBoTableViewCell.h"
#import "WebVIewController.h"
#import "Define.h"
#import "MineInfoViewController.h"
#import "NavgationBarTitleBtn.h"
#import "PopOverView.h"
#import "UIScreen+Additions.h"
#import "RightBtnTableView.h"
#import "TitleViewTableView.h"
#import "DevelopmentViewController.h"

@interface IndexViewController ()<UIGestureRecognizerDelegate,WeiBoCellRichTextDidSeletcedDelegate>
{
    CGRect _originalRect;
    WeiBoTableView * _tableView;
    UIActivityIndicatorView * _activityIndicatorView;
    NavgationBarTitleBtn * _navgationBarTitleBtn;
    //微博数据
    NSMutableArray * _models;
    //    WeboTypeHeaderView * _headerView;
}
//标题视图
@property (nonatomic,strong)PopOverView * titlePopOverView;
//雷达按钮视图
@property (nonatomic,strong)PopOverView * rightPopOverView;
//蒙版button
@property (nonatomic,strong)UIButton * maskBtn;
@end

@implementation IndexViewController

#pragma mark  -懒加载
-(PopOverView *)titlePopOverView
{
    if (!_titlePopOverView)
    {
        _titlePopOverView = [[PopOverView alloc] initWithFrame:CGRectMake(0, 0,180, 340) backgroundImage:[UIImage imageNamed:@"popover_background"]];
        
        //确定位置
        _titlePopOverView.layer.anchorPoint = CGPointMake(0.5, 0);
        _titlePopOverView.layer.position = CGPointMake(self.view.frame.size.width/2, 55);
        
        //创建tableView
        TitleViewTableView * tablevView = [[TitleViewTableView alloc] initWithFrame:CGRectMake(3, 9, _titlePopOverView.width - 6, _titlePopOverView.height - 49)];
        [tablevView setTitles:@[@[@"首页",@"好友圈",@"群微博",@"我的微博"],@[@"特别关注",@"名人明星",@"同事",@"同学",@"悄悄关注"],@[@"周边微博"]]];
        [tablevView setCellDidSelectedBlock:^(NSIndexPath *indexPath) {
            NSLog(@"点击了哟");
        }];
        [_titlePopOverView addSubview:tablevView];
        
        //创建编辑按钮
        UIButton * editBtn = [[UIButton alloc] initWithFrame:CGRectMake(3, CGRectGetMaxY(tablevView.frame), _titlePopOverView.width - 6, 38)];
        [editBtn setBackgroundImage:[UIImage imageNamed:@"popover_noarrow_background"] forState:UIControlStateNormal];
        [editBtn setTitle:@"编辑我的分组" forState:UIControlStateNormal];
        editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_titlePopOverView addSubview:editBtn];
        
        [self.navigationController.view addSubview:_titlePopOverView];
        [self.navigationController.view bringSubviewToFront:_titlePopOverView];
    }
    return _titlePopOverView;
}

-(PopOverView *)rightPopOverView
{
    if (!_rightPopOverView)
    {
        _rightPopOverView = [[PopOverView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width * 3/7, 100) backgroundImage:[UIImage imageNamed:@"popover_background_right"]];
        
        //确定位置
        _rightPopOverView.layer.anchorPoint = CGPointMake(1, 0);
        _rightPopOverView.layer.position = CGPointMake(self.view.frame.size.width - 8, 55);
        
        //创建tableView
        RightBtnTableView * rightBtnTableView = [[RightBtnTableView alloc] initWithFrame:CGRectMake(0, 9, _rightPopOverView.width,_rightPopOverView.height - 15)];
        [rightBtnTableView setCellDidSelectedBlock:^(NSIndexPath *indexPath) {
            NSLog(@"简单的小测试%ld",(long)indexPath.row);
        }];
        
        [_rightPopOverView addSubview:rightBtnTableView];
        [self.navigationController.view addSubview:_rightPopOverView];
        [self.navigationController.view bringSubviewToFront:_rightPopOverView];
    }
    return _rightPopOverView;
}

-(UIButton *)maskBtn
{
    if (!_maskBtn)
    {
        _maskBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.view.width, self.navigationController.view.height)];
        _maskBtn.backgroundColor = [UIColor clearColor];
        _maskBtn.hidden = YES;
        [_maskBtn addTarget:self action:@selector(maskBtnDidSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.view addSubview:_maskBtn];
    }
    return _maskBtn;
}

#pragma mark    初始化操作
-(void)initViewController
{
    //初始化数据
    self.view.backgroundColor = [UIColor whiteColor];
    _originalRect = self.tabBarController.view.frame;
    
    //添加手势
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleTouch:)];
    pan.delegate = self;
    [self.tabBarController.view addGestureRecognizer:pan];
    
    //初始化数组
    _models = [NSMutableArray array];
}


-(instancetype)init
{
    if (self = [super init])
    {
        UIImage * image = [UIImage imageNamed:@"tabbar_home"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIImage * selectedImage = [UIImage imageNamed:@"tabbar_home_selected"];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        self.tabBarItem.image = image;
        self.tabBarItem.selectedImage = selectedImage;
        self.tabBarItem.title = @"首页";
        
        //字体颜色设置
        [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initViewController];
    
    [self getJurisdiction];
}

#pragma mark   请求数据
-(void)getDataFromNetWorkWithUserInfo:(NSString *)accion;
{
    NSString * urlStr = [NSString stringWithFormat:@"%@?access_token=%@",UserNewFriendWeiBo,accion];

    
    ConnectDelegate * connect = [ConnectDelegate standConnectDelegate];
    [connect requestDataFromUrl:urlStr andParseDataBlock:^(id obj) {
        @autoreleasepool
        {
            if (obj)
            {
                //可变数组要放进池中   否则会相同数据累加多次
                NSMutableArray * models = [NSMutableArray array];
                
                NSDictionary * dict = obj;
                NSArray * statuses = dict[@"statuses"];
                [statuses enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull modelDict, NSUInteger idx, BOOL * _Nonnull stop) {
                    WeiboModel * model = [[WeiboModel alloc] init];
                    [model setValuesForKeysWithDictionary:modelDict];
                    [model getCellHeightWithContent];
                    [models addObject:model];
                }];
                [_tableView setDataModels:[models copy]];
                
                //获取用户字典
                //代理类貌似不能同时请求数据 有一方会失败 要按先后顺序
                [self getUserInfo];
            }
            
        }
    }];
}

#pragma mark  判断是否有权限
-(void)getJurisdiction
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSString * str = [defaults objectForKey:@"uid"];
    //未登录
    if(!str)
    {
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = @"https://api.weibo.com/oauth2/default.html";
        request.scope = @"all";
        request.userInfo = @{@"SSO_From": @"IndexViewController",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        [WeiboSDK sendRequest:request];
    }
    else
    {
        [self createUI];
    }
}

-(void)createUI
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    //导航栏
    //返回按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    //导航按钮
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    rightBtn.tag = kRightBtnTag;
    [rightBtn addTarget:self action:@selector(navigationBtnDidSelected:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:@"navigationbar_icon_radar-1"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"navigationbar_icon_radar_highlighted"] forState:UIControlStateHighlighted];
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    UIButton * leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftBtn.tag = kLeftBtnTag;
    [leftBtn addTarget:self action:@selector(navigationBtnDidSelected:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageNamed:@"navigationbar_friendattention"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navigationbar_friendattention_highlighted"] forState:UIControlStateHighlighted];
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    //侧滑栏创建
    //    UIImageView * backgroundView = [[UIImageView alloc] initWithFrame:_originalRect];
    //    backgroundView.image = [UIImage imageNamed:@"bg"];
    //加载到window上
    //    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //    [window addSubview:backgroundView];
    //    [window sendSubviewToBack:backgroundView];
    
    //创建侧滑选择栏
    //    WeiboTypeTableView * tableView = [[WeiboTypeTableView alloc] initWithFrame:CGRectMake(0, 50, self.tabBarController.view.frame.size.width*4/5, 600)];
    //    [backgroundView addSubview:tableView];
    //    _headerView = [WeboTypeHeaderView weboView];
    //    _headerView.frame = CGRectMake(0, 0, 0, 280);
    //    _headerView.contentView.backgroundColor = [UIColor clearColor];
    //    [_headerView getUserInfo];
    //    tableView.backgroundColor = [UIColor clearColor];
    //    tableView.tableHeaderView = _headerView;
    
    //微博视图
    _tableView = [[WeiBoTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    _tableView.cellDelegate = self;
    [self.view addSubview:_tableView];
    
    //请求数据
    [self getDataFromNetWorkWithUserInfo:[defaults objectForKey:@"access_token"]];
}



#pragma mark  手势相关
-(void)handleTouch:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [pan translationInView:self.tabBarController.view];
        CGRect rect = self.tabBarController.view.frame;
        
        rect.origin.x += point.x;
        
        if (rect.origin.x < 0)
        {
            rect.origin.x = 0;
        }
        else if (rect.origin.x > _originalRect.size.width * 4/5)
        {
            rect.origin.x = _originalRect.size.width * 4/5;
        }
        self.tabBarController.view.frame = rect;
    }
    else if (pan.state == UIGestureRecognizerStateEnded)
    {
        if (self.tabBarController.view.frame.origin.x > 200)
        {
            [UIView animateWithDuration:0.2 animations:^{
                CGRect rect = _originalRect;
                rect.origin.x = _originalRect.size.width * 4/5;
                self.tabBarController.view.frame = rect;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.tabBarController.view.frame = _originalRect;
            }];
        }
    }
    
    [pan setTranslation:CGPointZero inView:self.navigationController.view];
    
}

//只有首页的时候可以打开侧滑栏
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.tabBarController.selectedIndex == 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark  -微博视图富文本点击事件代理
-(void)richTextdDidSeletced:(NSString *)string RichTextType:(RichTextType)type
{
    //    NSLog(@"string=%@",string);
    switch (type)
    {
            //网页链接点击
        case urlText:
        {
            WebVIewController * webController = [[WebVIewController alloc] init];
            webController.url = string;
            [self.navigationController pushViewController:webController animated:YES];
        }
            break;
            //用户点击
        case userText:
        {
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            //拼接url
            NSString * url = [NSString stringWithFormat:@"%@?access_token=%@&screen_name=%@",UserInfoUrl,[defaults objectForKey:@"access_token"],string];
            //url可能含中文  按UTF8编码处理
            url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            MineInfoViewController * mineInfoController = [[MineInfoViewController alloc] init];
            [mineInfoController requestDataFromUrl:url];
            [self.navigationController pushViewController:mineInfoController animated:YES];
        }
            break;
            //话题点击
        case topicText:
        {
            
        }
            break;
            //用户头像
        case userId:
        {
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            //拼接url
            NSString * url = [NSString stringWithFormat:@"%@?access_token=%@&screen_name=%@",UserInfoUrl,[defaults objectForKey:@"access_token"],string];
            //url可能含中文  按UTF8编码处理
            url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            MineInfoViewController * mineInfoController = [[MineInfoViewController alloc] init];
            [mineInfoController requestDataFromUrl:url];
            [self.navigationController pushViewController:mineInfoController animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark  -获取用户信息字典  创建标题视图
-(void)getUserInfo
{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSString * access_token = [defaults objectForKey:@"access_token"];
    NSString * uid = [defaults objectForKey:@"uid"];
    
    NSString * url = @"https://api.weibo.com/2/users/show.json";
    
    ConnectDelegate * delegate = [ConnectDelegate standConnectDelegate];
    [delegate requestDataFromUrl:[NSString stringWithFormat:@"%@?access_token=%@&uid=%@",url,access_token,uid] andParseDataBlock:^(id obj) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        NSDictionary * objDict = (NSDictionary *)obj;
        
        //获取所需信息
        [dic setObject:objDict[@"name"] forKey:@"name"];
        [dic setObject:objDict[@"profile_image_url"] forKey:@"profile_image_url"];
        [dic setObject:objDict[@"screen_name"] forKey:@"screen_name"];
        [dic setObject:objDict[@"description"] forKey:@"description"];
        [dic setObject:objDict[@"statuses_count"] forKey:@"statuses_count"];
        [dic setObject:objDict[@"friends_count"] forKey:@"friends_count"];
        [dic setObject:objDict[@"followers_count"] forKey:@"followers_count"];
        
        //创建标题视图
        _navgationBarTitleBtn = [[NavgationBarTitleBtn alloc] navgationBarTitleBtn];
        _navgationBarTitleBtn.frame = CGRectMake(0, 0, 100, 35);
        [_navgationBarTitleBtn changeTitle:objDict[@"name"]];
        
        __weak IndexViewController * indexViewController = self;
        [_navgationBarTitleBtn setBtnDidSelectedBlock:^{
            indexViewController.maskBtn.hidden = !indexViewController.maskBtn.hidden;
            if (indexViewController.titlePopOverView.hidden)
            {
                indexViewController.titlePopOverView.hidden = !indexViewController.titlePopOverView.hidden;
                [UIView animateWithDuration:0.2 animations:^{
                    indexViewController.titlePopOverView.alpha = 1;
                }];
            }
            else
            {
                [UIView animateWithDuration:0.2 animations:^{
                    indexViewController.titlePopOverView.alpha = 0;
                } completion:^(BOOL finished) {
                    indexViewController.titlePopOverView.hidden = !indexViewController.titlePopOverView.hidden;
                }];
            }
        }];
        self.navigationItem.titleView = _navgationBarTitleBtn;
        
        [defaults setObject:[dic copy] forKey:@"userInfo"];
    }];
}

#pragma mark  -导航栏按钮点击事件
-(void)navigationBtnDidSelected:(UIButton *)btn
{
    switch (btn.tag)
    {
        case kRightBtnTag:
        {
            self.maskBtn.hidden = !self.maskBtn.hidden;
            if (self.rightPopOverView.hidden)
            {
                self.rightPopOverView.hidden = !self.rightPopOverView.hidden;
                [UIView animateWithDuration:0.2 animations:^{
                    self.rightPopOverView.alpha = 1;
                }];
            }
            else
            {
                [UIView animateWithDuration:0.2 animations:^{
                    self.rightPopOverView.alpha = 0;
                } completion:^(BOOL finished) {
                    self.rightPopOverView.hidden = !self.rightPopOverView.hidden;
                }];
            }
        }
            break;
        case kLeftBtnTag:
        {
            DevelopmentViewController * developmentController = [[DevelopmentViewController alloc] init];
            [self.navigationController pushViewController:developmentController animated:YES];
        }
            break;
        default:
            break;
    }
}

-(void)maskBtnDidSelected:(UIButton *)btn
{
    NSLog(@"dada");
    if (!self.rightPopOverView.hidden)
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.rightPopOverView.alpha = 0;
        } completion:^(BOOL finished) {
            self.rightPopOverView.hidden = !self.rightPopOverView.hidden;
        }];
    }
    
    if (!self.titlePopOverView.hidden)
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.titlePopOverView.alpha = 0;
        } completion:^(BOOL finished) {
            self.titlePopOverView.hidden = !self.titlePopOverView.hidden;
        }];
    }
    
    btn.hidden = YES;
}
@end
