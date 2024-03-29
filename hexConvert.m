//
//  hexConvert.m
//  iMNet Bryan
//
//  Created by Bryan on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "hexConvert.h"

@implementation hexConvert




//converts a string of 2 hex values to an NSNumber and stores in a mutable array
-   (NSMutableArray *) convertStringToArray:(NSString *)hexString{
    
    NSString *byteString;
    NSScanner *scan;
    NSMutableArray *array;
    uint dec;

    for (int i = 0; i < ([hexString length]/2); i++) {
        byteString = [NSString stringWithFormat:@"%c%c", [hexString characterAtIndex:(2*i)], [hexString characterAtIndex:((2*i)+1)]];
        scan = [NSScanner scannerWithString:byteString];
        [scan scanHexInt:&dec];
        [array addObject:[NSNumber numberWithUnsignedInt:dec]];
    }
    return array;
}


//converts a mutable array of bytes to a string of hex values in bytes
-   (NSString *) convertArrayToString:(NSMutableArray *)hexArray{

    NSMutableString *hexString = [[NSMutableString alloc] initWithCapacity:(2*[hexArray count])];
    for (int i = 0; i<[hexArray count]; i++) {
        [hexString appendString:[NSString stringWithFormat:@"%.2x",[[hexArray objectAtIndex:i] unsignedIntValue]]];
    }
    return hexString;
}

@end
