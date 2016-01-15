//
//  WeiboModel.m
//  Weibo
//
//  Created by apple on 15/12/14.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import "WeiboModel.h"
#import "NSString+Additions.h"
#import "Define.h"
#import <CoreText/CoreText.h>
#import "UIImage+GIF.h"

//图片间的宽度
static const CGFloat picSpace = 5;
//微博内容距四周的宽度
static const CGFloat contentSpace = 10;
//图片和底部栏之间的距离
static const CGFloat betweenPicAndBottomSpace = 10;

@interface WeiboModel ()
{
    NSDictionary * _textColorDict;
    UIFont * _font;
}
@end
@implementation WeiboModel

-(instancetype)init
{
    if (self = [super init])
    {
        _textColorDict = @{kRegexHighlightViewTypeAccount:[UIColor colorWithRed:106/255.0 green:140/255.0 blue:181/255.0 alpha:1],kRegexHighlightViewTypeURL:[UIColor colorWithRed:106/255.0 green:140/255.0 blue:181/255.0 alpha:1],kRegexHighlightViewTypeEmoji:[UIColor colorWithRed:106/255.0 green:140/255.0 blue:181/255.0 alpha:1],kRegexHighlightViewTypeTopic:[UIColor colorWithRed:106/255.0 green:140/255.0 blue:181/255.0 alpha:1]};
        
        _font = [UIFont systemFontOfSize:16];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"created_at"])
    {
        NSString * str = value;
        NSArray * createTime = [str componentsSeparatedByString:@" "];
        NSArray * now = [self getCurrentTime];
        [self createTimeWithNetWorkArr:createTime andNowArr:now];
    }
    //转换来源字段
    else if ([key isEqualToString:@"source"])
    {
        NSString * source = value;
        if (source.length>6)
        {
            NSInteger start = [source indexOf:@"\">"]+2;
            NSInteger end = [source indexOf:@"</a>"];
            _source = [source substringFromIndex:start toIndex:end];
        }
    }
    else
    {
        [super setValue:value forKey:key];
    }
}

#pragma mark  -获取cell高度
-(void)getCellHeightWithContent
{
    //cell顶部
    __block CGFloat height = 60;
    
    //可用屏幕宽度
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width - 2 * contentSpace;
    
    //图片宽 高
    CGFloat picWidth = (screenWidth - 2*picSpace)/3;
    
    //微博内容富文本
    _attributedString = [self highlightText:_text];
    
    //微博内容高度
    _textSize = CGSizeMake(screenWidth, [_attributedString.string boundingRectWithSize:CGSizeMake(screenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_font,NSParagraphStyleAttributeName:[self getParagraStyle]} context:nil].size.height + 17);
    height += _textSize.height;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _attributedString = [self expressionText:_attributedString];
        _attributedString = [self urlText:_attributedString];
        CGSize tmpTextSize = CGSizeMake(screenWidth, [_attributedString.string boundingRectWithSize:CGSizeMake(screenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_font,NSParagraphStyleAttributeName:[self getParagraStyle]} context:nil].size.height + 17);
        _cellHeight = _cellHeight - (_textSize.height - tmpTextSize.height);
        _textSize = tmpTextSize;
    });
    
    //判断是否为转发
    if (_retweeted_status)
    {
        //转发实际文字
        _retweeted_string = [NSString stringWithFormat:@"@%@：%@",_retweeted_status[@"user"][@"screen_name"],_retweeted_status[@"text"]];
        //转发文字富文本
        _retweeted_attributedString = [self highlightText:_retweeted_string];
        //转发文字大小
        _repostSize = CGSizeMake(screenWidth,[_retweeted_attributedString.string boundingRectWithSize:CGSizeMake(screenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_font,NSParagraphStyleAttributeName:[self getParagraStyle]} context:nil].size.height + 17);
        height += _repostSize.height;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _retweeted_attributedString = [self expressionText:_retweeted_attributedString];
            _retweeted_attributedString = [self urlText:_retweeted_attributedString];
            CGSize tmpRetSize = CGSizeMake(screenWidth,[_retweeted_attributedString.string boundingRectWithSize:CGSizeMake(screenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_font,NSParagraphStyleAttributeName:[self getParagraStyle]} context:nil].size.height + 17);
            _cellHeight = _cellHeight - (_repostSize.height - tmpRetSize.height);
            _repostSize = tmpRetSize;
        });
        
        
        
        //转发内容的图片字段
        _retweeted_pic_urls = _retweeted_status[@"pic_urls"];
        
        //转发是否有图片
        if (_retweeted_pic_urls.count > 0)
        {
            //获取图片size
            //有图片  height额外加了betweenPicAndBottomSpace   给图片和底部栏之间留一点距离
            _picturlsSize = _retweeted_pic_urls.count==1?CGSizeMake(screenWidth *2/3,picWidth * 1.2):CGSizeMake(picWidth,picWidth);
            height += _retweeted_pic_urls.count==1?picWidth * 1.2:_retweeted_pic_urls.count%3==0?_retweeted_pic_urls.count/3 * picWidth:(_retweeted_pic_urls.count/3 + 1) * picWidth + betweenPicAndBottomSpace;
        }
    }
    else
    {
        //微博是否有图片
        if (_pic_urls.count > 0)
        {
            //获取图片size
            _picturlsSize = _pic_urls.count==1?CGSizeMake(screenWidth * 2/3, picWidth * 1.2):CGSizeMake(picWidth, picWidth);
            
            height += _pic_urls.count==1?picWidth * 1.2:_pic_urls.count%3==0?_pic_urls.count/3 * picWidth:(_pic_urls.count/3 + 1) * picWidth + betweenPicAndBottomSpace;
        }
    }
    
    //cell底部按钮高度为33
    _cellHeight = height + 33;
    
    //底部和内容之间的空隙
    _cellHeight += 8;
}

