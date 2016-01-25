//
//  PhotoCollectionViewCell.h
//  JustForFunOfLee
//
//  Created by 文丹 on 16/1/24.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^imageDidSelected)(UIImage * image);
@interface PhotoCollectionViewCell : UICollectionViewCell

-(void)setModel:(UIImage *)image;
@end
