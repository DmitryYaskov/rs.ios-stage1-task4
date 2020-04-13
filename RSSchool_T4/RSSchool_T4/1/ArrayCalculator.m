#import "ArrayCalculator.h"

@implementation ArrayCalculator

+ (NSInteger)maxProductOf:(NSInteger)numberOfItems itemsFromArray:(NSArray *)array {
    
    NSMutableArray<NSNumber*> *mutableArray = array.mutableCopy;
    
    [mutableArray filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject isKindOfClass:[NSNumber class]];
    }]];
    
    NSMutableArray<NSNumber*> *resultArray = mutableArray.mutableCopy;
    
    NSMutableArray<NSNumber*> *sortedArray;
    sortedArray = [resultArray sortedArrayUsingComparator:^NSComparisonResult(NSNumber* a, NSNumber* b) {
        return a.intValue <= b.intValue;
    }].mutableCopy;
    
    // get sorted negative and positive numbers
    NSMutableArray<NSNumber*> *positiveMutableArray = sortedArray.mutableCopy;
    NSMutableArray<NSNumber*> *negativeMutableArray = sortedArray.mutableCopy;
    
    [positiveMutableArray filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSNumber *evaluatedObject, NSDictionary *bindings) {
        return evaluatedObject.intValue >= 0;
    }]];
    
    [negativeMutableArray filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSNumber *evaluatedObject, NSDictionary *bindings) {
        return evaluatedObject.intValue < 0;
    }]];
    
    // sort abs  numbers
    NSMutableArray<NSNumber*> *sortedAbsArray;
    sortedAbsArray = [resultArray sortedArrayUsingComparator:^NSComparisonResult(NSNumber* a, NSNumber* b) {
        return abs(a.intValue) <= abs(b.intValue);
    }].mutableCopy;
    
    NSRange theRange = NSMakeRange(0, sortedAbsArray.count > numberOfItems  ? numberOfItems : sortedAbsArray.count);
    resultArray = [sortedAbsArray subarrayWithRange: theRange].mutableCopy;
    
    // if it alrady max and positive
    int  happyFlowValue = [ArrayCalculator product: resultArray];
    // replace min positiv to max negative
    int  negativeFlowValue = INT_MIN;
    // replace min negative to max positiv
    int  positiveFlowValue = INT_MIN;
    if (happyFlowValue >= 0 || mutableArray.count <= numberOfItems) {
        // if positive
        return happyFlowValue;
    } else {
        // if negative
        [ArrayCalculator removeReferenceFrom: positiveMutableArray with: resultArray.copy];
        [ArrayCalculator removeReferenceFrom: negativeMutableArray with: resultArray.copy];
        
        for (int i = resultArray.count -1; i >= 0; i--) {
            if (resultArray[i].intValue < 0) {
                NSMutableArray *temp = resultArray.mutableCopy;
                temp[i] = positiveMutableArray[0];
                negativeFlowValue = [ArrayCalculator product: temp];
                break;
            }
        }
        
        for (int i = 0; i <= resultArray.count -1; i++) {
            if (resultArray[i].intValue > 0) {
                if (negativeMutableArray.count > 0) {
                    NSMutableArray *temp = resultArray.mutableCopy;
                    temp[i] = negativeMutableArray[negativeMutableArray.count-1];
                    positiveFlowValue = [ArrayCalculator product: temp];
                    break;
                }
            }
        }
    }
    
    return negativeFlowValue > positiveFlowValue ? negativeFlowValue : positiveFlowValue;
}

+ (int)product:(NSArray*) array  {
    if (array.count > 0) {
        int mul = 1;
        for (NSNumber *num in array) {
            mul *= [num intValue];
        }
        return mul;
    } else {
        return 0;
    }
}

+ (void)removeReferenceFrom:(NSMutableArray*) array1 with:(NSArray*)array2  {
    NSMutableArray *tempArray2 = array2.mutableCopy;
    for (int i = array1.count-1; i>=0; i--) {
        for (int j = tempArray2.count-1; j>=0; j--) {
            if (array1[i] == tempArray2[j]) {
                [array1 removeObjectAtIndex:i];
                [tempArray2 removeObjectAtIndex:j];
                break;
            }
        }
    }
}

@end
