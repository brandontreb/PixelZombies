//
//  Soldier.h
//  Pixel Zombiles
//
//  Created by Brandon Trebitowski on 9/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Boid.h"

@interface Soldier : Boid

@property(nonatomic) CGPoint destination;
@property(nonatomic, strong) NSMutableArray *zombies;
@property(nonatomic) BOOL turned;
@property(nonatomic) BOOL isPlayer;

@end
