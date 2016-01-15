//
//  WeiBoTableViewCell.m
//  Weibo
//
//  Created by apple on 15/12/16.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import "WeiBoTableViewCell.h"
#import "UIView+Additions.h"
#import "UIScreen+Additions.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import "Define.h"
#import <CoreText/CoreText.h>

@interface WeiBoTableViewCell ()<UITextViewDelegate>
{
    //微博用户头像
    UIImageView * _icon;
    //微博用户昵称
    UILabel * _nickName;
    //微博来源
    UILabel * _source;
    //更多按钮
    UIButton * _moreBtn;
    //横向线
    UIView * _line;
    //纵向分割线
    UIView * _leftLine;
    UIView * _rightLine;
    //转发图标
    UIButton * _repostBtn;
    UILabel * _repostLabel;
    //评论图标
    UIButton * _commentBtn;
    UILabel * _commentLabel;
    //点赞图标
    UIButton * _attitudesBtn;
    UILabel * _attitudesLabel;
    //微博内容
    UITextView * _weiBoLabel;
    //转发内容
    UITextView * _repostCellLabel;
    //转发内容背景
    UIView * _repostLabelBg;
}
//图片组
@property (nonatomic,strong)NSArray * picurls;
@end

//图片间的宽度
static const CGFloat picSpace = 5;
//微博内容距四周的宽度
static const CGFloat contentSpace = 10;
//微博顶部高度
static const CGFloat topHeight = 60;
//微博底部的高度
static const CGFloat bottomHeight = 33;

@implementation WeiBoTableViewCell

#pragma mark   -初始化方法
-(NSArray *)picurls
{
    if (!_picurls)
    {
        NSMutableArray * arr = [NSMutableArray array];
        for (int i = 0; i < 9; i++)
        {
            UIImageView * imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [arr addObject:imageView];
        }
        _picurls = [arr copy];
    }
    return _picurls;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        //可用屏幕宽度
//        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width - 2 * contentSpace;
        
        //头像
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(contentSpace, contentSpace,topHeight - 2 * contentSpace, topHeight - 2 * contentSpace)];
        _icon.userInteractionEnabled = YES;
        UITapGestureRecognizer * iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTouch:)];
        [_icon addGestureRecognizer:iconTap];
        _icon.backgroundColor = [UIColor redColor];
        _icon.layer.cornerRadius = _icon.height/2;
        _icon.layer.masksToBounds = YES;
        [self addSubview:_icon];
        
        //更多按钮
        CGFloat moreBtnSpace = 25;
        _moreBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - contentSpace -moreBtnSpace, 20, moreBtnSpace, moreBtnSpace)];
        [_moreBtn addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
        [_moreBtn setImage:[UIImage imageNamed:@"message_toolbar_popover_arrow"] forState:UIControlStateNormal];
        [self addSubview:_moreBtn];
        
        //昵称
        _nickName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_icon.frame) + 8, contentSpace, 200,_icon.height * 0.45)];
        _nickName.font = [UIFont systemFontOfSize:15];
        [self addSubview:_nickName];
        
        //时间  来源
        _source = [[UILabel alloc] initWithFrame:CGRectMake(_nickName.x,topHeight - 12 - contentSpace, 200, 10)];
        _source.font = [UIFont systemFontOfSize:11];
        _source.textColor = [UIColor grayColor];
        [self addSubview:_source];
        
        //底部线
        _line = [[UIView alloc] init];
        _line.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
        [self addSubview:_line];
        
        //分割线
        _leftLine = [[UIView alloc] init];
        _leftLine.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
        [self addSubview:_leftLine];
        
        _rightLine = [[UIView alloc] init];
        _rightLine.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
        [self addSubview:_rightLine];
        
        //图标
        _repostBtn = [[UIButton alloc] init];
        [_repostBtn  setImage:[UIImage imageNamed:@"toolbar_icon_retweet"] forState:UIControlStateNormal];
        _repostLabel = [[UILabel alloc] init];
        [self addSubview:_repostLabel];
        [self addSubview:_repostBtn];
        
        _commentBtn = [[UIButton alloc] init];
        [_commentBtn  setImage:[UIImage imageNamed:@"toolbar_icon_comment"] forState:UIControlStateNormal];
        _commentLabel = [[UILabel alloc] init];
        [self addSubview:_commentLabel];
        [self addSubview:_commentBtn];
        
        _attitudesBtn = [[UIButton alloc] init];
        [_attitudesBtn  setImage:[UIImage imageNamed:@"toolbar_icon_unlike"] forState:UIControlStateNormal];
        _attitudesLabel = [[UILabel alloc] init];
        [self addSubview:_attitudesLabel];
        [self addSubview:_attitudesBtn];
        
        //微博内容
        _weiBoLabel = [[UITextView alloc] init];
        _weiBoLabel.editable = NO;
        _weiBoLabel.scrollEnabled = NO;
        _weiBoLabel.delegate = self;
        //UITextView的tintColor影响富文本中 *设为链接的部分颜色*
        _weiBoLabel.tintColor = [UIColor colorWithRed:106/255.0 green:140/255.0 blue:181/255.0 alpha:1];
        [self addSubview:_weiBoLabel];
        
        _repostLabelBg = [[UIView alloc] init];
        _repostLabelBg.backgroundColor = [UIColor colorWithRed:0.937f green:0.937f blue:0.957f alpha:1.00f];
        [self addSubview:_repostLabelBg];
        
        //转发内容
        _repostCellLabel = [[UITextView alloc] init];
        _repostCellLabel.editable = NO;
        _repostCellLabel.scrollEnabled = NO;
        _repostCellLabel.delegate = self;
        _repostCellLabel.tintColor = [UIColor colorWithRed:106/255.0 green:140/255.0 blue:181/255.0 alpha:1];
        _repostCellLabel.backgroundColor = [UIColor colorWithRed:0.937f green:0.937f blue:0.957f alpha:1.00f];
        [self addSubview:_repostCellLabel];
        
    }
    return self;
}

