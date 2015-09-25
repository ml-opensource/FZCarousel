//
//  FZCarouselView.h
//  FZCarousel
//
//  Created by Sheng Dong on 9/25/15.
//  Copyright © 2015 Fuzz Productions, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @description FZCarouselView is view with default implementation of FZCarouselCollectionViewDelegate that takes an array of images for an infinitely scrolling carousel.
 *
 * @discussion Use it like a standard view with or without storyboard.
 */

@interface FZCarouselView : UIView

@property (nonatomic, strong) NSArray<UIImage *> *imageArray;
@property (nonatomic) BOOL gestureRecognitionShouldEndCarousel;
@property (nonatomic, assign) NSTimeInterval crankInterval; // Three Seconds by default

- (void)beginCarousel;

@end
