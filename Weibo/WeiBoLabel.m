//
//  WeiBoLabel.m
//  Weibo
//
//  Created by apple on 15/12/17.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#import "WeiBoLabel.h"
#import "Define.h"
#import <CoreText/CoreText.h>

@interface WeiBoLabel ()
{
    UIImageView * _textView;
    
    NSDictionary * _textColorDict;
}
@end
@implementation WeiBoLabel

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _textView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_textView];
        
        _textColorDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                          [UIColor colorWithRed:106/255.0 green:140/255.0 blue:181/255.0 alpha:1],kRegexHighlightViewTypeAccount,
                          [UIColor colorWithRed:106/255.0 green:140/255.0 blue:181/255.0 alpha:1],kRegexHighlightViewTypeURL,
                          [UIColor colorWithRed:106/255.0 green:140/255.0 blue:181/255.0 alpha:1],kRegexHighlightViewTypeEmoji,
                          [UIColor colorWithRed:106/255.0 green:140/255.0 blue:181/255.0 alpha:1],kRegexHighlightViewTypeTopic,nil];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)drawText
{
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:_text];
    
    //创建字体以及字体大小
    //    CTFontRef helvetica = CTFontCreateWithName(CFSTR("Helvetica"), 14.0, NULL);
    //    CTFontRef helveticaBold = CTFontCreateWithName(CFSTR("Helvetica-Bold"), 14.0, NULL);
    
    //创建文本对齐方式
    CTTextAlignment alignment = kCTJustifiedTextAlignment;//这种对齐方式会自动调整，使左右始终对齐
    CTParagraphStyleSetting alignmentStyle;
    alignmentStyle.spec=kCTParagraphStyleSpecifierAlignment;//指定为对齐属性
    alignmentStyle.valueSize=sizeof(alignment);
    alignmentStyle.value=&alignment;
    
    //创建文本行间距
    CGFloat lineSpace=0.0f;//间距数据
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec=kCTParagraphStyleSpecifierLineSpacing;//指定为行间距属性
    lineSpaceStyle.valueSize=sizeof(lineSpace);
    lineSpaceStyle.value=&lineSpace;
    
    //创建样式数组
    CTParagraphStyleSetting settings[]={
        alignmentStyle,lineSpaceStyle
    };
    
    //设置样式
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings));
    
    //给字符串添加样式attribute
    [string addAttribute:(id)kCTParagraphStyleAttributeName
                   value:(id)paragraphStyle
                   range:NSMakeRange(0, [string length])];
    
    string = [self highlightText:string];
    
    // layout master
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);
    //计算文本绘制size
    //    CGSize tmpSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), NULL, self.frame.size, NULL);
    //创建textBoxSize以设置view的frame
    //    CGSize textBoxSize = CGSizeMake((int)tmpSize.width + 1, (int)tmpSize.height + 1);
    //    NSLog(@"textBoxSize  == %f,%f,%f",textBoxSize.width,textBoxSize.height,textBoxSize.width / textBoxSize.height);
    //    self.frame = CGRectMake(6, 0, textBoxSize.width , textBoxSize.height);
    
    CGMutablePathRef leftColumnPath = CGPathCreateMutable();
    CGPathAddRect(leftColumnPath, NULL,
                  CGRectMake(0, 0,
                             self.bounds.size.width,
                             self.bounds.size.height));
    
    CTFrameRef leftFrame = CTFramesetterCreateFrame(framesetter,
                                                    CFRangeMake(0, 0),
                                                    leftColumnPath, NULL);
    
    //    NSLog(@"textBoxSize  == %f,%f,%f",self.frame.size.width,self.frame.size.height);
    // flip the coordinate system
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // draw
    CTFrameDraw(leftFrame, context);
    [self setNeedsDisplay];
    
    // cleanup
    
    CGPathRelease(leftColumnPath);
    CFRelease(framesetter);
    //CFRelease(helvetica);
    // CFRelease(helveticaBold);
    
    UIGraphicsPushContext(context);
}

//高亮处理
- (NSMutableAttributedString *)highlightText:(NSMutableAttributedString *)coloredString{
    //Create a mutable attribute string to set the highlighting
    NSString* string = coloredString.string;
    NSRange range = NSMakeRange(0,[string length]);
    //Define the definition to use
    NSDictionary* definition = @{kRegexHighlightViewTypeAccount: AccountRegular,
                                 kRegexHighlightViewTypeURL:URLRegular,
                                 kRegexHighlightViewTypeTopic:TopicRegular,
                                 kRegexHighlightViewTypeEmoji:EmojiRegular,
                                 };
    //For each definition entry apply the highlighting to matched ranges
    for(NSString* key in definition) {
        NSString* expression = [definition objectForKey:key];
        NSArray* matches = [[NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionDotMatchesLineSeparators error:nil] matchesInString:string options:0 range:range];
        for(NSTextCheckingResult* match in matches) {
            UIColor* textColor = nil;
            //Get the text color, if it is a custom key and no color was defined, choose black
            if(!_textColorDict||!(textColor=([_textColorDict objectForKey:key])))
                textColor = self.textColor;
    
            UIColor *highlightColor = _textColorDict[key];
            [coloredString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)highlightColor.CGColor range:match.range];
            
        }
    }
        return coloredString;
}
    
    
-(void)drawRect:(CGRect)rect
{
    [self drawText];
}
@end
