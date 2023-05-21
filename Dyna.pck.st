'From Cuis 6.0 [latest update: #5799] on 21 May 2023 at 10:45:33 pm'!
'Description '!
!provides: 'Dyna' 1 0!
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
Describes one or more contiguous teaching periods.!

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
