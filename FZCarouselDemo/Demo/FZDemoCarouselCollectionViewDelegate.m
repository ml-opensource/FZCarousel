//
//  FZDemoCarouselCollectionViewDelegate.m
//  Fuzz Productions
//
//  Created by Noah Blake on 12/8/14.
//  Copyright (c) 2014 Fuzz Productions, LLC. All rights reserved.
//
//	This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0, as well as to the Additional Term regarding proper attribution.
//	The latter is located in Term 11 of the License.
//	If a copy of the MPL with the Additional Term was not distributed with this file, You can obtain one at http://static.fuzzhq.com/licenses/MPL

#import "FZDemoCarouselCollectionViewDelegate.h"

#import "FZDemoCarouselCollectionViewCell.h"

static NSString *const FZDemoCarouselCollectionViewCellIdentifier = @"FZDemoCarouselCollectionViewCell";

@implementation FZDemoCarouselCollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	FZDemoCarouselCollectionViewCell *rtnCell = (FZDemoCarouselCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:FZDemoCarouselCollectionViewCellIdentifier forIndexPath:indexPath];
	if (indexPath.row < _dataArray.count)
	{
		NSString *tmpImageName = _dataArray[indexPath.row];
		rtnCell.imageView.image = [UIImage imageNamed:tmpImageName];
	}
	return rtnCell;
}

@end
