//
//  CustomTakePhotoViewController.m
//  JustForFunOfLee
//
//  Created by feerie luxe on 16/5/26.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "CustomTakePhotoViewController.h"
#import "AlbumModel.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface CustomTakePhotoViewController ()
{
    UILabel * _photoLabel;
    
    UILabel * _videoLabel;
    
    //背景
    UIView * _bgView;
    
    //关合摄像头的动画蒙版
    UIView * _topMaskView;
    UIView * _bottomMaskView;
    
    //动画时间
    CGFloat _animationDuration;
    
    //宽度
    CGFloat _width;
}
//AVFoundation

@property (nonatomic) dispatch_queue_t sessionQueue;
/**
 *  AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
 */
@property (nonatomic, strong) AVCaptureSession* session;
/**
 *  输入设备
 */
@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;
/**
 *  照片输出流
 */
@property (nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;
/**
 *  预览图层
 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;

@end
@implementation CustomTakePhotoViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    _animationDuration = 0.3;
    _width = self.view.frame.size.width;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initAVCaptureSession];
    [self initNavgation];
    [self initSubviews];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [UIView animateWithDuration:_animationDuration animations:^{
        [self animationForCameraOpen:YES];
    }];
    
    if (self.session)
    {
        [self.session startRunning];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    if (self.session)
    {
        [self.session stopRunning];
    }
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
    //蒙版
    _topMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, _width/2)];
    _topMaskView.backgroundColor = [UIColor whiteColor];
    _topMaskView.layer.anchorPoint = CGPointMake(0.5, 0);
    _topMaskView.layer.position = CGPointMake(_width/2, 64);
    [self.view addSubview:_topMaskView];
    
    _bottomMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, _width/2)];
    _bottomMaskView.backgroundColor = [UIColor whiteColor];
    _bottomMaskView.layer.anchorPoint = CGPointMake(0.5, 1);
    _bottomMaskView.layer.position = CGPointMake(_width/2, 64 + _width);
    [self.view addSubview:_bottomMaskView];
    
    //指示的小点
    UIView * pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
    pointView.layer.anchorPoint = CGPointMake(0.5, 0);
    pointView.layer.position = CGPointMake(_width/2, 64 + _width + 5);
    pointView.layer.cornerRadius = 3;
    pointView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:pointView];
    
    //提示的UIButton
    _photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
    _photoLabel.textColor = [UIColor orangeColor];
    _photoLabel.layer.anchorPoint = CGPointMake(0.5, 0);
    _photoLabel.font = [UIFont systemFontOfSize:8];
    _photoLabel.text = @"照片";
    _photoLabel.layer.position = CGPointMake(_width/2, CGRectGetMaxY(pointView.frame)+5);
    [self.view addSubview:_photoLabel];
    
    _videoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
    _videoLabel.layer.anchorPoint = CGPointMake(0, 0);
    _videoLabel.font = [UIFont systemFontOfSize:8];
    _videoLabel.text = @"视频";
    _videoLabel.layer.position = CGPointMake(CGRectGetMaxX(_photoLabel.frame) + 8 , CGRectGetMaxY(pointView.frame)+5);
    [self.view addSubview:_videoLabel];
    
    //拍照button
    UIButton * takePhotoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    takePhotoBtn.layer.anchorPoint = CGPointMake(0.5, 0);
    takePhotoBtn.layer.position = CGPointMake(_width/2, 64 + _width + 60);
    [takePhotoBtn setImage:[UIImage imageNamed:@"camera_camera_background"] forState:UIControlStateNormal];
    [takePhotoBtn setImage:[UIImage imageNamed:@"camera_camera_background_highlighted"] forState:UIControlStateHighlighted];
    [self.view addSubview:takePhotoBtn];
    
    //相册button
    UIButton * albumBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    albumBtn.layer.anchorPoint = CGPointMake(0.5, 0.5);
    albumBtn.layer.position = CGPointMake(CGRectGetMaxX(takePhotoBtn.frame) + 90, CGRectGetMidY(takePhotoBtn.frame));
    [albumBtn addTarget:self action:@selector(albumButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    if (self.model.result[0])
    {
        PHImageManager * imageManager = [PHImageManager defaultManager];
        [imageManager requestImageForAsset:self.model.result[0]
                                targetSize:PHImageManagerMaximumSize
                               contentMode:PHImageContentModeDefault
                                   options:nil
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 [albumBtn setImage:result forState:UIControlStateNormal];
                             }];
    }
    [self.view addSubview:albumBtn];
}

-(void)initAVCaptureSession
{
    self.session = [[AVCaptureSession alloc] init];
    
    NSError *error;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [device lockForConfiguration:nil];
    //设置闪光灯为自动
    [device setFlashMode:AVCaptureFlashModeAuto];
    [device unlockForConfiguration];
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error)
    {
        NSLog(@"%@",error);
    }
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput])
    {
        [self.session addInput:self.videoInput];
    }
    
    if ([self.session canAddOutput:self.stillImageOutput])
    {
        [self.session addOutput:self.stillImageOutput];
    }
    
    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.previewLayer.frame = CGRectMake(0, 64,_width, _width);
    [self.view.layer addSublayer:self.previewLayer];

}

#pragma mark   开关相机动画
-(void)animationForCameraOpen:(BOOL)isOpen
{
    
    CGRect topRect = _topMaskView.frame;
    topRect.origin.y = isOpen ? topRect.origin.y - _width/2 : topRect.origin.y + _width/2;
    _topMaskView.frame = topRect;
    
    CGRect bottomRect = _bottomMaskView.frame;
    bottomRect.origin.y = isOpen ? bottomRect.origin.y + _width/2 : bottomRect.origin.y - _width/2;
    _bottomMaskView.frame = bottomRect;
}

#pragma mark   UIbutton点击事件
-(void)navButtonTouched:(UIButton *)btn
{
    switch (btn.tag)
    {
        case NavExitButton:
        {
            
            [UIView animateWithDuration:_animationDuration animations:^{
                
                [self animationForCameraOpen:NO];
                
            } completion:^(BOOL finished) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            break;
        }
        default:
            break;
    }
}

-(void)albumButtonTouched:(UIButton *)btn
{
    [UIView animateWithDuration:_animationDuration animations:^{
        
        [self animationForCameraOpen:NO];
        
    } completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
@end
