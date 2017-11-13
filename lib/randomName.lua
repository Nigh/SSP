local vowel = {
	"a","e","i","y","o","u","ar","er","or","ur","ir","ie","ire","igh","ai","au","al","aw","air","are",
	"augh","ay","ure","ea","ee","ear","ei","ew","ere","ey","eigh","oa","oi","oy","oo","oor","ou","ough","ow"
}
local consonant = {
	head = {"b","c","g","h","k","s","n","x","ch","th","qu","ph","ck","kn","wr","wh",
	"d","f","j","l","m","p","r","t","v","w","z"},
	tail = {"b","c","g","h","k","s","n","x","ch","tch","th","ck","ng","tion","sion",
	"d","f","j","l","m","p","r","t","v","w","z"}
}
local randomWord = function()
	local word = ""
	local len = 0
	local rnd = love.math.random
	while true do
		len = len + 1
		if rnd()<0.8 then
			word = word..consonant.head[rnd(1,#consonant.head)]
		end
		word = word .. vowel[rnd(1,#vowel)]
		if rnd()<0.8 then
			word = word..consonant.tail[rnd(1,#consonant.tail)]
		end
		if rnd()<0.1 then
			if string.sub(word,-1,-1) ~= "e" then
				word = word.."e"
			end
			return word
		end
		if rnd()<1/len or len>5 then
			return word
		end
	end
end

function randomSentence()
	local len = love.math.random(5,12)
	local sentence = ""
	for i = 1,len do
		sentence = sentence .. randomWord().." "
	end
	sentence = string.upper(string.sub(sentence,1,1)) .. string.sub(sentence,2,-2).."."
	return sentence
end

for i = 1,10 do
	print(randomSentence())
end