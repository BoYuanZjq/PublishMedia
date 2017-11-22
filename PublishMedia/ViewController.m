//
//  ViewController.m
//  PublishMedia
//
//  Created by derek on 2017/11/20.
//  Copyright © 2017年 derek. All rights reserved.
//

#import "ViewController.h"
#import "FBFcDynamicViewController.h"

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
    [self.navigationController pushViewController:con animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
