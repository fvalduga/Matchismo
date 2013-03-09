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

- (Deck *)createDeck; //abstract
- (NSDictionary *)getGameOptions; //abstract
- (void)updateCardButton:(UIButton *)cardButton withCard:(Card *)card; //abstract
- (NSMutableAttributedString *) getCardsFlippedContents:(NSArray *)cardsFlipped; //abstract

@end
