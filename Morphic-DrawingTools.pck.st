'From Cuis 5.0 [latest update: #4520] on 14 January 2021 at 4:44:39 pm'!
'Description '!
!provides: 'Morphic-DrawingTools' 1 15!
!requires: 'VectorGraphics' 1 185 nil!
SystemOrganization addCategory: 'Morphic-DrawingTools'!


!classDefinition: #CompassMorph category: 'Morphic-DrawingTools'!
MovableMorph subclass: #CompassMorph
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Morphic-DrawingTools'!
!classDefinition: 'CompassMorph class' category: 'Morphic-DrawingTools'!
CompassMorph class
	instanceVariableNames: ''!

!classDefinition: #ProtractorMorph category: 'Morphic-DrawingTools'!
MovableMorph subclass: #ProtractorMorph
	instanceVariableNames: 'previousHandPosition'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Morphic-DrawingTools'!
!classDefinition: 'ProtractorMorph class' category: 'Morphic-DrawingTools'!
ProtractorMorph class
	instanceVariableNames: ''!

!classDefinition: #RulerMorph category: 'Morphic-DrawingTools'!
MovableMorph subclass: #RulerMorph
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Morphic-DrawingTools'!
!classDefinition: 'RulerMorph class' category: 'Morphic-DrawingTools'!
RulerMorph class
	instanceVariableNames: ''!

!classDefinition: #SetSquareMorph category: 'Morphic-DrawingTools'!
MovableMorph subclass: #SetSquareMorph
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Morphic-DrawingTools'!
!classDefinition: 'SetSquareMorph class' category: 'Morphic-DrawingTools'!
SetSquareMorph class
	instanceVariableNames: ''!


!ProtractorMorph methodsFor: 'drawing' stamp: 'hlsf 1/13/2021 19:57:57'!
drawOn: canvas
|  p1 p2 |
	canvas strokeWidth: 0.2 color: Color black fillColor: (Color yellow alpha: 0.6) do: [: engine |
		engine abs_MoveToX: 100 negated y: 0.
		engine abs_ArcToX: 100 y: 0 radiusX: 100 radiusY: 100 angleOfXAxis: 0 largeFlag: true sweepFlag: true.
		engine abs_LineToX: -100 y: 		0		].
	canvas strokeWidth: 1 color: Color black do: [
		canvas moveToX: 0 y: -0.5; lineToX: 0 y: -8].
	-180 to: 0 do: [:degree |
		canvas strokeWidth: 0.5 color: Color black do: [:engine |
			p1 _ Point r: 100 degrees: degree.
			p2 _ Point r: 95 degrees: degree.
			engine abs_MoveToX: p1 x y: p1 y; abs_LineToX: p2 x y: p2 y]]		.
	-170 to: -10 by: 10 do: [:degree |
		canvas strokeWidth: 1 color: Color black do: [:engine |
			p1 _ Point r: 100 degrees: degree.
			p2 _ Point r: 90 degrees: degree.
			engine abs_MoveToX: p1 x y: p1 y; abs_LineToX: p2 x y: p2 y]].
	-175 to: -5 by: 10 do: [:degree |
		canvas strokeWidth: 0.6 color: Color black do: [:engine |
			p1 _ Point r: 100 degrees: degree.
			p2 _ Point r: 92 degrees: degree.
			engine abs_MoveToX: p1 x y: p1 y; abs_LineToX: p2 x y: p2 y]]! !

!ProtractorMorph methodsFor: 'initialization' stamp: 'hlsf 1/14/2021 14:56:24'!
addLabel: string font: font centeredAt: position rotationDegrees: angle
"Add a label top-centered at position and rotated of angle degrees"
	| p label |
	p _ position - (position normal * (font widthOfString: string asString) / 2). 
	label _ LabelMorph contents: string font: font.
	label rotation: (90 - angle) degreesToRadians.
	self addMorph: label.
	label morphPosition: p.
	^ label! !

!ProtractorMorph methodsFor: 'initialization' stamp: 'hlsf 1/14/2021 15:34:05'!
initialize
| font btn |
	super initialize .
	font _ FontFamily familyName: FontFamily defaultFamilyName pointSize: 4.
	10 to: 170 by: 10 do: [:angle | 
		self 
			addLabel: angle asString 
			font: font 
			centeredAt: (Point r: 88 degrees: angle negated)
			rotationDegrees: angle].
	btn _ PluggableButtonMorph new label: 'O' font: font.
	btn model: self ;
		actWhen: #buttonStillDown;
		action: #rotateProtractor.
	self addMorph: btn.
	btn morphPosition: 60 @ -20! !

!ProtractorMorph methodsFor: 'action' stamp: 'hlsf 1/14/2021 16:43:36'!
rotateProtractor
	| event p1 v1 v2|
	"any thing new to do?"
	self activeHand hasChanged ifFalse: [^self ].
	event _ self activeHand lastMouseEvent.
	event isMove 
		ifTrue: [
			p1 _ location transform: 0@0.
			v1 _ previousHandPosition - p1.
			previousHandPosition _ event eventPosition.
			v2 _ 	previousHandPosition - p1.
			(v1 isZero or: [v2 isZero]) ifTrue: [^self].
			self rotateBy:  ((v1 crossProduct: v2) / (v1 r * v2 r)) arcSin	] 
		ifFalse: [
			previousHandPosition _ event eventPosition].! !

!RulerMorph methodsFor: 'drawing' stamp: 'hlsf 1/12/2021 14:35:14'!
drawOn: canvas
	| length font |
	font _ FontFamily familyName: FontFamily defaultFamilyName pointSize: 4.
	length _ 205.
	canvas strokeWidth: 1 color: Color black fillColor: (Color yellow alpha: 0.8) do: [
		canvas roundRectangleMinX: -5 maxX: length minY: 0 maxY: 40 rx: 2 ry: 5].
	canvas strokeWidth: 0 color: Color black fillColor: (Color yellow alpha: 0.8) do: [
		canvas rectangleMinX: -4 maxX: length - 1 minY:  1 maxY: 15].
	
	canvas strokeWidth: 1 color: Color black do: [
		0 to: length - 5  by: 10 do: [:x |
		canvas moveToX: x y: 0.5;
			lineToX: x y: 5]].
	0 to: length - 5  by: 10 do: [:x |
		canvas drawString: (x//10) asString atCenterX: x@8 font: font color: Color black		].! !

!SetSquareMorph methodsFor: 'as yet unclassified' stamp: 'hlsf 1/12/2021 14:53:50'!
drawOn: canvas
	| length  |
	length _ 205.
	canvas strokeWidth: 1 color: Color black fillColor: (Color yellow alpha: 0.8) do: [
		canvas moveToX: 0 y: 0 negated; lineToX: length / 2.0 y: 0; lineToX: 0 y: length negated].
	canvas strokeWidth: 1 color: Color black fillColor: (Color white alpha: 1 ) do: [
		canvas moveToX: 20 y: 20 negated; lineToX: length / 2.0 -30 y: -20; lineToX: 20 y: length negated + 80]
	
	
	! !
