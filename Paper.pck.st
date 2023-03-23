'From Cuis 6.0 [latest update: #5716] on 23 March 2023 at 9:44:58 pm'!
'Description '!
!provides: 'Paper' 1 3!
SystemOrganization addCategory: 'Paper'!


!classDefinition: #PaperMorph category: 'Paper'!
BoxedMorph subclass: #PaperMorph
	instanceVariableNames: 'currentStroke strokes pen samples'
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

!PaperMorph methodsFor: 'initialization' stamp: 'hlsf 3/23/2023 21:26:21'!
initialize
	super initialize.
	extent := 400@400.
	strokes := OrderedCollection new.
	pen := Pencil new color: Color black.
	self color: Color white
	! !

!PaperMorph methodsFor: 'as yet unclassified' stamp: 'hlsf 3/23/2023 21:29:08'!
addStroke
	| controlPoint stroke |
	samples size < 3 ifTrue: [self].
	controlPoint := self 
		intersectionOrigin1: samples first vector1: samples second - samples first
		origin2: samples last vector2: (samples atLast: 2) - samples last. 
	stroke := Stroke new
		start: samples first end: samples last control: controlPoint.
	strokes add: stroke.
	self redrawNeeded ! !

!PaperMorph methodsFor: 'as yet unclassified' stamp: 'hlsf 3/23/2023 21:26:39'!
drawOn: canvas
	super drawOn: canvas.
	canvas strokeWidth: 2 color: Color black do: [
		strokes do: [:s |
			canvas moveTo: s start.
			s control 
				ifNil: [canvas lineTo: s end]
				ifNotNil: [	canvas quadraticBezierTo: s end control: s control]				]
			]! !

!PaperMorph methodsFor: 'as yet unclassified' stamp: 'hlsf 3/23/2023 21:04:55'!
intersectionOrigin1: p1 vector1: v1 origin2: p2 vector2: v2
| det c1 c2 |
	det := v1 crossProduct: v2.
	(det closeTo: 0) ifTrue: [^ nil].
	c1 := p1 crossProduct: v1.
	c2 := p2 crossProduct: v2.
	^ ((c2 * v1 x - (c1 * v2 x) ) / det) @ ((v1 y * c2 - (v2 y * c1)) / det)! !

!PaperMorph methodsFor: 'as yet unclassified' stamp: 'hlsf 3/23/2023 21:23:17'!
requiresVectorCanvas
	^ true! !

!PaperMorph methodsFor: 'events' stamp: 'hlsf 3/23/2023 15:11:55'!
mouseButton1Down: event localPosition: localPosition
	" We are going to sample the user hand strokes "
	samples := OrderedCollection with: localPosition
! !

!PaperMorph methodsFor: 'events' stamp: 'hlsf 3/23/2023 21:05:38'!
mouseButton1Up: event localPosition: localPosition
	samples add: localPosition.
	self addStroke
! !

!PaperMorph methodsFor: 'events' stamp: 'hlsf 3/23/2023 15:01:13'!
mouseHover: event localPosition: localPosition
	pen position: localPosition ! !

!PaperMorph methodsFor: 'events' stamp: 'hlsf 3/23/2023 21:42:44'!
mouseMove: event localPosition: localPosition
	(samples last squaredDistanceTo: localPosition) > 36 
		ifTrue: [	samples add: localPosition.
		samples size = 3 
			ifTrue: [
				self addStroke.
				samples := OrderedCollection with: localPosition]
		]! !

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

!Stroke methodsFor: 'as yet unclassified' stamp: 'hlsf 3/23/2023 21:42:11'!
printOn: str
	super printOn: str.
	str nextPutAll: ' p1: '.
	p1 printOn: str.
	str nextPutAll: 'p2: '.
	p2 printOn: str.
	str nextPutAll: ' c: '.
	c printOn: str.
	
! !
