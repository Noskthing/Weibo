//
//  PhototShowViewController.m
//  JustForFunOfLee
//
//  Created by 文丹 on 16/1/25.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "PhototShowViewController.h"
#import "LeeScrollViewWithArray.h"


@interface PhototShowViewController ()

@end

@implementation PhototShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //遍历创造uiimageView；
    NSMutableArray * arr = [NSMutableArray array];
    [_images enumerateObjectsUsingBlock:^(UIImage *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @autoreleasepool
        {
            UIImageView * imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.image = obj;
            [arr addObject:imageView];
        }
    }];
    
    LeeScrollViewWithArray * scrollView = [[LeeScrollViewWithArray alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height) andArray:[arr copy] andTimerWithTimeInterval:999];
    [scrollView scrollToPage:self.num];
    
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
