//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Felipe Valduga on 2/2/13.
//  Copyright (c) 2013 Felipe Valduga. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (readwrite, nonatomic) int score;
@property (readwrite, nonatomic) int flipScore;
@property (strong, nonatomic) Deck *deck;
@property (nonatomic) int bonus;
@property (nonatomic) int penalty;
@property (nonatomic) int flipCost;
@property (nonatomic) int numberOfCardsToMatch;
@property (strong, nonatomic) NSMutableArray *cards;

@end

@implementation CardMatchingGame

#define MINIMUM_CARDS_TO_MATCH 2
#define MAXIMUM_CARDS_TO_MATCH 3

#define CARD_COUNT_KEY @"cardCount"
#define N_CARD_MATCH_KEY @"numberOfCardsToMatch"
#define MATCH_BONUS_KEY @"matchBonus"
#define MISMATCH_PENALTY_KEY @"mismatchPenalty"
#define FLIP_COST_KEY @"flipCost"

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc]init];
    }
    return _cards;
}

- (NSUInteger)numberOfCardsInPlay
{
    _numberOfCardsInPlay = [self.cards count];
    return _numberOfCardsInPlay;
}

-(void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    NSMutableArray *cardsFacingUp = [[NSMutableArray alloc] init];
    
    //reset properties
    self.flipScore = 0;
    self.flippedCards = nil;
    
    if (card && !card.isFaceUp) {
        for (Card *otherCard in self.cards) {
            if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                [cardsFacingUp addObject:otherCard];
            }
        }
        if ([cardsFacingUp count] + 1 == self.numberOfCardsToMatch) {
            int matchScore = [card match:cardsFacingUp];
            
            if (matchScore) {
                card.unplayable = YES;
                for (Card *otherCard in cardsFacingUp) {
                    otherCard.unplayable = YES;
                }
                self.flipScore = matchScore * self.bonus;
                self.score += self.flipScore;
                
            } else {
                
                for (Card *otherCard in cardsFacingUp) {
                    otherCard.faceUp = NO;
                }
                self.flipScore = - self.penalty;
                self.score += self.flipScore;
            }
        }
        self.score -= self.flipCost;
        self.flippedCards = [cardsFacingUp arrayByAddingObject:card];
    }
    card.faceUp = !card.faceUp;
}

-(Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

-(void)removeCardAtIndex:(NSUInteger)index
{
    if (index < [self.cards count]) {
        [self.cards removeObjectAtIndex:index];
    }
}

// Return the number of cards added
-(NSUInteger)dealMoreCards:(NSUInteger)numberOfCards
{
    NSUInteger cardsAdded = 0;
    
    for (int i = 0; i < numberOfCards; i++) {
        Card *card = [self.deck drawRandomCard];
        
        if (card) {
            [self.cards addObject:card];
            cardsAdded++;
        }
    }
    return cardsAdded;
}

-(id)initWithDeck:(Deck *)deck gameOptions:(NSDictionary *)gameOptions
{
    self = [super init];
    
    if (self) {
        
        int cardCount = ([gameOptions[CARD_COUNT_KEY] isKindOfClass:[NSNumber class]]) ? [gameOptions[CARD_COUNT_KEY] intValue] : 0;
        int cardsToMatch = ([gameOptions[N_CARD_MATCH_KEY] isKindOfClass:[NSNumber class]]) ? [gameOptions[N_CARD_MATCH_KEY] intValue] : 0;
        
        _bonus = ([gameOptions[MATCH_BONUS_KEY] isKindOfClass:[NSNumber class]]) ? [gameOptions[MATCH_BONUS_KEY] intValue] : 0;
        _penalty = ([gameOptions[MISMATCH_PENALTY_KEY] isKindOfClass:[NSNumber class]]) ? [gameOptions[MISMATCH_PENALTY_KEY] intValue] : 0;
        _flipCost = ([gameOptions[FLIP_COST_KEY] isKindOfClass:[NSNumber class]]) ? [gameOptions[FLIP_COST_KEY] intValue] : 0;
        _deck = deck;
        _numberOfCardsInPlay = cardCount;
        
        // Checking if deck has enough cards
        for (int i = 0; i < cardCount; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                self.cards[i] = card;
            } else {
                self = nil;
                break;
            }
        }

        //Checking of numberOfCardsToMatch is within limits
        if (cardsToMatch >= MINIMUM_CARDS_TO_MATCH || cardsToMatch <= MAXIMUM_CARDS_TO_MATCH) {
            _numberOfCardsToMatch = cardsToMatch;
        } else {
            self = nil;
        }
    }
    
    return self;
}

@end
