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
//readwrite could be supressed but it is there just to get attention because is different than public interface

@property (readwrite, nonatomic) NSString *resultDescription;
@property (nonatomic) NSUInteger numberOfCardsToMatch;

@property (strong, nonatomic) NSMutableArray *cards; //of Card

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
    NSMutableArray *cardsFacingUp = [[NSMutableArray alloc] init];
    
    
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
                
                self.score += matchScore * MATCH_BONUS;
                self.resultDescription =[NSString stringWithFormat:@"Matched %@&%@ for %d points!",[cardsFacingUp componentsJoinedByString:@"&"],card.contents, matchScore * MATCH_BONUS];
            } else {
                
                for (Card *otherCard in cardsFacingUp) {
                    otherCard.faceUp = NO;
                }
                
                self.score -= MISMATCH_PENALTY;
                self.resultDescription = [NSString stringWithFormat:@"%@&%@ don't match!%d point penalty!",[cardsFacingUp componentsJoinedByString:@"&"],card.contents,MISMATCH_PENALTY];
            }
        } else {
            self.resultDescription = [NSString stringWithFormat:@"Flipped up %@",card.contents];
        }
        
        self.score -= FLIP_COST;
        
    }
    
    card.faceUp = !card.faceUp;
    
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
        if (numberOfCardsToMatch < 2 && numberOfCardsToMatch > 3) {
            self = nil;
        } else self.numberOfCardsToMatch = numberOfCardsToMatch;
        
        
    }
    
    return self;
}

@end