#pragma mark  -传递模型
-(void)setWeiBoModel:(WeiboModel *)model
{
    NSDictionary * user = model.user;
    [_icon sd_setImageWithURL:[NSURL URLWithString:user[@"profile_image_url"]]];
    _nickName.text = user[@"screen_name"];
    _source.text = [NSString stringWithFormat:@"%@  来自 %@",model.created_at,model.source];
    
    //底部线
    _line.frame = CGRectMake(0, self.height - bottomHeight, self.width, 0.8);
   //分割线
    _leftLine.frame = CGRectMake(self.width/3,self.height - bottomHeight * 3/4 , 1, bottomHeight/2);
    _rightLine.frame = CGRectMake(self.width * 2/3, self.height - bottomHeight * 3/4, 1, bottomHeight/2);
    
    //底部图标
    NSArray * btnArray = @[_repostBtn,_commentBtn,_attitudesBtn];
    NSArray * labelArray = @[_repostLabel,_commentLabel,_attitudesLabel];
    [btnArray enumerateObjectsUsingBlock:^(UIButton *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @autoreleasepool
        {
            obj.frame = CGRectMake(self.width * (1 + 3*idx)/9, self.height - bottomHeight * 3/4, bottomHeight/2, bottomHeight/2);
            UILabel * label = labelArray[idx];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor colorWithRed:0.607f green:0.607f blue:0.607f alpha:1.00f];
            label.frame = CGRectMake(CGRectGetMaxX(obj.frame) + 8, self.height - bottomHeight * 3/4, self.width * 2/3 - 10,bottomHeight/2 );
        }
    }];
    _repostLabel.text = [NSString stringWithFormat:@"%ld",(long)model.reposts_count];
    _commentLabel.text = [NSString stringWithFormat:@"%ld",(long)model.comments_count];
    _attitudesLabel.text = [NSString stringWithFormat:@"%ld",(long)model.attitudes_count];
    
    //微博内容
    _weiBoLabel.frame = CGRectMake(contentSpace, topHeight - 5, model.textSize.width, model.textSize.height);
    _weiBoLabel.attributedText = model.attributedString;
    
