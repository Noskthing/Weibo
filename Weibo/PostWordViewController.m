//
//  PostWordViewController.m
//  JustForFunOfLee
//
//  Created by apple on 16/1/7.
//  Copyright © 2016年 com.jdtx. All rights reserved.
//

#import "PostWordViewController.h"
#import "UIView+Additions.h"
#import "LeeKeyboard.h"
#import "CustomTextView.h"
#import "StatusBtnView.h"
#import "ConnectDelegate.h"
#import "Define.h"
#import "LocationViewController.h"
#import "ShareRangeViewController.h"
#import "PhotoViewController.h"
#import "NavTitleView.h"
#import "PostWordCollectionViewCell.h"

@interface PostWordViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    //背景视图下滑目标位置y坐标
    CGFloat _y;
    //发送按钮
    UIButton * _postBtn;
    //选择图片PHImageResult数组
    NSMutableArray * _results;
    //被选择图片的下标
    NSMutableArray * _resultsNum;
}
//自定义键盘的选择视图背景
@property (nonatomic,strong)UIView * bgView;
//输入视图
@property (nonatomic,strong)CustomTextView * textView;
//键盘按钮
@property (nonatomic,strong)UIButton * hideBtn;
//地址按钮
@property (nonatomic,strong)StatusBtnView * addressBtn;
//权限按钮
@property (nonatomic,strong)StatusBtnView * jurisdictionBtn;
//选择图片展示collectionView
@property(nonatomic,strong)UICollectionView * photosCollectionView;
@end

static const CGFloat customKeyBoardHeight = 46;
@implementation PostWordViewController

//-(NSMutableArray *)results
//{
//    if (!_results)
//    {
//        _results = [NSMutableArray arrayWithObject:@(0)];
//    }
//    
//    return _results;
//}

+(instancetype)postWordViewController
{
    static PostWordViewController * viewController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        viewController = [[PostWordViewController alloc]init];
    });
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    __weak __typeof__(self) weakSelf = self;
    self.getAlbumPhotosBlock = ^(NSMutableArray * photots,NSMutableArray * photosNum){
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
//        NSLog(@"photo is %lu",(unsigned long)photots.count);
        _results = photots;
        _resultsNum = photosNum;
        [strongSelf.photosCollectionView reloadData];
    };
    [self createNavigationBar];
    [self createUI];
    [self registerNotification];
}



-(void)dealloc
{
    [_textView removeObserver:self forKeyPath:@"text"];
    [_bgView removeObserver:self forKeyPath:@"frame"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLeeKeyBoardWillDisappear object:nil];
}

#pragma mark  -通知相关
-(void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification:) name:@"address" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification:) name:@"jurisdiction" object:nil];
}

#pragma mark  -地址通知
-(void)getNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"jurisdiction"])
    {
        int num = [notification.object intValue];
        if (num == 1)
        {
            num = 2;
        }
        else if(num == 2)
        {
            num = 1;
        }
            
        _jurisdictionBtn.jurisdiction = num;
    }
    else if ([notification.name isEqualToString:@"address"])
    {
        NSArray * arr = notification.object;
        [_addressBtn getCurrentAddress:arr[2] latitude:[arr[0] floatValue] longitude:[arr[1] floatValue]];
    }
}

