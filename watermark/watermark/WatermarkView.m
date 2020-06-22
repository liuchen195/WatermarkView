//
//  WatermarkView.m
//  iSee
//
//  Created by 刘琛 on 2020/6/19.
//  Copyright © 2020 刘琛. All rights reserved.
//

#import "WatermarkView.h"


/***  屏幕宽 */
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width

/***  屏幕高度 */
#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height


@interface WatermarkView()

@end



@implementation WatermarkView

#pragma mark 单例
+ (instancetype)defaultWatermarkView {
    static WatermarkView *view = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view = [[WatermarkView alloc] init];
        view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        view.backgroundColor = [UIColor clearColor];
        view.windowLevel = UIWindowLevelNormal;
        view.userInteractionEnabled = NO;

    });
    return view; 
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)setShowStr:(NSString *)showStr {
    _showStr = showStr;
    
    self.backgroundColor = [UIColor colorWithPatternImage:[self getLabelsView]];
}

- (void)show {
    self.hidden = NO;
}

- (void)hidden {
    self.hidden = YES;
}

#pragma mark 生成图片


- (UIImage *)getLabelsView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    view.backgroundColor = [UIColor clearColor];
    
    //高度计算（基于安全域高度进行计算）
    UIViewController *currentVC = [self getCurrentVC];
    CGFloat rowHeiht;
    if (@available(iOS 13.0, *)) {
        UIWindow *currentWindow = [UIApplication sharedApplication].windows.lastObject;
        rowHeiht = (kScreenHeight - currentVC.navigationController.navigationBar.bounds.size.height - currentWindow.windowScene.statusBarManager.statusBarFrame.size.height - currentVC.tabBarController.tabBar.bounds.size.height) / 3;
    }else {
        
        rowHeiht = (kScreenHeight - currentVC.navigationController.navigationBar.bounds.size.height - [[UIApplication sharedApplication] statusBarFrame].size.height - currentVC.tabBarController.tabBar.bounds.size.height) / 3;
    }

    
    CGFloat middleX = [UIScreen mainScreen].bounds.size.width / 2;
    
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 2; j++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake( j * middleX, i * rowHeiht, middleX, rowHeiht)];
            //水印旋转角度
            label.transform = CGAffineTransformMakeRotation(- M_PI/6);
            label.alpha = 0.08;
            label.numberOfLines = 0;
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = self.showStr;
            [view addSubview:label];
        }
    }
    
    return [self makeImageWithView:view];
}

- (UIImage *)makeImageWithView:(UIView *)view{
    CGSize s = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark 获取单一window 最上层VC
- (UIViewController *)getCurrentVC {
    
    UIViewController *result = nil;
    
    
    UIWindow * window;
    if (@available(iOS 13.0, *)) {
        window = [[UIApplication sharedApplication] keyWindow];
    }else {
        window = [UIApplication sharedApplication].windows.lastObject;
    }
    
    //获取最上层window是否为视图，不是alert，不是StatusBar
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        
        for (UIWindow *tempWin in windows) {
            if (tempWin.windowLevel == UIWindowLevelNormal) {
                window = tempWin;
                break;
            }
        }
    }

    //判断window的根视图是UITabBarController
    //这里判断的是tabbar-nav-ctrl的布局方式
    if ([window.rootViewController isKindOfClass:[UITabBarController class]]) {
            
        UITabBarController *tempTabbar = (UITabBarController *)window.rootViewController;
            
        //判断tabbar的选中视图是否是Nav
        if ([tempTabbar.selectedViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *nav = (UINavigationController *) tempTabbar.selectedViewController;
            result = nav.topViewController;
        }else {
            
            result = tempTabbar.selectedViewController;
                
        }
            
    //判断window的根视图是否是导航视图
    }else if([window.rootViewController isKindOfClass:[UINavigationController class]]) {
            
        UINavigationController *nav = (UINavigationController *) window.rootViewController;
        //这里判断的是nav-tabbar-ctrl的布局方式
        if ([nav.topViewController isKindOfClass:[UITabBarController class]]) {
                
            UITabBarController *tempTabbar = (UITabBarController *)nav.topViewController;
            result = tempTabbar.selectedViewController;
                
        }else {
                
            result = nav.topViewController;
        }
            
    }else {
            
            result = window.rootViewController;
            
    }
    
    return result;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
