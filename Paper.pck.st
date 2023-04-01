'From Cuis 6.0 [latest update: #5733] on 1 April 2023 at 10:56:16 pm'!
'Description '!
!provides: 'Paper' 1 29!
SystemOrganization addCategory: 'Paper'!


!classDefinition: #PaperMorph category: 'Paper'!
BoxedMorph subclass: #PaperMorph
	instanceVariableNames: 'stroker strokes pen samples mousePositions'
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

!classDefinition: #StrokeBezier2 category: 'Paper'!
Object subclass: #StrokeBezier2
	instanceVariableNames: 'color width p1 p2 c'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Paper'!
!classDefinition: 'StrokeBezier2 class' category: 'Paper'!
StrokeBezier2 class
	instanceVariableNames: ''!

!classDefinition: #Stroker category: 'Paper'!
Object subclass: #Stroker
	instanceVariableNames: 'paper strokes'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Paper'!
!classDefinition: 'Stroker class' category: 'Paper'!
Stroker class
	instanceVariableNames: ''!

!classDefinition: #StrokerC0 category: 'Paper'!
Stroker subclass: #StrokerC0
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Paper'!
!classDefinition: 'StrokerC0 class' category: 'Paper'!
StrokerC0 class
	instanceVariableNames: ''!

!classDefinition: #StrokerC1 category: 'Paper'!
Stroker subclass: #StrokerC1
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Paper'!
!classDefinition: 'StrokerC1 class' category: 'Paper'!
StrokerC1 class
	instanceVariableNames: ''!

!classDefinition: #StrokerRegressionC1 category: 'Paper'!
Stroker subclass: #StrokerRegressionC1
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Paper'!
!classDefinition: 'StrokerRegressionC1 class' category: 'Paper'!
StrokerRegressionC1 class
	instanceVariableNames: ''!

!classDefinition: #StrokerRegressionC0 category: 'Paper'!
StrokerRegressionC1 subclass: #StrokerRegressionC0
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Paper'!
!classDefinition: 'StrokerRegressionC0 class' category: 'Paper'!
StrokerRegressionC0 class
	instanceVariableNames: ''!


!PaperMorph commentStamp: '<historical>' prior: 0!
(PaperMorph new stroker: Stroker ) openInWorld.

Try different broken scenarii to compute bezier curves parameters:
(PaperMorph new stroker: StrokerC1) openInWorld.  
(PaperMorph new stroker: StrokerC0 ) openInWorld. <= seems better
(PaperMorph new stroker: StrokerRegressionC1) openInWorld.
(PaperMorph new stroker: StrokerRegressionC0 ) openInWorld.
!

!StrokeBezier2 commentStamp: '<historical>' prior: 0!
A quadratic Bézier stroke!

!Stroker commentStamp: '<historical>' prior: 0!
Given samples of mouse positions and previous strokes, I compute a new stroke. I can be subclassed to adjust my behavior.!

!StrokerC0 commentStamp: '<historical>' prior: 0!
We only have C0 continuity at the junction points between the strokes. 
The tangents to the control point are computed at best using (S0S1) and (S(n-1)Sn) from the mouse samples!

!StrokerC1 commentStamp: '<historical>' prior: 0!
We have C1 continuity at the junction points between the strokes!

!StrokerRegressionC1 commentStamp: '<historical>' prior: 0!
In this scenario, the tangent line to the control point are computed by a linear regression from the samples.
We still have C1 continuity at the junction points between the strokes!

!StrokerRegressionC0 commentStamp: '<historical>' prior: 0!
We only have C0 continuity at the junction points between the strokes. 
The tangents to the control point are computed at best with a linear regression at both extremity of the stroke.!

!PaperMorph methodsFor: 'accessing' stamp: 'hlsf 4/1/2023 12:54:30'!
samples
	^ samples! !

!PaperMorph methodsFor: 'accessing' stamp: 'hlsf 4/1/2023 12:50:46'!
samplesQty
"Number of samples before instantiating a new hand stroke"
	^ self valueOfProperty: #samplesQty! !

!PaperMorph methodsFor: 'accessing' stamp: 'hlsf 4/1/2023 14:29:30'!
stroker: aStrokerClass
	stroker := aStrokerClass on: self! !

!PaperMorph methodsFor: 'accessing' stamp: 'hlsf 4/1/2023 22:36:02'!
strokes
	^ stroker strokes! !

