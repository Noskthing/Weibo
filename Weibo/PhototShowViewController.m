//
//  PhototShowViewController.m
//  JustForFunOfLee
//
//  Created by 文丹 on 16/1/25.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "PhototShowViewController.h"
#import "LBWScrollView.h"
#import "AlbumModel.h"
#import "PhotoManager.h"


@interface PhototShowViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView * collectionView;

@end

@implementation PhototShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
}

#pragma mark    创建UI
#pragma mark  创建UICollectionView
-(void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.collectionView];
}


#pragma mark     错误代码 反思注释
-(void)errorThing
{
    /**
     
     这里不推荐使用UIScrollView展示
     非常抱歉的是个人自己封装的UIScrollView也无法使用
     遍历获得PHAsset 通过PHImageManager获取图片   其中可能是因为异步的原因导致获取图片数组失败  想要一次性获得所有图片不现实  个人封装的UIScrollView在复用这里考虑的不如系统本身的UITableView之类的全面 可能出现未知崩溃
     妥协的办法是使用UItableView之类 将PHAsset数组传入 在每一个cell/item使用时去使用PHImageManager去获取图片加载
     
     我的疑惑是遍历获取图片是否会出现偏差 因为是单例类PHImageManager  频繁调用某一个方法可能出现线程错误  我的猜测啊
     
     */
    
    //    LBWScrollViewWithArray * scrollView = [[LBWScrollViewWithArray alloc] initWithFrame: CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    //    [self.view addSubview:scrollView];
    //
    ////    遍历创造uiimageView
    //    NSMutableArray * arr = [NSMutableArray array];
    //
    //    for(int i = 0; i < 4;i ++)
    //    {
    //        NSLog(@"hahahahaha");
    //        [[PHImageManager defaultManager] requestImageForAsset:self.model.result[0] targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
    //            UIImageView * imageView = [[UIImageView alloc] init];
    //            imageView.contentMode = UIViewContentModeScaleAspectFit;
    //            imageView.image = result;
    //            [arr addObject:imageView];
    //
    //            if (i == 3)
    //            {
    //                scrollView.views = [arr copy];
    //            }
    //        }];
    //    }
}

@end
