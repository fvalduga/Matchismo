//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Felipe Valduga on 2/2/13.
//  Copyright (c) 2013 Felipe Valduga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

@property (readonly, nonatomic) int score;

/* NSDictionary that represent flip card results. It contains 2 keys:
    @"cardsFlipped" : NSArray with cards flipped
    @"flipScore"    : NSNumber with match score or penalty
*/
@property (readonly, strong, nonatomic) NSDictionary *flipResults;

//Designated Initializer
-(id)initWithCardCount:(NSUInteger)count
usingDeck:(Deck *)deck matching: (NSUInteger) numberOfCardsToMatch gameOptions: (NSDictionary *)gameoptions;

-(void)flipCardAtIndex:(NSUInteger)index;
-(Card *)cardAtIndex:(NSUInteger)index;

@end
