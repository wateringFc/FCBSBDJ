//
//  XMGEssenceViewController.m
//  备课-百思不得姐
//
//  Created by MJ Lee on 15/6/15.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "XMGEssenceViewController.h"
#import "XMGTagsViewController.h"
#import "FCParentClassViewController.h"
@interface XMGEssenceViewController ()<UIScrollViewDelegate>
/**红色指示器*/
@property (weak, nonatomic) UIView *iundicatyorView;

/**当前选中按钮*/
@property (weak, nonatomic) UIButton *selectedButton;

/**顶部的标签*/
@property (weak, nonatomic) UIView *titlesView;

/**底部ScrollView*/
@property (weak, nonatomic) UIScrollView *contenView;

@end

@implementation XMGEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置导航栏
    [self setUpNav];

    // 初始化子控制器
    [self setUpChinldVces];
    
    // 设置顶部的标签栏
    [self setUptitlesView];
    
    // 底部的scrollView
    [self setUpContenView];
}

#pragma mark- 设置顶部的标签栏
- (void)setUptitlesView
{
    // 标签的背景
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    titlesView.frame = CGRectMake(0, FCTitlesViewY, self.view.xmg_width, FCTitlesViewHeighe);
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 内部的子控件
//    NSArray *titlesArr = @[@"全部", @"视频", @"声音", @"图片", @"段子"];
    CGFloat width = titlesView.xmg_width / self.childViewControllers.count;
    CGFloat height = titlesView.xmg_height;
    
    for (int i = 0; i < self.childViewControllers.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        CGFloat but_x = i * width;
        button.frame = CGRectMake(but_x, 0, width, height);
        UIViewController *vc = self.childViewControllers[i];
        [button setTitle:vc.title forState:UIControlStateNormal];
//        [button layoutIfNeeded];// 设置完文字之后马上更新子控件frame布局（强制布局）
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];// 不能被点的时候
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(titlesClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:button];
        
        // 默认选中第一个按钮
        if (i == 0) {
            button.enabled = NO;
            self.selectedButton = button;
            // 让button内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
            self.iundicatyorView.xmg_width = button.titleLabel.xmg_width;
            self.iundicatyorView.xmg_centerX = button.xmg_centerX;
        }
    }
    
    // 底部红色指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor redColor];
    indicatorView.xmg_height = 2;
    indicatorView.tag = -1; // 区分按钮tag
    indicatorView.xmg_y = titlesView.xmg_height - indicatorView.xmg_height;
    // 保证按钮在前面，
    [titlesView addSubview:indicatorView];
    self.iundicatyorView = indicatorView;
}

#pragma mark- 标签指示器点击事件
- (void)titlesClick:(UIButton *)button
{
    // 修改标签状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton= button;
    
    // 指示器跟随动画
    [UIView animateWithDuration:0.25 animations:^{
        // 指示器宽度等于 button文字宽度
        self.iundicatyorView.xmg_width = self.selectedButton.titleLabel.xmg_width;
        self.iundicatyorView.xmg_centerX = self.selectedButton.xmg_centerX;
    }];
    
    // 滚动 子控制器
    CGPoint offset = self.contenView.contentOffset;
    offset.x = button.tag * self.contenView.xmg_width;
    [self.contenView setContentOffset:offset animated:YES];
}

#pragma mark- 底部的scrollView
- (void)setUpContenView
{
//    // 不要自动调整insets（也就不会自动添加64高度）
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    UIScrollView *contenView = [[UIScrollView alloc] init];
//    contenView.frame = self.view.bounds;// 设置成全屏，做内容穿透其它子控件的效果
//    // 设置内边距⭐️ （获取 self.titlesView.frame 的底部Y值 作为ScrollView顶部内边距，获取tabBar的高度作为底部内边距）
//    CGFloat top = CGRectGetMaxY(self.titlesView.frame);
//    CGFloat bottom = self.tabBarController.tabBar.xmg_height;
//    // 穿透效果，让添加在ScrollView的控件显示在有效范围内
//    contenView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
//    // 把控件放在控制器最低层
//    [self.view insertSubview:contenView atIndex:0];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *contenView = [[UIScrollView alloc] init];
    contenView.backgroundColor = [UIColor lightGrayColor];
    contenView.frame = self.view.bounds;
    contenView.delegate = self;
    contenView.pagingEnabled = YES;
    contenView.contentSize = CGSizeMake(contenView.xmg_width * self.childViewControllers.count, 0);
    [self.view insertSubview:contenView atIndex:0];
    self.contenView = contenView;
    
    // (默认)添加第一个控制器
    [self scrollViewDidEndScrollingAnimation:contenView];
}


#pragma mark- scrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 添加子控制器的view
    // 获取当前索引
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 取出子控制器(设置)
    UIViewController *vc = self.childViewControllers[index];
    vc.view.xmg_x = scrollView.contentOffset.x;
    vc.view.xmg_y = 0; // 设置默认值20为0，解决间隙问题
    vc.view.xmg_height = scrollView.xmg_height;
    
    [scrollView addSubview:vc.view];
    
}
// 滑动减速完毕后调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    // 滑动tableview的时候上面指示器跟随移动（调用button点击事件方法）
    NSInteger index = scrollView.contentOffset.x / scrollView.xmg_width;
    [self titlesClick:self.titlesView.subviews[index]];
    
    // viewWithTag 会寻找自己的 tag，把self.titlesView 也当做button使用，就会崩掉
//    [self titlesClick:[self.titlesView viewWithTag:index]];
}



#pragma mark- 初始化子控制器
- (void)setUpChinldVces
{
    
    FCParentClassViewController *all = [[FCParentClassViewController alloc] init];
    all.title = @"全部";
    all.type = FCTopicTypeAll;
    [self addChildViewController:all];
    
    FCParentClassViewController *video = [[FCParentClassViewController alloc] init];
    video.title = @"视频";
    video.type = FCTopicTypeVideo;
    [self addChildViewController:video];
    
    FCParentClassViewController *voice = [[FCParentClassViewController alloc] init];
    voice.title = @"声音";
    voice.type = FCTopicTypeVoice;
    [self addChildViewController:voice];
    
    FCParentClassViewController *picture = [[FCParentClassViewController alloc] init];
    picture.title = @"图片";
    picture.type = FCTopicTypePicture;
    [self addChildViewController:picture];
    
    FCParentClassViewController *word = [[FCParentClassViewController alloc] init];
    word.title = @"段子";
    word.type = FCTopicTypeWord;
    [self addChildViewController:word];
    
}

#pragma mark- 页面初始设置
- (void)setUpNav
{
    self.view.backgroundColor = XMGColor(231, 231, 231);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagSub)];
}
//  左上tabBarItme点击事件
- (void)tagSub
{
    XMGTagsViewController *tags = [[XMGTagsViewController alloc] init];
    [self.navigationController pushViewController:tags animated:YES];
}










@end