!PaperMorph methodsFor: 'accessing' stamp: 'hlsf 3/28/2023 20:24:48'!
threshold
"Minimum squared distance between two consecutive samples"
	^ self valueOfProperty: #threshold! !

!PaperMorph methodsFor: 'drawing' stamp: 'hlsf 4/1/2023 15:57:34'!
drawMouseStrokesOn: canvas
"Draw the line connecting the samples, for user comfort"	
	mousePositions do: [:s | 
		canvas fillColor: Color orange do: [ canvas circleCenter: s radius: 1]	].
! !

!PaperMorph methodsFor: 'drawing' stamp: 'hlsf 4/1/2023 22:36:28'!
drawOn: canvas
	super drawOn: canvas.
	self showMouseStrokes ifTrue: [self drawMouseStrokesOn: canvas].
	self strokes do: [:s | canvas strokeWidth: 1 color: Color black do: [ s drawOn: canvas]].
	self showTangents ifTrue: [self strokes do: [:s | s drawTangentsOn: canvas]].
	self showPoints ifTrue: [self strokes do: [:s | s drawPointsOn: canvas]].
	self showControls ifTrue: [self strokes do: [:s | s drawControlsOn: canvas]]	! !

!PaperMorph methodsFor: 'event handling testing' stamp: 'hlsf 3/23/2023 12:10:09'!
handlesMouseDown: event
	^ true! !

!PaperMorph methodsFor: 'events' stamp: 'hlsf 3/28/2023 20:42:30'!
mouseButton1Down: event localPosition: localPosition
" We start sampling user hand strokes from this position"
	self resetSamplingTo: localPosition
	
! !

!PaperMorph methodsFor: 'events' stamp: 'hlsf 4/1/2023 22:36:44'!
mouseButton1Up: event localPosition: localPosition
	samples add: localPosition.
	"In case there is not enought sample, clone the last one"
	self samplesQty - samples size timesRepeat: [	samples add: samples last].
	stroker newStroke.
	self resetSamplingTo: nil.
	self redrawNeeded 
! !

!PaperMorph methodsFor: 'events' stamp: 'hlsf 4/1/2023 22:36:53'!
mouseMove: event localPosition: localPosition
	event mouseButton1Pressed not ifTrue: [^ self ].
	(mousePositions isEmpty 
	or: [(mousePositions last squaredDistanceTo: localPosition) > 4]) ifTrue: [
		mousePositions add: localPosition].	
	(samples last squaredDistanceTo: localPosition) > self threshold 		ifTrue: [	
		samples add: localPosition.
		samples size = self samplesQty			ifTrue: [
			stroker newStroke.
			self resetSamplingTo: localPosition]
		].
	self redrawNeeded! !

!PaperMorph methodsFor: 'geometry testing' stamp: 'hlsf 3/23/2023 21:23:17'!
requiresVectorCanvas
	^ true! !

!PaperMorph methodsFor: 'initialization' stamp: 'hlsf 4/1/2023 22:38:04'!
initialize
	super initialize.
	extent := 400@400.
	samples := OrderedCollection new.
	mousePositions := OrderedCollection new.
	pen := Pencil new color: Color black.
	self color: Color white.
	self setProperty: #samplesQty toValue: 4.
	self setProperty: #threshold toValue: 2 squared
	! !

!PaperMorph methodsFor: 'menus' stamp: 'hlsf 4/1/2023 12:51:44'!
addStandardHaloMenuItemsTo: aCustomMenu hand: aHandMorph
	aCustomMenu 
		add: 'samples quantity' action: #setSampleQty;
		add: 'sampling threshold' action: #setThreshold;
		addUpdating: #showPointsString action: #pointsOnOff;
		addUpdating: #showControlsString action: #controlsOnOff;
		addUpdating: #showTangentsString action: #tangentsOnOff;
		addUpdating: #showMouseStrokesString action: #mouseStrokesOnOff;
		add: 'clear' action: #clearStrokes! !

!PaperMorph methodsFor: 'menus' stamp: 'hlsf 3/27/2023 21:52:11'!
controlsOnOff
	self 
		setProperty: #showControls
		toValue: self showControls not.
	self redrawNeeded ! !

!PaperMorph methodsFor: 'menus' stamp: 'hlsf 3/31/2023 23:38:40'!
mouseStrokesOnOff
	self 
		setProperty: #showMouseStrokes
		toValue: self showMouseStrokes not.
	self redrawNeeded ! !

