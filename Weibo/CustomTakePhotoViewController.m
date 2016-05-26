//
//  CustomTakePhotoViewController.m
//  JustForFunOfLee
//
//  Created by feerie luxe on 16/5/26.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "CustomTakePhotoViewController.h"

@implementation CustomTakePhotoViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavgation];
    [self initSubviews];
}

#pragma mark     初始化方法
-(void)initNavgation
{
    self.navigationItem.title = @"微博相机";
    
    
    UIButton * exitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    exitBtn.tag = NavExitButton;
    [exitBtn addTarget:self action:@selector(navButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [exitBtn setImage:[UIImage imageNamed:@"camera_edit_cross"] forState:UIControlStateNormal];
    [exitBtn setImage:[UIImage imageNamed:@"camera_edit_cross_highlighted"] forState:UIControlStateHighlighted];
    UIBarButtonItem * exitBar = [[UIBarButtonItem alloc] initWithCustomView:exitBtn];
    self.navigationItem.leftBarButtonItem = exitBar;
    
    UIButton * flashBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    flashBtn.tag = NavFlashButton;
    [flashBtn addTarget:self action:@selector(navButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [flashBtn setImage:[UIImage imageNamed:@"camera_flashlight_auto"] forState:UIControlStateNormal];
    [flashBtn setImage:[UIImage imageNamed:@"camera_flashlight_auto_disable"] forState:UIControlStateHighlighted];
    UIBarButtonItem * flashBar = [[UIBarButtonItem alloc] initWithCustomView:flashBtn];
    
    UIButton * cameraBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    cameraBtn.tag = NavChangeCameraButton;
    [cameraBtn addTarget:self action:@selector(navButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [cameraBtn setImage:[UIImage imageNamed:@"camera_overturn"] forState:UIControlStateNormal];
    [cameraBtn setImage:[UIImage imageNamed:@"camera_overturn_highlighted"] forState:UIControlStateHighlighted];
    UIBarButtonItem * cameraBar = [[UIBarButtonItem alloc] initWithCustomView:cameraBtn];
    
    self.navigationItem.rightBarButtonItems = @[cameraBar,flashBar];
}

-(void)initSubviews
{
    //拍照区域
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    //指示的小点
    UIView * pointView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 3, 64 + self.view.frame.size.width + 9, 6, 6)];
    pointView.layer.cornerRadius = 3;
    pointView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:pointView];
    
    //提示的UIButton
    
    
    UIButton * takePhotoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    takePhotoBtn.layer.anchorPoint = CGPointMake(0.5, 0);
    takePhotoBtn.layer.position = CGPointMake(self.view.frame.size.width/2, 64 + self.view.frame.size.width + 50);
    [takePhotoBtn setImage:[UIImage imageNamed:@"camera_camera_background"] forState:UIControlStateNormal];
    [takePhotoBtn setImage:[UIImage imageNamed:@"camera_camera_background_highlighted"] forState:UIControlStateHighlighted];
    [self.view addSubview:takePhotoBtn];
}

#pragma mark   navBtn点击事件
-(void)navButtonTouched:(UIButton *)btn
{
    switch (btn.tag)
    {
        case NavExitButton:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
}
@end
