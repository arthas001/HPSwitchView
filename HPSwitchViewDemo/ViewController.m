//
//  ViewController.m
//  HPSwitchViewDemo
//
//  Created by 韩学鹏 on 16/10/10.
//  Copyright © 2016年 韩学鹏. All rights reserved.
//

#import "ViewController.h"
#import "HPSwitchView.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"

@interface ViewController ()<HPSwitchViewDelegate>

@property (nonatomic, strong) HPSwitchView *switchView;

@property (nonatomic, strong) FirstViewController *firstVC;

@property (nonatomic, strong) SecondViewController *secondVC;

@property (nonatomic, strong) ThirdViewController *thirdVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"首页";
    self.edgesForExtendedLayout =  UIRectEdgeNone;
    
    //添加顶部滑动
    self.switchView = [[HPSwitchView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.switchView];
    self.switchView.delegate = self;
    
    self.switchView.tabItemNormalColor = [UIColor lightGrayColor];
    self.switchView.tabItemSelectedColor = [UIColor redColor];
    
    self.firstVC = [[FirstViewController alloc] init];
    
    self.secondVC = [[SecondViewController alloc] init];
    
    self.thirdVC = [[ThirdViewController alloc] init];
    
    [self.switchView buildUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HPSwitchViewDelegate

- (NSInteger)numberOfTab:(HPSwitchView *)view
{
    return 3;
}

- (UIViewController *)onSwitchView:(HPSwitchView *)view viewOfTab:(NSInteger)index
{
    switch (index) {
        case 0:{
            return self.firstVC;
        }break;
        case 1:{
            return self.secondVC;
        }break;
        case 2:{
            return self.thirdVC;
        }break;
        default:
            break;
    }
    
    return nil;
}

@end