#pragma mark  -创建导航UI
-(void)createNavigationBar
{
    //用户标题
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * userInfo = [defaults objectForKey:@"userInfo"];
    
    NavTitleView * titleView = [NavTitleView navTitleView];
    titleView.name.text = userInfo[@"screen_name"];
    
    self.navigationItem.titleView = titleView;

    
    //发布button
    UIButton * postBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 65,30, 50, 25)];
    _postBtn = postBtn;
    [postBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    postBtn.backgroundColor = [UIColor whiteColor];
    postBtn.layer.borderColor = [UIColor blackColor].CGColor;
    postBtn.layer.cornerRadius = 3;
    [postBtn setTitle:@"发布" forState:0];
    [postBtn addTarget:self action:@selector(postBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    postBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:postBtn];
}


-(void)createUI
{
    //滑动背景图
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 113)];
    scrollView.bounces = YES;
    scrollView.contentSize = CGSizeMake(self.view.width, self.view.height - 112);
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    //底部状态栏视图
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - customKeyBoardHeight, self.view.width, customKeyBoardHeight)];
    _bgView.backgroundColor = [UIColor colorWithRed:0.957f green:0.957f blue:0.957f alpha:1.00f];
    _bgView.layer.borderColor = [UIColor colorWithRed:0.843f green:0.843f blue:0.843f alpha:1.00f].CGColor;
    _bgView.layer.borderWidth = 1;
    [_bgView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:_bgView];
    
    __weak PostWordViewController * postVC = self;
    
    //地址按钮
    StatusBtnView * btn = [[StatusBtnView alloc] initWithFrame:CGRectMake(10, CGRectGetMinY(_bgView.frame) - 30, self.view.width *0.6, 24)];
    _addressBtn = btn;
    [btn setDetailText:@"显示位置" imageName:@"compose_locatebutton_ready" viewAlignment:viewAlignmentLeft];
    [btn setMaskBtnDidSeletcedBlock:^(NSInteger jurisdiction){
        LocationViewController * locationVC = [[LocationViewController alloc] init];
        [postVC presentViewController:locationVC animated:YES completion:^{
            
        }];
    }];
    [self.view addSubview:btn];
    
    //权限按钮
    _jurisdictionBtn = [[StatusBtnView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame), CGRectGetMinY(_bgView.frame) - 30, self.view.width - CGRectGetMaxX(btn.frame) - 10, 24)];
    [_jurisdictionBtn changeTextColor:[UIColor colorWithRed:0.392f green:0.525f blue:0.702f alpha:1.00f]];
    [_jurisdictionBtn setDetailText:@"公开" imageName:@"compose_publicbutton" viewAlignment:viewAlignmentRight];
    [_jurisdictionBtn setMaskBtnDidSeletcedBlock:^(NSInteger jurisdiction){
        ShareRangeViewController * shareRange = [[ShareRangeViewController alloc] init];
        shareRange.num = jurisdiction;
        [postVC presentViewController:shareRange animated:YES completion:^{
        }];
    }];
    [self.view addSubview:_jurisdictionBtn];
    
    //初始化
    _y = self.view.height - customKeyBoardHeight;
    NSArray * btnImages = @[@"compose_toolbar_picture",@"compose_mentionbutton_background",@"compose_trendbutton_background",@"compose_emoticonbutton_background",@"message_add_background"];
    NSArray * btnHightLightImages = @[@"compose_toolbar_picture_highlighted",@"compose_mentionbutton_background_highlighted",@"compose_trendbutton_background_highlighted",@"compose_emoticonbutton_background_highlighted",@"message_add_background_highlighted"];
    
    CGFloat btnWidth = self.view.width/5;
    for (int i = 0; i < 5; i ++)
    {
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(i * btnWidth, 0, btnWidth, customKeyBoardHeight)];
        btn.tag = 200 + i;
        [btn setImage:[UIImage imageNamed:btnImages[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:btnHightLightImages[i]] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(customKeyBoardBarButtonsDidSelected:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:btn];
        
        if (i == 3)
        {
            UIButton * hideBtn = [[UIButton alloc] initWithFrame:CGRectMake(i * btnWidth, 0, btnWidth, customKeyBoardHeight)];
            hideBtn.backgroundColor = [UIColor colorWithRed:0.957f green:0.957f blue:0.957f alpha:1.00f];
            _hideBtn = hideBtn;
            hideBtn.tag = 205;
            hideBtn.hidden = YES;
            [hideBtn setImage:[UIImage imageNamed:@"compose_keyboardbutton_background"] forState:UIControlStateNormal];
            [hideBtn setImage:[UIImage imageNamed:@"compose_keyboardbutton_background_highlighted"] forState:UIControlStateHighlighted];
            [hideBtn addTarget:self action:@selector(customKeyBoardBarButtonsDidSelected:) forControlEvents:UIControlEventTouchUpInside];
            [_bgView addSubview:hideBtn];
        }
    }
    
    //输入视图
    _textView = [[CustomTextView alloc] initWithFrame:CGRectMake(0,5, self.view.width, 120)];
    [_textView addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [scrollView addSubview:_textView];
    
    //选中图片
    //参数设置
    static CGFloat edge = 10;
    static CGFloat space = 5;
    CGFloat collectionViewWidth = scrollView.frame.size.width * 0.85;
    CGFloat itemWidth = (collectionViewWidth - space * 2 -  edge * 2)/3;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(edge, edge, edge, edge);
    flowLayout.minimumInteritemSpacing = space;
    flowLayout.minimumLineSpacing = space;
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    
    self.photosCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - collectionViewWidth)/2 , 125, collectionViewWidth, (itemWidth * 3 + edge * 2 + space * 2)) collectionViewLayout:flowLayout];
    self.photosCollectionView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:self.photosCollectionView];
    self.photosCollectionView.delegate = self;
    self.photosCollectionView.dataSource = self;
    self.photosCollectionView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    [self.photosCollectionView registerNib:[UINib nibWithNibName:@"PostWordCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"postViewController"];
}

#pragma mark   -UIButton点击事件
- (void)postBtnTouch:(UIButton *)sender
{
    

    NSString * access_token = NSUserDefaultsObjectForKey(@"access_token");
    
    NSString * str = _textView.text;
    [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:@{@"access_token":access_token,@"status":str,@"visible":@(_jurisdictionBtn.jurisdiction)}];
    
    if (_results.count > 0)
    {
        UIImage * image = [UIImage imageNamed:@"card_icon_addattention"];
        NSData * data = UIImageJPEGRepresentation(image, .5);
        
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:[dict copy] constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            [formData appendPartWithFileData:data name:@"img" fileName:@"test" mimeType:@"image/jpeg"];

        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"succ");
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"error is %@",error);
        }];
    }
    else
    {
        
        if (_addressBtn.lon!= 0 && _addressBtn.lat !=0)
        {
            [dict setObject:@(_addressBtn.lat) forKey:@"lat"];
            [dict setObject:@(_addressBtn.lon) forKey:@"long"];
        }
        
        
        ConnectDelegate * connect = [ConnectDelegate standConnectDelegate];
        [connect requestDataFromUrl:@"https://api.weibo.com/2/statuses/update.json" parameters:[dict copy] andParseDataBlock:^(id obj) {
            if (obj)
            {
                [self createPromptViewWithImageName:@"health_infoPop_icon_check" title:@"已 发 送"];
            }
            else
            {
                [self createPromptViewWithImageName:@"health_infoPop_icon_close" title:@"发 送 失 败"];
            }
        }];
    }
}

