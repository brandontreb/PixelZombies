//
//  Zombie.h
//  Pixel Zombiles
//
//  Created by Brandon Trebitowski on 9/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Boid.h"

@interface Zombie : Boid

@property(nonatomic, strong) NSMutableArray *people;
@property(nonatomic, strong) NSMutableArray *soldiers;
@property(nonatomic) BOOL dead;

@end
