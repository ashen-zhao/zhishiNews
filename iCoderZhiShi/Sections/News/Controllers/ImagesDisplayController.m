//
//  ImagesDisplayController.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/6.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "ImagesDisplayController.h"
#import "CommonMacros.h"
#import "NetworkHelpers.h"
#import "ImagesDisplayModel.h"
#import "ImagesDisplayView.h"
#import "UIImageView+WebCache.h"
#import "CommentController.h"
#import "FavoriteModel.h"
#import "MBProgressHUD.h"
#import "DBHelper.h"
#import "AppDelegate.h"
#import  <ShareSDK/ShareSDK.h>
#import "IndexScrollView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#define kURL_ImagesSet @"http://c.3g.163.com/photo/api/set/%@/%@.json"

@interface ImagesDisplayController ()<UIScrollViewDelegate, UIAlertViewDelegate> {
    NSInteger _pindex;
}
@property (nonatomic, retain) ImagesDisplayView *imagesDisplayView;
@property (nonatomic, retain) NSMutableArray *photosData;
@property (nonatomic, copy) NSString *docid;
@property (nonatomic, copy) NSString *imageTitle;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, retain) UIScrollView *changescrollView; //记录上一次的scrollView
@property (nonatomic, retain) NSMutableSet *recycledPages;
@property (nonatomic, retain) NSMutableSet *visiblePages;
@end

@implementation ImagesDisplayController
- (NSMutableSet *)recycledPages {
    if (!_recycledPages) {
        self.recycledPages = [NSMutableSet set];
    }
    return _recycledPages;
}
- (NSMutableSet *)visiblePages {
    if (!_visiblePages) {
        self.visiblePages = [NSMutableSet set];
    }
    return _visiblePages;
}
- (NSMutableArray *)photosData {
    if (!_photosData) {
        self.photosData = [NSMutableArray array];
    }
    return [[_photosData retain] autorelease];
}
- (void)dealloc {
    [_recycledPages release];
    [_visiblePages release];
    [_url release];
    [_imageTitle release];
    [_changescrollView release];
    [_docid release];
    [_skipID release];
    [_skipTypeID release];
    [_photosData release];
    [_imagesDisplayView release];
    [super dealloc];
}