-(void)customKeyBoardBarButtonsDidSelected:(UIButton *)btn
{
    switch (btn.tag)
    {
        case 200:
        {
            PhotoViewController * photoViewController = [[PhotoViewController alloc] init];
            [self.navigationController pushViewController:photoViewController animated:YES];
         }
            break;
        case 201:
        {
            
        }
            break;
        case 202:
        {
            
        }
            break;
        case 203:
        {
            _y = self.view.height - customKeyBoardHeight - leeKeyBoardHeight;
            
            //隐藏系统键盘
            [_textView resignFirstResponder];
            //弹出自定义表情键盘
            [[NSNotificationCenter defaultCenter] postNotificationName:kLeeKeyBorardWillAppear object:_textView userInfo:nil];
            [UIView animateWithDuration:leeKeyBoardAnimationDuration animations:^{
                CGRect rect = _bgView.frame;
                rect.origin.y = self.view.height - customKeyBoardHeight - leeKeyBoardHeight;
                _bgView.frame = rect;
            }];
            
            _hideBtn.hidden = NO;
        }
            break;
        case 204:
        {
            
        }
            break;
        case 205:
        {
            //隐藏自定义表情键盘
            [[NSNotificationCenter defaultCenter] postNotificationName:kLeeKeyBoardWillDisappear object:_textView userInfo:nil];
            //修改状态栏下滑目标位置
            _y = self.view.height - customKeyBoardHeight - leeKeyBoardHeight;
            //出现系统键盘
            [_textView becomeFirstResponder];
        }
            break;
        default:
            break;
    }
}

