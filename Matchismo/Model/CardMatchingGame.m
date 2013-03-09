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
@property (readwrite, strong, nonatomic) NSDictionary *flipResults;

// Keys (@"matchBonus",@"mismatchPenalty",@"flipCost") values: NSNumber as integers
@property (strong, nonatomic) NSDictionary *gameOptions;

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

-(void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    int bonus = ([[self.gameOptions valueForKey:@"matchBonus"] isKindOfClass:[NSNumber class]]) ? [[self.gameOptions valueForKey:@"matchBonus"] integerValue] : 0;
    int penalty = ([[self.gameOptions valueForKey:@"mismatchPenalty"] isKindOfClass:[NSNumber class]]) ? [[self.gameOptions valueForKey:@"mismatchPenalty"] integerValue] : 0;
    int flipCost = ([[self.gameOptions valueForKey:@"flipCost"] isKindOfClass:[NSNumber class]]) ? [[self.gameOptions valueForKey:@"flipCost"] integerValue] : 0;
    
    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];
    NSMutableArray *cardsFacingUp = [[NSMutableArray alloc] init];
    
    if (card && !card.isFaceUp) {
        for (Card *otherCard in self.cards) {
            if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                [cardsFacingUp addObject:otherCard];
            }
        }
        [results setObject:[cardsFacingUp arrayByAddingObject:card] forKey:@"cardsFlipped"];
        
        if ([cardsFacingUp count] + 1 == self.numberOfCardsToMatch) {
            int matchScore = [card match:cardsFacingUp];
            
            if (matchScore) {
                card.unplayable = YES;
                for (Card *otherCard in cardsFacingUp) {
                    otherCard.unplayable = YES;
                }
                self.score += matchScore * bonus;
                [results setObject:@(matchScore * bonus) forKey:@"flipScore"];
            } else {
                
                for (Card *otherCard in cardsFacingUp) {
                    otherCard.faceUp = NO;
                }
                self.score -= penalty;
                [results setObject:@(-penalty) forKey:@"flipScore"];
            }
        }
        self.score -= flipCost;
    }
    card.faceUp = !card.faceUp;
    self.flipResults = [results copy];
}

-(Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
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
