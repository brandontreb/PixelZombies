//
//  Person.h
//  Pixel Zombiles
//
//  Created by Brandon Trebitowski on 9/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Boid.h"

@interface Person : Boid

@property(nonatomic, strong) NSMutableArray *zombies;
@property(nonatomic) BOOL turned;

@end
