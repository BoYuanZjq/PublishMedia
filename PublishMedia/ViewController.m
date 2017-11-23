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
}

// 发布
- (IBAction)publishEvent:(id)sender {
    FBFcDynamicViewController *con = [[FBFcDynamicViewController alloc] initWithNibName:@"FBFcDynamicViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:con];
    [self presentViewController:nav animated:YES completion:nil];
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
