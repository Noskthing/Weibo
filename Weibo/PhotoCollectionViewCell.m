//
//  PhotoCollectionViewCell.m
//  JustForFunOfLee
//
//  Created by 文丹 on 16/1/24.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#import "AlbumModel.h"

@interface PhotoCollectionViewCell ()
{

    __weak IBOutlet UIButton *imageBtn;
    __weak IBOutlet UIButton *selectedBtn;
    
    //当前图片
    UIImage * _image;
    //第几张图片
    NSInteger _num;
    //相册一共多少张
    NSInteger _count;
    //相册图片
    NSArray * _photos;
    //相册模型
    AlbumModel * _model;
    
    //图片点击执行的block
    CellDidSelectedBlock _cellBlock;
    //选中图片按钮点击执行的block
    SelectedBtnDidSelectedBlock _seleBlock;
    
}
@end
@implementation PhotoCollectionViewCell

-(void)setModel:(UIImage *)image isFirstBtn:(BOOL)first
{
    _image = image;
    
    if (!first)
    {
        [imageBtn setBackgroundImage:image forState:UIControlStateNormal];
        [imageBtn setImage:nil forState:UIControlStateNormal];
    }
    else
    {
        [imageBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [imageBtn setImage:[UIImage imageNamed:@"compose_photo_photograph_highlighted"] forState:UIControlStateNormal];
    }
    
    selectedBtn.hidden = first;
}

-(void)changeBtnSelected
{
    selectedBtn.selected = !selectedBtn.selected;
}

-(void)setIsSelected:(BOOL)isSelected
{
    selectedBtn.selected = isSelected;
}

-(void)setPhototNumber:(NSInteger)num photosCount:(NSInteger)count AlbumModel:(AlbumModel *)model
{
    _num = num;
    _count = count;
    _model = model;
}

-(void)setCellDidSelectedBlock:(CellDidSelectedBlock)cellBlock SelectedBtnDidSelectedBlock:(SelectedBtnDidSelectedBlock)seleBlock
{
    _cellBlock = cellBlock;
    _seleBlock = seleBlock;
}

- (IBAction)btnDidSelected:(UIButton *)sender
{
    if (_seleBlock)
    {
        if(_seleBlock(_image,!sender.selected,_num))
        {
            sender.selected = !sender.selected;
        }
    }
}


- (IBAction)imageDidSelected:(UIButton *)sender
{
    if (selectedBtn.hidden)
    {
        NSLog(@"拍照");
    }
    else
    {
        NSLog(@"查看");
        if (_cellBlock)
        {
            _cellBlock(_num,_model,_count);
        }
    }
}

@end