#pragma mark  -获取当前时间
-(NSArray *)getCurrentTime
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString * currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    return [currentDateStr componentsSeparatedByString:@"-"];
}

#pragma mark  -将月份单词转化为对应数字
-(NSInteger)switchMonthWord:(NSString *)month
{
    if ([month isEqualToString:@"January"])
    {
        return 1;
    }
    else if ([month isEqualToString:@"February"])
    {
        return 2;
    }
    else if ([month isEqualToString:@"March"])
    {
        return 3;
    }
    else if ([month isEqualToString:@"April"])
    {
        return 4;
    }
    else if ([month isEqualToString:@"May"])
    {
        return 5;
    }
    else if ([month isEqualToString:@"June"])
    {
        return 6;
    }
    else if ([month isEqualToString:@"July"])
    {
        return 7;
    }
    else if ([month isEqualToString:@"August"])
    {
        return 8;
    }
    else if ([month isEqualToString:@"September"])
    {
        return 9;
    }
    else if ([month isEqualToString:@"October"])
    {
        return 10;
    }
    else if ([month isEqualToString:@"November"])
    {
        return 11;
    }
    else
    {
        return 12;
    }
    
    return 1;
}

#pragma mark  -根据时间字段定义获取时间
-(void)createTimeWithNetWorkArr:(NSArray *)createTime andNowArr:(NSArray *)now
{
    //是否为今年
    if ([createTime[5] integerValue] < [now[0] integerValue])
    {
        _created_at = [NSString stringWithFormat:@"%@-%@-%@",now[0],now[1],now[2]];
    }
    else
    {
        //是否为这个月
        if ([self switchMonthWord:createTime[1]] < [now[1] integerValue])
        {
            _created_at = [NSString stringWithFormat:@"%@-%@",now[1],now[2]];
        }
        else
        {
            //是否是今天
            if ([createTime[2] integerValue] < [now[2] integerValue])
            {
                NSInteger num = [now[2] integerValue] - [createTime[2] integerValue];
                _created_at = [NSString stringWithFormat:@"%ld天前",(long)num];
            }
            else
            {
                NSString * str = createTime[3];
                _created_at = [str substringFromIndex:0 toIndex:5];
            }
        }
    }
}

