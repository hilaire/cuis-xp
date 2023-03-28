'From Cuis 6.0 [latest update: #5730] on 28 March 2023 at 9:48:11 pm'!
'Description '!
!provides: 'Paper' 1 13!
SystemOrganization addCategory: 'Paper'!


!classDefinition: #PaperMorph category: 'Paper'!
BoxedMorph subclass: #PaperMorph
	instanceVariableNames: 'currentStroke strokes pen samples mouseStrokes'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Paper'!
!classDefinition: 'PaperMorph class' category: 'Paper'!
PaperMorph class
	instanceVariableNames: ''!

!classDefinition: #Pencil category: 'Paper'!
Object subclass: #Pencil
	instanceVariableNames: 'color width position'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Paper'!
!classDefinition: 'Pencil class' category: 'Paper'!
Pencil class
	instanceVariableNames: ''!

!classDefinition: #Stroke category: 'Paper'!
Object subclass: #Stroke
	instanceVariableNames: 'color width p1 p2 c'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Paper'!
!classDefinition: 'Stroke class' category: 'Paper'!
Stroke class
	instanceVariableNames: ''!


!PaperMorph methodsFor: 'event handling testing' stamp: 'hlsf 3/23/2023 12:10:09'!
handlesMouseDown: event
	^ true! !

!PaperMorph methodsFor: 'event handling testing' stamp: 'hlsf 3/23/2023 14:59:40'!
handlesMouseHover: event
	^ true! !

!PaperMorph methodsFor: 'initialization' stamp: 'hlsf 3/28/2023 20:36:55'!
initialize
	super initialize.
	extent := 400@400.
	strokes := OrderedCollection new.
	mouseStrokes := OrderedCollection new.
	pen := Pencil new color: Color black.
	self color: Color white.
	self setProperty: #samples toValue: 4.
	self setProperty: #threshold toValue: 2 squared
	! !

!PaperMorph methodsFor: 'strokes' stamp: 'hlsf 3/28/2023 20:44:08'!
addStroke
	| stroke |
	samples size < self samples ifTrue: [ ^ nil ].
	
	stroke := Stroke new
		start: samples first
		end: samples last
		control: self controlPoint.
	strokes add: stroke.
	self redrawNeeded.
	^ stroke! !

!PaperMorph methodsFor: 'strokes' stamp: 'hlsf 3/28/2023 20:40:58'!
clearStrokes
	self resetSamplingTo: nil.
	strokes := OrderedCollection new.
	self redrawNeeded ! !

!PaperMorph methodsFor: 'strokes' stamp: 'hlsf 3/27/2023 21:07:21'!
controlPoint
	" Compute the control point according to current and previous stroke "
	| lastStroke |
	lastStroke := strokes lastIfEmpty: [nil].
	^ (lastStroke notNil and: [
		lastStroke control notNil and: [ lastStroke end == samples first ]])
		ifTrue: [
			" we have continuity, ensure we have C1 continuity between the new stroke and the previous one "
			self
				intersectionOrigin1: samples first
				vector1: lastStroke control - samples first
				origin2: samples last
				vector2: (samples atLast: 2) - samples last ]
		ifFalse: [
			" The new stroke is disconnected from the previous one "
			self
				intersectionOrigin1: samples first
				vector1: samples second - samples first
				origin2: samples last
				vector2: (samples atLast: 2) - samples last ].! !

!PaperMorph methodsFor: 'strokes' stamp: 'hlsf 3/26/2023 13:01:48'!
intersectionOrigin1: p1 vector1: v1 origin2: p2 vector2: v2
| det c1 c2 |
	det := v1 crossProduct: v2.
	(det closeTo: 0) ifTrue: [^ nil].
	c1 := p1 crossProduct: v1.
	c2 := p2 crossProduct: v2.
	^ ((c2 * v1 x - (c1 * v2 x) ) / det) @ ((v1 y * c2 - (v2 y * c1)) / det)! !

!PaperMorph methodsFor: 'strokes' stamp: 'hlsf 3/28/2023 20:40:24'!
resetSamplingTo: aPoint
	samples := OrderedCollection new.
	mouseStrokes := OrderedCollection new.
	aPoint ifNotNil: [
		samples add: aPoint.
		mouseStrokes add: aPoint]
! !

!PaperMorph methodsFor: 'events' stamp: 'hlsf 3/28/2023 20:42:30'!
mouseButton1Down: event localPosition: localPosition
" We start sampling user hand strokes from this position"
	self resetSamplingTo: localPosition
	
! !

!PaperMorph methodsFor: 'events' stamp: 'hlsf 3/28/2023 21:05:54'!
mouseButton1Up: event localPosition: localPosition
	samples add: localPosition.
	"In case there is not enought sample, clone the last one"
	self samples - samples size timesRepeat: [	samples add: samples last].
	self addStroke.
	self resetSamplingTo: nil