- (void)loadView {
    self.imagesDisplayView = [[[ImagesDisplayView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    self.view = _imagesDisplayView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    DDMenuController *menuC  = delegate.menuController;
    [menuC setEnableGesture:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.fd_prefersNavigationBarHidden = YES;
    //读取数据
    [self readDataByURL];
    [_imagesDisplayView.btnBack addTarget:self action:@selector(handleBack:) forControlEvents:UIControlEventTouchUpInside];
    [_imagesDisplayView.btnComment addTarget:self action:@selector(handleComment:) forControlEvents:UIControlEventTouchUpInside];
    [_imagesDisplayView.btnSave addTarget:self action:@selector(handleSave:) forControlEvents:UIControlEventTouchUpInside];
    [_imagesDisplayView.btnShare addTarget:self action:@selector(handleShare:) forControlEvents:UIControlEventTouchUpInside];
    //添加手势
    [self addGestureRecognizer];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //    if([self isViewLoaded] && !self.view.window) {
    //        //安全移除掉根视图
    //        self.view = nil;
    //    }
}

#pragma mark - UIScrollViewDelegate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice]userInterfaceIdiom] ==UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation !=UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

//返回缩放的视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return  [[scrollView subviews] firstObject];
}
//结束缩放时让imageView 居中
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    ((UIImageView *)[[scrollView subviews] firstObject]).center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark - UIAlertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //NSInteger index = _imagesDisplayView.imagesScrollView.contentOffset.x / kScreenWidth;
        if (_imagesDisplayView.imagesScrollView.subviews.count) {
            UIScrollView *tempScroll = [_imagesDisplayView.imagesScrollView subviews][0];
            UIImageView *imageV = [[tempScroll subviews] firstObject];
            UIImageWriteToSavedPhotosAlbum(imageV.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有可保存的图片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
    
}
//判断图片保存状态
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"保存成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

#pragma mark - UIScrollView重用机制
- (void)tilePages
{
    CGRect visibleBounds = _imagesDisplayView.imagesScrollView.bounds;
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex = MIN(lastNeededPageIndex, (int)[self.photosData count] - 1);
    if (self.visiblePages) {
        
        for (IndexScrollView *page in self.visiblePages) {
            //不显⽰的判断条件
            if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
                //将没有显示的ImageView保存在recycledPages里
                [self.recycledPages addObject:page];
                //将未显示的ImageView移除
                [page removeFromSuperview];
            }
        }
    }
    //集合-指定集合(即:所有不在既定集合中的元素)
    [self.visiblePages minusSet:self.recycledPages];
    
    while (self.recycledPages.count > 2) {
        [self.recycledPages removeObject:[self.recycledPages anyObject]];
    }
    // add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) { //当index对应的ImageView没有显示时,使用重用来定义ImageView
            IndexScrollView *page = [self dequeueRecycledPage]; //当page = = nil
            if (!page) {
                page = [[[IndexScrollView alloc] init] autorelease];
                page.bounces = YES;
                page.delegate = self;
                page.zoomScale = 1.0;
                page.minimumZoomScale = 1.0;
                page.maximumZoomScale = 2.0;
                page.showsVerticalScrollIndicator = NO;
                page.directionalLockEnabled = YES;
            }
            //设置index对应的ImageView图片和位置
            [self configurePage:page forIndex:index];
            //将page加入到visiblePages集合里
            [self.visiblePages addObject:page];
            [_imagesDisplayView.imagesScrollView addSubview:page];
        }
    }
}
- (IndexScrollView *)dequeueRecycledPage {
    //查看是否有重用对象
    IndexScrollView *page = [self.recycledPages anyObject];
    if (page) {
        [[page retain] autorelease];
        //返回重用对象,并从重用集合中删除
        [self.recycledPages removeObject:page];
    }
    return page;
}
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index {
    BOOL foundPage = NO;
    for (IndexScrollView *page in self.visiblePages) {
        if (page.index == index) { //如果index所对应的ImageView在可见数组中,将标志位标记为YES,否则返 回NO
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}
- (void)configurePage:(IndexScrollView *)page forIndex:(NSUInteger)index {
    page.index = index; //这句要写，不然第一张会消失
    page.frame = CGRectMake(kScreenWidth * index, -20, kScreenWidth, kScreenHeight);
    page.imageV.contentMode = UIViewContentModeScaleAspectFit;//自适应图片大小
    page.imageV.frame = self.view.bounds;
    [page.imageV sd_setImageWithURL: self.photosData[index][@"imgurl"] placeholderImage:[UIImage imageNamed:@"blackDefault"]];
    
}
//最后设置一下 scrollView 的代理方法:
//视图滑动时

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self tilePages];
    //    if(_imagesDisplayView.imagesScrollView.contentOffset.x >=  kScreenWidth *([self.photosData count] - 1)) {
    //            [_imagesDisplayView.imagesScrollView  scrollRectToVisible:CGRectMake(0, 0, kScreenWidth, kScreenHeight) animated:NO];
    //    }
}
//当滚动视图停⽌止
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView {
    NSInteger index = self.imagesDisplayView.imagesScrollView.contentOffset.x / kScreenWidth;
    _imagesDisplayView.note.text = [NSString stringWithFormat:@"       %@",self.photosData[index][@"note"]];
    _imagesDisplayView.lblPage.text = [NSString stringWithFormat:@"%ld/%ld", (long)(index + 1), (unsigned long)self.photosData.count];
    //切换图片后，将变化的图片，变回原来的大小
    if (_pindex != index) {
        self.changescrollView.zoomScale = 1.0;
    }
    self.changescrollView = [_imagesDisplayView.imagesScrollView subviews][0];
    _pindex = index;
}

#pragma mark -  数据类method
- (void)readDataByURL {
    self.skipTypeID = self.skipTypeID == nil ? @"0096" : [self.skipTypeID substringFromIndex:4];
    
    [NetworkHelpers JSONDataWithUrl:[NSString stringWithFormat:kURL_ImagesSet, self.skipTypeID, self.skipID] success:^(id data) {
        NSDictionary *dataDict = [NSDictionary dictionaryWithDictionary:data];
        ImagesDisplayModel *model = [[ImagesDisplayModel alloc] init];
        [model setValuesForKeysWithDictionary:dataDict];
        self.imagesDisplayView.model = model;
        self.docid = model.postid;
        self.imageTitle = model.setname;
        self.url = model.url;
        [self configureImageScrollView:model.photos];
        [model release];

    } fail:^{
        
    }];
}
#pragma mark - 视图布局
- (void)configureImageScrollView:(NSMutableArray *)photos {
    self.photosData = photos;
    _imagesDisplayView.imagesScrollView.contentSize = CGSizeMake(photos.count * kScreenWidth, 0);
    _imagesDisplayView.imagesScrollView.delegate = self;
    _imagesDisplayView.imagesScrollView.pagingEnabled = YES;
    [self tilePages];
}
#pragma mark - 为滚动视图添加手势
- (void)addGestureRecognizer {
    //单击手势，隐藏/显示内容
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_imagesDisplayView.imagesScrollView addGestureRecognizer:tap];
    [tap release];
    //双击手势，进入图片缩放界面
    UITapGestureRecognizer *twoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoTap:)];
    twoTap.numberOfTapsRequired = 2;
    [_imagesDisplayView.imagesScrollView addGestureRecognizer:twoTap];
    [twoTap release];
    //解决单击双击手势并存问题
    [tap requireGestureRecognizerToFail:twoTap];
    
    //长按手势 ，用户保存图片到相册
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlePress:)];
    [_imagesDisplayView.imagesScrollView addGestureRecognizer:press];
    [press  release];
    
}
#pragma mark - action
//pop
- (void)handleBack:(UIButton *)sender {
    self.tabBarController.tabBar.hidden = NO; //将tabBar显示出来
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20], NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController popViewControllerAnimated:YES];
}
//push到评论
- (void)handleComment:(UIButton *)sender {
    CommentController *commentController = [[CommentController alloc] init];
    commentController.docid = self.docid; //传唯一标识
    commentController.flag = @"photoview_bbs"; //标识是图片集, 跳转评论标识
    
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:commentController animated:YES];
    [self setHidesBottomBarWhenPushed:YES];
    [commentController release];
}
//收藏
- (void)handleSave:(UIButton *)sender {
    FavoriteModel *fmodel = [[FavoriteModel alloc] init];
    fmodel.ftitle = self.imageTitle;
    fmodel.furl = [NSString stringWithFormat:kURL_ImagesSet,self.skipTypeID, self.skipID];
    fmodel.fdocid = self.skipID;
    fmodel.fboardid = @"photoview_bbs";
    fmodel.flag = @"IMAGES";
    MBProgressHUD *hud= [[MBProgressHUD alloc] init];
    [self.view addSubview:hud];
    if ([DBHelper insertData:fmodel]) {
        //加载条上显示文本
        hud.labelText = @"收藏成功";
    } else {
        hud.labelText = [fmodel.ftitle isEqualToString:@""] || !fmodel.ftitle ? @"加载完成才能收藏哦？" : @"已经收藏";
    }
    //置当前的view为灰度
    hud.dimBackground = YES;
    //设置对话框样式
    hud.mode = MBProgressHUDModeText;
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [hud removeFromSuperview];
    }];
    [hud release];
    [fmodel release];
    
    
}
//分享
- (void)handleShare:(UIButton *)sender {
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content: self.imageTitle
                                       defaultContent:@"有事没事，点一下"
                                                image:nil
                                                title:@"pmmq"
                                                  url:self.url
                                          description:@"知事在线，有事没事，逛一下"
                                            mediaType:SSPublishContentMediaTypeNews];
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                MBProgressHUD *hud= [[MBProgressHUD alloc] init];
                                [self.view addSubview:hud];
                                if (state == SSResponseStateSuccess)
                                {
                                    hud.labelText = @"分享成功";
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    hud.labelText = @"分享失败";
                                }
                                hud.mode = MBProgressHUDModeText;
                                [hud showAnimated:YES whileExecutingBlock:^{
                                    sleep(1);
                                } completionBlock:^{
                                    [hud removeFromSuperview];
                                }];
                                [hud release];
                            }];
}


