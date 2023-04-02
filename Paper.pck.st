'From Cuis 6.0 [latest update: #5733] on 2 April 2023 at 11:18:45 pm'!
'Description '!
!provides: 'Paper' 1 33!
SystemOrganization addCategory: 'Paper'!


!classDefinition: #PaperMorph category: 'Paper'!
BoxedMorph subclass: #PaperMorph
	instanceVariableNames: 'stroker pen samples sampleIndex'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Paper'!
!classDefinition: 'PaperMorph class' category: 'Paper'!
PaperMorph class
	instanceVariableNames: ''!

!classDefinition: #Bezier2Morph category: 'Paper'!
Morph subclass: #Bezier2Morph
	instanceVariableNames: 'color width p1 p2 c1'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Paper'!
!classDefinition: 'Bezier2Morph class' category: 'Paper'!
Bezier2Morph class
	instanceVariableNames: ''!

!classDefinition: #Bezier3Morph category: 'Paper'!
Bezier2Morph subclass: #Bezier3Morph
	instanceVariableNames: 'c2'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Paper'!
!classDefinition: 'Bezier3Morph class' category: 'Paper'!
Bezier3Morph class
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

!classDefinition: #StrokerBezier2 category: 'Paper'!
Object subclass: #StrokerBezier2
	instanceVariableNames: 'paper strokes'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Paper'!
!classDefinition: 'StrokerBezier2 class' category: 'Paper'!
StrokerBezier2 class
	instanceVariableNames: ''!

!classDefinition: #StrokerBezier3 category: 'Paper'!
StrokerBezier2 subclass: #StrokerBezier3
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Paper'!
!classDefinition: 'StrokerBezier3 class' category: 'Paper'!
StrokerBezier3 class
	instanceVariableNames: ''!


!PaperMorph commentStamp: '<historical>' prior: 0!
- stroker:  an object to compute a stroke
- samples: an array of fixed size, collected mouse positions
- samplesQty: quantity of required samples to compute a stroke
- sampleIndex: the index of the next sample to collect

(PaperMorph new stroker: StrokerBezier2 ) openInWorld. "Quadratic Bézier"
(PaperMorph new stroker: StrokerBezier3 ) openInWorld. "Cubic Bézier"
!

!Bezier2Morph commentStamp: '<historical>' prior: 0!
A quadratic Bézier stroke!

!Bezier3Morph commentStamp: '<historical>' prior: 0!
A cubic Bézier stroke!

!StrokerBezier2 commentStamp: '<historical>' prior: 0!
Given samples of mouse positions and previous strokes, I compute a new Bézier quadratic stroke . 
I can be subclassed to adjust my behavior.!

!PaperMorph methodsFor: 'accessing' stamp: 'hlsf 4/1/2023 12:54:30'!
samples
	^ samples! !

!PaperMorph methodsFor: 'accessing' stamp: 'hlsf 4/2/2023 12:39:15'!
samplesQty
"Number of samples before instantiating a new hand stroke"
	^ samples size! !

!PaperMorph methodsFor: 'accessing' stamp: 'hlsf 4/2/2023 14:28:07'!
stroker: aStrokerClass
	stroker := aStrokerClass on: self.
	samples := Array new: stroker samplesQty.
	sampleIndex := 1.! !

!PaperMorph methodsFor: 'accessing' stamp: 'hlsf 3/28/2023 20:24:48'!
threshold
"Minimum squared distance between two consecutive samples"
	^ self valueOfProperty: #threshold! !

!PaperMorph methodsFor: 'drawing' stamp: 'hlsf 4/2/2023 20:51:24'!
draw2On: canvas
	super drawOn: canvas.
	canvas strokeWidth: 1 color: Color black do: [
		self strokes do: [:s |  s drawOn: canvas].
		sampleIndex > 1 ifTrue: [
			canvas moveTo: samples first.
			2 to: sampleIndex - 1 do: [:i | canvas lineTo: (samples at: i)]
		]	
	].	
	self showTangents ifTrue: [self strokes do: [:s | s drawTangentsOn: canvas]].
	self showPoints ifTrue: [self strokes do: [:s | s drawPointsOn: canvas]].
	self showControls ifTrue: [self strokes do: [:s | s drawControlsOn: canvas]]	! !

