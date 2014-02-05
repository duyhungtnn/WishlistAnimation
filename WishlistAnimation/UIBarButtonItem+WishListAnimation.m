//
//  UIBarButtonItem+WishListAnimation.m
//  WishlistAnimation
//
//  Created by Fábio Bernardo on 03/02/14.
//  Copyright (c) 2014 fbernardo. All rights reserved.
//

#import "UIBarButtonItem+WishListAnimation.h"

@implementation UIBarButtonItem (WishListAnimation)

+ (UIBarButtonItem *)wlBarButtonWithImage:(UIImage *)image target:(id)target action:(SEL)selector {
    //Generate selected image
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeMultiply);
    CGContextSetAlpha(UIGraphicsGetCurrentContext(), .2);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), (CGRect) {.size = image.size}, image.CGImage);
    UIImage *selectedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //Create images with the template rendering mode (for tintColor)
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    //Create button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateHighlighted];
    [button setImage:selectedImage forState:UIControlStateSelected];
    [button sizeToFit];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)wishListAnimationWithImage:(UIImage *)image completionBlock:(void (^)())completionBlock {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect frame = [window convertRect:self.customView.bounds fromView:self.customView];
    
    CGSize imageSize = (CGSize) {.width = 88, .height = 88};
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = (CGRect) {
        .size = imageSize,
        .origin.x = roundf(CGRectGetMidX(frame) - imageSize.width / 2.f),
        .origin.y = roundf(CGRectGetMidY(frame) - imageSize.height / 2.f)
    };
    [window addSubview:imageView];
    
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        imageView.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        if (finished) {
            [self signalAnimationWithCompletionBlock:completionBlock];
        } else {
            if (completionBlock) completionBlock();
        }
    }];
}

- (void)signalAnimationWithCompletionBlock:(void (^)())completionBlock {
    CGAffineTransform initialTransform = self.customView.transform;
    
    [UIView animateKeyframesWithDuration:.4 delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.2 animations:^{
            self.customView.transform = CGAffineTransformScale(initialTransform, 1.4, 1.4);
        }];
        [UIView addKeyframeWithRelativeStartTime:.2 relativeDuration:.2 animations:^{
            self.customView.transform = CGAffineTransformScale(initialTransform, 1, 1);
        }];
    } completion:^(BOOL finished){
        self.customView.transform = initialTransform;
        if (completionBlock) completionBlock();
    }];
}

@end
