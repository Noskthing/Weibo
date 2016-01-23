//
//  BaseViewController.m
//  JustForFunOfLee
//
//  Created by 文丹 on 16/1/23.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "BaseViewController.h"
#import "LeeKeyboard.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigationBar];
}

#pragma mark  -创建导航UI
-(void)initNavigationBar
{
    //背景
    UIView * navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    _navigationView = navigationView;
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
}

#pragma mark   -UIButton点击事件
- (void)cancelBtnTouch:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLeeKeyBoardWillDisappear object:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
