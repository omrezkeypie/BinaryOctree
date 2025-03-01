--!optimize 2

--[[
This file is for use by Benchmarker (https://boatbomber.itch.io/benchmarker)

|WARNING| THIS RUNS IN YOUR REAL ENVIRONMENT. |WARNING|
--]]

local BinaryOctreeModule = require("path to binary octree")
local SleitnickModule = require("path to sleitnicks module")

local Dot = Vector3.zero.Dot
local OctreeSize = 516

local Objects = {}

for i = 1,1000 do
	table.insert(Objects,{Position = Vector3.new(math.random(-OctreeSize,OctreeSize),math.random(-OctreeSize,OctreeSize),math.random(-OctreeSize,OctreeSize))})
end

local StartPosition = Vector3.new(50,1,50)

local Radius = 30

local function LinearSearch()
	local GottenObjects = {}

	for _,Object in Objects do
		local SubtractedPosition = Object.Position - StartPosition
		if SubtractedPosition.Magnitude <= Radius then
			table.insert(GottenObjects,Object)
		end
	end

	return GottenObjects
end

local QueryBinaryOctree = BinaryOctreeModule.new(OctreeSize,5,Vector3.zero)
BinaryOctreeModule.InsertObjects(QueryBinaryOctree,Objects)
local SleitnickOctree = SleitnickModule.new(OctreeSize)

local SleitNodes = {}

for _,Object in Objects do
	table.insert(SleitNodes,SleitnickOctree:CreateNode(Object.Position,Object))
end

return {
	ParameterGenerator = function()
		return
	end,

	Functions = {
		["Linear Search Sphere"] = function(Profiler)
			LinearSearch()
		end,
		["Sleitnick query sphere"] = function(Profiler)
			SleitnickOctree:SearchRadius(StartPosition,Radius)
		end,
		["BinaryOctree Query Sphere"] = function(Profiler)
			BinaryOctreeModule.QuerySphere(QueryBinaryOctree,StartPosition,Radius)
		end,
	},
}
