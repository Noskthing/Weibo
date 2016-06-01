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

@interface CustomImageViewController ()
{
    CGFloat _width;
    
    //图片实际所在位置
    CGFloat _imageWidth;
    CGFloat _imageHeight;
    
    //图片
    UIImageView * _imageView;
    UIImage * _image;
    
    //第一次旋转
    BOOL _isFirst;
}
@property (nonatomic,strong)UIView * toolsView;

@property (nonatomic,strong)ImageOptionScrollView * filterView;

@property (nonatomic,strong)ImageOptionScrollView * stickerView;

@property (nonatomic,strong)CropImageView * cropView;
@end
@implementation CustomImageViewController

-(void)viewDidLoad
{
    _width = self.view.frame.size.width;
    
    self.view.backgroundColor = ColorWithRGB(224, 224, 224);
    
    _isFirst = YES;
    
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

-(UIScrollView *)stickerView
{
    if (!_stickerView)
    {
        _stickerView = [[ImageOptionScrollView alloc] initWithFrame:CGRectMake(0, 64 + _width, _width, self.view.frame.size.height - 49 - 64 - _width)];
        _stickerView.backgroundColor = ColorWithRGB(239, 239, 239);
        _stickerView.images = @[@"",@"",@"",@"",@""];
        _stickerView.hidden = YES;
        [_stickerView setOptionButtonDidSelevtedBlock:^(NSInteger tag) {
            NSLog(@"tag is %ld",(long)tag);
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
        [self.view addSubview:_cropView];
    }
    return _cropView;
}

-(void)createUI
{
    //待编辑图片
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.frame = CGRectMake(0, 64, _width, _width);
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager requestImageForAsset:self.asset
                            targetSize:PHImageManagerMaximumSize
                           contentMode:PHImageContentModeDefault
                               options:nil
                         resultHandler:^(UIImage *result, NSDictionary *info) {
//                             imageView.frame = result.scale >= 1?CGRectMake(0, 64, _width/result.scale, _width):CGRectMake(0, 64, _width, _width * result.scale);
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
            _imageView = [UIImageView rotate90DegreeWithImageView:_imageView];
            
            if (_isFirst)
            {
                _isFirst = NO;
            }
            else
            {
                _image = [UIImage image:_image rotation:UIImageOrientationRight];
                _imageView.image = _image;
            }
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
@end
