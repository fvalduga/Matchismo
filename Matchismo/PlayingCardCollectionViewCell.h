//
//  PlayingCardCollectionViewCell.h
//  Matchismo
//
//  Created by Felipe Valduga on 3/25/13.
//  Copyright (c) 2013 Felipe Valduga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"

@interface PlayingCardCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;

@end
