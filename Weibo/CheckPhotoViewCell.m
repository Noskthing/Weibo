//
//  CheckPhotoViewCell.m
//  JustForFunOfLee
//
//  Created by feerie luxe on 16/4/20.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "CheckPhotoViewCell.h"


@interface CheckPhotoViewCell ()
{
    CellDidSelectedBlock _block;
}
@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation CheckPhotoViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self makeUI];
    }
    return self;
}

-(void)setCellDidSelectedBlock:(CellDidSelectedBlock)block
{
    _block = block;
}

- (void)makeUI{
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellDidSelected)];
    [self.imageView addGestureRecognizer:tap];
    
}

-(void)cellDidSelected
{
    if (_block)
    {
        _block();
    }
}

- (void)configWith:(PHAsset *)phasset{
    // 在资源的集合中获取第一个集合，并获取其中的图片
    self.imageView.image = nil;
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager requestImageForAsset:phasset
                            targetSize:PHImageManagerMaximumSize
                           contentMode:PHImageContentModeDefault
                               options:nil
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             self.imageView.image = result;
                         }];
    
}
@end
