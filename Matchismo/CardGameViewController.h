//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Felipe Valduga on 1/30/13.
//  Copyright (c) 2013 Felipe Valduga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"


@interface CardGameViewController : UIViewController

@property (nonatomic) NSUInteger numberOfCardsToMatch; //abstract
@property (nonatomic) NSUInteger startingCardCount; //abstract
@property (nonatomic) NSUInteger numberOfCardsToDeal;//abstract

- (Deck *)createDeck; //abstract
- (NSDictionary *)getGameOptions; //abstract
-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card; //abstract
-(void)updateResultsInView:(UIView *)view usingCards:(NSArray *)cards withScore:(int)score; //abstract

@end
