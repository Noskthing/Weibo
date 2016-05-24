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
#import "CheckPhotoViewCell.h"
#import "PostWordViewController.h"

@interface PhototShowViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    ViewWillDisappearBlock _block;
}
@property(nonatomic,strong)UICollectionView * collectionView;

@property(nonatomic,strong)UIButton * selectedBtn;

@property(nonatomic,strong)UIButton * rightBarItemButton;
@end

@implementation PhototShowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createCollectionView];
    [self createSelectedBtn];
    
    [self createSubviewsOnNav];
}


-(void)setViewWillDisappearBlock:(ViewWillDisappearBlock)block
{
    _block = block;
}

//滑动到制定位置
-(void)viewDidLayoutSubviews
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.num - 1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

//选中图片回调
-(void)viewWillDisappear:(BOOL)animated
{
    if (_block)
    {
        _block(self.selectedPhotos);
    }
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
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) collectionViewLayout:flowLayout];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    [self.collectionView registerClass:[CheckPhotoViewCell class] forCellWithReuseIdentifier:@"CheckPhotoViewCell"];
    
}

#pragma mark     创建选中按钮
-(void)createSelectedBtn
{
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.8, 95, 30, 30)];
    _selectedBtn = btn;
    
    [btn addTarget:self action:@selector(selectedBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setImage:[UIImage imageNamed:@"compose_photo_preview_default"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"compose_photo_preview_right"] forState:UIControlStateSelected];
    
    [self.view addSubview:btn];
}

#pragma mark    导航栏控件创建
-(void)createSubviewsOnNav
{
    self.navigationItem.title = [NSString stringWithFormat:@"%ld/%lu",(long)self.num,(unsigned long)self.count];
    
    self.rightBarItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.selectedPhotos.count != 0?68:55, 25)];
    self.rightBarItemButton.layer.cornerRadius = 5;
    [self.rightBarItemButton setTitle:self.selectedPhotos.count != 0?[NSString stringWithFormat:@"下一步(%lu)",(unsigned long)self.selectedPhotos.count]:@"下一步" forState:UIControlStateNormal];
    self.rightBarItemButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.rightBarItemButton.backgroundColor = [UIColor orangeColor];
    self.rightBarItemButton.titleLabel.tintColor = [UIColor whiteColor];
    [self.rightBarItemButton addTarget:self action:@selector(nextSetupBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBarItemButton];
}

#pragma mark     UICollectionView代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.model)
    {
        return self.model.result.count;
    }
    return 0;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CheckPhotoViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CheckPhotoViewCell" forIndexPath:indexPath];
    
    if (self.model)
    {
        [cell configWith:self.model.result[indexPath.row]];
    }
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.num = ((scrollView.contentOffset.x/self.view.bounds.size.width + 1) < 1?1:(scrollView.contentOffset.x/self.view.bounds.size.width + 1));
    
    //修改标题
    self.navigationItem.title = [NSString stringWithFormat:@"%ld/%lu",(long)self.num,(unsigned long)self.count];
    
    //判断选中按钮状态
    if ([self.selectedPhotos containsObject:@(self.num)])
    {
        _selectedBtn.selected = YES;
    }
    else
    {
        _selectedBtn.selected = NO;
    }
    
    //修改下一步Button
    [self changeNextSetupBtnTitle];
}

#pragma mark     选中按钮点击事件
-(void)selectedBtnTouch:(UIButton *)btn
{
//    NSLog(@"num is %ld res is %@",(long)self.num,self.selectedPhotos[0]);
    if (btn.selected)
    {
        [self.selectedPhotos removeObject:@(self.num)];
    }
    else
    {
        if (self.selectedPhotos.count == 9)
        {
            NSLog(@"最多只能选择9张");
            btn.selected = !btn.selected;
        }
        else
        {
            [self.selectedPhotos addObject:@(self.num)];
        }
    }
    
    btn.selected = !btn.selected;
    
    [self changeNextSetupBtnTitle];
}

#pragma mark    修改下一步Button.titleLabel
-(void)changeNextSetupBtnTitle
{
    CGRect frame = self.rightBarItemButton.frame;
    frame.size.width = self.selectedPhotos.count != 0?68:55;
    self.rightBarItemButton.frame = frame;
    [self.rightBarItemButton setTitle:self.selectedPhotos.count != 0?[NSString stringWithFormat:@"下一步(%lu)",(unsigned long)self.selectedPhotos.count]:@"下一步" forState:UIControlStateNormal];
}

#pragma mark    下一步按钮点击事件
-(void)nextSetupBtnTouch:(UIButton *)btn
{
    NSMutableArray * arr = [NSMutableArray array];
    [_selectedPhotos enumerateObjectsUsingBlock:^(NSNumber *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObject:[self.model.result objectAtIndex:[obj integerValue]]];
    }];
    
//    [PostWordViewController postWordViewController].getAlbumPhotosBlock(arr);
    [self.navigationController popToRootViewControllerAnimated:YES];
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
