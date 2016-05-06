//
//  NewVC.m
//  LoadingHUD
//
//  Created by Labanotation on 16/5/6.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "NewVC.h"
#import "LSYLoadingHUD.h"
@interface NewVC ()
@property (nonatomic) NSInteger count;

@end
@implementation NewVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchData];
}
-(void)fetchData{
    _count++;
    [self showText:@"正在加载..."];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(5);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_count==2) {
                [self hidden];
                return;
            }
            [self failure:@"加载失败" block:^{
                [self fetchData];
            }];
        });
    });
    
}
-(void)showText:(NSString *)text
{
    LSYLoadingHUD *hud = [[LSYLoadingHUD alloc] init];
    [hud showHUDText:text inViewController:self];
}
-(void)failure:(NSString *)text block:(void(^)(void))block
{
    for (UIViewController *viewController in self.childViewControllers) {
        if ([viewController isKindOfClass:[LSYLoadingHUD class]]) {
            LSYLoadingHUD *loadingVC = (LSYLoadingHUD *)viewController;
            [loadingVC showFailHUDText:text inViewController:self reload:block];
        }
    }
}
-(void)hidden
{
    [LSYLoadingHUD hiddenAllHUD:self];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:self completion:nil];
}

@end
