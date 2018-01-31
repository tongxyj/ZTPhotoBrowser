//
//  ViewController.m
//  ZTPhotoBrowser-Objc
//
//  Created by zhaitong on 2018/1/29.
//  Copyright © 2018年 zhaitong. All rights reserved.
//

#import "ViewController.h"
#import "ZTPhotoBrowserViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didPressedTypeOne:(id)sender {
    ZTPhotoBrowserViewController *vc = [[ZTPhotoBrowserViewController alloc] init];
    PhotoVCParams *params = [[PhotoVCParams alloc] init];
    params.browserVCType = ZTPhotoBrowserVCTypeCategory;
    vc.photoParams = params;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
