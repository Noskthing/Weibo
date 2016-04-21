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
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigation];
    [self createToolBar];
    [self createUI];
}

#pragma mark     相册的获取
-(void)createUI
{
    PhotoManager * manager = [PhotoManager standPhotoManager];
    if (![manager photoJurisdiction])
        //没有访问相册的权限
    {
        //相册进行授权
        //  * * 第一次安装应用时直接进行这个判断进行授权 * *
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
            //授权后直接打开照片库
            if (status == PHAuthorizationStatusAuthorized)
            {
                //授权成功
                //必须回到主线程更新UI  使用GCD返回主线程  否则会有警告
                //授权判定应该是异步处理的  并且阻塞主线程 之前在photoJurisdiction方法当中进行逻辑判断也是这样 因为是异步  所以在第一次授权情况下会跳过授权过程直接按照授权成功的逻辑处理
                //This application is modifying the autolayout engine from a background thread, which can lead to engine corruption and weird crashes.  This will cause an exception in a future release.
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self createPhotoView];
                });
            }
            else
            {
                //授权被拒绝
                // app名称
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString * app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
                
                //提示label
                UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 200)];
                label.numberOfLines = 2;
                label.textAlignment = NSTextAlignmentCenter;
                label.text = [NSString stringWithFormat:@"请在iPhone的“设置->隐私->照片”开启%@访问你的手机相册",app_Name];
                [self.view addSubview:label];            }
        }];

    }
    //可以访问相册
    else
    {
        [self createPhotoView];
    }
}

#pragma mark   相册授权成功展示视图的创建
-(void)createPhotoView
{
    //获取相册模型
    PhotoManager * manager = [PhotoManager standPhotoManager];
    
    NSArray * albums = [manager getAlbummodels];
    AlbumModel * model = albums[0];
    
    
    //创建PhotoShowView
    PhotoShowView * phototShowView = [[PhotoShowView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 113)];

    //photoView属性设置
    [phototShowView setModel:model];
    [phototShowView setCellDidSelectedBlock:^(NSInteger row, AlbumModel *model, NSUInteger countOfImages) {
                    PhototShowViewController * phototShowViewController = [[PhototShowViewController alloc] init];
                    phototShowViewController.model = model;
                    phototShowViewController.num = row;
                    phototShowViewController.count = countOfImages;
                    phototShowViewController.selectedPhotos = [@[@(1),@(3)] mutableCopy];
                    [self.navigationController pushViewController:phototShowViewController animated:YES];
//        NSLog(@"row is %ld countOfImage is %lu",(long)row,(unsigned long)countOfImages);
    }];
    
    [phototShowView setSelectedBtnDidSelectedBlock:^(UIImage *image, BOOL isSelected) {
        if (image && isSelected)
        {
            NSLog(@"被选中");
        }
    }];
    [self.view addSubview:phototShowView];
    
    
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

#pragma mark    导航栏的创建
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

#pragma mark    创建toolbar
-(void)createToolBar
{
    //背景
    UIView * toorBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];
    toorBarView.backgroundColor = [UIColor colorWithRed:0.961f green:0.961f blue:0.961f alpha:1.00f];
    toorBarView.layer.borderColor = [UIColor colorWithRed:0.843f green:0.843f blue:0.843f alpha:1.00f].CGColor;
    toorBarView.layer.borderWidth = 1;
    [self.view addSubview:toorBarView];
}

@end