! !

!PaperMorph methodsFor: 'events' stamp: 'hlsf 3/23/2023 15:01:13'!
mouseHover: event localPosition: localPosition
	pen position: localPosition ! !

!PaperMorph methodsFor: 'events' stamp: 'hlsf 3/28/2023 21:36:20'!
mouseMove: event localPosition: localPosition
	event mouseButton1Pressed not ifTrue: [^ self ].
	(mouseStrokes isEmpty 
	or: [(mouseStrokes last squaredDistanceTo: localPosition) > 4]) ifTrue: [
		mouseStrokes add: localPosition].	
	self redrawNeeded .
	(samples last squaredDistanceTo: localPosition) > self threshold 		ifTrue: [	
		samples add: localPosition.
		samples size = self samples			ifTrue: [
			self addStroke ifNotNil: [self resetSamplingTo: localPosition]]
		]! !

!PaperMorph methodsFor: 'menus' stamp: 'hlsf 3/28/2023 20:21:38'!
addCustomMenuItems: aCustomMenu hand: aHandMorph
	super addCustomMenuItems: aCustomMenu hand: aHandMorph.
	aCustomMenu 
		add: 'samples size' action: #setSampleSize;
		add: 'sampling threshold' action: #setThreshold;
		addUpdating: #showPointsString action: #pointsOnOff;
		addUpdating: #showControlsString action: #controlsOnOff;
		addUpdating: #showTangentsString action: #tangentsOnOff;
		add: 'clear' action: #clearStrokes! !

!PaperMorph methodsFor: 'menus' stamp: 'hlsf 3/27/2023 21:52:11'!
controlsOnOff
	self 
		setProperty: #showControls
		toValue: self showControls not.
	self redrawNeeded ! !

!PaperMorph methodsFor: 'menus' stamp: 'hlsf 3/27/2023 21:52:05'!
pointsOnOff
	self 
		setProperty: #showPoints
		toValue: self showPoints not.
	self redrawNeeded ! !

!PaperMorph methodsFor: 'menus' stamp: 'hlsf 3/27/2023 22:08:45'!
setSampleSize
	self 
		request: 'Number of sample before a new stroke'
		initialAnswer: self samples asString
		verifying: [:aString | aString asInteger notNil ]
		do: [:aString | | integer |
			integer := aString asInteger.
			(integer notNil and: [integer >=3]) ifTrue: [
				self setProperty: #samples toValue: integer.
				samples := OrderedCollection new			] 
			]! !

