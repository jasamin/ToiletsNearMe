//
//  CVRegisterLoginVC.m
//  XiuxiuService
//
//  Created by 邱嘉敏 on 16/11/23.
//  Copyright © 2016年 邱嘉敏. All rights reserved.
//

#import "CVRegisterLoginVC.h"

@interface CVRegisterLoginVC ()

@end

@implementation CVRegisterLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view.layer addSublayer: [self backgroundLayer]];
    
    UIImageView *earth = [[UIImageView alloc]initWithFrame:CGRectMake(0, 80/568.0*SCR_HEIGHT, 730/320.0*SCR_WIDTH, 730/320.0*SCR_WIDTH)];
    [earth setImage:[UIImage imageNamed:@"earth"]];
    [earth setCenter:CGPointMake(SCR_WIDTH/2.0, earth.center.y)];
    [self.view addSubview:earth];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.duration = 40; // 持续时间
    animation.removedOnCompletion = NO;
    animation.repeatCount = 100000; // 重复次数
    animation.fromValue = [NSNumber numberWithFloat:0.0]; // 起始角度
    animation.toValue = [NSNumber numberWithFloat:-(M_PI * 2.0)]; // 终止角度
    [earth.layer addAnimation:animation forKey:@"rotate-layer"];
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"running.gif" ofType:nil];
    NSData* imageData = [NSData dataWithContentsOfFile:filePath];
    _gifImageView = [[CVGIFImageView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH/3.0, SCR_WIDTH/3.0)];
    [_gifImageView setData:imageData];
    _gifImageView.center = CGPointMake(SCR_WIDTH/2.0, SCR_HEIGHT/2.7);
    [self.view addSubview:_gifImageView];
    
    float hH = SCR_HEIGHT/1.60;
    UITextField *userName = [[UITextField alloc]initWithFrame:CGRectMake(50, hH, SCR_WIDTH-100, 30)];
    userName.placeholder = @"输入电话";
    [self.view addSubview:userName];
    UIView *l = [[UIView alloc]initWithFrame:CGRectMake(userName.frame.origin.x, userName.frame.origin.y+userName.frame.size.height+1, userName.frame.size.width, 1)];
    l.backgroundColor = [UIColor grayColor];
    [self.view addSubview:l];
    
    UITextField *pwd = [[UITextField alloc]initWithFrame:CGRectMake(50, hH+50, SCR_WIDTH-100, 30)];
    pwd.placeholder = @"输入密码";
    [self.view addSubview:pwd];
    UIView *l1 = [[UIView alloc]initWithFrame:CGRectMake(pwd.frame.origin.x, pwd.frame.origin.y+pwd.frame.size.height+1, pwd.frame.size.width, 1)];
    l1.backgroundColor = [UIColor grayColor];
    [self.view addSubview:l1];
    
    UIButton *btn_login = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn_login setFrame:CGRectMake(l1.frame.origin.x, l1.frame.origin.y + 10, l1.frame.size.width/2.0-5, 35)];
    [btn_login setTitle:@"登   入" forState:0];
    [btn_login setTintColor:[UIColor whiteColor]];
    [btn_login.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [btn_login.layer setBorderWidth:1];
    [btn_login addTarget:self action:@selector(didOnSava:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_login];
    
    UIButton *btn_register = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn_register setFrame:CGRectMake(btn_login.frame.origin.x+btn_login.frame.size.width + 10, l1.frame.origin.y + 10, l1.frame.size.width/2.0-5, 35)];
    [btn_register setTitle:@"注   册" forState:0];
    [btn_register setTintColor:[UIColor whiteColor]];
    [btn_register.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [btn_register.layer setBorderWidth:1];
    [btn_register addTarget:self action:@selector(didOnregister:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_register];
    
    UIButton *btn_error = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn_error setFrame:CGRectMake(SCR_WIDTH-90/320.0*SCR_WIDTH,SCR_HEIGHT-40/568.0*SCR_HEIGHT,80/320.0*SCR_WIDTH,30/568.0*SCR_HEIGHT)];
    [btn_error setTitle:@"无法登入？" forState:0];
    [btn_error setTintColor:[UIColor whiteColor]];
    //[btn_error.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    //[btn_error.layer setBorderWidth:1];
    [btn_error addTarget:self action:@selector(didOnErr:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_error];
}

- (void)didOnSava:(UIButton*)sender {
    
}

- (void)didOnregister:(UIButton*)sender {
    
}

- (void)didOnErr:(UIButton*)sender{
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}

-(CAGradientLayer *)backgroundLayer{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    gradientLayer.colors = @[(__bridge id)[UIColor whiteColor].CGColor,(__bridge id)BaseColor.CGColor];
    gradientLayer.startPoint = CGPointMake(0.1, 0.1);
    gradientLayer.endPoint = CGPointMake(0.65,1);
    gradientLayer.locations = @[@0.1,@0.8];
    return gradientLayer;
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
