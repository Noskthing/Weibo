//
//  MessageViewController.m
//  Weibo
//
//  Created by apple on 15/11/30.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import "MessageViewController.h"
#import "WeiboSDK.h"
#import "MessageTableView.h"
#import "ConnectDelegate.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

#pragma mark  -初始化底部tabbar
-(instancetype)init
{
    if (self = [super init])
    {
        UIImage * image = [UIImage imageNamed:@"tabbar_message_center"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIImage * selectedImage = [UIImage imageNamed:@"tabbar_message_center_selected"];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        self.tabBarItem.image = image;
        self.tabBarItem.selectedImage = selectedImage;
        self.tabBarItem.title = @"消息";
        
        //字体颜色设置
        [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化
    self.view.backgroundColor = [UIColor whiteColor];

    //导航栏设置
    self.navigationItem.title = @"消息";
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    label.text = @"发现群";
    label.font = [UIFont systemFontOfSize:16];
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:label];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setImage:[UIImage imageNamed:@"navigationbar_icon_newchat"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"navigationbar_icon_newchat_highlight"] forState:UIControlStateHighlighted];
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = leftBarItem;
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    //主页
    MessageTableView * messageTableView = [[MessageTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.height -49) style:UITableViewStylePlain];
    [self.view addSubview:messageTableView];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];

    ConnectDelegate * delegate = [ConnectDelegate standConnectDelegate];
    [delegate requestDataFromUrl:@"https://api.weibo.com/oauth2/get_token_info" parameters:@{@"access_token":[defaults objectForKey:@"access_token"]} andParseDataBlock:^(id obj) {
        NSLog(@"授权 = %@",obj);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
