'From Cuis 6.0 [latest update: #5799] on 22 May 2023 at 10:23:47 pm'!
'Description '!
!provides: 'Dyna' 1 2!
SystemOrganization addCategory: 'Dyna'!


!classDefinition: #DyBAgenda category: 'Dyna'!
Object subclass: #DyBAgenda
	instanceVariableNames: 'start end daysOff assignments'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Dyna'!
!classDefinition: 'DyBAgenda class' category: 'Dyna'!
DyBAgenda class
	instanceVariableNames: ''!

!classDefinition: #DyBApp category: 'Dyna'!
Object subclass: #DyBApp
	instanceVariableNames: 'user schools agenda'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Dyna'!
!classDefinition: 'DyBApp class' category: 'Dyna'!
DyBApp class
	instanceVariableNames: ''!

!classDefinition: #DyBClassGroup category: 'Dyna'!
Object subclass: #DyBClassGroup
	instanceVariableNames: 'number headTeacher students courses'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Dyna'!
!classDefinition: 'DyBClassGroup class' category: 'Dyna'!
DyBClassGroup class
	instanceVariableNames: ''!

!classDefinition: #DyBCourse category: 'Dyna'!
Object subclass: #DyBCourse
	instanceVariableNames: 'subject color teacher courseHours binder'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Dyna'!
!classDefinition: 'DyBCourse class' category: 'Dyna'!
DyBCourse class
	instanceVariableNames: ''!

!classDefinition: #DyBCourseHour category: 'Dyna'!
Object subclass: #DyBCourseHour
	instanceVariableNames: 'room dayOfWeek timeSlots'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Dyna'!
!classDefinition: 'DyBCourseHour class' category: 'Dyna'!
DyBCourseHour class
	instanceVariableNames: ''!

!classDefinition: #DyBPerson category: 'Dyna'!
Object subclass: #DyBPerson
	instanceVariableNames: 'lastName firstName email'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Dyna'!
!classDefinition: 'DyBPerson class' category: 'Dyna'!
DyBPerson class
	instanceVariableNames: ''!

!classDefinition: #DyBStudent category: 'Dyna'!
DyBPerson subclass: #DyBStudent
	instanceVariableNames: 'classGroup'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Dyna'!
!classDefinition: 'DyBStudent class' category: 'Dyna'!
DyBStudent class
	instanceVariableNames: ''!

!classDefinition: #DyBTeacher category: 'Dyna'!
DyBPerson subclass: #DyBTeacher
	instanceVariableNames: 'classGroups'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Dyna'!
!classDefinition: 'DyBTeacher class' category: 'Dyna'!
DyBTeacher class
	instanceVariableNames: ''!

!classDefinition: #DyBSchool category: 'Dyna'!
Object subclass: #DyBSchool
	instanceVariableNames: 'name phone email timeSlots subject classGroups'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Dyna'!
!classDefinition: 'DyBSchool class' category: 'Dyna'!
DyBSchool class
	instanceVariableNames: ''!

!classDefinition: #DyBTimeSlot category: 'Dyna'!
Object subclass: #DyBTimeSlot
	instanceVariableNames: 'name startTime endTime'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Dyna'!
!classDefinition: 'DyBTimeSlot class' category: 'Dyna'!
DyBTimeSlot class
	instanceVariableNames: ''!

!classDefinition: #DyBinder category: 'Dyna'!
Object subclass: #DyBinder
	instanceVariableNames: 'topics last resources'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Dyna'!
!classDefinition: 'DyBinder class' category: 'Dyna'!
DyBinder class
	instanceVariableNames: ''!

!classDefinition: #DyTopic category: 'Dyna'!
Object subclass: #DyTopic
	instanceVariableNames: 'title color documents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Dyna'!
!classDefinition: 'DyTopic class' category: 'Dyna'!
DyTopic class
	instanceVariableNames: ''!


!DyBAgenda commentStamp: '<historical>' prior: 0!
The place to record teacher assignments or other events. It follows the user times slots as describe in its attached school instance
!

!DyBApp commentStamp: '<historical>' prior: 0!
- user may be a DBTeacher or DBStudent!

!DyBClassGroup commentStamp: '<historical>' prior: 0!
It describes a class: its number, the list of its students, taught courses, etc.
!

!DyBCourse commentStamp: '<historical>' prior: 0!
It is useful for the teacher and student to describe all of their courses.!

!DyBCourseHour commentStamp: '<historical>' prior: 0!
Describes one or more contiguous teaching periods.

timeSlots := ListMultiModel with: aSchool timeSlots :: selectedIndexes: #()!

!DyBStudent commentStamp: '<historical>' prior: 0!
- classGroup: the class the student belong to!

!DyBTeacher commentStamp: '<historical>' prior: 0!
- classGroups: the classes the teacher teaches!

!DyBSchool commentStamp: '<historical>' prior: 0!
Description of the user's educational institutions. Possibly several per user.
!

!DyBTimeSlot commentStamp: '<historical>' prior: 0!
Describe the organization of the teaching periods in a school. There are generally 10 time slots per school.
Example of a time slot: P2, 9:25am, 10:10am!

!DyBinder commentStamp: '<historical>' prior: 0!
A binder contains the pedagogical materials related to a given course. 
!

!DyTopic commentStamp: '<historical>' prior: 0!
Pedagogical document grouped in one topic.!

!DyBTimeSlot methodsFor: 'as yet unclassified' stamp: 'hlsf 5/22/2023 20:08:23'!
mold
	| mold start |
	mold := Mold new.
	mold stringField
		label: 'Name' translated;
		on: #slotName of: self;
		beRequired.
	(start := mold timeField)
		label: 'Start time' translated;
		example: '8:35';
		on: #start of: self;
		beRequired.
	mold timeField 
		label: 'End time' translated;
		on: #end of: self;
		addCondition: [:input :value | input isEmptyOrNil or: [value > start value ] ]
			labeled: 'End time can''t preced start time.' translated.
	^ mold
	! !

!DyBTimeSlot methodsFor: 'accessing' stamp: 'hlsf 5/22/2023 19:58:55'!
end
	^ endTime! !

!DyBTimeSlot methodsFor: 'accessing' stamp: 'hlsf 5/22/2023 20:01:48'!
end: aTime
	endTime := aTime! !

!DyBTimeSlot methodsFor: 'accessing' stamp: 'hlsf 5/22/2023 19:58:11'!
slotName
	^ name! !

!DyBTimeSlot methodsFor: 'accessing' stamp: 'hlsf 5/22/2023 20:02:10'!
slotName: aString
	name := 	aString ! !

!DyBTimeSlot methodsFor: 'accessing' stamp: 'hlsf 5/22/2023 19:56:55'!
start
	^ startTime ! !

!DyBTimeSlot methodsFor: 'accessing' stamp: 'hlsf 5/22/2023 20:01:59'!
start: aTime
	startTime := aTime ! !

!DyBTimeSlot methodsFor: 'printing' stamp: 'hlsf 5/22/2023 22:04:28'!
printOn: aStream
	name ifNil: [ super printOn: aStream ]
		ifNotNil: [	
			aStream nextPutAll: name;
				space;
				nextPutAll: startTime hhmm24 ;
				nextPut: $-;
				nextPutAll: endTime hhmm24 ]! !
