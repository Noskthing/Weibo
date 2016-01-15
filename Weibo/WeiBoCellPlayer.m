//
//  WeiBoCellPlayer.m
//  JustForFunOfLee
//
//  Created by apple on 15/12/25.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import "WeiBoCellPlayer.h"

@interface WeiBoCellPlayer ()

@property (nonatomic,copy)AvPlayerItemStatusBlock _block;

@end

@implementation WeiBoCellPlayer

#pragma mark    自定义播放器layer容器
+(Class)layerClass
{
    return [AVPlayerLayer class];
}

-(void)setPlayer:(AVPlayer *)player
{
//    CALyer -->  AVPlayerLayer
    AVPlayerLayer * layer = (AVPlayerLayer *)self.layer;
//    只有AVPlayerLayer才能使用setLayer
    [layer setPlayer:player];
}


-(AVPlayer *)player
{
    AVPlayerLayer * layer = (AVPlayerLayer *)self.layer;
    return layer.player;
}

#pragma mark   设置播放器url及数据传输状态处理block
-(void)setVideoUrl:(NSString *)url avPlayerItemStatusBlock:(AvPlayerItemStatusBlock)block
{
//    NSURL * videoUrl = [NSURL URLWithString:url];
    
}
@end
