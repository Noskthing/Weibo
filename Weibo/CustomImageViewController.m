//
//  CustomImageViewController.m
//  JustForFunOfLee
//
//  Created by feerie luxe on 16/5/30.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "CustomImageViewController.h"
#import "ImageOptionScrollView.h"
#import "UIImage+Addition.h"
#import "UIImageView+Animation.h"
#import "CropImageView.h"
#import "CameraWaterMarkView.h"

@interface CustomImageViewController ()
{
    CGFloat _width;
    
    //图片实际所在位置
    CGFloat _imageWidth;
    CGFloat _imageHeight;
    
    //挂件中心点 便宜角度
    CGPoint _centerPoint;
    double _angle;
    
    double _radius;
}
@property (nonatomic,strong)UIView * toolsView;

@property (nonatomic,strong)ImageOptionScrollView * filterView;

@property (nonatomic,strong)ImageOptionScrollView * stickerView;

@property (nonatomic,strong)CropImageView * cropView;

//图片
@property (nonatomic,strong)UIImageView * imageView;

@property (nonatomic,strong)UIImage * image;

//水印
@property (nonatomic,strong)CameraWaterMarkView * cameraWaterMarkView;

//挂件按钮
@property (nonatomic,strong)UIButton * removeBtn;

@property (nonatomic,strong)UIImageView * zoomView;

@property (nonatomic,assign)UIImageOrientation orientation;
@end
@implementation CustomImageViewController

-(void)viewDidLoad
{
    _width = self.view.frame.size.width;
    
    self.view.backgroundColor = ColorWithRGB(224, 224, 224);
    
    [self createUI];
}

#pragma mark     UI创建
-(UIView *)toolsView
{
    if (!_toolsView)
    {
        _toolsView.hidden = YES;
        _toolsView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + _width, _width, self.view.frame.size.height - 49 - 64 - _width)];
        _toolsView.backgroundColor = ColorWithRGB(239, 239, 239);
        NSArray * imageNames = @[@"camera_edit_revolve",@"camera_edit_cut",@"camera_edit_optimize"];
        NSArray * imageSelectedNames = @[@"camera_edit_revolve_highlighted",@"camera_edit_cut_highlighted",@"camera_edit_optimize_highlighted"];
        
        CGFloat edge = 50;
        CGFloat leftSpace = (_width - 150)/4;
        CGFloat topSpace = (_toolsView.frame.size.height - 50)/2;
        
        for (NSInteger i = 0; i < 3 ; i++)
        {
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake((i + 1) * leftSpace + i * 50, topSpace, edge, edge)];
            btn.tag = i + 5;
            [btn addTarget:self action:@selector(toolsViewButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:imageSelectedNames[i]] forState:UIControlStateHighlighted];
            
            [_toolsView addSubview:btn];
        }
    }
    
    return _toolsView;
}

-(ImageOptionScrollView *)stickerView
{
    if (!_stickerView)
    {
        _stickerView = [[ImageOptionScrollView alloc] initWithFrame:CGRectMake(0, 64 + _width, _width, self.view.frame.size.height - 49 - 64 - _width)];
        _stickerView.backgroundColor = ColorWithRGB(239, 239, 239);
        _stickerView.images = @[@"",@"",@"",@"",@""];
        _stickerView.hidden = YES;

        __weak __typeof__(self) weakSelf = self;
        [_stickerView setOptionButtonDidSelevtedBlock:^(NSInteger tag) {
//            NSLog(@"tag is %ld",(long)tag);
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            strongSelf.cameraWaterMarkView.image = [UIImage imageNamed:@"compose_slogan"];
            [strongSelf.imageView addSubview:strongSelf.cameraWaterMarkView];
            _centerPoint = strongSelf.cameraWaterMarkView.center;
            _radius = hypot(strongSelf.cameraWaterMarkView.frame.size.width/2, strongSelf.cameraWaterMarkView.frame.size.height/2);
            
            double tan = strongSelf.cameraWaterMarkView.frame.size.height / strongSelf.cameraWaterMarkView.frame.size.width;
            
            _angle = atan(tan);

        }];
    }
    
    return _stickerView;
}

-(ImageOptionScrollView *)filterView
{
    if (!_filterView)
    {
        _filterView = [[ImageOptionScrollView alloc] initWithFrame:CGRectMake(0, 64 + _width, _width, self.view.frame.size.height - 49 - 64 - _width)];
        _filterView.backgroundColor = ColorWithRGB(239, 239, 239);
        _filterView.images = @[@"",@"",@"",@"",@""];
        _filterView.hidden = YES;
        [_filterView setOptionButtonDidSelevtedBlock:^(NSInteger tag) {
            NSLog(@"tag is %ld",(long)tag);
        }];
    }
    return _filterView;
}

