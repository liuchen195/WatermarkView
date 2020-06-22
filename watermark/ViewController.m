//
//  ViewController.m
//  watermark
//
//  Created by 刘琛 on 2020/6/22.
//  Copyright © 2020 lc. All rights reserved.
//

#import "ViewController.h"
#import "watermark/WatermarkView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    WatermarkView *water = [WatermarkView defaultWatermarkView];
    water.showStr = @"我是水印第一行\n我是水印第二行\n我是第三行\n我是第四行";
    [self.view addSubview:water];
    
}

- (IBAction)showWaterMark:(id)sender {
    
    [[WatermarkView defaultWatermarkView] show];
    
}



- (IBAction)hiddenWatermark:(id)sender {
    
    [[WatermarkView defaultWatermarkView] hidden];
}

@end