//    CGFloat diff = (_weiBoLabel.height - _weiBoLabel.contentSize.height)/2;
    //转发内容
    if(model.repostSize.height)
    {
        //有转发内容
        _repostCellLabel.frame = CGRectMake(contentSpace, CGRectGetMaxY(_weiBoLabel.frame),model.repostSize.width, model.repostSize.height);
        _repostLabelBg.frame = CGRectMake(0, CGRectGetMaxY(_weiBoLabel.frame), self.width,self.height - bottomHeight - CGRectGetMaxY(_weiBoLabel.frame));
        //显示富文本
        _repostCellLabel.attributedText = model.retweeted_attributedString;
        
        [self picturlsShowInCell:model.retweeted_pic_urls andPicturlSize:model.picturlsSize andMaxY:CGRectGetMaxY(_repostCellLabel.frame)];
//        NSLog(@"----%f----%f",(_repostCellLabel.height - _repostCellLabel.contentSize.height)/2,diff);
    }
    else
    {
        //无转发内容  隐藏转发相关视图
        _repostCellLabel.frame = CGRectZero;
        _repostLabelBg.frame = CGRectZero;
        
        [self picturlsShowInCell:model.pic_urls andPicturlSize:model.picturlsSize andMaxY:CGRectGetMaxY(_weiBoLabel.frame)];
    }
}

#pragma mark   -根据图片尺寸以及视图顶部位置依次布局图片
-(void)picturlsShowInCell:(NSArray *)picurls andPicturlSize:(CGSize)picturlSize andMaxY:(CGFloat)maxY
{
    //有图
    if (picurls.count > 0)
    {
        //遍历图片视图数组
        [self.picurls enumerateObjectsUsingBlock:^(UIImageView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //有图片的   从视图数组取出异步加载
            if (idx < picurls.count)
            {
                //取图片地址
                NSDictionary * tmpDict = picurls[idx];
                [obj sd_setImageWithURL:tmpDict[@"thumbnail_pic"]];
                //计算这是第几行 第几列的图片
                NSInteger row;
                NSInteger column;
                if (picurls.count == 4)
                {
                    row = idx/2;
                    column = idx%2;
                }
                else
                {
                    row = idx/3;
                    column = idx%3;
                }
                obj.frame = CGRectMake(contentSpace + column * (picSpace + picturlSize.width), maxY + row * (picSpace + picturlSize.height), picturlSize.width, picturlSize.height);
                
                [self addSubview:obj];
            }
            //没有图片则从父视图移除
            else
            {
                [obj removeFromSuperview];
            }
        }];
    }
    else
    {
        //将数组所有视图全部从俯视图移除
        [self.picurls enumerateObjectsUsingBlock:^(UIImageView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
    }
}

#pragma mark   -UITextView代理方法
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    //将NSUrl转换成NSString 并进行反编码处理
    NSString * str = [URL absoluteString];
    str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //获取点击时间对应事件
    NSString * type = [str substringWithRange:NSMakeRange(0, 3)];
    
    //获取所需字段的时候  截取英文和中文截取点不一样   NSMakeRange(location,length)
    //英文开头从0算   中文从1算
    //具体情况还是测试为准...我也不确定
    //用户
    if ([type isEqualToString:@"use"])
    {
        NSString * userName = [str substringWithRange:NSMakeRange(4, str.length -4)];
        [_delegate richTextdDidSeletced:userName RichTextType:userText];
//        NSLog(@"userName = %@",userName);
    }
    //话题
    else if ([type isEqualToString:@"top"])
    {
        NSString * topicName = [str substringWithRange:NSMakeRange(4, str.length -5)];
        [_delegate richTextdDidSeletced:topicName RichTextType:topicText];
//        NSLog(@"topicName = %@",topicName);
    }
    //网页链接
    else
    {
        NSString * urlName = [str substringWithRange:NSMakeRange(3, str.length -3)];
        [_delegate richTextdDidSeletced:urlName RichTextType:urlText];
//        NSLog(@"urlName = %@",urlName);
    }
    //不跳转
    return NO;
}

#pragma mark    -更多按钮点击时间
-(void)btnTouch:(UIButton *)sender
{
    
}


#pragma mark    -头像点击时间
-(void)iconTouch:(UITapGestureRecognizer *)tap
{
    [_delegate richTextdDidSeletced:_nickName.text RichTextType:userId];
}
@end