!PaperMorph methodsFor: 'drawing' stamp: 'hlsf 4/2/2023 22:57:09'!
drawOn: canvas
	super drawOn: canvas.
	canvas strokeWidth: 1 color: Color black do: [
		sampleIndex > 1 ifTrue: [
			canvas moveTo: samples first.
			2 to: sampleIndex - 1 do: [:i | canvas lineTo: (samples at: i)]
		]	
	].	
! !

!PaperMorph methodsFor: 'event handling testing' stamp: 'hlsf 3/23/2023 12:10:09'!
handlesMouseDown: event
	^ true! !

!PaperMorph methodsFor: 'events' stamp: 'hlsf 3/28/2023 20:42:30'!
mouseButton1Down: event localPosition: localPosition
" We start sampling user hand strokes from this position"
	self resetSamplingTo: localPosition
	
! !

!PaperMorph methodsFor: 'events' stamp: 'hlsf 4/2/2023 20:48:15'!
mouseButton1Up: event localPosition: localPosition
	samples at: sampleIndex put: localPosition.
	sampleIndex := sampleIndex + 1.
	"In case there is not enought sample, clone the last one"
	sampleIndex to: self samplesQty do: [	:i |		samples at: i put: localPosition].
	self addMorph: stroker newStroke.
	self resetSamplingTo: nil.
	self redrawNeeded 
! !

!PaperMorph methodsFor: 'events' stamp: 'hlsf 4/2/2023 22:00:45'!
mouseMove: event localPosition: localPosition
	event mouseButton1Pressed not ifTrue: [^ self ].
	((samples at: sampleIndex -1) squaredDistanceTo: localPosition) > self threshold 		ifTrue: [	
		samples at: sampleIndex put: localPosition.
		sampleIndex := sampleIndex + 1.
		sampleIndex > self samplesQty			ifTrue: [ |stroke|
			self addMorph: (stroke := stroker newStroke).
			stroke redrawNeeded.
			self resetSamplingTo: localPosition.
			"self redrawNeeded"]
		].
	! !

!PaperMorph methodsFor: 'geometry testing' stamp: 'hlsf 3/23/2023 21:23:17'!
requiresVectorCanvas
	^ true! !

!PaperMorph methodsFor: 'initialization' stamp: 'hlsf 4/2/2023 22:47:42'!
initialize
	super initialize.
	extent := 400@400.
	pen := Pencil new color: Color black.
	self color: Color white.
	self setProperty: #threshold toValue: 6 squared
	! !

!PaperMorph methodsFor: 'menus' stamp: 'hlsf 4/2/2023 21:30:54'!
addStandardHaloMenuItemsTo: aCustomMenu hand: aHandMorph
	aCustomMenu 
		add: 'sampling threshold' action: #setThreshold;
		addUpdating: #showPointsString action: #pointsOnOff;
		addUpdating: #showControlsString action: #controlsOnOff;
		addUpdating: #showTangentsString action: #tangentsOnOff;
		add: 'clear' action: #removeAllMorphs! !

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

!PaperMorph methodsFor: 'strokes' stamp: 'hlsf 4/2/2023 14:23:49'!
resetSamplingTo: aPoint
	sampleIndex := 1.
	aPoint ifNotNil: [
		samples at: 1 put: aPoint.
		sampleIndex := sampleIndex + 1]
! !

!Bezier2Morph methodsFor: 'accessing' stamp: 'hlsf 3/23/2023 14:51:46'!
color
	^ color! !

!Bezier2Morph methodsFor: 'accessing' stamp: 'hlsf 3/23/2023 14:51:39'!
color: aColor
	color := aColor ! !

!Bezier2Morph methodsFor: 'accessing' stamp: 'hlsf 4/2/2023 10:38:09'!
control1
	^ c1! !

!Bezier2Morph methodsFor: 'accessing' stamp: 'hlsf 3/23/2023 21:21:04'!
end
	^ p2! !

!Bezier2Morph methodsFor: 'accessing' stamp: 'hlsf 4/1/2023 22:44:40'!
end: aPoint
	 p2 := aPoint ! !

