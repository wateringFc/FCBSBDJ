//
//  FCShowPictureViewController.m
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/15.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FCShowPictureViewController.h"
#import "FCTopicModel.h"
#import "FCProgressView.h"
@interface FCShowPictureViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet FCProgressView *progressView;
@end

@implementation FCShowPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // 已知：屏幕的宽度、图片的宽度、图片高度
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    // 算出图片显示高度
    CGFloat pictureW = screenW;
    CGFloat pictureH = screenW * self.topic.height / self.topic.width;
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back)]];
    [self.scrollView addSubview:imageView];
    self.imageView = imageView;
    
    
    if (pictureH > screenH) {
        // 需要滚动查看
        imageView.frame = CGRectMake(0, 0, pictureW, pictureH);
        self.scrollView.contentSize = CGSizeMake(0, pictureH);
    }else{
        
        imageView.xmg_size = CGSizeMake(pictureW, pictureH);
        imageView.xmg_centerY = screenH *0.5;
    }
    
    // 马上显示当前图片的下载进度（防止网速慢，显示其它图片下载进度）
    [self.progressView setProgress:self.topic.pictureProgress animated:YES];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [self.progressView setProgress:1.0 * receivedSize / expectedSize animated:YES];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
    }];
    
    
}

// 点击图片返回
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)buttonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 10:
        {// 返回
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case 20:
        {// 转发
            
        }
            break;
        case 30:
        {// 保存到手机图片相册
            
            if (self.imageView.image == nil) {
                [SVProgressHUD showErrorWithStatus:@"图片暂未下载完毕"];
            }else{
                UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            }
        }
            break;
            
        default:
            break;
    }
}

// 保存图片点击事件
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    if (error) {
        [SVProgressHUD showSuccessWithStatus:@"保存失败"];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
