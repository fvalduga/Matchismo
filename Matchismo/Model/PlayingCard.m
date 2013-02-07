//
//  PlayingCard.m
//  Matchismo
//
//  Created by Felipe Valduga on 1/30/13.
//  Copyright (c) 2013 Felipe Valduga. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit; //because we provide setter and getter

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 1) {
        
        PlayingCard *otherCard = [otherCards lastObject];
        
        if ([self.suit isEqualToString:otherCard.suit]) {
            score = 1;
        } else if (self.rank == otherCard.rank) {
            score = 4;
        }
    } else if ([otherCards count] == 2) {
        
        int suitMatches = 0;
        int rankMatches = 0;
        
        for (PlayingCard *otherCard in otherCards) {
            if ([self.suit isEqualToString:otherCard.suit]){
                suitMatches++;
            } else if (self.rank == otherCard.rank){
                rankMatches++;
            }
        }
        if (suitMatches == 2) score = 5;
        else if (rankMatches == 2) score = 100;
    }
    
    return score;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

+ (NSArray *)validSuits
{
    static NSArray  *validSuits = nil;
    if (!validSuits) validSuits = @[@"♠",@"♣",@"♥",@"♦"];
    return validSuits;
}

+ (NSArray *)rankStrings
{
    static NSArray *rankStrings = nil;
    if (!rankStrings) rankStrings = @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
    return rankStrings;
}

+ (NSUInteger)maxRank
{
    return [[self rankStrings] count]-1;
    //since maxRank is a Class method, it can use "self" to invoke other class methods.
}

- (void) setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

@end
