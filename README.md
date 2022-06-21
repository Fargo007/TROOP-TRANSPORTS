# TROOP-TRANSPORTS
A more realistic way to handle convoys carrying troops in DCS

## TROOP-TRANSPORTS
seeks to provide a consumable script that can be added into missions where convoy activity is expected, and there is a desire to portray these convoys as carrying armed soldiers of one kind or another. 

## The problem 
There is presently no notion of vehicles carrying combat capable troops in DCS. There are vehicles, and there are troops, but there is no marriage of these two entities directly. Presenting a mission scenario where an engaged truck carrying troops stops and the troops disembark and engage what attacked them is not straightforward.  

**TROOP-TRANSPORTS** simulates real live behaviors to a large extent. Things you will see in the script and would likely see in reality if a vehicle carrying combat troops were engaged (and notionally disabled or blocked):

1. The vehicle will stop, or proceed off the road _("get the vehicle off the X")._
2. The troops will disembark. The truck can't defend itself, but they can defend it.
3. The troops will move away from the vehicle, ASAP _("Get off the X")_ in a random direction.
4. Troops will start engaging any visible enemy (ground, air) with whatever weapons they have.
5. Vehicles not carrying troops will see the panicking driver exit the vehicle and run away (squirter). 
6. After a configurable amount of time, the troops will re-embark, and the vehicles will continue on their route unless they were destroyed.
7. Troops or drivers who bailed out can get left behind if their ride is destroyed. 
8. A vehicle carrying troops that is hard-killed such as with a bomb or missile will not generate troops. It's assumed they died on missile/bomb impact.

## Example:

https://www.youtube.com/watch?v=-BnJ_z7BlzM

# Loading and Setup

## ME triggers:

Load the latest MOOSE version as shown:

![Screenshot_2022-06-21_11-14-54](https://user-images.githubusercontent.com/32640017/174848241-55a4ecfe-397f-486d-98ad-5ee5ecce7dee.png)

At least a second later, load the script as either an assert line (advanced) or as a `DO SCRIPT FILE`: 

![Screenshot_2022-06-21_11-15-23](https://user-images.githubusercontent.com/32640017/174848438-a110fe47-d60e-4958-b480-e6d55a33b2f3.png)


## Convoy template groups setup

![Screenshot_2022-06-21_10-57-48](https://user-images.githubusercontent.com/32640017/174844685-d9ddd569-5044-476d-a7ef-3d5bfa38a611.png)

When setting up your convoys, the following configurable elements are required.

```-- troops_namestring: Quoted string of text that if in the unit name, will cause that unit to have troops spawn from it.
troops_namestring = "TROOPS"

-- convoy_template_string: Quoted string of text. Late Activated groups starting with this name will be consumed by the script as convoys and spawned
-- upon the stub.
convoy_template_string = "convoy-"

-- convoy_stub_string: Quoted string of text. Late Activated groups starting with this name should be your late act. convoys, with waypoints.
-- the actual convoy will spawn in place of the stub, and proceed according to the stub's waypoints and actions.
convoy_stub_string = "convoystub"


-- enemy_inf_string: Quoted string of text. Late Activated groups of enemy infantry that will become the troops carried in properly marked units.
enemy_inf_string = "enemyinf-"

-- enemy_inf_stub_string: Quoted string of text. This is a stub used to spawn your ramdomly sized infantry groups. A single infantry guy is recommended. 
enemy_inf_stub_string = "enemyinfstub"
```


You can see in the ME example that this three vehicle convoy is named with the convention `convoy-` , and one of the units in it has the string  `TROOPS` in the name.  Any vehicle matching those two criteria will be considered to be carrying troops. It could be one vehicle, one of several, or each of them if desired.

# Stubs

Stubs are late activated placeholder items in place of which something else shall spawn. Observe this convoy:

![Screenshot_2022-06-21_11-06-22](https://user-images.githubusercontent.com/32640017/174846340-ea84892b-52dc-4e41-9de5-6e92033d17c6.png)



Name the convoy stubs according to your desired configuration name. Default is `convoystub-`. Apply whatever routing you wish to the convoy. The unit name here does not matter, but the route and the speed do.  


![Screenshot_2022-06-21_11-08-08](https://user-images.githubusercontent.com/32640017/174846676-427249aa-6bc6-4723-8cd4-f625ea1d6c6f.png)

This is the enemyinfstub.  It only needs to be a single late activated unit of any type or kind. There is a `DRIVER` stub as well (not pictured) which follows the same rules.


 ## Infantry groups
 
 The infantry carried in the properly marked units are randomized.  Create as many groups as you like, naming them accordingly with regard to your configuration (Default: "enemyinf-"). When your convoy is engaged, one of these groups will come out of it.
 
 Example:
 
 ![Screenshot_2022-06-21_11-09-30](https://user-images.githubusercontent.com/32640017/174847345-9d059806-d784-4410-ab87-e0fbe12d800f.png)


## ASSETS INCLUDED IN RELEASE:

A static template file is included with some starter convoys. Use "LOAD STATIC TEMPLATE" in the ME to consume these objects into your mission. _**CHECK THAT THE NAMES ARE ALL SET AS THEY SHOULD BE. 
**_

1. Templates for other maps will be coming later. You can edit the template with a text editor and move it to a different map if desired.
2. Test mission (Syria) **ADD YOUR OWN AIRCRAFT CONFIGURED AS YOU WISH**
3. Script file: TROOP-TRANSPORTS.lua
4. This README.md file