!Bezier2Morph methodsFor: 'accessing' stamp: 'hlsf 3/23/2023 21:20:59'!
start
	^ p1! !

!Bezier2Morph methodsFor: 'accessing' stamp: 'hlsf 4/1/2023 22:44:51'!
start: aPoint
	p1 := aPoint ! !

!Bezier2Morph methodsFor: 'accessing' stamp: 'hlsf 4/2/2023 10:39:07'!
start: startPoint end: endPoint control1: controlPoint
	p1 := startPoint.
	p2 := endPoint .
	c1 := controlPoint ! !

!Bezier2Morph methodsFor: 'accessing' stamp: 'hlsf 3/23/2023 14:51:54'!
width
	^ width ! !

!Bezier2Morph methodsFor: 'accessing' stamp: 'hlsf 3/23/2023 14:52:12'!
width: aNumber
	width := aNumber ! !

!Bezier2Morph methodsFor: 'printing' stamp: 'hlsf 4/2/2023 10:38:09'!
printOn: str
	super printOn: str.
	str nextPutAll: ' p1: ';
		nextPutAll: (p1 printShowingDecimalPlaces: 1);
		nextPutAll: ' p2: ';
		nextPutAll: (p2 printShowingDecimalPlaces: 1);		
		nextPutAll: ' c: ';
		nextPutAll: (c1 ifNotNil: [c1 printShowingDecimalPlaces: 1] ifNil: ['nil'])
	
! !

!Bezier2Morph methodsFor: 'drawing' stamp: 'hlsf 4/2/2023 22:51:31'!
drawControlsOn: canvas
	canvas fillColor: Color red do: [	canvas circleCenter: c1 radius: 1.5]! !

!Bezier2Morph methodsFor: 'drawing' stamp: 'hlsf 4/2/2023 22:52:33'!
drawOn: canvas
	canvas strokeWidth: 1 color: Color black do: [
		canvas moveTo: p1.
		canvas quadraticBezierTo: p2 control: c1].
	owner showControls ifTrue: [self drawControlsOn: canvas].
	owner showPoints ifTrue: [self drawPointsOn: canvas].
	owner showTangents ifTrue: [self drawTangentsOn: canvas]! !

!Bezier2Morph methodsFor: 'drawing' stamp: 'hlsf 4/1/2023 15:57:18'!
drawPointsOn: canvas
	canvas fillColor: Color blue do: [canvas circleCenter: p1 radius: 1.5].
	canvas fillColor: Color blue do: [canvas circleCenter: p2 radius: 1.5]! !

!Bezier2Morph methodsFor: 'drawing' stamp: 'hlsf 4/2/2023 22:51:18'!
drawTangentsOn: canvas
	canvas strokeWidth: 0.8 color: Color green do: [		
			canvas moveTo: p1.
			canvas lineTo: c1.
			canvas lineTo: p2]! !

!Bezier3Morph methodsFor: 'accessing' stamp: 'hlsf 4/2/2023 14:35:57'!
control2
	^ c2! !

!Bezier3Morph methodsFor: 'accessing' stamp: 'hlsf 4/2/2023 14:37:13'!
start: startPoint end: endPoint control1: controlPoint1 
	self shouldNotImplement ! !

!Bezier3Morph methodsFor: 'accessing' stamp: 'hlsf 4/2/2023 14:29:51'!
start: startPoint end: endPoint control1: controlPoint1 control2: controlPoint2
	p1 := startPoint.
	p2 := endPoint .
	c1 := controlPoint1.
	c2 := controlPoint2 ! !

!Bezier3Morph methodsFor: 'printing' stamp: 'hlsf 4/2/2023 14:31:08'!
printOn: str
	super printOn: str.
	str
		nextPutAll: ' c2: ';
		nextPutAll: (c2 ifNotNil: [c2 printShowingDecimalPlaces: 1] ifNil: ['nil'])
	
! !

!Bezier3Morph methodsFor: 'drawing' stamp: 'hlsf 4/2/2023 22:51:42'!
drawControlsOn: canvas
	super drawControlsOn: canvas.
	canvas fillColor: Color red do: [	canvas circleCenter: c2 radius: 1.5]! !

