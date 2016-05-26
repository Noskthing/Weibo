//
//  MineViewController.m
//  Weibo
//
//  Created by apple on 15/11/30.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import "MineViewController.h"
#import "ConnectDelegate.h"
#import "MineTableView.h"
#import "MineInfoViewController.h"
#import "WeiboSDK.h"

@interface MineViewController ()
{
    MineTableView * _tableView;
}
@end

@implementation MineViewController

-(instancetype)init
{
    if (self = [super init])
    {
        UIImage * image = [UIImage imageNamed:@"tabbar_profile"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIImage * selectedImage = [UIImage imageNamed:@"tabbar_profile_selected"];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        self.tabBarItem.image = image;
        self.tabBarItem.selectedImage = selectedImage;
        self.tabBarItem.title = @"我";
        
        //字体颜色设置
        [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

-(void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self getUserInfo];
    
    //主要视图(原微博 我 界面)
    _tableView = [[MineTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 113)];
    __weak MineViewController * view = self;
    [_tableView setCellDidSeletcedBlock:^(NSInteger num){
        switch (num)
        {
            case 0:
            {
                MineInfoViewController * mineInfo = [[MineInfoViewController alloc] init];
                [mineInfo requestDataFromUrl:nil];
                [view.navigationController pushViewController:mineInfo animated:YES];
            }
                break;
                
            default:
                break;
        }
    }];
    [self.view addSubview:_tableView];
    
    
    //导航栏设置
    self.navigationItem.title = @"我";
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setTitle:@"设置" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTintColor:[UIColor blackColor]];
    [btn addTarget:self action:@selector(configBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barItem;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
}

#pragma mark  -获取用户信息字典
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
        
        NSArray * keys = @[@"avatar_hd",@"avatar_large",@"cover_image",@"gender",@"name",@"friends_count",@"followers_count",@"description",@"screen_name",@"statuses_count",@"profile_image_url"];

        [keys enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (objDict[obj])
            {
                [dic setObject:objDict[obj] forKey:obj];
            }
        }];
        
        [defaults setObject:[dic copy] forKey:@"userInfo"];
        [_tableView reloadData];
    }];

}

-(void)configBtnTouch:(UIButton *)btn
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uid"];
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"https://api.weibo.com/oauth2/default.html";
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"IndexViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}
@end
