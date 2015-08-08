number:100
add 	(set:0.0000780, arrayObject:0.0000081, arrayIndex:0.0000119, orderedset:0.0000541)
find	(set:0.0000219, arrayObject:0.0006752, arrayIndex:0.0000041, orderedset:0.0000169)
delete	(set:0.0000200, arrayObject:0.0006561, arrayIndex:0.0000091, orderedset:0.0000191)


number:200
add 	(set:0.0001180, arrayObject:0.0000141, arrayIndex:0.0000231, orderedset:0.0001130)
find	(set:0.0000339, arrayObject:0.0025892, arrayIndex:0.0000119, orderedset:0.0000541)
delete	(set:0.0000410, arrayObject:0.0026350, arrayIndex:0.0000150, orderedset:0.0000379)

number:500
add 	(set:0.0001950, arrayObject:0.0000188, arrayIndex:0.0000498, orderedset:0.0002019)
find	(set:0.0000691, arrayObject:0.0162790, arrayIndex:0.0000100, orderedset:0.0000820)
delete	(set:0.0000679, arrayObject:0.0220950, arrayIndex:0.0000410, orderedset:0.0000849)

number:1000
add 	(set:0.0003760, arrayObject:0.0000370, arrayIndex:0.0001252, orderedset:0.0003648)
find	(set:0.0002389, arrayObject:0.0685818, arrayIndex:0.0000179, orderedset:0.0002239)
delete	(set:0.0003409, arrayObject:0.0705690, arrayIndex:0.0000949, orderedset:0.0001979)

number:2000
add 	(set:0.0010910, arrayObject:0.0000870, arrayIndex:0.0003018, orderedset:0.0008152)
find	(set:0.0002511, arrayObject:0.2945991, arrayIndex:0.0000279, orderedset:0.0002780)
delete	(set:0.0002439, arrayObject:0.3151770, arrayIndex:0.0004518, orderedset:0.0006919)

number:4000
add 	(set:0.0016921, arrayObject:0.0001791, arrayIndex:0.0009909, orderedset:0.0014141)
find	(set:0.0007730, arrayObject:1.1474731, arrayIndex:0.0000560, orderedset:0.0006800)
delete	(set:0.0006611, arrayObject:1.2189889, arrayIndex:0.0007358, orderedset:0.0008240)

number:8000
add 	(set:0.0042570, arrayObject:0.0005369, arrayIndex:0.0039918, orderedset:0.0036411)
find	(set:0.0012650, arrayObject:4.6505001, arrayIndex:0.0002749, orderedset:0.0021019)
delete	(set:0.0018969, arrayObject:4.9683521, arrayIndex:0.0026402, orderedset:0.0013959)

number:16000
add 	(set:0.0045409, arrayObject:0.0005760, arrayIndex:0.0181170, orderedset:0.0058370)
find	(set:0.0027769, arrayObject:18.3389149, arrayIndex:0.0002201, orderedset:0.0030470)
delete	(set:0.0026510, arrayObject:19.7886481, arrayIndex:0.0155160, orderedset:0.0056419)

number:32000
add 	(set:0.0099950, arrayObject:0.0009601, arrayIndex:0.0546200, orderedset:0.0132761)
find	(set:0.0040741, arrayObject:73.6985590, arrayIndex:0.0004010, orderedset:0.0043740)
delete	(set:0.0077369, arrayObject:77.9020700, arrayIndex:0.0551429, orderedset:0.0238130)



#import <Foundation/Foundation.h>

#define MAX_TEST_COUNT 1000000
#define ELEMENT_TEST_COUNT 32000


NSMutableArray *retainIds = nil;
int64_t *originalIds = NULL;
int64_t *findAndDeleteIds = NULL;
int *addAndDeleteIndexs = NULL;

void generate_original_ids()
{
	srand(time(NULL));
	
	retainIds = [NSMutableArray array];
	originalIds = new int64_t[MAX_TEST_COUNT];
	findAndDeleteIds = new int64_t[MAX_TEST_COUNT];
	addAndDeleteIndexs = new int[ELEMENT_TEST_COUNT];
	
	addAndDeleteIndexs[0] = 0;
	for (int i = 1; i < ELEMENT_TEST_COUNT; i ++)
	{
		addAndDeleteIndexs[i] = rand() % i;
	}
	
	for (int i = 0; i < MAX_TEST_COUNT; i ++)
	{
		id obj = [NSNumber numberWithInt:i];
		originalIds[i] = (int64_t)obj;
		findAndDeleteIds[i] = (int64_t)obj;
		[retainIds addObject:obj];
	}
	
	for (int i = 0; i < MAX_TEST_COUNT; i ++)
	{
		int index = rand() % MAX_TEST_COUNT;
		
		int64_t tmp = originalIds[index];
		originalIds[index] = originalIds[i];
		originalIds[i] = tmp; 
	}
}

