if select(2, UnitClass("player")) ~= "PRIEST" then return end

local _, MaxDps_PriestTable = ...;

if not MaxDps then
	return
end

local Priest = MaxDps_PriestTable.Priest;


local HL = {
};

setmetatable(HL, Priest.spellMeta);

function Priest:Holy()
	return nil;
end
