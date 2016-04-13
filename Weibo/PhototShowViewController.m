//
//  PhototShowViewController.m
//  JustForFunOfLee
//
//  Created by 文丹 on 16/1/25.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "PhototShowViewController.h"
#import "LeeScrollViewWithArray.h"
#import "AlbumModel.h"
#import "PhotoManager.h"


@interface PhototShowViewController ()

@end

@implementation PhototShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //遍历创造uiimageView；
    NSMutableArray * arr = [NSMutableArray array];
//    NSArray * images = [[PhotoManager standPhotoManager] getPhotoAssets:self.model.result targetSize:PHImageManagerMaximumSize];
//    [images enumerateObjectsUsingBlock:^(UIImage *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        @autoreleasepool
//        {
//            UIImageView * imageView = [[UIImageView alloc] init];
//            imageView.contentMode = UIViewContentModeScaleAspectFit;
//            imageView.image = obj;
//            [arr addObject:imageView];
//        }
//    }];
    [self.model.result enumerateObjectsUsingBlock:^(PHAsset *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHImageManager *imageManager = [PHImageManager defaultManager];
        [imageManager requestImageForAsset:obj
                                targetSize:PHImageManagerMaximumSize
                               contentMode:PHImageContentModeDefault
                                   options:nil
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 UIImageView * imageView = [[UIImageView alloc] initWithImage:result];
                                 [arr addObject:imageView];
                             }];
        if (idx == self.model.result.count - 1)
        {
            LeeScrollViewWithArray * scrollView = [[LeeScrollViewWithArray alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) andArray:[arr copy] andTimerWithTimeInterval:999];
            scrollView.backgroundColor = [UIColor redColor];
//            [scrollView scrollToPage:self.num];
            
            [self.view addSubview:scrollView];
        }
    }];
    
 
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
