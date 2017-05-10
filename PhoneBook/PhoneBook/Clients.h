
//
//  Clients.h
//  PhoneBook
//
//  Created by Serik Klement on 11.03.17.
//  Copyright © 2017 Serik Klement. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Clients : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *lastName;
@property (assign, nonatomic) NSInteger age;
@property (strong, nonatomic) NSString *image;

//@property (assign, nonatomic) NSInteger num;

+ (Clients*) randomClient;

@end
