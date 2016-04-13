//
//  PhotoShowView.m
//  JustForFunOfLee
//
//  Created by 文丹 on 16/1/24.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "PhotoShowView.h"
#import "PhotoCollectionViewCell.h"
#import "AlbumModel.h"
#import "PhotoManager.h"

@interface PhotoShowView ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView * _collectionView;
    NSArray * _models;
    CellDidSelectedBlock _cellBlock;
    SelectedBtnDidSelectedBlock _seleBlock;
    AlbumModel * _model;
}
@end

static const CGFloat space = 5;
static const CGFloat edge = 5;

@implementation PhotoShowView

-(void)setCellDidSelectedBlock:(CellDidSelectedBlock)block
{
    _cellBlock = block;
}

-(void)setSelectedBtnDidSelectedBlock:(SelectedBtnDidSelectedBlock)block
{
    _seleBlock = block;
}

-(void)setModel:(AlbumModel *)model
{
//    CGFloat side = (self.frame.size.width - 2 * (edge + space))/3;
    _model = model;
    _models = [[PhotoManager standPhotoManager] getPhotoAssets:model.result targetSize:CGSizeMake(200,200)];
    
    [_collectionView reloadData];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        CGFloat side = (frame.size.width - 2 * (edge + space))/3;
        
        UICollectionViewFlowLayout * flowLayout= [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(side, side);
        flowLayout.minimumInteritemSpacing = edge;
        flowLayout.minimumLineSpacing = space;
        flowLayout.sectionInset = UIEdgeInsetsMake(edge, edge, edge, edge);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_collectionView];
    }
    return self;
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCollectionViewCell.h"];
}

#pragma mark -代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_models)
    {
        return _models.count + 1;
    }
    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell.h" forIndexPath:indexPath];

    
    if (_models)
    {
        [cell setModel:indexPath.row == 0?nil:_models[indexPath.row - 1] isFirstBtn:indexPath.row == 0?YES:NO];
        [cell setPhototNumber:indexPath.row photosCount:_models.count AlbumModel:_model];
        if (_seleBlock && _cellBlock)
        {
            [cell setCellDidSelectedBlock:_cellBlock SelectedBtnDidSelectedBlock:_seleBlock];
        }
    }
    
    return cell;
}

@end