!PaperMorph methodsFor: 'menus' stamp: 'hlsf 3/28/2023 20:27:22'!
setThreshold
	self 
		request: 'Minimum screen distance between two consecutive samples'
		initialAnswer: self threshold sqrt asString
		verifying: [:aString | aString asInteger notNil ]
		do: [:aString | | integer |
			integer := aString asInteger.
			(integer notNil and: [integer >=0]) ifTrue: [
				self setProperty: #threshold toValue: integer squared] 
			]! !

!PaperMorph methodsFor: 'menus' stamp: 'hlsf 3/27/2023 21:48:57'!
showControls
	^ self valueOfProperty: #showControls ifAbsent: [false]! !

!PaperMorph methodsFor: 'menus' stamp: 'hlsf 3/27/2023 21:48:50'!
showControlsString
	^ self showControls asMenuItemTextPrefix , 
		'show controls'! !

!PaperMorph methodsFor: 'menus' stamp: 'hlsf 3/27/2023 21:48:31'!
showPoints
	^ self valueOfProperty: #showPoints ifAbsent: [false]! !

!PaperMorph methodsFor: 'menus' stamp: 'hlsf 3/27/2023 21:48:24'!
showPointsString
	^ self showPoints asMenuItemTextPrefix , 
		'show points'! !

!PaperMorph methodsFor: 'menus' stamp: 'hlsf 3/27/2023 21:47:26'!
showTangents
	^ self valueOfProperty: #showTangents ifAbsent: [false]! !

!PaperMorph methodsFor: 'menus' stamp: 'hlsf 3/27/2023 21:48:06'!
showTangentsString
	^ self showTangents asMenuItemTextPrefix , 
		'show tangents'! !

!PaperMorph methodsFor: 'menus' stamp: 'hlsf 3/27/2023 21:52:18'!
tangentsOnOff
	self 
		setProperty: #showTangents
		toValue: self showTangents not.
	self redrawNeeded ! !

!PaperMorph methodsFor: 'drawing' stamp: 'hlsf 3/28/2023 20:15:25'!
drawControlsOn: canvas
	"Draw control points "	
	strokes do: [:s |
		s control ifNotNil: [:c | 
			canvas fillColor: Color red do: [	canvas circleCenter: c radius: 1.5]] ]
		! !

!PaperMorph methodsFor: 'drawing' stamp: 'hlsf 3/28/2023 20:57:39'!
drawOn: canvas
	super drawOn: canvas.
	canvas strokeWidth: 1 color: Color black do: [
		"Draw the line connecting the samples, for user comfort"	
		mouseStrokes ifNotEmpty: [ 
			canvas moveTo: mouseStrokes first.
			mouseStrokes allButFirstDo: [:s |	canvas lineTo: s]].
		"Draw the strokes"
		strokes do: [:s |
			canvas moveTo: s start.
			s control 
				ifNil: [canvas lineTo: s end]
				ifNotNil: [canvas quadraticBezierTo: s end control: s control]]].
	self showTangents ifTrue: [self drawTangentsOn: canvas ].
	self showPoints ifTrue: [self drawPointsOn: canvas].
	self showControls ifTrue: [self drawControlsOn: canvas]
		
		! !

!PaperMorph methodsFor: 'drawing' stamp: 'hlsf 3/28/2023 20:14:30'!
drawPointsOn: canvas
"Draw start-end points"
	strokes do: [:s |
		canvas fillColor: Color blue do: [canvas circleCenter: s start radius: 1.5].
		canvas fillColor: Color blue do: [canvas circleCenter: s end radius: 1.5] ] 
		
		! !

!PaperMorph methodsFor: 'drawing' stamp: 'hlsf 3/28/2023 20:16:03'!
drawTangentsOn: canvas
	"Draw tangent"
	strokes do: [:s |			
		s control ifNotNil: [
			canvas strokeWidth: 0.8 color: Color green do: [		
				canvas moveTo: s start.
				canvas lineTo: s control.
				canvas lineTo: s end ]]]
		! !

!PaperMorph methodsFor: 'geometry testing' stamp: 'hlsf 3/23/2023 21:23:17'!
requiresVectorCanvas
	^ true! !

!PaperMorph methodsFor: 'accessing' stamp: 'hlsf 3/28/2023 20:25:19'!
samples
"Number of samples before instantiating a new hand stroke"
	^ self valueOfProperty: #samples! !

!PaperMorph methodsFor: 'accessing' stamp: 'hlsf 3/28/2023 20:24:48'!
threshold
"Minimum squared distance between two consecutive samples"
	^ self valueOfProperty: #threshold! !

!Pencil methodsFor: 'accessing' stamp: 'hlsf 3/23/2023 14:50:10'!
color
	^ color! !

!Pencil methodsFor: 'accessing' stamp: 'hlsf 3/23/2023 14:50:01'!
color: aColor
	color := 	aColor ! !

!Pencil methodsFor: 'accessing' stamp: 'hlsf 3/23/2023 14:50:55'!
position
	^ position! !

!Pencil methodsFor: 'accessing' stamp: 'hlsf 3/23/2023 14:50:48'!
position: aPoint
	position := aPoint ! !

!Pencil methodsFor: 'accessing' stamp: 'hlsf 3/23/2023 14:50:17'!
width
	^ width ! !

!Pencil methodsFor: 'accessing' stamp: 'hlsf 3/23/2023 14:50:29'!
width: aNumber
	width := aNumber ! !

!Stroke methodsFor: 'accessing' stamp: 'hlsf 3/23/2023 14:51:46'!
color
	^ color! !

!Stroke methodsFor: 'accessing' stamp: 'hlsf 3/23/2023 14:51:39'!
color: aColor
	color := aColor ! !

!Stroke methodsFor: 'accessing' stamp: 'hlsf 3/23/2023 21:19:29'!
control
	^ c! !

!Stroke methodsFor: 'accessing' stamp: 'hlsf 3/23/2023 21:21:04'!
end
	^ p2! !

!Stroke methodsFor: 'accessing' stamp: 'hlsf 3/23/2023 21:20:59'!
start
	^ p1! !

!Stroke methodsFor: 'accessing' stamp: 'hlsf 3/23/2023 20:58:52'!
start: startPoint end: endPoint control: controlPoint
	p1 := startPoint.
	p2 := endPoint .
	c := controlPoint ! !

!Stroke methodsFor: 'accessing' stamp: 'hlsf 3/23/2023 14:51:54'!
width
	^ width ! !

!Stroke methodsFor: 'accessing' stamp: 'hlsf 3/23/2023 14:52:12'!
width: aNumber
	width := aNumber ! !

!Stroke methodsFor: 'printing' stamp: 'hlsf 3/26/2023 14:03:55'!
printOn: str
	super printOn: str.
	str nextPutAll: ' p1: ';
		nextPutAll: (p1 printShowingDecimalPlaces: 1);
		nextPutAll: ' p2: ';
		nextPutAll: (p2 printShowingDecimalPlaces: 1);		
		nextPutAll: ' c: ';
		nextPutAll: (c ifNotNil: [c printShowingDecimalPlaces: 1] ifNil: ['nil'])
	
! !