#pragma mark    -高亮处理
- (NSMutableAttributedString *)highlightText:(NSString *)string
{
    // 配置字体 和 段落属性
    NSMutableAttributedString * coloredString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:_font,NSParagraphStyleAttributeName:[self getParagraStyle]}];
    
    //Define the definition to use
    NSDictionary* definition = @{kRegexHighlightViewTypeAccount:AccountRegular,
                                 kRegexHighlightViewTypeTopic:TopicRegular,
                                 };
    
    for(NSString* key in definition)
    {
        NSString * expression = [definition objectForKey:key];
        NSArray* matches = [[NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionDotMatchesLineSeparators error:nil] matchesInString:coloredString.string options:0 range:NSMakeRange(0,[coloredString.string length])];
        
        for(NSTextCheckingResult* match in matches)
        {
            //添加点击时间会自动根据tintColor设置颜色
            [coloredString addAttribute:NSForegroundColorAttributeName value:_textColorDict[key] range:match.range];
            NSURL * url;
            if ([key isEqualToString:kRegexHighlightViewTypeTopic])
            {
                url = [NSURL URLWithString:[NSString stringWithFormat:@"top%@",[[string substringWithRange:match.range] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            }
            else
            {
                url = [NSURL URLWithString:[NSString stringWithFormat:@"use%@",[[string substringWithRange:match.range] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]];
            }
            //添加点击事件
            //NSUrl中不可以包含中文  需要对NSString进行编码处理   否则NSUrl会为空
            //真他妈坑
            if(url)
            {
                [coloredString addAttribute:NSLinkAttributeName value:url range:match.range];
            }
        }
    }

    return coloredString;
}


#pragma mark   -表情替换
-(NSMutableAttributedString *)expressionText:(NSMutableAttributedString *)coloredString
{
    
    
    NSArray* matches = [[NSRegularExpression regularExpressionWithPattern:EmojiRegular options:NSRegularExpressionDotMatchesLineSeparators error:nil] matchesInString:coloredString.string options:0 range:NSMakeRange(0,[coloredString.string length])];
    
    //累计差值   正则匹配以后的字段range会和进行修改以后的字段发生冲突
    //图片length为1
    NSUInteger num = 0;
    
    for(NSTextCheckingResult* match in matches)
    {
        NSRange currentRange = NSMakeRange(match.range.location - num, match.range.length);
        //本地获取表情字典
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary * dict = [defaults objectForKey:@"expression"];
        NSString * str = [coloredString.string substringWithRange:currentRange];
        NSData * data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:dict[str]]];
        UIImage * image = [UIImage sd_animatedGIFWithData:data];
        
        
        NSTextAttachment *textAttachment01 = [[NSTextAttachment alloc] init];
        //设置图片源
        textAttachment01.image = image;
        //设置图片位置和大小
        //Y值越小图片越向下   （貌似取值效果与正常frame相反）
        textAttachment01.bounds = CGRectMake(0, -3, 18, 18);
        NSAttributedString * imageString = [NSAttributedString attributedStringWithAttachment:textAttachment01];
        [coloredString replaceCharactersInRange:currentRange withAttributedString:imageString];
        num += match.range.length -1;
    }
    
    return coloredString;
}

#pragma mark  -url替换
-(NSMutableAttributedString *)urlText:(NSMutableAttributedString *)urlString
{
    NSArray* matches = [[NSRegularExpression regularExpressionWithPattern:URLRegular options:NSRegularExpressionDotMatchesLineSeparators error:nil] matchesInString:urlString.string options:0 range:NSMakeRange(0,[urlString.string length])];
    
    //累计差值   正则匹配以后的字段range会和进行修改以后的字段发生冲突
    //图片length为1
    NSUInteger num = 0;
    
    for(NSTextCheckingResult* match in matches)
    {
        //计算当前range
        NSRange currentRange = NSMakeRange(match.range.location - num, match.range.length);
        //获取网页链接
        NSString * str = [urlString.string substringWithRange:currentRange];
        //从网页获取源码
        NSString * htmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:str] encoding:NSUTF8StringEncoding error:nil];
        //匹配字符  获取title
        //htmlString可能为空   加一个判断  否则会出现nil argument :)
        if (htmlString)
        {
            //匹配出title
            NSArray* results = [[NSRegularExpression regularExpressionWithPattern:TitleRegular options:NSRegularExpressionDotMatchesLineSeparators error:nil] matchesInString:htmlString options:0 range:NSMakeRange(0,[htmlString length])];
            //只要第一个title
            if (results.count > 0)
            {
                NSTextCheckingResult* result = results[0];
                NSString * title = [htmlString substringWithRange:result.range];
                //根据title决定图片和标题
                NSString * imageName;
                NSString * name;
                //秒拍视频
                if ([title isEqualToString:@"秒拍视频"])
                {
                    imageName  = @"timeline_card_small_video";
                    name = title;
                }
                else
                {
                    imageName = @"timeline_card_small_web";
                    //标题字段比 图片+网页链接短
                    if (title.length <= str.length)
                    {
                        name = @"秒拍视频";
                    }
                    //长就截断
                    //新浪微博对自家的链接title进行了二次截断   外部链接貌似也是处理过的   不知道规律  看心情定了这么一个规则
                    //主要怕string长度出现问题  越界什么的真是作孽啊！！！
                    else
                    {
                        name = [title substringWithRange:NSMakeRange(0, str.length - 1)];
                    }
                }
                //替换链接
                UIImage * image = [UIImage imageNamed:imageName];
                NSTextAttachment *textAttachment01 = [[NSTextAttachment alloc] init];
                //设置图片源
                textAttachment01.image = image;
                //设置图片位置和大小
                textAttachment01.bounds = CGRectMake(0, -3, 14, 14);
                //图标
                NSAttributedString * imageString = [NSAttributedString attributedStringWithAttachment:textAttachment01];
                //网页链接字体
                NSMutableAttributedString * url = [[NSMutableAttributedString alloc] initWithString:name];
                //拼接网页链接富文本
                [url insertAttributedString:imageString atIndex:0];
                //替换
                [urlString replaceCharactersInRange:currentRange withAttributedString:url];
                //添加点击事件
                [urlString addAttribute:NSLinkAttributeName value:[NSURL URLWithString:[NSString stringWithFormat:@"url%@",str]] range:NSMakeRange(currentRange.location, url.string.length)];
                
                num += match.range.length -url.string.length;
            }
        }
        
    }
    
    // 配置字体 和 段落属性
    [urlString addAttribute:NSFontAttributeName value:_font range:NSMakeRange(0, urlString.string.length)];
    return urlString;
}

#pragma mark  -段落设置
- (NSMutableParagraphStyle *)getParagraStyle
{
    // 定制段落的样式
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    return style;
}

@end