!PaperMorph methodsFor: 'menus' stamp: 'hlsf 3/27/2023 21:52:05'!
pointsOnOff
	self 
		setProperty: #showPoints
		toValue: self showPoints not.
	self redrawNeeded ! !

!PaperMorph methodsFor: 'menus' stamp: 'hlsf 4/1/2023 12:54:05'!
setSampleQty
	self 
		request: 'Number of sample to create a new stroke'
		initialAnswer: self samplesQty asString
		verifying: [:aString | aString asInteger notNil ]
		do: [:aString | | integer |
			integer := aString asInteger.
			(integer notNil and: [integer >=3]) ifTrue: [
				self setProperty: #samplesQty toValue: integer.
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

!PaperMorph methodsFor: 'menus' stamp: 'hlsf 3/31/2023 23:38:00'!
showMouseStrokes
	^ self valueOfProperty: #showMouseStrokes ifAbsent: [false]! !

!PaperMorph methodsFor: 'menus' stamp: 'hlsf 3/31/2023 23:37:33'!
showMouseStrokesString
	^ self showMouseStrokes asMenuItemTextPrefix , 
		'show mouse strokes'! !

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

!PaperMorph methodsFor: 'strokes' stamp: 'hlsf 4/1/2023 22:37:57'!
clearStrokes
	self resetSamplingTo: nil.
	mousePositions := OrderedCollection new. "To remove, see resetSampling: "
	stroker clearStrokes.
	self redrawNeeded ! !

!PaperMorph methodsFor: 'strokes' stamp: 'hlsf 4/1/2023 21:01:59'!
resetSamplingTo: aPoint
	samples removeAll.
	"mousePositions removeAll"
	aPoint ifNotNil: [
		samples add: aPoint.
		mousePositions add: aPoint]
! !

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

!StrokeBezier2 methodsFor: 'accessing' stamp: 'hlsf 3/23/2023 14:51:46'!
color
	^ color! !

!StrokeBezier2 methodsFor: 'accessing' stamp: 'hlsf 3/23/2023 14:51:39'!
color: aColor
	color := aColor ! !

!StrokeBezier2 methodsFor: 'accessing' stamp: 'hlsf 3/23/2023 21:19:29'!
control
	^ c! !

!StrokeBezier2 methodsFor: 'accessing' stamp: 'hlsf 3/23/2023 21:21:04'!
end
	^ p2! !

!StrokeBezier2 methodsFor: 'accessing' stamp: 'hlsf 4/1/2023 22:44:40'!
end: aPoint
	 p2 := aPoint ! !

!StrokeBezier2 methodsFor: 'accessing' stamp: 'hlsf 3/23/2023 21:20:59'!
start
	^ p1! !

!StrokeBezier2 methodsFor: 'accessing' stamp: 'hlsf 4/1/2023 22:44:51'!
start: aPoint
	p1 := aPoint ! !

!StrokeBezier2 methodsFor: 'accessing' stamp: 'hlsf 3/23/2023 20:58:52'!
start: startPoint end: endPoint control: controlPoint
	p1 := startPoint.
	p2 := endPoint .
	c := controlPoint ! !

!StrokeBezier2 methodsFor: 'accessing' stamp: 'hlsf 3/23/2023 14:51:54'!
width
	^ width ! !

!StrokeBezier2 methodsFor: 'accessing' stamp: 'hlsf 3/23/2023 14:52:12'!
width: aNumber
	width := aNumber ! !

!StrokeBezier2 methodsFor: 'printing' stamp: 'hlsf 3/26/2023 14:03:55'!
printOn: str
	super printOn: str.
	str nextPutAll: ' p1: ';
		nextPutAll: (p1 printShowingDecimalPlaces: 1);
		nextPutAll: ' p2: ';
		nextPutAll: (p2 printShowingDecimalPlaces: 1);		
		nextPutAll: ' c: ';
		nextPutAll: (c ifNotNil: [c printShowingDecimalPlaces: 1] ifNil: ['nil'])
	
! !

!StrokeBezier2 methodsFor: 'drawing' stamp: 'hlsf 4/1/2023 15:57:12'!
drawControlsOn: canvas
	c ifNotNil: [ canvas fillColor: Color red do: [	canvas circleCenter: c radius: 1.5]]! !

!StrokeBezier2 methodsFor: 'drawing' stamp: 'hlsf 4/1/2023 14:37:32'!
drawOn: canvas
	canvas moveTo: p1.
	c ifNil: [canvas lineTo: p2]	 ifNotNil: [canvas quadraticBezierTo: p2 control: c]! !

!StrokeBezier2 methodsFor: 'drawing' stamp: 'hlsf 4/1/2023 15:57:18'!
drawPointsOn: canvas
	canvas fillColor: Color blue do: [canvas circleCenter: p1 radius: 1.5].
	canvas fillColor: Color blue do: [canvas circleCenter: p2 radius: 1.5]! !

!StrokeBezier2 methodsFor: 'drawing' stamp: 'hlsf 4/1/2023 14:41:39'!
drawTangentsOn: canvas
	c ifNotNil: [
		canvas strokeWidth: 0.8 color: Color green do: [		
				canvas moveTo: p1.
				canvas lineTo: c.
				canvas lineTo: p2] ]! !

!Stroker methodsFor: 'instance' stamp: 'hlsf 4/1/2023 22:44:01'!
newStroke
	| newStroke lastStroke junctionPoint |
	lastStroke := strokes ifEmpty: [nil] ifNotEmpty: [strokes last].
	newStroke := StrokeBezier2 new
		start: self samples first
		end: self samples last
		control: self controlPoint;
		yourself.
	strokes add: newStroke .
	(lastStroke notNil and: [lastStroke end == newStroke start]) ifTrue: [	
		junctionPoint := (lastStroke control + newStroke control) / 2.0.
		lastStroke end: junctionPoint.
		newStroke start: junctionPoint].
	
	! !

!Stroker methodsFor: 'accessing' stamp: 'hlsf 4/1/2023 22:37:40'!
clearStrokes
	strokes removeAll! !

!Stroker methodsFor: 'accessing' stamp: 'hlsf 4/1/2023 12:32:38'!
paper: aPaperMorph
	paper := aPaperMorph ! !

!Stroker methodsFor: 'accessing' stamp: 'hlsf 4/1/2023 12:53:07'!
samples
"samples used to compute a new stroke"
	^ paper samples! !

!Stroker methodsFor: 'accessing' stamp: 'hlsf 4/1/2023 12:54:48'!
samplesQty
"Quantity of samples used to compute a new stroke"
	^ paper samplesQty! !

!Stroker methodsFor: 'accessing' stamp: 'hlsf 4/1/2023 22:34:40'!
strokes
"Existing stroke in the paper morph"
	^ strokes! !

!Stroker methodsFor: 'compute' stamp: 'hlsf 4/1/2023 22:19:35'!
controlPoint
" Naively take the middle point in the samples collection 
"
	^ self samples middle
! !

!Stroker methodsFor: 'compute' stamp: 'hlsf 4/1/2023 22:34:59'!
initialize
	super initialize.
	strokes := OrderedCollection new.! !

!Stroker methodsFor: 'compute' stamp: 'hlsf 4/1/2023 12:56:11'!
intersectionOrigin1: p1 vector1: v1 origin2: p2 vector2: v2
| det c1 c2 |
	det := v1 crossProduct: v2.
	det squared < 1e-8 ifTrue: [^ nil].
	c1 := p1 crossProduct: v1.
	c2 := p2 crossProduct: v2.
	^ ((c2 * v1 x - (c1 * v2 x) ) / det) @ ((v1 y * c2 - (v2 y * c1)) / det)! !

!Stroker class methodsFor: 'instance creation' stamp: 'hlsf 4/1/2023 14:29:08'!
on: aPaperMorph
	^ self new ::
		paper: aPaperMorph ;
		yourself! !

!StrokerC0 methodsFor: 'as yet unclassified' stamp: 'hlsf 4/1/2023 16:11:18'!
controlPoint
" 
	Compute the control point according to current and previous stroke. 
	No rocket science here to compute the tangents to the control point: 
	asume (S0S1) and (S(n-1)Sn) where S is the collection 	of mouse samples 
"
	| samples |
	samples := self samples.
	^ self
		intersectionOrigin1: samples first
		vector1: samples second - samples first
		origin2: samples last
		vector2: (samples atLast: 2) - samples last! !

!StrokerC1 methodsFor: 'as yet unclassified' stamp: 'hlsf 4/1/2023 22:18:34'!
controlPoint
" 
	Compute the control point according to current and previous stroke. 
	No rocket science here to compute the tangents to the control point: 
	asume (S0S1) and (S(n-1)Sn) where S is the collection 	of mouse samples 
"
	| lastStroke samples |
	samples := self samples.
	lastStroke := self strokes lastIfEmpty: [nil].
	^ (lastStroke notNil and: [
		lastStroke control notNil and: [ lastStroke end == samples first ]])
		ifTrue: [ " we have continuity, ensure we have C1 continuity between the new stroke and the previous one "
			self
				intersectionOrigin1: samples first
				vector1: lastStroke control - samples first
				origin2: samples last
				vector2: (self samples atLast: 2) - samples last ]
		ifFalse: [ " The new stroke is disconnected from the previous one "
			self
				intersectionOrigin1: samples first
				vector1: samples second - samples first
				origin2: samples last
				vector2: (samples atLast: 2) - samples last ].! !

!StrokerRegressionC1 methodsFor: 'compute' stamp: 'hlsf 4/1/2023 15:34:39'!
controlPoint
	" Compute the control point according to current and previous stroke "
	| lastStroke regressionStart regressionEnd count samples |
	count := self samplesQty // 2. "Size collection for regression"
	samples := self samples.
	lastStroke := self strokes lastIfEmpty: [nil].
	^ (lastStroke notNil and: [
		lastStroke control notNil and: [ lastStroke end == samples first ]])
		ifTrue: [
			" we have continuity, ensure we have C1 continuity between the new stroke and the previous one "
			regressionEnd := self regressionFrom: self samplesQty - count to: self samplesQty.
			self
				intersectionOrigin1: samples first
				vector1: lastStroke control - samples first
				origin2: (regressionEnd ifNil: [samples last] ifNotNil: [0@ regressionEnd second])
				vector2:  (regressionEnd ifNil: [0@1] ifNotNil: [1@ regressionEnd first]) 
		]
		ifFalse: [
			" The new stroke is disconnected from the previous one "
			regressionStart := self regressionFrom: 1 to: count.
			regressionEnd := self regressionFrom: self samplesQty - count to: self samplesQty.
			self
				intersectionOrigin1: (regressionStart ifNil: [samples first] ifNotNil: [0@regressionStart second])
				vector1: (regressionStart ifNil: [0@1] ifNotNil: [1@regressionStart first])
				origin2: (regressionEnd ifNil: [samples last] ifNotNil: [0@regressionEnd second])
				vector2: (regressionEnd ifNil: [0@1] ifNotNil: [1@regressionEnd first])
		]! !

!StrokerRegressionC1 methodsFor: 'compute' stamp: 'hlsf 4/1/2023 13:08:47'!
regressionFrom: i to: j
"Compute a linear regression from samples i to j"
	^ (self samples collect: [:position | position x ] from: i to: j) 		
		regression: 	(self samples collect: [:position | position y ] from: i to: j)! !

!StrokerRegressionC0 methodsFor: 'as yet unclassified' stamp: 'hlsf 4/1/2023 15:53:40'!
controlPoint
	" Compute the control point according to current and previous stroke "
	| lastStroke regressionStart regressionEnd count samples |
	count := self samplesQty // 2. "Size collection for regression"
	samples := self samples.
	lastStroke := self strokes lastIfEmpty: [nil].
	regressionStart := self regressionFrom: 1 to: count.
	regressionEnd := self regressionFrom: self samplesQty - count to: self samplesQty.
	^ self
		intersectionOrigin1: (regressionStart ifNil: [samples first] ifNotNil: [0@regressionStart second])
		vector1: (regressionStart ifNil: [0@1] ifNotNil: [1@regressionStart first])
		origin2: (regressionEnd ifNil: [samples last] ifNotNil: [0@regressionEnd second])
		vector2: (regressionEnd ifNil: [0@1] ifNotNil: [1@regressionEnd first])
! !

!Collection methodsFor: '*Paper' stamp: 'hlsf 3/31/2023 22:22:27'!
covariance: y
	^ (self * y) sum / self size - (self mean * y mean)! !

!Collection methodsFor: '*Paper' stamp: 'hlsf 4/1/2023 15:28:39'!
regression: y
"Linear regression (least-squares), return a, b of y=ax+b"
	| a b v |
	v := self variance.
	v isZero ifTrue: [^nil]. "points are vertically aligned"
	a := (self covariance: y) / v.
	b := y mean - (a * self mean).
	^ Array with: a with: b! !

!Collection methodsFor: '*Paper' stamp: 'hlsf 3/31/2023 22:01:21'!
variance
	^ self squared sum / self size - self mean squared! !