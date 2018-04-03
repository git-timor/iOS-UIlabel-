//
//  ViewController.m
//  HyperlinksDemo
//
//  Created by 周周旗 on 2018/4/3.
//  Copyright © 2018年 ZQ. All rights reserved.
//

#import "ViewController.h"
#import "HyperlinksLabel.h"
#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

@interface ViewController ()
{
    NSString *Phone;
}
@property (nonatomic, strong)HyperlinksLabel *lab;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    [self addNotifaction];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//一定要释放通知，否则会造成多次通知。如果不能走dealloc，则是vc中具有强引用未消除，原因附在文末，可直接在viewdiddisapper方法中释放。
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark -- responder
- (void)gotoWebViewOrCall:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *mobileNum =  [userInfo objectForKey:@"url"];
    if (mobileNum.length == 11) {//这里简易判断是不是手机号 按理应该正则判断，此处简易处理
        Phone = [userInfo objectForKey:@"url"];
        [self call];
        NSLog(@"+++++=+++++拨打电话");
    }else{
        NSLog(@"+++++++++ 跳转到网页");
    }
}
- (void)gotoHyperlinksWebView:(NSNotification *)notification{
   
}

- (void)call {
    //这里应该先判断是否具有打电话的功能，如ipad等不能拨打电话，此处省略。。
        NSString *mobile = Phone;
        NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel://%@",mobile];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

#pragma mark -- setter and getter

- (void)initSubViews{
    [self.view addSubview:self.lab];
    
    [_lab  urlAndIphoneValidation:@"电话18708123456 链接http://www.baidu.com/"];

}

- (HyperlinksLabel *)lab{
    if (!_lab) {
        _lab = [[HyperlinksLabel alloc]initWithFrame:CGRectMake(15, 64,SCREEN_WIDTH-30 , 100)];
        [_lab setTextColor:[UIColor blackColor]];
        [_lab setBackgroundColor:[UIColor orangeColor]];
        _lab.numberOfLines = 0;
    }
    return _lab;
}

- (void)addNotifaction{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoWebViewOrCall:)
                                                 name:@"LinkAccess"
                                               object:nil];
}

@end
