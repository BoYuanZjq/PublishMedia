//
//  ViewController.m
//  PublishMedia
//
//  Created by derek on 2017/11/20.
//  Copyright © 2017年 derek. All rights reserved.
//

#import "ViewController.h"
#import "FBFcDynamicViewController.h"
#import "FBFriendCircleViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImageView *iamgeView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 60, 60)];
    [self.view addSubview:iamgeView];
    [iamgeView sd_setImageWithURL:[NSURL URLWithString:@"http://fc.img.kiimi.cc/33B4224A-FBFE-4495-B214-5206AE788707.jpg?x-oss-process=style/kiimi"] placeholderImage:nil];
}

// 发布
- (IBAction)publishEvent:(id)sender {
    FBFcDynamicViewController *controller = [[FBFcDynamicViewController alloc] initWithNibName:@"FBFcDynamicViewController" bundle:nil];
    //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
//    [self presentViewController:controller animated:YES completion:nil];
    [self.navigationController pushViewController:controller animated:YES];
}
//　朋友圈
- (IBAction)friendC:(id)sender {
    FBFriendCircleViewController *friend = [[FBFriendCircleViewController alloc] initWithNibName:@"FBFriendCircleViewController" bundle:nil];
    [self.navigationController pushViewController:friend animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
