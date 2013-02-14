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
@property (readonly, nonatomic) NSString *resultDescription;

//Designated Initializer
-(id)initWithCardCount:(NSUInteger)count
             usingDeck:(Deck *)deck;

-(void)flipCardAtIndex:(NSUInteger)index;
-(Card *)cardAtIndex:(NSUInteger)index;

@end
