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
@property (readonly, nonatomic) int flipScore;
@property (strong, nonatomic) NSArray *flippedCards; //of Cards
@property (nonatomic) NSUInteger numberOfCardsInPlay;

//Designated Initializer
//gameOptions - ( Keys: [@"cardCount",@"numberOfCardsToMatch",@"matchBonus",@"mismatchPenalty",@"flipCost"] values: NSNumber as integers )
-(id)initWithDeck:(Deck *)deck gameOptions: (NSDictionary *)gameOptions;

-(void)flipCardAtIndex:(NSUInteger)index;
-(Card *)cardAtIndex:(NSUInteger)index;
-(void)removeCardAtIndex:(NSUInteger)index;
-(NSUInteger)dealMoreCards:(NSUInteger)numberOfCards;

@end
