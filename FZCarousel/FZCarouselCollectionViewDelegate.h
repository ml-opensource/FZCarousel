//
//  TAPCarouselCollectionViewDelegate.h
//  Fuzz Productions
//
//  Created by Noah Blake on 6/3/14.
//  Copyright (c) 2014 Fuzz Productions, LLC. All rights reserved.
//
//	This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0, as well as to the Additional Term regarding proper attribution.
//	The latter is located in Term 11 of the License.
//	If a copy of the MPL with the Additional Term was not distributed with this file, You can obtain one at http://static.fuzzhq.com/licenses/MPL

@import UIKit;

/**
 * @description FZCarouselCollectionViewDelegate is an abstract UICollectionViewDelegate that produces an infinitely scrolling carousel.
 *
 * @discussion Users of this class should begin by subclasssing it. Subclasses should handle all UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, and UICollectionViewDelegate methods that need to be overwritten to produce the desired collectionView layout. 
	This class, in turn, will handle all "carousel concerns," which include manipulation and syncing of the data array, page control updates, and carousel cranking.
 */

typedef void (^FZCarouselCollectionViewDelegateDidSelectCellBlock)(UICollectionView *inCollectionView, NSIndexPath *inIndexPath, id inDataForIndexPath);

@interface FZCarouselCollectionViewDelegate : NSObject <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UIGestureRecognizerDelegate>
{
	@protected NSArray *_dataArray;
}
/**
 * @description The block invoked when a cell is selected.
 */
@property (nonatomic, copy) FZCarouselCollectionViewDelegateDidSelectCellBlock didSelectCellBlock;
/**
 * @description A page control optionally maintained by the `FZCarouselCollectionViewDelegate`.
 */
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
/**
 * @description The collectionView managed by `FZCarouselCollectionViewDelegate`.
 */
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
/**
 * @description The speed at which the carousel cranks. If a lazyCrankInterval is specified, the speed at which the carousel cranks for its first "cycle."
 */
@property (nonatomic, assign) NSTimeInterval defaultCrankInterval;
/**
 * @description The speed at which the carousel cranks after the first cycle is complete.
 */
@property (nonatomic, assign) NSTimeInterval lazyCrankInterval;
/**
 * @description Determines whether gestures received by the collecitonView cancel carousel movement. By default, YES.
 */
@property (nonatomic, assign) BOOL gestureRecognitionShouldEndCarousel;

#pragma mark - Constructors -
/**
 * @description The default constructor.
 * @param inCollectionView The collectionView managed by the `FZCarouselCollectionViewDelegate`.
 * @param inDataArray The data array represented in collectionView.
 * @param inCrankInterval The speed at which the carousel cranks.
 * @return An FZCarouselCollectionViewDelegate configured as specified by the constructor's parameters.
 *
 */
+ (instancetype)carouselCollectionViewDelegateForCollectionView:(UICollectionView *)inCollectionView dataArray:(NSArray *)inDataArray crankInterval:(NSTimeInterval)inCrankInterval;
/**
 * @description A constructor supporting lazy crank intervals.
 * @param inCollectionView The collectionView managed by the `FZCarouselCollectionViewDelegate`.
 * @param inDataArray The data array represented in collectionView.
 * @param inCrankInterval The speed at which the carousel cranks for its first cycle.
 * @param inLazyCrankInterval The speed at which the carousel cranks after its first cycle.
 * @return An FZCarouselCollectionViewDelegate configured as specified by the constructor's parameters.
 *
 */
+ (instancetype)carouselCollectionViewDelegateForCollectionView:(UICollectionView *)inCollectionView dataArray:(NSArray *)inArray defaultCrankInterval:(NSTimeInterval)inDefaultCrankInterval lazyCrankInterval:(NSTimeInterval)inLazyCrankInterval;

#pragma mark - Data setting -
/**
 * @description Set the array of data to be represented in the collectionView.
 * @parameter inDataArray The array of data represented in the collectionView
 * @discussion This array's contents will be multiplied in order to produce the infinitely scrollable effect. Once set, external classes should not attempt to read this value.
 */
- (void)setDataArray:(NSArray *)inDataArray;

#pragma mark - Carousel control -
/**
 * @description Begin carousel movement.
 * @discussion Call this method to begin or resume the carousel.
 */
- (void)beginCarousel;
/**
 * @description End carousel movement.
 * @discussion Call this method to end the carousel.
 */
- (void)endCarousel;
/**
 * @description A method for subclasses to implement to provide custom view code for their page controls.
 * @discussion Implement this method to customize the carousel's page control.
 */
- (void)configurePageControl;

@end
