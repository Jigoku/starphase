names = {}


names.syl = {
	"ab", "ac", "ad", "ae", "af", "al", "ak", "ai", "ap", "ar" , "am" ,"an",
	"dr", "ja", "io", "li", "il", "ra", "be", "je", "ke", "ek", "na", "ze",
	"ur", "in", "ze", "zo", "oz", "pe", "ni", "is", 
	"ori", "net", "gin", "ge", "ga", "gi", "hi",
	"ju", "ij", "ja", "je", "xe", "xu", "xi","ao", "ch", "ph", "cu", "nt",
	"ba", "st", "de", "we", "ed", "ca", "bi", "gla", "sin", "cos", "phi", "dos", "win",
	"shu", "min", "kel", "pal", "del"
}


function names:getGalaxy()

end

function names:getPlanet()
	local len = love.math.random(2,4)
	local digits = love.math.random(0,5)
	local str = ""
	
	for i=1,len do
		str = str .. self.syl[love.math.random(1,#self.syl)]
	end
	
	if digits == 4 then str = str .. "-".. love.math.random(1,9) end
	if digits == 5 then str = str .. "-".. love.math.random(1,9) .. love.math.random(1,9) end

	return str
end
