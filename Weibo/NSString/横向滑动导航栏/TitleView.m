//
//  TitleView.m
//  test
//
//  Created by mac on 15/9/16.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "TitleView.h"
#import "CollectionViewCell.h"
@interface TitleView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray * _titles;
    UIColor * _color;
    CGRect _currentRect;
    NSInteger _currntNum;
    CGFloat  _itemWidth;
    UIView * _scrollView;
    itemDidSelectedBlock _block;
}

@end

//底部滑动块的高度
static const CGFloat scrollViewHeight = 3;

@implementation TitleView



#pragma mark  初始化方法
-(void)titleViewWithTitles:(NSArray *)titles scrollViewColor:(UIColor *)color itemDidSelectedBlock:(itemDidSelectedBlock)block
{
    _titles = titles;
    _color = color;
    _block = block;
}

#pragma mark 根据传入的item位置偏移
-(void)changeTitlesViewCurrentNum:(NSInteger)index
{
    [self judgeIndex:index];
    [self animationForScrollView];
}


#pragma mark 判断下一个index
-(void)judgeIndex:(NSInteger)index
{
    if (index > _currntNum)
    {
        _currntNum = 0;
    }
    else if(index < 0)
    {
        _currntNum = _titles.count;
    }
    else
    {
        _currntNum = index;
    }
}

#pragma mark  创建底部滑动块
-(void)createScrollView
{
    UIView * view = [[UIView alloc] init];
    view.frame = CGRectMake(0, self.frame.size.height-scrollViewHeight,self.frame.size.width/_titles.count,scrollViewHeight );
    _scrollView = view;
    _currentRect = view.frame;
    
    view.backgroundColor = _color?_color:[UIColor redColor];

    
    [self addSubview:view];
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    //cell大小
    CGFloat width = (self.frame.size.width / _titles.count)*1.0;
    _itemWidth = width;
    flow.itemSize = CGSizeMake(width,self.frame.size.height);
    //滚动方向
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //距离边缘的空隙
    flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //两个item水平的最小空隙(默认10)
    flow.minimumInteritemSpacing = 0;
    //两个item垂直方向的最小空隙(默认10)
    flow.minimumLineSpacing = 0;
    
    self.delegate = self;
    self.dataSource = self;
    
    [self createScrollView];

    self.backgroundColor = [UIColor whiteColor];
    
    [self registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];

}

#pragma mark 根据比例滑动
-(void)scrollViewWithOffset:(CGFloat)scale
{
    _currentRect.origin.x = scale*self.frame.size.width;
    [UIView animateWithDuration:0.2 animations:^{
        _scrollView.frame = _currentRect;
    }];
}


#pragma mark 滑动动画
-(void)animationForScrollView
{
    _currentRect.origin.x = _currntNum * _itemWidth;
    
    [UIView animateWithDuration:0.3 animations:^{
        _scrollView.frame = _currentRect;
    }];
}
#pragma mark  UICollectionViewDelegate
//当前collectionView里面有多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _titles.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    
    
    /*
     UITableView IndexPath(row,section)
     UICollectionView IndexPath(item,section)
     */
    
    //赋值

    cell.labelTitle.text = _titles[indexPath.row];
    
    return cell;
}


#pragma mark 代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _currntNum = indexPath.row;
    
    [self animationForScrollView];
    
    CGFloat scale = indexPath.row/(CGFloat)_titles.count;
    
    
    _block(scale,_currntNum);
    
    
    



}

@end
