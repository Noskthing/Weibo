//
//  CustomTakePhotoViewController.h
//  JustForFunOfLee
//
//  Created by feerie luxe on 16/5/26.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    NavExitButton,
    NavFlashButton,
    NavChangeCameraButton,
} NavButtonType;

@class AlbumModel;
@interface CustomTakePhotoViewController : UIViewController

@property (nonatomic,strong)AlbumModel * model;

@end
