--!optimize 2

--[[
This file is for use by Benchmarker (https://boatbomber.itch.io/benchmarker)

|WARNING| THIS RUNS IN YOUR REAL ENVIRONMENT. |WARNING|
--]]

local BinaryOctreeModule = require("Path to binary octree")
--OldOctreeModule is a previous iteration of binaryoctree so its not included in this benchmark file as its not documented or saved on a github repo
--local OldOctreeModule = require(game.ReplicatedStorage.Shared.Octree)
local SleitnickModule = require("Path to sleitnicks module")

local Dot = Vector3.zero.Dot
local OctreeSize = 516

local Objects = {}

for i = 1,1000 do
	table.insert(Objects,{Position = Vector3.new(math.random(-OctreeSize,OctreeSize),math.random(-OctreeSize,OctreeSize),math.random(-OctreeSize,OctreeSize))})
end

local StartPosition = workspace.StartPosition.Position

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

local QueryOctree = BinaryOctreeModule.new(OctreeSize,5,Vector3.zero)
BinaryOctreeModule.InsertObjects(QueryOctree,Objects)


local SleitnickOctree = SleitnickModule.new(516)

local SleitNodes = {}

for _,Object in Objects do
	table.insert(SleitNodes,SleitnickOctree:CreateNode(Object.Position,Object))
end

return {
	ParameterGenerator = function()
		return
	end,

	Functions = {
		["Creating and inserting BinaryOctree"] = function(Profiler)
			Profiler.Begin("Creating Octree")
			local newOc = BinaryOctreeModule.new(516,10,Vector3.zero)
			Profiler.End()

			Profiler.Begin("Inserting")
			BinaryOctreeModule.InsertObjects(newOc,Objects)
			Profiler.End()
		end,
		["Sleitnick Updating nodes"] = function(Profiler)
			for _,Node in SleitNodes do
				SleitnickOctree:ChangeNodePosition(Node,Vector3.new(math.random(-OctreeSize,OctreeSize),math.random(-OctreeSize,OctreeSize),math.random(-OctreeSize,OctreeSize)))
			end
		end,
	},
}
