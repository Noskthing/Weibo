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
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initNavigationBar];
}

#pragma mark  -创建导航UI
-(void)initNavigationBar
{
    //取消button
    UIButton * cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 34, 40, 18)];
    [cancelBtn setTitleColor:[UIColor colorWithRed:0.220f green:0.220f blue:0.220f alpha:1.00f] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [cancelBtn setTitle:@"取消" forState:0];
    [cancelBtn addTarget:self action:@selector(cancelBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
}

#pragma mark   -UIButton点击事件
- (void)cancelBtnTouch:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLeeKeyBoardWillDisappear object:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
