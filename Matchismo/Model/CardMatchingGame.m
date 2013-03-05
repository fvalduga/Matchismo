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
@property (strong, nonatomic) NSDictionary *flipResults;

@property (strong, nonatomic) NSMutableArray *cards;

@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc]init];
    }
    return _cards;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

-(void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
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
                self.score += matchScore * MATCH_BONUS;
                [results setObject:@(matchScore * MATCH_BONUS) forKey:@"flipScore"];
            } else {
                
                for (Card *otherCard in cardsFacingUp) {
                    otherCard.faceUp = NO;
                }
                self.score -= MISMATCH_PENALTY;
                [results setObject:@(-MISMATCH_PENALTY) forKey:@"flipScore"];
            }
        }
        self.score -= FLIP_COST;
    }
    card.faceUp = !card.faceUp;
    self.flipResults = [results copy];
}

-(Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

-(id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck matching: (NSUInteger) numberOfCardsToMatch
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                self.cards[i] = card;
            } else {
                self = nil;
                break;
            }
        }
        //number of cards to match can be either 2 or 3.
        if (numberOfCardsToMatch < 2 || numberOfCardsToMatch > 3) {
            self = nil;
        } else self.numberOfCardsToMatch = numberOfCardsToMatch;
        
        
    }
    
    return self;
}

@end