-(CropImageView *)cropView
{
    if (!_cropView)
    {
        _cropView = [[CropImageView alloc] initWithFrame:CGRectMake(0, 64, _width, self.view.frame.size.height - 64)];
        _cropView.hidden = YES;
        
        __weak __typeof__(self) weakSelf = self;
        [_cropView setOptionButtonDidSelectedBlock:^(UIImage *image) {
            if (image)
            {
                __strong __typeof__(weakSelf) strongSelf = weakSelf;
                strongSelf.image = image;
                strongSelf.imageView.image = image;
                
                //截取的新图片替换原图  那么imageView的方向和保存的imageView的旋转方向需要恢复到默认  也就是最开始正放的状态
                strongSelf.imageView.layer.transform = CATransform3DMakeRotation(0, 0, 0, 0);
                strongSelf.orientation = UIImageOrientationUp;
                
                CGFloat scale = image.size.height/image.size.width;
                strongSelf.imageView.frame = scale >= 1?CGRectMake(strongSelf.view.frame.size.width * (1 - 1/scale)/2, 64, strongSelf.view.frame.size.width/scale, strongSelf.view.frame.size.width):CGRectMake(0, 64 + strongSelf.view.frame.size.width * (1 - scale)/2, strongSelf.view.frame.size.width, strongSelf.view.frame.size.width * scale);
            }
        }];
        [self.view addSubview:_cropView];
    }
    return _cropView;
}

-(CameraWaterMarkView *)cameraWaterMarkView
{
    if (!_cameraWaterMarkView)
    {
        _cameraWaterMarkView = [[CameraWaterMarkView alloc] initWithFrame:CGRectMake(100, 100, 100, 40)];
        _cameraWaterMarkView.layer.allowsEdgeAntialiasing = YES;
        self.removeBtn.layer.position = CGPointMake(100, 100);
        self.removeBtn.hidden = NO;
        self.zoomView.layer.position = CGPointMake(200, 140);
        self.zoomView.hidden = NO;
        
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveCameraWaterMarkView:)];
        [_cameraWaterMarkView addGestureRecognizer:pan];
        
        [self.view addSubview:_cameraWaterMarkView];
    }
    
    return _cameraWaterMarkView;
}

-(UIButton *)removeBtn
{
    if (!_removeBtn)
    {
        _removeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        _removeBtn.layer.anchorPoint = CGPointMake(0.5, 0.5);
        _removeBtn.hidden = YES;
        [_removeBtn setImage:[UIImage imageNamed:@"camera_water_mrak_delete"] forState:UIControlStateNormal];
        [self.imageView addSubview:_removeBtn];
    }
    return _removeBtn;
}

-(UIImageView *)zoomView
{
    if (!_zoomView)
    {
        _zoomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        _zoomView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        _zoomView.userInteractionEnabled = YES;
        _zoomView.image = [UIImage imageNamed:@"camera_water_mrak_zoom"];
        // 添加拖动手势
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self  action:@selector(handlePan:)];
        [_zoomView addGestureRecognizer:panGestureRecognizer];

        [self.imageView addSubview:_zoomView];
    }
    return _zoomView;
}

-(void)createUI
{
    //待编辑图片
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
//    _imageView.frame = CGRectMake(0, 64, _width, _width);
    _imageView.userInteractionEnabled = YES;
    _imageView.clipsToBounds = YES;
    _orientation = UIImageOrientationUp;
    
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager requestImageForAsset:self.asset
                            targetSize:PHImageManagerMaximumSize
                           contentMode:PHImageContentModeDefault
                               options:nil
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             CGFloat scale = result.size.height/result.size.width;
                             _imageView.frame = scale >= 1?CGRectMake(_width * (1 - 1/scale)/2, 64, _width/scale, _width):CGRectMake(0, 64 + _width * (1 - scale)/2, _width, _width * scale);
                             _image = result;
                             _imageView.image = result;
                         }];
    _imageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    _imageView.layer.position = CGPointMake(_width/2, _width/2 + 64);
    [self.view addSubview:_imageView];
    
    //编辑区域背景
    self.stickerView.hidden = NO;
    [self.view addSubview:self.toolsView];
    [self.view addSubview:self.stickerView];
    [self.view addSubview:self.filterView];
    
    //编辑选项按钮区域
    UIView * tabarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, _width, 49)];
    tabarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tabarView];
    
    CGFloat space =  (_width - 120)/4;
    
    NSArray * imageNames = @[@"camera_image_capture_water_mark_button",@"camera_image_capture_photofilter_button",@"camera_image_capture_set_button"];
    NSArray * imageSelectedNames = @[@"camera_image_capture_water_mark_button_highlight",@"camera_image_capture_photofilter_button_highlight",@"camera_image_capture_set_button_highlight"];
    NSArray * labelNames = @[@"贴纸",@"滤镜",@"工具"];
    
    for (NSInteger i = 1; i < 4; i++)
    {
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(i * space + (i - 1) *40, 0, 40, 38)];
        btn.tag = i + 15;
        [btn setImage:[UIImage imageNamed:imageNames[i-1]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imageSelectedNames[i-1]] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(tabarButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [tabarView addSubview:btn];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(i * space + (i - 1) *40, 38, 40, 10)];
        label.tag = i  * 10;
        label.text = labelNames[i - 1];
        label.font = [UIFont systemFontOfSize:11];
        label.textAlignment = NSTextAlignmentCenter;
        [tabarView addSubview:label];
        
        if (i == 1)
        {
            btn.selected = YES;
            label.textColor = [UIColor orangeColor];
        }
    }
    
}

