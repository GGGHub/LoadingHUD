//
//  LSYLoadingHUD.m
//  LoadingHUD
//
//  Created by Labanotation on 16/5/6.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYLoadingHUD.h"
#import "LSYActivityIndicator.h"

#define StateFont [UIFont systemFontOfSize:14]
#define FontColor [UIColor blackColor]

@interface LSYLoadingHUD ()

@property (nonatomic,strong) LSYActivityIndicator *activity;
@property (nonatomic,strong) UIImageView *stateView;
@property (nonatomic,strong) UILabel *stateLabel;
@property (nonatomic,strong) UIButton *refreshButton;
@property (nonatomic,strong) reload reloadBlock;
@end

@implementation LSYLoadingHUD

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_loadingView) {
        [self.view addSubview:_loadingView];
    }
    else{
        [self.view addSubview:self.activity];
    }
    [self.view addSubview:self.stateView];
    [self.view addSubview:self.stateLabel];
    [self.view addSubview:self.refreshButton];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
-(LSYActivityIndicator *)activity
{
    if (!_activity) {
        _activity = [[LSYActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    }
    return _activity;
}
-(UIImageView *)stateView
{
    if (!_stateView) {
        _stateView = [[UIImageView alloc] init];
        _stateView.contentMode = UIViewContentModeScaleAspectFit;
        _stateView.image =  _failureImage?:[self loadingFail];
    }
    return _stateView;
}
-(UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        [_stateLabel setFont:StateFont];
        [_stateLabel setTextColor:FontColor];
        [_stateLabel setNumberOfLines:0];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _stateLabel;
}
-(UIButton *)refreshButton
{
    if (!_refreshButton) {
        _refreshButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_refreshButton setTitle:@"重新加载" forState:UIControlStateNormal];
        [_refreshButton.titleLabel setFont:StateFont];
        [_refreshButton setTitleColor:FontColor forState:UIControlStateNormal];
        _refreshButton.layer.borderColor = [UIColor grayColor].CGColor;
        _refreshButton.layer.borderWidth = 0.5f;
        [_refreshButton addTarget:self action:@selector(p_reloadClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshButton;
}
-(void)p_reloadClick:(UIButton *)sender
{
    _reloadBlock();
}

-(void)p_loadStateShowWithState:(OKWLoadState) state{
    switch (state) {
        case OKWLoading:
        {
            
            [_activity startAnimating];
            _loadingView.hidden = NO;
            _stateView.hidden = YES;
            _refreshButton.hidden = YES;
        }
            break;
        case OKWLoadError:
        {
            
            [_activity stopAnimating];
            _loadingView.hidden = YES;
            _stateView.hidden = NO;
            _refreshButton.hidden = NO;
        }
            break;
    }
}

-(UIImage *)loadingFail
{
    CGRect rect = CGRectMake(0, 0, 100, 100);
    NSMutableArray *paths = [NSMutableArray array];
    for (int i=0; i<4; i++) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineWidth = 5;
        [path addArcWithCenter:CGPointMake(rect.size.width/2, rect.size.height) radius:35-i*10 startAngle:M_PI/4*5 endAngle:M_PI/4*7 clockwise:YES];
        [paths addObject:path];
    }
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    {
        [[UIColor lightGrayColor] setStroke];
        for (UIBezierPath *path in paths) {
            [path stroke];
        }
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    return image;
    
}
#pragma mark - Publish Method
-(void)showHUDText:(NSString *)text inViewController:(UIViewController *)vc
{
    self.view.frame = vc.view.frame;
    [self removeFromParentViewController];
    [vc addChildViewController:self];
    [vc.view addSubview:self.view];
    _stateLabel.text = text;
    [_stateLabel sizeToFit];
    [self p_loadStateShowWithState:OKWLoading];
    
}
-(void)showFailHUDText:(NSString *)text inViewController:(UIViewController *)vc reload:(reload)reload
{
    _stateLabel.text = text;
    [_stateLabel sizeToFit];
    [self p_loadStateShowWithState:OKWLoadError];
    _reloadBlock = reload;
}
-(void)hiddenHUDViewController:(UIViewController *)vc
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
+(void)hiddenAllHUD:(UIViewController *)vc
{
    for (UIViewController *viewController in vc.childViewControllers) {
        if ([viewController isKindOfClass:[LSYLoadingHUD class]]) {
            LSYLoadingHUD *loadingVC = (LSYLoadingHUD *)viewController;
            [loadingVC.view removeFromSuperview];
            [loadingVC removeFromParentViewController];
        }
    }
}
#pragma mark - Font Height
-(CGFloat)fontText:(NSString *)text withFontWidth:(CGFloat)width
{
    NSDictionary *fontAttribute = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
    CGSize fontSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:fontAttribute context:nil].size;
    return fontSize.height;
}

#pragma mark -
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _activity.frame = CGRectMake((self.view.frame.size.width - 100)/2, self.view.frame.size.height/2-100, 100, 100);
    _loadingView.frame = CGRectMake((self.view.frame.size.width - 100)/2, self.view.frame.size.height/2-100, 100, 100);
    _stateView.frame = CGRectMake((self.view.frame.size.width - 100)/2, self.view.frame.size.height/2-100, 100, 100);
    
    _stateLabel.frame = CGRectMake(10,(_activity.frame.origin.y+_activity.frame.size.height)?:(_loadingView.frame.origin.y+_loadingView.frame.size.height)+10, self.view.frame.size.width-20, [_stateLabel sizeThatFits:CGSizeMake(self.view.frame.size.width-20, 0)].height);
    _refreshButton.frame = CGRectMake((self.view.frame.size.width-100)/2,_stateLabel.frame.origin.y+_stateLabel.frame.size.height+10, 100,30);
    
}

@end
