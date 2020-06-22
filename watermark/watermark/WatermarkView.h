//  水印的window
//  WatermarkView.h
//  iSee
//
//  Created by 刘琛 on 2020/6/19.
//  Copyright © 2020 刘琛. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WatermarkView : UIWindow

@property (nonatomic, strong) NSString *showStr;

//显示
- (void)show;

//隐藏
- (void)hidden;

//单例初始化
+ (instancetype)defaultWatermarkView;

@end

NS_ASSUME_NONNULL_END