!Bezier3Morph methodsFor: 'drawing' stamp: 'hlsf 4/2/2023 22:50:19'!
drawOn: canvas
	canvas strokeWidth: 1 color: Color black do: [
		canvas moveTo: p1.
		c1 ifNil: [canvas lineTo: p2]	 ifNotNil: [canvas cubicBezierTo: p2 control1: c1 control2: c2]].
	owner showControls ifTrue: [self drawControlsOn: canvas].
	owner showPoints ifTrue: [self drawPointsOn: canvas].
	owner showTangents ifTrue: [self drawTangentsOn: canvas]! !

!Bezier3Morph methodsFor: 'drawing' stamp: 'hlsf 4/2/2023 14:39:30'!
drawTangentsOn: canvas
	canvas strokeWidth: 0.8 color: Color green do: [		
				canvas moveTo: p1.
				canvas lineTo: c1.
				canvas moveTo: p2.
				canvas lineTo: c2] ! !

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

!StrokerBezier2 methodsFor: 'instance' stamp: 'hlsf 4/2/2023 22:38:49'!
newStroke
	| newStroke lastStroke junctionPoint samples |
	samples := self samples.
	lastStroke := paper hasSubmorphs ifFalse: [nil] ifTrue: [paper firstSubmorph].
	newStroke := Bezier2Morph new
		start: samples first
		end: samples last
		control1: samples second;
		yourself.
	(lastStroke notNil and: [lastStroke end == newStroke start]) ifTrue: [	
		junctionPoint := (lastStroke control1 + newStroke control1) / 2.0.
		lastStroke end: junctionPoint.
		newStroke start: junctionPoint.
		lastStroke redrawNeeded ].
	^ newStroke
	
	! !

!StrokerBezier2 methodsFor: 'accessing' stamp: 'hlsf 4/1/2023 12:32:38'!
paper: aPaperMorph
	paper := aPaperMorph ! !

!StrokerBezier2 methodsFor: 'accessing' stamp: 'hlsf 4/1/2023 12:53:07'!
samples
"samples used to compute a new stroke"
	^ paper samples! !

!StrokerBezier2 methodsFor: 'accessing' stamp: 'hlsf 4/2/2023 14:44:49'!
samplesQty
"Quantity of samples used to compute a new stroke"
	^ 3! !

!StrokerBezier2 methodsFor: 'compute' stamp: 'hlsf 4/1/2023 12:56:11'!
intersectionOrigin1: p1 vector1: v1 origin2: p2 vector2: v2
| det c1 c2 |
	det := v1 crossProduct: v2.
	det squared < 1e-8 ifTrue: [^ nil].
	c1 := p1 crossProduct: v1.
	c2 := p2 crossProduct: v2.
	^ ((c2 * v1 x - (c1 * v2 x) ) / det) @ ((v1 y * c2 - (v2 y * c1)) / det)! !

!StrokerBezier2 class methodsFor: 'instance creation' stamp: 'hlsf 4/1/2023 14:29:08'!
on: aPaperMorph
	^ self new ::
		paper: aPaperMorph ;
		yourself! !

!StrokerBezier3 methodsFor: 'instance' stamp: 'hlsf 4/2/2023 22:49:08'!
newStroke
	| newStroke lastStroke junctionPoint samples |
	samples := self samples.
	lastStroke := paper hasSubmorphs ifFalse: [nil] ifTrue: [paper firstSubmorph].
	newStroke := Bezier3Morph new
		start: samples first
		end: samples last
		control1: samples second
		control2: samples third;
		yourself.
	(lastStroke notNil and: [lastStroke end == newStroke start]) ifTrue: [	
		junctionPoint := (lastStroke control2 + newStroke control1) / 2.0.
		lastStroke end: junctionPoint.
		newStroke start: junctionPoint.
		lastStroke redrawNeeded].
	^ newStroke
	
	! !

!StrokerBezier3 methodsFor: 'accessing' stamp: 'hlsf 4/2/2023 14:44:41'!
samplesQty
"Quantity of samples used to compute a new stroke"
	^ 4! !

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
