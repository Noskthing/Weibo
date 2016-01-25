//
//  PhotoShowView.m
//  JustForFunOfLee
//
//  Created by 文丹 on 16/1/24.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "PhotoShowView.h"
#import "PhotoCollectionViewCell.h"

@interface PhotoShowView ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView * _collectionView;
    NSArray * _models;
    CellDidSelectedBlock _block;
}
@end

static const CGFloat space = 5;
static const CGFloat edge = 5;

@implementation PhotoShowView

-(void)setCellDidSelectedBlock:(CellDidSelectedBlock)block
{
    _block = block;
}

-(void)setModels:(NSArray *)models
{
    _models = models;
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
        return _models.count;
    }
    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell.h" forIndexPath:indexPath];
    
    if (_models)
    {
        [cell setModel:_models[indexPath.row]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_block)
    {
        UIImage * image = _models[indexPath.row];
        _block(indexPath.row,image,_models.count);
    }
}
@end
