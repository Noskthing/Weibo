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
#import "PhotoShowView.h"
#import "PhototShowViewController.h"

@interface PhotoViewController ()
{
    NSArray * _images;
}
@property (nonatomic,strong)UIView * tmpView;
@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createNavigation];
    [self createUI];
}

-(void)createNavigation
{
    NavgationBarTitleBtn * btn = [[NavgationBarTitleBtn alloc] navgationBarTitleBtn];
    [btn changeTitle:@"相册胶卷"];
    [btn setBtnDidSelectedBlock:^{
        
    }];
    self.navigationItem.titleView = btn;
    
    //取消button
    UIButton * cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 34, 40, 18)];
    [cancelBtn setTitleColor:[UIColor colorWithRed:0.220f green:0.220f blue:0.220f alpha:1.00f] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [cancelBtn setTitle:@"取消" forState:0];
    [cancelBtn addTarget:self action:@selector(cancelBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    //下一步button
    UIButton * nextStep = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 65,30, 50, 25)];
    [nextStep setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    nextStep.backgroundColor = [UIColor whiteColor];
    nextStep.layer.borderColor = [UIColor blackColor].CGColor;
    nextStep.layer.cornerRadius = 3;
    [nextStep setTitle:@"下一步" forState:0];
    [nextStep addTarget:self action:@selector(nextStpBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    nextStep.titleLabel.font = [UIFont systemFontOfSize:15];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nextStep];
}

-(void)createUI
{
    PhotoManager * manager = [PhotoManager standPhotoManager];
    if (![manager getAlbummodels])
    {
         NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // app名称
        NSString * app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 200)];
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"请在iPhone的“设置->隐私->照片”开启%@访问你的手机相册",app_Name];
        [self.view addSubview:label];
    }
    else
    {
        PhotoShowView * phototShowView = [[PhotoShowView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [phototShowView setCellDidSelectedBlock:^(NSInteger row, UIImage *image, NSUInteger countOfImages) {
            PhototShowViewController * phototShowViewController = [[PhototShowViewController alloc] init];
            phototShowViewController.images = _images;
            phototShowViewController.num = row;
            [self.navigationController pushViewController:phototShowViewController animated:YES];
        }];
        [self.view addSubview:phototShowView];
        
        NSArray * albums = [manager getAlbummodels];
        AlbumModel * model = albums[0];
        
        [phototShowView setModels:model];
    }
}

#pragma mark -UIButton点击事件
-(void)nextStpBtnTouch:(UIButton *)sender
{
    
}

- (void)cancelBtnTouch:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
