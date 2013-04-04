--[[
Project: Gridmap
Author: CMP
Version: 1.1
http://developer.coronalabs.com/code/gridmap
 
A tiled map loader.
--]]
 
local gridmap={}
 
local function strRight(str,pattern)
  local s,e = str:find(pattern)
  local ret
  if e then
    ret =  str:sub(e+1)
    return ret~='' and ret or nil
  end
  return nil
end
 
local function isNumeric(str) 
        return tonumber(str) and true or false 
end
 
function gridmap:createMap(mapName)
        local data=require(mapName)
        local mapW, mapH=data.width, data.height
        local tw, th=data.tilewidth, data.tileheight
        local t=data.tilesets
        
        local x, y=tw/2, th/2
        local totalTiles=mapW*mapH
        
        local map=display.newGroup()
        map.layers={}
        local tilesets={}
        local tileRef={}
        local tiles={}
        local a=0
        local e=0
        
        for i=1, #t do
                tilesets[i]={}
                local ts=tilesets[i]
                
                ts.name=t[i].name
                ts.tilewidth=t[i].tilewidth
                ts.tileheight=t[i].tileheight
                ts.image=t[i].image
                ts.imagewidth=t[i].imagewidth
                ts.imageheight=t[i].imageheight
                
                ts.numCol=ts.imagewidth/ts.tilewidth
                ts.numRow=ts.imageheight/ts.tileheight
                ts.numFrames=ts.numCol*ts.numRow
                
                local props=t[i].properties
                ts.properties={}
                for k, v in pairs(props) do
                        ts.properties[k]=props[k]
                end
                
                ts.spriteSheet=graphics.newImageSheet(ts.image, {width=ts.tilewidth, height=ts.tileheight, numFrames=ts.numFrames})
                for l=1, ts.numFrames do
                        tileRef[#tileRef+1]={tilesets[i], ts.spriteSheet, l}
                end
        end
        
        for i=1, #data.layers do
                map.layers[i]=display.newGroup()
                map.layers[i].tiles={}
                map:insert(map.layers[i])
                if data.layers[i].type=="tilelayer" then
                        local layer=data.layers[i]
                        local layerW=layer.width
                        local layerH=layer.height
                        local tileData=layer.data
                        local offX=layer.x
                        local offY=layer.y
                        local alpha=layer.opacity
                                                
                        local props=data.layers[i].properties
                        map.layers[i].properties={}
                        map.layers[i].physicsData={}
                        map.layers[i].tileProps={}
                        for k, v in pairs(props) do
                                if string.find(k, "Physics:")~=nil then
                                        map.layers[i].physicsData[strRight(k, ":")]=props[k]
                                        if map.layers[i].physicsData[strRight(k, ":")]=="true" then
                                                map.layers[i].physicsData[strRight(k, ":")]=true
                                        elseif map.layers[i].physicsData[strRight(k, ":")]=="false" then
                                                map.layers[i].physicsData[strRight(k, ":")]=false
                                        elseif isNumeric(map.layers[i].physicsData[strRight(k, ":")])==true then
                                                map.layers[i].physicsData[strRight(k, ":")]=tonumber(map.layers[i].physicsData[strRight(k, ":")])
                                        end
                                elseif string.find(k, "Layer:")~=nil then
                                        map.layers[i][strRight(k, ":")]=props[k]
                                        if map.layers[i][strRight(k, ":")]=="true" then
                                                map.layers[i][strRight(k, ":")]=true
                                        elseif map.layers[i][strRight(k, ":")]=="false" then
                                                map.layers[i][strRight(k, ":")]=false
                                        elseif isNumeric(map.layers[i][strRight(k, ":")])==true then
                                                map.layers[i][strRight(k, ":")]=tonumber(map.layers[i][strRight(k, ":")])
                                        end
                                elseif string.find(k, "Tiles:")~=nil then
                                        map.layers[i].tileProps[strRight(k, ":")]=props[k]
                                        if map.layers[i].tileProps[strRight(k, ":")]=="true" then
                                                map.layers[i].tileProps[strRight(k, ":")]=true
                                        elseif map.layers[i].tileProps[strRight(k, ":")]=="false" then
                                                map.layers[i].tileProps[strRight(k, ":")]=false
                                        elseif isNumeric(map.layers[i].tileProps[strRight(k, ":")])==true then
                                                map.layers[i].tileProps[strRight(k, ":")]=tonumber(map.layers[i].tileProps[strRight(k, ":")])
                                        end
                                else
                                        map.layers[i].properties[k]=props[k]
                                end
                        end
                        
                        for h=1, layerH do
                                for w=1, layerW do
                                        a=a+1
                                        e=e+1
                                        if tileData[a]~=nil and tileData[a]~=0 then
                                                local curSet=tileRef[tileData[a]]
                                                tiles[a]=display.newSprite(curSet[2], {name="tile"..e, start=1, count=curSet[1].numFrames, time=0})
                                                tiles[a].x, tiles[a].y=x+offX, y+offY
                                                tiles[a]:setFrame(curSet[3])
                                                tiles[a].alpha=alpha
                                                                                        
                                                if map.layers[i].physicsData.existent==true then
                                                        physics.addBody(tiles[a], "kinematic", map.layers[i].physicsData)
                                                end
                                                
                                                for k, v in pairs(map.layers[i].tileProps) do
                                                        tiles[a][k]=map.layers[i].tileProps[k]
                                                end
                                                
                                                map.layers[i]:insert(tiles[a])
                                                map.layers[i].tiles[a]=tiles[a]
                                        end
                                        x=x+tw
                                end
                                y=y+th
                                x=tw/2
                        end
                        map.layers[i]:setReferencePoint(display.CenterReferencePoint)
                        map.layers[i].layerW, map.layers[i].layerH=layerW, layerH
                end
                y=th/2
                x=tw/2
                a=0
        end
        
        function map:getTile(layer, x, y)
                local num=map.layers[layer].layerW*(y-1)+(x)
                return map.layers[layer].tiles[num]
        end
        
        map:setReferencePoint(display.CenterReferencePoint)
        return map
end
 
return gridmap
