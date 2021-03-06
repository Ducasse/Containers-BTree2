Class {
	#name : #DateTreeTest,
	#superclass : #TestCase,
	#instVars : [
		'now',
		'sixHours',
		'tomorrow',
		'nextWeek',
		'twoWeeks',
		'threeWeeks',
		'timespans'
	],
	#category : #'Containers-BTree2-Tests'
}

{ #category : #'as yet unclassified' }
DateTreeTest >> setUp [
	now := DateAndTime now.
	sixHours := now + 6 hours.
	tomorrow := now + 1 day.
	nextWeek := now + 1 week.
	twoWeeks := now + 2 weeks.
	threeWeeks := now + 3 weeks.
	
	timespans := Set new.
	
	timespans add: (Timespan starting: now ending: nextWeek).
	timespans add: (Timespan starting: nextWeek ending: twoWeeks).
	timespans add: (Timespan starting: now ending: tomorrow).
	timespans add: (Timespan starting: sixHours ending: (sixHours + 6 hours)).
]

{ #category : #accessing }
DateTreeTest >> testAdd [
	| dateRanges timespan |
	dateRanges := DateTree new.
	timespan := Timespan starting: now ending: twoWeeks.
	dateRanges at: timespan put: timespan.
	self assert: (dateRanges at: timespan) equals: timespan
]

{ #category : #'as yet unclassified' }
DateTreeTest >> testClipEndRange [
	| dateRanges returnedDates expectedDates |
	
	dateRanges := DateTree new.
	timespans do: [ :ea | dateRanges at: ea put: ea asString ].
	expectedDates := timespans select: [ :ea | (ea start >= now) and: [ ea end <= nextWeek ]] thenCollect: [ :ea | ea asString ].
	returnedDates := (dateRanges between: now and: nextWeek) collect: [ :ea | ea asString ].
	self assert: (returnedDates intersection: expectedDates) size equals: expectedDates size.
]

{ #category : #'as yet unclassified' }
DateTreeTest >> testClipStartRange [
	| dateRanges returnedDates expectedDates |
	
	dateRanges := DateTree new.
	timespans do: [ :ea | dateRanges at: ea put: ea asString ].
	expectedDates := timespans select: [ :ea | (ea start >= nextWeek) and: [ ea end <= twoWeeks ]] thenCollect: [ :ea | ea asString ].
	returnedDates := (dateRanges between: nextWeek and: twoWeeks) collect: [ :ea | ea asString ].
	self assert: (returnedDates intersection: expectedDates) size equals: expectedDates size.
]

{ #category : #'as yet unclassified' }
DateTreeTest >> testFirstLast [
	| dateRanges |
	dateRanges := DateTree new.
	self should: [ dateRanges first ] raise: Error.
	self should: [ dateRanges last ] raise: Error.
	dateRanges at: (Timespan starting: tomorrow ending: nextWeek) put: #inner.
	self assert: dateRanges first = #inner.
	self assert: dateRanges last = #inner.
	dateRanges at: (Timespan starting: now ending: twoWeeks) put: #outer.
	self assert: dateRanges first = #outer.
	self assert: dateRanges last = #outer.
	dateRanges at: (Timespan starting: tomorrow ending: threeWeeks) put: #last.
	self assert: dateRanges first = #outer.
	self assert: dateRanges last = #last
]

{ #category : #'as yet unclassified' }
DateTreeTest >> testInclusiveRange [
	| dateRanges returnedDates expectedDates |
	
	dateRanges := DateTree new.
	timespans do: [ :ea | dateRanges at: ea put: ea asString ].
	expectedDates := timespans collect: [ :ea | ea asString ].
	returnedDates := (dateRanges between: now and: threeWeeks) collect: [ :ea | ea asString ].
	self assert: (returnedDates intersection: expectedDates) size equals: expectedDates size.
]

{ #category : #'as yet unclassified' }
DateTreeTest >> testIteration [
	| dateRanges |
	
	dateRanges := DateTree new.
	timespans do: [ :ea | dateRanges at: ea put: ea asString ].
	dateRanges keysAndValuesDo: [ :key :val | self assert: (key asString) = val ].
]

{ #category : #'as yet unclassified' }
DateTreeTest >> testMissing [
	| dateRanges timespan missingTimespan |
	dateRanges := DateTree new.
	timespan := Timespan starting: now ending: twoWeeks.
	missingTimespan := Timespan starting: now ending: tomorrow.
	dateRanges at: timespan put: timespan.
	self assert: (dateRanges at: missingTimespan ifAbsent: [ false ]) = false.
]

{ #category : #'as yet unclassified' }
DateTreeTest >> testRemove [
	| dateRanges timespan |
	dateRanges := DateTree new.
	timespans do: [ :ea | dateRanges at: ea put: ea asString. ].
	timespan := timespans anyOne.
	self assert: (dateRanges at: timespan) = timespan asString.
	dateRanges removeKey: timespan.
	self assert: ((dateRanges at: timespan ifAbsent: [ false ]) = false)
]
