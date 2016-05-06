//
//  LSYActivityIndicator.h
//  LoadingHUD
//
//  Created by Labanotation on 16/5/6.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSYActivityIndicator : UIView
@property (nonatomic) BOOL hidesWhenStopped;
-(void)startAnimating;
-(void)stopAnimating;
-(BOOL)isAnimating;
@end
