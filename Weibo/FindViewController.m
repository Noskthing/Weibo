//
//  FindViewController.m
//  Weibo
//
//  Created by apple on 15/11/30.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import "FindViewController.h"
#import "AFNetworking.h"
#import "FindTableView.h"
@interface FindViewController ()

@end

@implementation FindViewController


-(instancetype)init
{
    if (self = [super init])
    {
        UIImage * image = [UIImage imageNamed:@"tabbar_discover"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIImage * selectedImage = [UIImage imageNamed:@"tabbar_discover_selected"];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        self.tabBarItem.image = image;
        self.tabBarItem.selectedImage = selectedImage;
        self.tabBarItem.title = @"发现";
        
        //字体颜色设置
        [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UISearchBar * searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];

//    [searchBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
//        {
//            [obj removeFromSuperview];
//        }
//    }];
//    UIView * view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor redColor];
//    [searchBar insertSubview:view atIndex:1];
    self.navigationItem.titleView = searchBar;
    
    //主视图
    FindTableView * findTableView = [[FindTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height -49)];
    [self.view addSubview:findTableView];
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