//手势处理action
- (void)handleTap:(UIGestureRecognizer *)tap {
    if (_imagesDisplayView.layerView.frame.origin.y < 0) {
        [UIView animateWithDuration:0.5 animations:^{
            [[UIApplication sharedApplication]  setStatusBarHidden:NO];
            _imagesDisplayView.toolBar.frame = CGRectMake(0, self.view.frame.size.height - 40, kScreenWidth, 40);
            _imagesDisplayView.layerView.frame = CGRectMake(0, 0, kScreenWidth, 100);
            _imagesDisplayView.layerViewNote.frame = CGRectMake(0, self.view.frame.size.height - 170, kScreenWidth, 170);
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            [[UIApplication sharedApplication]  setStatusBarHidden:YES];
            _imagesDisplayView.toolBar.frame = CGRectMake(0, self.view.frame.size.height + 40, kScreenWidth, 40);
            _imagesDisplayView.layerView.frame = CGRectMake(10, - 100 , kScreenWidth, 100);
            _imagesDisplayView.layerViewNote.frame = CGRectMake(0, self.view.frame.size.height + 170, kScreenWidth, 170);
        }];
    }
}
//双击缩放
- (void)handleTwoTap:(UITapGestureRecognizer *)pinch {
    self.modalTransitionStyle =  UIModalTransitionStyleFlipHorizontal;
    _pindex = _imagesDisplayView.imagesScrollView.contentOffset.x / kScreenWidth;
    if (_imagesDisplayView.imagesScrollView.subviews.count) {
        self.changescrollView = [_imagesDisplayView.imagesScrollView subviews][0];
        [UIView animateWithDuration:0.5 animations:^{
            self.changescrollView .zoomScale =  self.changescrollView.zoomScale == 1.0 ? 2.0 : 1.0;
        }];
    }
}
- (void)handlePress:(UIGestureRecognizer *)press {
    //保存imageView上展示的图片到相册
    if (press.state == UIGestureRecognizerStateBegan) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您确定要保存吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        [alert release];
    }
}

@end