NSTimeInterval costTime(void(^block)())
{
	NSTimeInterval time1 = [[NSDate date] timeIntervalSince1970];
	block();
	NSTimeInterval time2 = [[NSDate date] timeIntervalSince1970];
	return time2 - time1;
}

NSArray * test_number(int count)
{
	NSMutableSet *set = [NSMutableSet set];
	NSMutableArray *arrayObject = [NSMutableArray array];
	NSMutableArray *arrayIndex = [NSMutableArray array];
	NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSet];
	
	// create set
	NSTimeInterval t1 = costTime(^(void) {
		for (int index = 0; index < count; index ++)
		{
			[set addObject:(__bridge id) (void*)originalIds[index]];
		}
		return;
	});
	
	
	// create NSArray Object
	NSTimeInterval t2 = costTime(^(void) {
		for (int index = 0; index < count; index ++)
		{
			[arrayObject addObject:(__bridge id) (void*)originalIds[index]];
		}
		return;
	});
	
	// create NSArray Index
	NSTimeInterval t3 = costTime(^(void) {
		for (int index = 0; index < count; index ++)
		{
			[arrayIndex insertObject:(__bridge id) (void*)originalIds[index] atIndex:addAndDeleteIndexs[index]];
		}
		return;
	});
	
	// create OrderedSet
	NSTimeInterval t4 = costTime(^(void) {
		for (int index = 0; index < count; index ++)
		{
			[orderedSet addObject:(__bridge id) (void*)originalIds[index]];
		}
		return;
	});
	
	
	
	// find set
	NSTimeInterval t5 = costTime(^(void) {
		for (int index = 0; index < count; index ++)
		{
			[set containsObject:(__bridge id) (void*)findAndDeleteIds[index]];
		}
		return;
	});
	
	// find array object
	NSTimeInterval t6 = costTime(^(void) {
		for (int index = 0; index < count; index ++)
		{
			[arrayObject containsObject:(__bridge id) (void*)findAndDeleteIds[index]];
		}
		return;
	});
	
	// find array Index
	NSTimeInterval t7 = costTime(^(void) {
		for (int index = 0; index < count; index ++)
		{
			[arrayIndex objectAtIndex:index];
		}
		return;
	});
	
	// find orderedset
	NSTimeInterval t8 = costTime(^(void) {
		for (int index = 0; index < count; index ++)
		{
			[orderedSet containsObject:(__bridge id) (void*)findAndDeleteIds[index]];
		}
		return;
	});
	
	// delete set
	NSTimeInterval t9 = costTime(^(void) {
		for (int index = 0; index < count; index ++)
		{
			[set removeObject:(__bridge id) (void*)findAndDeleteIds[index]];
		}
		return;
	});
	
	// delete array Object
	NSTimeInterval t10 = costTime(^(void) {
		for (int index = 0; index < count; index ++)
		{
			[arrayObject removeObject:(__bridge id) (void*)findAndDeleteIds[index]];
		}
		return;
	});
	
	// delete array index
	NSTimeInterval t11 = costTime(^(void) {
		for (int index = 0; index < count; index ++)
		{
			[arrayIndex removeObjectAtIndex:addAndDeleteIndexs[count - index - 1]];
		}
		return;
	});
	
	// delete orderedset
	NSTimeInterval t12 = costTime(^(void) {
		for (int index = 0; index < count; index ++)
		{
			[orderedSet removeObject:(__bridge id) (void*)findAndDeleteIds[index]];
		}
		return;
	});
	
	return @[@(t1), @(t2), @(t3), @(t4), @(t5), @(t6), @(t7), @(t8), @(t9), @(t10), @(t11), @(t12)];
}




int main(int argc, char *argv[]) {
	@autoreleasepool {
		assert(ELEMENT_TEST_COUNT < MAX_TEST_COUNT);
		
		generate_original_ids();
		int number = ELEMENT_TEST_COUNT;
		NSArray* result = test_number(number);
		NSLog(@"\nnumber:%d\nadd \t(set:%.7f, arrayObject:%.7f, arrayIndex:%.7f, orderedset:%.7f)\n"
				"find\t(set:%.7f, arrayObject:%.7f, arrayIndex:%.7f, orderedset:%.7f)\n"
				"delete\t(set:%.7f, arrayObject:%.7f, arrayIndex:%.7f, orderedset:%.7f)\n",
				number,
				[result[0] doubleValue],
				[result[1] doubleValue],
				[result[2] doubleValue],
				[result[3] doubleValue],
				[result[4] doubleValue],
				[result[5] doubleValue],
				[result[6] doubleValue],
				[result[7] doubleValue],
				[result[8] doubleValue],
				[result[9] doubleValue],
				[result[10] doubleValue],
				[result[11] doubleValue]
				);
	}
	return 0;
}