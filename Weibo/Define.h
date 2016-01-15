//
//  Define.h
//  Weibo
//
//  Created by apple on 15/12/17.
//  Copyright © 2015年 com.jdtx. All rights reserved.
//

#ifndef Define_h
#define Define_h


#endif /* Define_h */


#define kRegexHighlightViewTypeURL @"url"
#define kRegexHighlightViewTypeAccount @"account"
#define kRegexHighlightViewTypeTopic @"topic"
#define kRegexHighlightViewTypeEmoji @"emoji"

#define URLRegular @"(http|https)://(t.cn/|weibo.com/)+(([a-zA-Z0-9/])*)"
#define EmojiRegular @"(\\[\\w+\\])"
#define AccountRegular @"@[\u4e00-\u9fa5a-zA-Z0-9_-]{2,30}"
#define TopicRegular @"#[^#]+#"
#define TitleRegular @"(?<=\\<title\\>).* ?(?=\\</title\\>)"

#define PicTag 1993
#define kRightBtnTag 344
#define kLeftBtnTag 345

/** 获取用户信息*/
#define UserInfoUrl @"https://api.weibo.com/2/users/show.json"
/** 获取用户关注人的最新微博**/
#define UserNewFriendWeiBo @"https://api.weibo.com/2/statuses/friends_timeline.json"

#define AppDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]
