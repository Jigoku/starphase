names = {}


names.phonetic = {
	-- https://en.wikibooks.org/wiki/Japanese/Pronunciation
	-- japanese phonetics
	"a", "i", "u", "e", "o", 
	"ka", "ki", "ku", "ke", "ko",
	"sa", "shi", "su", "se", "so", 
	"ta", "chi", "tsu", "te", "to",
	"na", "ni", "nu", "ne", "no",
	"ha", "hi", "fu", "he", "ho",
	"ma", "mi", "mu", "me", "mo",
	"ya", "yu", "yo",
	"ra", "ri", "ru", "re", "ro",
	"wa",
	"ga", "gi", "gu", "ge", "go",
	"za", "ji", "zu", "ze", "zo",
	"da", "de", "do",
	"ba", "bi", "bu", "be", "bo",
	"pa", "pi", "pu", "pe", "po",
	"kya", "kyu", "kyo",
	"sha", "shu", "sho",
	"cha", "chu", "cho",
	"nya", "nyu", "nyo",
	"hya", "hyu", "hyo",
	"mya", "myu", "myo",
	"rya", "ryu", "ryo",
	"gya", "gyu", "gyo",
	"ja", "ju", "jo",
	"bya", "byu", "byo",
	"pya", "pyu", "pyo",

}

function names:getPlanet()
	local len = love.math.random(2,3) -- number of syllables to use
	local str = ""
	
	for i=1,len do
		str = str .. self.phonetic[love.math.random(1,#self.phonetic)]
	end
	
	local digits = love.math.random(1,3) -- 1/3 chance of appended digits
	local append = love.math.random(1,2) -- 1/2 chance of appended character
	
	if digits == 1 then 
		str = str .. "-".. love.math.random(1,9) 
		
		if append == 1 then 
			str = str .. string.char(love.math.random(97,123))
		end
	end

	return str
end



love.math.setRandomSeed(os.time())

for i=1, 10 do
	print( names:getPlanet(),names:getPlanet(),names:getPlanet())
end