#pragma mark    UIButton点击事件
-(void)tabarButtonTouched:(UIButton *)btn
{
    switch (btn.tag - 15)
    {
        case 1:
            self.stickerView.hidden = NO;
            self.toolsView.hidden = YES;
            self.filterView.hidden = YES;
            break;
            
        case 2:
            self.stickerView.hidden = YES;
            self.toolsView.hidden = YES;
            self.filterView.hidden = NO;
            break;
            
        case 3:
            self.stickerView.hidden = YES;
            self.toolsView.hidden = NO;
            self.filterView.hidden = YES;
            break;
            
        default:
            break;
    }
    
    for (NSInteger i = 1; i < 4; i++)
    {
        UILabel * label = [self.view viewWithTag:i * 10];
        label.textColor = i == btn.tag - 15?[UIColor orangeColor]:[UIColor blackColor];
        
        NSLog(@"btn.tag is %ld,i is %ld",(long)btn.tag,(long)i);
        
        
        UIButton * button = [self.view viewWithTag:i + 15];
        button.selected =( i == btn.tag - 15?YES:NO);
    }
}

-(void)toolsViewButtonTouched:(UIButton *)btn
{
    switch (btn.tag)
    {
        case 5:
            switch (_orientation)
        {
            case UIImageOrientationUp:
                _imageView = [UIImageView imageView:_imageView rotation:UIImageOrientationRight];
                _orientation = UIImageOrientationRight;
                break;
            case UIImageOrientationRight:
                _imageView = [UIImageView imageView:_imageView rotation:UIImageOrientationDown];
                _orientation = UIImageOrientationDown;
                break;
            case UIImageOrientationDown:
                _imageView = [UIImageView imageView:_imageView rotation:UIImageOrientationLeft];
                _orientation = UIImageOrientationLeft;
                break;
            case UIImageOrientationLeft:
                _imageView = [UIImageView imageView:_imageView rotation:UIImageOrientationUp];
                _orientation = UIImageOrientationUp;
                break;
                default:
                    break;
            }
            _image = [UIImage image:_image rotation:UIImageOrientationRight];
            break;
            
        case 6:
            [self.cropView setImage:_image];
            self.cropView.hidden = NO;
            break;
            
        case 7:
            
            break;
            
        default:
            break;
    }
}

#pragma mark     手势相关
-(void)handlePan:(UIPanGestureRecognizer *)pan
{
    CGPoint translation = [pan translationInView:self.imageView];

//    NSLog(@"translation.x is %f,translation.y is %f",translation.x,translation.y);
//    NSLog(@"----x is %f  y is %f",_centerPoint.x,_centerPoint.y);
     pan.view.center = CGPointMake(pan.view.center.x + translation.x, pan.view.center.y + translation.y);
    
    double radius = hypot(pan.view.center.x - _centerPoint.x, pan.view.center.y - _centerPoint.y);
    double scale = radius/_radius;
    
    double tan = ( pan.view.center.y - _centerPoint.y) / ( pan.view.center.x - _centerPoint.x );
    double angle = atan(tan) - _angle;
    
    //不要修改layer层 不然手势会失效
    self.cameraWaterMarkView.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(scale, scale), angle);

    self.removeBtn.layer.position = CGPointMake(2 * _centerPoint.x - self.zoomView.center.x, 2 * _centerPoint.y - self.zoomView.center.y);
    
    [pan setTranslation:CGPointZero inView:self.imageView];
}

-(void)moveCameraWaterMarkView:(UIPanGestureRecognizer *)pan
{
    CGPoint translation = [pan translationInView:self.imageView];
    
    pan.view.center = CGPointMake(pan.view.center.x + translation.x, pan.view.center.y + translation.y);
    _centerPoint = pan.view.center;
    self.removeBtn.center = CGPointMake(self.removeBtn.center.x + translation.x, self.removeBtn.center.y + translation.y);
    self.zoomView.center = CGPointMake(self.zoomView.center.x + translation.x, self.zoomView.center.y + translation.y);
    
    [pan setTranslation:CGPointZero inView:self.imageView];
    
}
@end
