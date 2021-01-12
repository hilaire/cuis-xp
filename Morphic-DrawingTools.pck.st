'From Cuis 5.0 [latest update: #4520] on 12 January 2021 at 9:23:30 pm'!
'Description '!
!provides: 'Morphic-DrawingTools' 1 9!
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
	instanceVariableNames: ''
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


!ProtractorMorph methodsFor: 'drawing' stamp: 'hlsf 1/12/2021 19:52:43'!
drawOn: canvas
| length p1 p2 |
	length _ 100.
	canvas strokeWidth: 1 color: Color black fillColor: (Color yellow alpha: 0.6) do: [: engine |
		engine abs_MoveToX: length negated y: 0.
		engine abs_ArcToX: length y: 0 radiusX: length radiusY: length angleOfXAxis: 0 largeFlag: true sweepFlag: true.
		engine abs_LineToX: length negated y: 		0		].
	canvas strokeWidth: 1 color: Color black do: [
		canvas moveToX: 0 y: -0.5; lineToX: 0 y: -8].
	-180 to: 0 do: [:degree |
		canvas strokeWidth: 0.5 color: Color black do: [:engine |
			p1 _ Point r: length degrees: degree.
			p2 _ Point r: length - 5 degrees: degree.
			engine abs_MoveToX: p1 x y: p1 y; abs_LineToX: p2 x y: p2 y]]		.
	-180 to: 0 by: 10 do: [:degree |
		canvas strokeWidth: 1 color: Color black do: [:engine |
			p1 _ Point r: length degrees: degree.
			p2 _ Point r: length - 10 degrees: degree.
			engine abs_MoveToX: p1 x y: p1 y; abs_LineToX: p2 x y: p2 y]]! !

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