#pragma mark  -观察者模式
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"text"])
    {
        if (_textView.text.length == 0)
        {
            _textView.label.hidden = NO;
            _postBtn.backgroundColor = [UIColor whiteColor];
            [_postBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        else
        {
            _textView.label.hidden = YES;
            _postBtn.backgroundColor = [UIColor orangeColor];
            [_postBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    else if ([keyPath isEqualToString:@"frame"])
    {
        _addressBtn.frame = CGRectMake(10, CGRectGetMinY(_bgView.frame) - 30, self.view.width *0.6, 24);
        _jurisdictionBtn.frame = CGRectMake(CGRectGetMaxX(_addressBtn.frame), CGRectGetMinY(_bgView.frame) - 30, self.view.width - CGRectGetMaxX(_addressBtn.frame) - 10, 24);
    }
}

-(void)keyBoardWillAppear:(NSNotification *)notification
{
    //1.获取动画
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //2.获取键盘弹出后的坐标
    CGRect frameForKeyboardEnd = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration animations:^{
        CGRect rect = _bgView.frame;
        rect.origin.y = self.view.height - rect.size.height - frameForKeyboardEnd.size.height;
        _bgView.frame = rect;
    } completion:^(BOOL finished) {
        
    }];
    
    //隐藏键盘按钮
    _hideBtn.hidden = YES;
}

-(void)keyBoardWillDisappear:(NSNotification *)notification
{
    //1.获取动画
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        CGRect rect = _bgView.frame;
        rect.origin.y = _y;
        _bgView.frame = rect;
    } completion:^(BOOL finished) {
        _y = self.view.height - customKeyBoardHeight;
    }];
}

#pragma mark  -监听滑动视图  收回键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLeeKeyBoardWillDisappear object:nil];
    [_textView resignFirstResponder];
    
    [UIView animateWithDuration:leeKeyBoardAnimationDuration animations:^{
        CGRect rect = _bgView.frame;
        rect.origin.y = self.view.height - customKeyBoardHeight;
        _bgView.frame = rect;
    }];
}

#pragma mark  -创建提示视图
-(void)createPromptViewWithImageName:(NSString *)imageName title:(NSString *)title
{
    //收回键盘！
    [_textView resignFirstResponder];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 120)];
    view.layer.position = self.view.center;
    view.backgroundColor = [UIColor colorWithRed:0.648f green:0.648f blue:0.648f alpha:1.00f];
    view.layer.cornerRadius = 5;
    [self.view addSubview:view];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30, 40, 40)];
    imageView.image = [UIImage imageNamed:imageName];
    [view addSubview:imageView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 100, 40)];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    [UIView animateWithDuration:1.5 animations:^{
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
}

#pragma mark     UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_results.count > 0)
    {
        collectionView.hidden = NO;
        return _results.count == 9?9:_results.count + 1;
    }
    
    collectionView.hidden = YES;
    return 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PostWordCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"postViewController" forIndexPath:indexPath];
   
    cell.indexPath = indexPath;
    
    if (!cell.removeBtnDidSelectedBlock)
    {
        cell.removeBtnDidSelectedBlock = ^(NSIndexPath * indexPath){
            
//            NSLog(@"indexPath is %@",indexPath);
            /*
             这里有一个需要注意的地方
             我们无论是delete insert 还是其他的一些update的操作 都需要先操作数据源
             查看函数栈可以发现  在update的相关函数里会有一些刷新操作  你的collectionView的数据源没有修改导致和item的不匹配可能导致update的失败  出现数组越界或者插入到空collectionView当中
             
             但是这里又有一个特殊的坑点
             我们这个collectionView它如果不是九张图片 会多一个拍照的cell  本来应该在数据源为空的时候一同消失  但恰恰是这多出的一个cell  让本来数据源和cell一一对应的情况被打破  删除最后一张图片的时候按理应该update以后还有一个cell 的  但是在- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section方法里我们已经将cell置空了  这个时候delete就会出现越界的情况
             
             
             我的解决办法是在数据源为空的时候return 1   但是我让collectionView.hidden = YES  达到相同效果
             **/
            
            [_results removeObjectAtIndex:_results.count == 9?indexPath.item:indexPath.item - 1];
            [_resultsNum removeObjectAtIndex:_results.count == 9?indexPath.item:indexPath.item - 1];
            [self.photosCollectionView deleteItemsAtIndexPaths:@[indexPath]];
            
           //reloadData不走   这个吃屎的bug被我碰到了
            [self.photosCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        };
    }
    
    if (!cell.imageBtnDidSelectedBlock)
    {
        cell.imageBtnDidSelectedBlock = ^(NSIndexPath * indexPath){
            if (indexPath.item == 0 && _results.count < 9)
            {
                PhotoViewController * photoViewController = [[PhotoViewController alloc] init];
                photoViewController.photos = _resultsNum;
                [self.navigationController pushViewController:photoViewController animated:YES];
            }
            else
            {
                
            }
        };
    }
    
    if (_results)
    {
        if (indexPath.item == 0)
        {
            _results.count == 9?[cell configWith:_results[indexPath.row]]:[cell addPhotoBtn];
        }
        else
        {
            [cell configWith:_results.count == 9?_results[indexPath.row]:_results[indexPath.row - 1]];
        }
    
    }
    
    return cell;
}
@end
