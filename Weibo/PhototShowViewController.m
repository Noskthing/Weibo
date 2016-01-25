//
//  PhototShowViewController.m
//  JustForFunOfLee
//
//  Created by 文丹 on 16/1/25.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "PhototShowViewController.h"
#import "LeeScrollViewWithView.h"

@interface PhototShowViewController ()

@end

@implementation PhototShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.image = self.images[self.num];
    
    LeeScrollViewWithView * scrollView = [[LeeScrollViewWithView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) andView:imageView andTimerWithTimeInterval:999];
    
    [self.view addSubview:scrollView];
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
