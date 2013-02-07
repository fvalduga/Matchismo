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
//gameMode: "2" for 2-card-match game OR "3" for 3-card-match
-(id)initWithCardCount:(NSUInteger)count
            usingDeck:(Deck *)deck
          andGameMode:(NSUInteger)gameMode;

-(void)flipCardAtIndex:(NSUInteger)index;
-(Card *)cardAtIndex:(NSUInteger)index;

@end
