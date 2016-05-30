//
//  CustomImageViewController.h
//  JustForFunOfLee
//
//  Created by feerie luxe on 16/5/30.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

#define ColorWithRGB(R,G,B) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]

@interface CustomImageViewController : UIViewController

@property (nonatomic,strong)PHAsset * asset;
@end
