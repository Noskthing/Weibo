//
//  PostWordCollectionViewCell.m
//  JustForFunOfLee
//
//  Created by feerie luxe on 16/4/22.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "PostWordCollectionViewCell.h"

@interface PostWordCollectionViewCell ()
{
    __weak IBOutlet UIButton *bg;
    
    __weak IBOutlet UIButton *removeBtn;
}
@end

@implementation PostWordCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)configWith:(PHAsset *)phasset{
    // 在资源的集合中获取第一个集合，并获取其中的图片
    
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager requestImageForAsset:phasset
                            targetSize:PHImageManagerMaximumSize
                           contentMode:PHImageContentModeDefault
                               options:nil
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             [bg setBackgroundImage:result forState:UIControlStateNormal];
                         }];
    
}

-(void)addPhotoBtn
{
    
}
@end
