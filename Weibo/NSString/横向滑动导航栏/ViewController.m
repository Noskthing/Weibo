//
//  ViewController.m
//  test
//
//  Created by mac on 15/9/16.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "ViewController.h"
#import "TitleView.h"
#import "LeeScrollViewWithView.h"
#import "ScrollView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UICollectionViewFlowLayout * layout  = [[UICollectionViewFlowLayout alloc] init];
    TitleView * view = [[TitleView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 49) collectionViewLayout:layout];
    
    
    
    UIView * view1 = [[UIView alloc] init];
    view1.backgroundColor = [UIColor yellowColor];
    UIView * view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor greenColor];
    UIView * view3 = [[UIView alloc] init];
    view3.backgroundColor = [UIColor redColor];
    UIView * view4 = [[UIView alloc] init];
    view4.backgroundColor = [UIColor blueColor];
    
    NSArray * views = @[view1,view2,view3,view4];
    
    ScrollView * scrollView = [[ScrollView alloc] initWithFrame:self.view.frame];
    [scrollView setOffsetChangeBlock:^(CGFloat scale) {
        [view scrollViewWithOffset:scale];
    } views:views];


    
    
    NSArray * arr = @[@"李博文是天才",@"李博文是天才",@"李博文是天才",@"李博文是天才"];
    [view titleViewWithTitles:arr scrollViewColor:[UIColor redColor] itemDidSelectedBlock:^(CGFloat scale,NSInteger index) {
        [scrollView scrollWithScale:scale];
        NSLog(@"------%ld",(long)index);
    }];
    [self.view addSubview:scrollView];
    [self.view addSubview:view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
