# HPSwitchView

## 使用方法

将目录HPSwitchView拖到项目中引入头文件即可使用，计划后期使用pod管理。

## Demo

```
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


```

## Demo截图
![demo](https://github.com/arthas001/HPSwitchView/blob/master/1.png)