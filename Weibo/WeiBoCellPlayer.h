//
//  WeiBoCellPlayer.h
//  JustForFunOfLee
//
//  Created by apple on 15/12/25.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^AvPlayerItemStatusBlock)();
@interface WeiBoCellPlayer : UIView

@property (nonatomic,strong)AVPlayer * player;

-(void)setVideoUrl:(NSString *)url avPlayerItemStatusBlock:(AvPlayerItemStatusBlock)block;
@end
