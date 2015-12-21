//
//  UserGuideViewController.m
//  UserGuide
//
//  Created by dahe on 14/11/26.
//  Copyright (c) 2014年 yahui. All rights reserved.
//

#import "UserGuideViewController.h"
#import "RootController.h"
#define Imagecount 4
#define kMargin_pageControl_x 110
#define kMargin_pageControl_y 520
#define kWidth_pageControl 100
#define kHeigth_pageControl 30

@interface UserGuideViewController ()<UIScrollViewDelegate>

@end

@implementation UserGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubview];//布局子视图
    
}
- (void)setUpSubview {
    [self setupScroller];//布局滚动视图
    [self setuppageCrotrol];//布局滚动页面(圆点)
}
- (void)setupScroller {
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    scroller.contentSize = CGSizeMake(scroller.frame.size.width * 4, scroller.frame.size.height);
    scroller.pagingEnabled = YES;//设置滚动条开始是否滚到子视图边缘
    scroller.showsHorizontalScrollIndicator = NO;//水平滑动条
    scroller.showsVerticalScrollIndicator = NO;//竖直方向滚动条
    scroller.bounces = NO;//关闭反弹效果
    scroller.directionalLockEnabled = YES;//单向滑动
    scroller.delegate = self;//代理
    [self.view addSubview:scroller];
    [scroller release];
    
    for (int i = 0; i < Imagecount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(scroller.frame.size.width *i, 0, scroller.frame.size.width, scroller.frame.size.height)];
       imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"information0%d@2x", i + 1] ofType:@"png"]];
        [scroller addSubview:imageView];
        [imageView release];
        if (Imagecount -1 == i) {
            
            imageView.userInteractionEnabled = YES;//用户交互打开
            [self addTapGestureForView:imageView];//自身添加手势触发事件
        }
    }
}
//视图添加轻怕手势
- (void)addTapGestureForView:(UIView *)sender {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletap:)];
    [sender addGestureRecognizer:tap];
    [tap release];
}
- (void)handletap:(UIGestureRecognizer *)naviGation {
    //将元素写入表中
    NSUserDefaults *userDfautle = [NSUserDefaults  standardUserDefaults];
    [userDfautle setBool:YES forKey:kFirstLunchKey];
    [userDfautle synchronize];//立即同步
    //当用户点击最后一个ImageViewer 进入到应有程序的主页面,切换应有程序window的根视图
    RootController *rootvc = [[RootController alloc]init];
    //更换window是根视图控制器
//    RootController *mVC = [[RootController alloc]initWithRootViewController:rootvc];
   
    [[UIApplication sharedApplication].keyWindow setRootViewController:rootvc];
}

- (void)setuppageCrotrol{
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(kMargin_pageControl_x, kMargin_pageControl_y, kWidth_pageControl, kHeigth_pageControl)];
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    pageControl.pageIndicatorTintColor = [UIColor magentaColor];
    pageControl.numberOfPages = 4;
    pageControl.tag = 101;
    [pageControl addTarget:self action:@selector(handlePageControl:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    [pageControl release];
    
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    UIPageControl *pageControl = (UIPageControl *)[self.view viewWithTag:101];
    pageControl.currentPage = scrollView.contentOffset.x / 320;
}
#pragma mark - handle action
- (void)handlePageControl:(UIPageControl *)pageControl {
    UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:100];
    scrollView.contentOffset = CGPointMake(pageControl.currentPage * 320, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && !self.view.window) {
        self.view = nil;
    }

    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
