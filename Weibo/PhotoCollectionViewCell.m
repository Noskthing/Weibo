//
//  PhotoCollectionViewCell.m
//  JustForFunOfLee
//
//  Created by 文丹 on 16/1/24.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@interface PhotoCollectionViewCell ()
{

    __weak IBOutlet UIImageView *imageView;

    
}
@end
@implementation PhotoCollectionViewCell

-(void)setModel:(UIImage *)image
{
    imageView.image = image;
}

- (IBAction)btnDidSelected:(UIButton *)sender
{
    sender.selected = !sender.selected;
}



@end
