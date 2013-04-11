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
@property (nonatomic) NSUInteger numberOfCardsToMatch;

// Keys (@"matchBonus",@"mismatchPenalty",@"flipCost") values: NSNumber as integers
@property (strong, nonatomic) NSDictionary *gameOptions;
@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) NSMutableArray *cards;

@end

@implementation CardMatchingGame

#define MINIMUM_CARDS_TO_MATCH 2
#define MAXIMUM_CARDS_TO_MATCH 3

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

//-(NSArray *)flippedCards
//{
//    NSMutableArray *cards = [[NSMutableArray alloc] init];
//    
//    for (Card *card in self.cards) {
//        if (!card.isUnplayable && card.faceUp) {
//            [cards addObject:card];
//        }
//    }
//    return cards;
//}

-(void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    int bonus = ([[self.gameOptions valueForKey:@"matchBonus"] isKindOfClass:[NSNumber class]]) ? [[self.gameOptions valueForKey:@"matchBonus"] integerValue] : 0;
    int penalty = ([[self.gameOptions valueForKey:@"mismatchPenalty"] isKindOfClass:[NSNumber class]]) ? [[self.gameOptions valueForKey:@"mismatchPenalty"] integerValue] : 0;
    int flipCost = ([[self.gameOptions valueForKey:@"flipCost"] isKindOfClass:[NSNumber class]]) ? [[self.gameOptions valueForKey:@"flipCost"] integerValue] : 0;
    
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
                self.flipScore = matchScore * bonus;
                self.score += self.flipScore;
                
            } else {
                
                for (Card *otherCard in cardsFacingUp) {
                    otherCard.faceUp = NO;
                }
                self.flipScore = - penalty;
                self.score += self.flipScore;
            }
        }
        self.score -= flipCost;
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

-(id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck matching: (NSUInteger) numberOfCardsToMatch gameOptions:(NSDictionary *)gameOptions
{
    self = [super init];
    
    if (self) {
        // Checking if deck has enough cards
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                self.cards[i] = card;
            } else {
                self = nil;
                break;
            }
        }
        self.deck = deck;
        self.numberOfCardsInPlay = count;
        
        if (numberOfCardsToMatch < MINIMUM_CARDS_TO_MATCH || numberOfCardsToMatch > MAXIMUM_CARDS_TO_MATCH) {
            self = nil;
        } else {
            self.numberOfCardsToMatch = numberOfCardsToMatch;
        }
        
        if (gameOptions) {
            self.gameOptions = gameOptions;
        } else {
            self = nil;
        }
    }
    
    return self;
}

@end
