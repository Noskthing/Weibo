//
//  PhotoViewController.m
//  JustForFunOfLee
//
//  Created by 文丹 on 16/1/23.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "PhotoViewController.h"
#import "NavgationBarTitleBtn.h"
#import "PhotoManager.h"
#import "AlbumModel.h"

@interface PhotoViewController ()
@property (nonatomic,strong)UIView * tmpView;
@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigation];
    [self createUI];
}

-(void)createNavigation
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 0)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    NavgationBarTitleBtn * btn = [[NavgationBarTitleBtn alloc] navgationBarTitleBtn];
    btn.layer.position = CGPointMake(self.view.frame.size.width/2, 42);
    [btn changeTitle:@"相册胶卷"];
    [btn setBtnDidSelectedBlock:^{
        [UIView animateWithDuration:0.35 animations:^{
            view.frame = CGRectMake(0, 70, self.view.frame.size.width, 120);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                view.frame = CGRectMake(0, 64, self.view.frame.size.width, 120);
            }];
        }];
    }];

    [self.navigationView addSubview:btn];
    
    //下一步button
    UIButton * nextStep = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 65,30, 50, 25)];
    [nextStep setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    nextStep.backgroundColor = [UIColor whiteColor];
    nextStep.layer.borderColor = [UIColor blackColor].CGColor;
    nextStep.layer.cornerRadius = 3;
    [nextStep setTitle:@"下一步" forState:0];
    [nextStep addTarget:self action:@selector(nextStpBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    nextStep.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.navigationView addSubview:nextStep];
}

-(void)createUI
{
    PhotoManager * manager = [PhotoManager standPhotoManager];
    if (![manager getAlbummodels])
    {
         NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // app名称
        NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        [NSString stringWithFormat:@"请在iPhone的“设置->隐私->照片”开启%@访问你的手机相册",app_Name];
    }
}

#pragma mark -UIButton点击事件
-(void)nextStpBtnTouch:(UIButton *)sender
{
    
}
@end
