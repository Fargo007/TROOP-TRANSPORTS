-- DEBUG: If true, this script will output debugging information in your dcs.log. If you are having problems, turn this on, then study the log.
-- true or false, unquoted.
DEBUG = true

-- resumetime: How long after being engaged will the troops re-embark and the vehicles continue on their route?
-- value is randomized between the min and max seconds here
resumetime_min = 180
resumetime_max = 220

-- offsetX min/max = how far the troops will go to "get off the X"
offsetX_min = 75
offsetX_max = 125

-- troops_namestring: Quoted string of text that if in the unit name, will cause that unit to have troops spawn from it.
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


-- quantity_alive: how many vehicles should be spawned/alive at one time in each convoy. If less than this number and enough room for the 
-- new convoy, new ones will spawn. You can break this by setting a number here that is lower than the # of units in your convoys.
quantity_alive = 5

-- maxgroups: only spawn this many groups, then stop. A 0 here means no limit, they will keep coming for the duration of the mission.
maxgroups = 1000

-- convoy_spawn_interval : the delay between spawning of new convoys.  Unquoted number.
convoy_spawn_interval = 90


-- 8<------------------------------------- THERE IS NO SUPPORT FOR CHANGING ANYTHING BELOW THIS LINE. ----------------8<-----------
 
 convoys_template_table = { }
 convoy_stubs_table = { }
 enemy_inf_table = { }

convoy_groups_set = SET_GROUP:New():FilterCategoryGround():FilterCoalitions("red"):FilterPrefixes(convoy_template_string):FilterOnce()
convoy_stubs_set  = SET_GROUP:New():FilterCategoryGround():FilterCoalitions("red"):FilterPrefixes(convoy_stub_string):FilterOnce()
enemyinfset  = SET_GROUP:New():FilterCategoryGround():FilterCoalitions("red"):FilterPrefixes(enemy_inf_string):FilterOnce()

convoy_groups_set:ForEachGroup(function (grp)
  table.insert(convoys_template_table, grp:GetName())
end)

convoy_stubs_set:ForEachGroup(function (grp)
  table.insert(convoy_stubs_table, grp)
  if DEBUG == true then env.info("DEBUG: GRP:GETNAME() " .. grp:GetName()) end
end)

enemyinfset:ForEachGroup(function (grp)
  table.insert(enemy_inf_table, grp:GetName())
end)

enemyinf = SPAWN:NewWithAlias(enemy_inf_stub_string,"enemy_PAX"):InitRandomizeTemplate(enemy_inf_table)

driver = SPAWN:NewWithAlias(enemy_inf_stub_string,"driver")

for i=1,#convoy_stubs_table do

  convoystubname = convoy_stubs_table[i]:GetName()
  convoystubname = SPAWN:New(convoystubname):InitKeepUnitNames(true):InitRandomizeTemplate(convoys_template_table):InitLimit(quantity_alive,maxgroups)
:OnSpawnGroup(
  function( SpawnGroup )
    
--[[     if convoy_patrol_route == true then  -- The script manages the convoy's routing
        -- if DEBUG == true then env.info("DEBUG: convoy_speed = " .. convoy_speed) end            
          if SpawnGroup then
           --SpawnGroup:PatrolRouteRandom(55,"On Road",1)
           --SpawnGroup:PatrolRoute()
          end
     end
--]]     
       
      SpawnGroup:HandleEvent( EVENTS.Hit  )
      resumetime = math.random(resumetime_min, resumetime_max)
     local spawnedenemyinf = 0

     function SpawnGroup:OnEventHit( EventData )
                    
        if spawnedenemyinf == 0 then
        SpawnGroup:RouteStop()
        local routeResume = SCHEDULER:New( nil,function()
          SpawnGroup:RouteResume()  
          if DEBUG == true then env.info("DEBUG: ROUTE RESUMING " )  end             
        end, {}, resumetime ) 
         convoycoords = SpawnGroup:GetCoordinate()

        local directionX = math.random(1,100)
        local offsetX = math.random(offsetX_min,offsetX_max)
        
        if directionX > 50 then
          off_the_X = -offsetX
        else
          off_the_X = offsetX
            
        end
        if DEBUG == true then env.info("DEBUG: offsetX " .. off_the_X .. " , " .. offsetX) end               
        
         driver:OnSpawnGroup(function (grp)
         local GTFO_coord = grp:GetUnit(1):GetOffsetCoordinate(off_the_X,0,off_the_X) -- math.random(-offsetB,offsetB))
         grp:RouteGroundTo(GTFO_coord,24,"Diamond")
          local routeResume = SCHEDULER:New( nil,function()
          grp:Destroy()  
          spawnedenemyinf = 0
          if DEBUG == true then env.info("DEBUG: Group destroyed " ) end           
        end, {}, resumetime ) 
         
         end) --driver
                      
        unitlist = SpawnGroup:GetUnits()
        for i=1,#unitlist do 
            if DEBUG == true then env.info("DEBUG: unitname = " .. unitlist[i]:GetName()) end
              
            if string.match(unitlist[i]:GetName(), troops_namestring) then  --is this a troop carrier?
             inf_coord = nil
                     
                enemyinf:OnSpawnGroup(function (grp)
                 
                  GTFO_coord = grp:GetUnit(1):GetOffsetCoordinate(off_the_X,0,off_the_X) -- math.random(-offsetB,offsetB))        
                  grp:RouteGroundTo(GTFO_coord,24,"Diamond")
                  


                local routeResume = SCHEDULER:New( nil,function()
                  if unitlist[i]:IsAlive() then 
                    grp:Destroy() --"re-embark and GTFO" 
                  end
                  spawnedenemyinf = 0
                       
                  if DEBUG == true then env.info("DEBUG: Group destroyed " ) end 
                            
                  end, {}, resumetime ) --scheduler
        
        
        end)    --enemyinf 
        
        local infSpawn = SCHEDULER:New( nil,function()
          if unitlist[i]:IsAlive() then 
            inf_coord = unitlist[i]:GetOffsetCoordinate(5,5)             
            enemyinf:SpawnFromCoordinate(inf_coord)
          end
        end, {}, 5 ) --scheduler fires 3 secs after hit event, giving the convoy time to stop
                      
            else
            
            local driverSpawn = SCHEDULER:New( nil,function()
              if unitlist[i]:IsAlive() then 
                driver_coord = unitlist[i]:GetOffsetCoordinate(2,2) 
                driver:SpawnFromCoordinate(driver_coord) 
              end      
            end, {}, 5 ) --scheduler fires 3 secs after hit event, giving the convoy time to stop
                      
            end
            
            
        end
              spawnedenemyinf = 1
        end -- 0           
     end

 end)

:SpawnScheduled(convoy_spawn_interval,1)

end
