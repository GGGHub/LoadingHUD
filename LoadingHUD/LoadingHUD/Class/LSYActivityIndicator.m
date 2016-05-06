//
//  LSYActivityIndicator.m
//  LoadingHUD
//
//  Created by Labanotation on 16/5/6.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYActivityIndicator.h"
#import <objc/runtime.h>
#define ANIMATION_DURATION_SECS 0.5
@interface LSYActivityIndicator ()
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) float dotRadius;
@property (nonatomic, assign) int stepNumber;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, assign) CGRect firstPoint, secondPoint, thirdPoint, fourthPoint;
@property (nonatomic, strong) CALayer *firstDot, *secondDot, *thirdDot;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic,strong) id timerTarget;

@end

@implementation LSYActivityIndicator
static const void * weakKey = @"weakKey";

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupViewLayout:self.frame];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupViewLayout:frame];
    }
    return self;
}

- (void)setupViewLayout:(CGRect)frame
{
    _stepNumber = 0;
    _isAnimating = NO;
    self.hidesWhenStopped = YES;
    self.color = [UIColor colorWithRed:210/255.0f green:55/255.0f blue:44/255.0f alpha:1.0];
    
    _dotRadius = frame.size.height <= frame.size.width ? frame.size.width/12 : frame.size.height/12;
    _firstPoint = CGRectMake(frame.size.width/4-_dotRadius, frame.size.height/2-_dotRadius, 2*_dotRadius, 2*_dotRadius);
    _secondPoint = CGRectMake(frame.size.width/2-_dotRadius, frame.size.height/4-_dotRadius, 2*_dotRadius, 2*_dotRadius);
    _thirdPoint = CGRectMake(3*frame.size.width/4-_dotRadius, frame.size.height/2-_dotRadius, 2*_dotRadius, 2*_dotRadius);
    _fourthPoint = CGRectMake(frame.size.width/2-_dotRadius, 3*frame.size.height/4-_dotRadius, 2*_dotRadius, 2*_dotRadius);
    
    _firstDot = [CALayer layer];
    [_firstDot setMasksToBounds:YES];
    [_firstDot setBackgroundColor:[self.color CGColor]];
    [_firstDot setCornerRadius:_dotRadius];
    [_firstDot setBounds:CGRectMake(0.0f, 0.0f, _dotRadius*2, _dotRadius*2)];
    _firstDot.frame = _fourthPoint;
    
    _secondDot = [CALayer layer];
    [_secondDot setMasksToBounds:YES];
    [_secondDot setBackgroundColor:[self.color CGColor]];
    [_secondDot setCornerRadius:_dotRadius];
    [_secondDot setBounds:CGRectMake(0.0f, 0.0f, _dotRadius*2, _dotRadius*2)];
    _secondDot.frame = _firstPoint;
    
    _thirdDot = [CALayer layer];
    [_thirdDot setMasksToBounds:YES];
    [_thirdDot setBackgroundColor:[self.color CGColor]];
    [_thirdDot setCornerRadius:_dotRadius];
    [_thirdDot setBounds:CGRectMake(0.0f, 0.0f, _dotRadius*2, _dotRadius*2)];
    _thirdDot.frame = _thirdPoint;
    
    [[self layer] addSublayer:_firstDot];
    [[self layer] addSublayer:_secondDot];
    [[self layer] addSublayer:_thirdDot];
    
    self.layer.hidden = YES;
}

-(void)startAnimating
{
    if (!_isAnimating)
    {
        _isAnimating = YES;
        self.layer.hidden = NO;
        _timerTarget = [NSObject new];
        class_addMethod([_timerTarget class], @selector(animateNextStep), (IMP)timMethod, "v@:");
        _timer = [NSTimer scheduledTimerWithTimeInterval:ANIMATION_DURATION_SECS target:_timerTarget selector:@selector(animateNextStep) userInfo:nil repeats:YES];
         objc_setAssociatedObject(_timerTarget, weakKey, self, OBJC_ASSOCIATION_ASSIGN);
    }
}
void timMethod(id self,SEL _cmd)
{
    LSYActivityIndicator *indicator = objc_getAssociatedObject(self, weakKey);
    IMP imp = [indicator methodForSelector:_cmd];
    void (*func)(id,SEL) = (void *)imp;
    func(indicator,_cmd);
}
-(void)dealloc
{
    [_timer invalidate];
}
-(void)stopAnimating
{
    _isAnimating = NO;
    if (self.hidesWhenStopped)
        self.layer.hidden = YES;
    [_timer invalidate];
    _stepNumber = 0;
    _firstDot.frame = _fourthPoint;
    _secondDot.frame = _firstPoint;
    _thirdDot.frame = _thirdPoint;
}

-(void)animateNextStep
{
    switch (_stepNumber)
    {
        case 0:
            [CATransaction begin];
            [CATransaction setAnimationDuration:ANIMATION_DURATION_SECS];
            _firstDot.frame = _secondPoint;
            _thirdDot.frame = _fourthPoint;
            [CATransaction commit];
            break;
        case 1:
            [CATransaction begin];
            [CATransaction setAnimationDuration:ANIMATION_DURATION_SECS];
            _secondDot.frame = _thirdPoint;
            _thirdDot.frame = _firstPoint;
            [CATransaction commit];
            break;
        case 2:
            [CATransaction begin];
            [CATransaction setAnimationDuration:ANIMATION_DURATION_SECS];
            _firstDot.frame = _fourthPoint;
            _thirdDot.frame = _secondPoint;
            [CATransaction commit];
            break;
        case 3:
            [CATransaction begin];
            [CATransaction setAnimationDuration:ANIMATION_DURATION_SECS];
            _secondDot.frame = _firstPoint;
            _thirdDot.frame = _thirdPoint;
            [CATransaction commit];
            break;
        case 4:
            [CATransaction begin];
            [CATransaction setAnimationDuration:ANIMATION_DURATION_SECS];
            _firstDot.frame = _secondPoint;
            _thirdDot.frame = _fourthPoint;
            [CATransaction commit];
            _stepNumber = 0;
        default:
            break;
    }
    
    _stepNumber++;
}

- (BOOL)isAnimating
{
    return _isAnimating;
}

@end
