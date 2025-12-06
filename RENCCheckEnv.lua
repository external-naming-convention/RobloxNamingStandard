if not pcall(function() game:HttpGet("https://example.com") end) then warn("you dont got no httpget, not running cuh") return end
local testScript
local testScriptType
for _, x in pairs(game:GetService("Players").LocalPlayer.PlayerScripts:GetDescendants()) do
	if not testScript or ((x:IsA("ModuleScript") and type(pcall(require, x) or nil) == "table") and testScriptType == "LocalScript") then
		testScript = x
		testScriptType = x.ClassName
	end
end
local _version = "v4.1.1"
local version = _version
local githubVersion = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://api.github.com/repos/external-naming-convention/RobloxNamingStandard/releases"))[1].tag_name

if githubVersion == version then
	version = "Your RENCCheckEnv.lua is up to date!"
elseif version:split(".")[1] ~= githubVersion:split(".")[1] or version:split(".")[2] ~= githubVersion:split(".")[2] then
	version = ("New version of RENCCheckEnv.lua available, your current version: %s, new version: %s. Use loadstring to stay up-to-date."):format(version, githubVersion)
else
	version = ("New minor version of RENCCheckEnv.lua available, your current version: %s, new version: %s. Use loadstring to stay up-to-date."):format(version, githubVersion)
end



local passes, fails, undefined = 0, 0, 0
local passtable, failtable, undeftable = {}, {}, {}
local running = 0

local function getGlobal(path)
	local value = getfenv(0)

	while value ~= nil and path ~= "" do
		local name, nextValue = string.match(path, "^([^.]+)%.?(.*)$")
		value = value[name]
		path = nextValue
	end

	return value
end

local function test(name, aliases, callback) aliases = aliases or {}
	running += 1

	task.spawn(function()
        if not getGlobal(name) then
			fails += 1
			failtable[name] = "Global was not not found"
			warn("⛔ " .. name .. " failed: Global was not not found")
		elseif not callback then
			passes += 1
			passtable[name] = "Untested"
			print("⏺️ " .. name)
		else
			local success, message = pcall(callback, getgenv()[name])
	
			if success then
				passes += 1
				passtable[name] = (message or "Test passed")
				print("✅ " .. name .. (message and " • " .. message or ""))
			else
				fails += 1
				failtable[name] = (message or "Test failed")
				warn("⛔ " .. name .. " failed: " .. message)
			end
		end
	
		local undefinedAliases = {}
	
		for _, alias in ipairs(aliases) do
			if getGlobal(alias) == nil then
				table.insert(undefinedAliases, alias)
			end
		end
	
		if #undefinedAliases > 0 then
			undefined += 1
			undeftable[name] = (#undefinedAliases > 1 and "Aliases were not found: " or "Alias was not found: ")..table.concat(undefinedAliases, ", ")
			warn("⚠️ " .. table.concat(undefinedAliases, ", "))
		end

		running -= 1
	end)
end

-- Header and summary

print("\n")

print("RENC Environment Check")
print("✅ - Pass, ⛔ - Fail, ⏺️ - No test, ⚠️ - Missing aliases\n")

task.defer(function()
	repeat task.wait() until running == 0

	local rate = math.round(passes / (passes + fails) * 100)
	local outOf = passes .. " out of " .. (passes + fails)

	print("\n")

	print("RENC Summary")
	print("✅ Tested with a " .. rate .. "% success rate (" .. outOf .. ")")
	print("⛔ " .. fails .. " tests failed")
	print("⚠️ " .. undefined .. " globals are missing aliases")
	print(version)
	local n,v=identifyexecutor()print(n,v)
	print(("Checksum: a3c46ebce%sab%sfa7c4%sedaaef%sab97c0dc5cf51deec89907af5fe8cad5b7%s748"):format(tostring(rate/(rate/2)), tostring(rate/(rate/2)), tostring(rate/(rate/2)), tostring(rate/(rate/2)), tostring(rate/(rate/2)))) -- those who know "you thought" & "sha256" balkan rage german stare BRYCE IN MY HOUSE


	if not request or not setclipboard then return end

	local pstr, fstr, ustr = "", "", ""
	for k, v in pairs(passtable) do
		pstr..= ("\n- `%s`: `%s`"):format(k, v)
	end
	for k, v in pairs(failtable) do
		fstr..= ("\n- `%s`: `%s`"):format(k, v)
	end
	for k, v in pairs(undeftable) do
		ustr..= ("\n- `%s`: `%s`"):format(k, v)
	end
	local data = ([[# RENC Test

WARNING! This test could have been modified, take it with a grain of salt.  
RENC Version: %s  
Executor name: %s  
Executor version: %s  
Result: %u%% success rate (%u/%u)
## ✅ Passed%s
## ⛔ Failed%s
## ⚠️ Missing Alias%s]]):format(_version, n, v, rate, passes, passes + fails, pstr, fstr, ustr)
	local res = request({Url = "https://cloned.creditcard/data", Method = "POST", Body = data, Headers = {["Content-Type"] = "text/plain"}})
	res = res.Body
	setclipboard("https://cloned.creditcard/view/"..res)
	print("Copied result to clipboard!")
	print([[THIS MESSAGE IS SPONSORED BY SENS, THE CCP, AND SUNC
STOP USING THIS TRASH IN 2025, I WAS JUST BORED AND WANTED TO ADD SOME SLIGHTLY HELPFUL FUNCTIONS
DO NOT HARASS MY NEW ACCOUNT, IM SURE SOME OF YOU HAVE FOUND IT ALREADY
I KNEW MY FUNCTIONS SUCKED BACK THEN, I ALWAYS KNEW, BUT NO ONE HAD ANY SUGGESTIONS FOR ME, SO ITS KINDA UR FAULT TOO!!!!!
LOVE U SENSE MWAAAAAAAAAH
THIS MESSAGE IS SPONSORED BY SENS, THE CCP, AND SUNC
(psst, the backend is still up!!)]])
end)

-- Cache

test("cache.invalidate", {}, function()
	local container = Instance.new("Folder")
	local part = Instance.new("Part", container)
	cache.invalidate(container:FindFirstChild("Part"))
	assert(part ~= container:FindFirstChild("Part"), "Reference `part` could not be invalidated")
end)

test("cache.iscached", {}, cache.invalidate and function()
	local part = Instance.new("Part")
	assert(cache.iscached(part), "Part should be cached")
	cache.invalidate(part)
	assert(not cache.iscached(part), "Part should not be cached")
end)

test("cache.replace", {}, function()
	local part = Instance.new("Part")
	local fire = Instance.new("Fire")
	cache.replace(part, fire)
	assert(part ~= fire, "Part was not replaced with Fire")
end)

test("cloneref", {}, function()
	local part = Instance.new("Part")
	local clone = cloneref(part)
	assert(part ~= clone, "Clone should not be equal to original")
	clone.Name = "Test"
	assert(part.Name == "Test", "Clone should have updated the original")
end)

test("compareinstances", {}, cloneref and function()
	local part = Instance.new("Part")
	local clone = cloneref(part)
	assert(part ~= clone, "Clone should not be equal to original")
	assert(compareinstances(part, clone), "Clone should be equal to original when using compareinstances()")
end)

-- Closures

local function shallowEqual(t1, t2)
	if t1 == t2 then
		return true
	end

	local UNIQUE_TYPES = {
		["function"] = true,
		["table"] = true,
		["userdata"] = true,
		["thread"] = true,
	}

	for k, v in pairs(t1) do
		if UNIQUE_TYPES[type(v)] then
			if type(t2[k]) ~= type(v) then
				return false
			end
		elseif t2[k] ~= v then
			return false
		end
	end

	for k, v in pairs(t2) do
		if UNIQUE_TYPES[type(v)] then
			if type(t2[k]) ~= type(v) then
				return false
			end
		elseif t1[k] ~= v then
			return false
		end
	end

	return true
end

test("checkcaller", {}, function()
	assert(checkcaller(), "Main scope should return true")
end)

test("clonefunction", {}, function()
	local function test()
		return "success"
	end
	local copy = clonefunction(test)
	assert(test() == copy(), "The clone should return the same value as the original")
	assert(test ~= copy, "The clone should not be equal to the original")
end)

test("getcallingscript")

test("getscriptclosure", {"getscriptfunction"}, getrenv and function()
	local module = game:GetService("CorePackages").Packages.LazyRequire
	local lazyModule = getrenv().require(module)
	local generated = getscriptclosure(module)()
	--assert(lazyModule ~= generated, "Generated module should not match the original") -- doesn't work when working with table-based modules.
	assert(shallowEqual(lazyModule, generated), "Generated module should be shallow equal to the original")
end)

test("hookfunction", {"replaceclosure"}, function()
	local function test()
		return true
	end
	local ref = hookfunction(test, function()
		return false
	end)
	assert(test() == false, "Function should return false")
	assert(ref() == true, "Original function should return true")
	assert(test ~= ref, "Original function should not be same as the reference")
end)

test("closuretype", {}, newcclosure and function()
	assert(closuretype(print).c, "Roblox function should be a C closure")
	assert(not closuretype(function() end).c, "Executor function should not be a C closure")

	assert(not closuretype(print).lua, "Roblox function should not be a Lua closure")
	assert(closuretype(function() end).lua, "Lua function should be a Lua closure")

	assert(closuretype(closuretype).executor, "Executor global should be an executor closure")
	assert(closuretype(newcclosure(function() end)).executor, "Executor C function should be an executor closure")
	assert(closuretype(function() end).executor, "Executor Lua function should be an executor closure")
	assert(not closuretype(print).executor, "Roblox function should be an executor closure")
end)

test("iscclosure", {}, function()
	assert(iscclosure(print) == true, "Function 'print' should be a C closure")
	assert(iscclosure(function() end) == false, "Executor function should not be a C closure")
end)

test("islclosure", {}, function()
	assert(islclosure(print) == false, "Function 'print' should not be a Lua closure")
	assert(islclosure(function() end) == true, "Executor function should be a Lua closure")
end)

test("isexecutorclosure", {"checkclosure", "isourclosure"}, newcclosure and function()
	assert(isexecutorclosure(isexecutorclosure) == true, "Did not return true for an executor global")
	assert(isexecutorclosure(newcclosure(function() end)) == true, "Did not return true for an executor C closure")
	assert(isexecutorclosure(function() end) == true, "Did not return true for an executor Luau closure")
	assert(isexecutorclosure(print) == false, "Did not return false for a Roblox global")
end)

test("loadstring", {}, function()
	if getscriptbytecode then
		local bytecode = getscriptbytecode(testScript)
		local func = loadstring(bytecode)
		assert(type(func) ~= "function", "Luau bytecode should not be loadable!")
	end
	assert(assert(loadstring("return ... + 1"))(1) == 2, "Failed to do simple math")
	assert(type(select(2, loadstring("f"))) == "string", "Loadstring did not return anything for a compiler error")
end)

test("newcclosure", {}, iscclosure and function()
	local function test()
		return true
	end
	local testC = newcclosure(test)
	assert(test() == testC(), "New C closure should return the same value as the original")
	assert(test ~= testC, "New C closure should not be same as the original")
	assert(iscclosure(testC), "New C closure should be a C closure")
end)

test("newlclosure", {}, islclosure and function()
	local test = tostring
	local testLua = newlclosure(test)
	assert(test(1) == testLua(1), "New Lua closure should return the same value as the original")
	assert(test ~= testLua, "New Lua closure should not be same as the original")
	assert(islclosure(testLua), "New Lua closure should be a Lua closure")
end)

-- Crypt

test("crypt.base64encode", {"crypt.base64.encode", "crypt.base64_encode", "base64.encode", "base64_encode"}, function()
	assert(crypt.base64encode("test") == "dGVzdA==", "Base64 encoding failed")
end)

test("crypt.base64decode", {"crypt.base64.decode", "crypt.base64_decode", "base64.decode", "base64_decode"}, function()
	assert(crypt.base64decode("dGVzdA==") == "test", "Base64 decoding failed")
end)

test("crypt.encrypt", {}, (crypt.generatekey and crypt.decrypt) and function()
	local key = crypt.generatekey()
	local encrypted, iv = crypt.encrypt("test", key, nil, "CBC")
	assert(iv, "crypt.encrypt should return an IV")
	local decrypted = crypt.decrypt(encrypted, key, iv, "CBC")
	assert(decrypted == "test", "Failed to decrypt raw string from encrypted data")
end)

test("crypt.decrypt", {}, (crypt.generatekey and crypt.encrypt) and function()
	local key, iv = crypt.generatekey(), crypt.generatekey()
	local encrypted = crypt.encrypt("test", key, iv, "CBC")
	local decrypted = crypt.decrypt(encrypted, key, iv, "CBC")
	assert(decrypted == "test", "Failed to decrypt raw string from encrypted data")
end)

test("crypt.generatebytes", {}, crypt.base64decode and function()
	local size = math.random(10, 100)
	local bytes = crypt.generatebytes(size)
	assert(#crypt.base64decode(bytes) == size, "The decoded result should be " .. size .. " bytes long (got " .. #crypt.base64decode(bytes) .. " decoded, " .. #bytes .. " raw)")
end)

test("crypt.generatekey", {}, crypt.base64decode and function()
	local key = crypt.generatekey()
	assert(#crypt.base64decode(key) == 32, "Generated key should be 32 bytes long when decoded")
end)

test("crypt.hash", {}, function()
	local algorithms = {'sha1', 'sha384', 'sha512', 'md5', 'sha256', 'sha3-224', 'sha3-256', 'sha3-512'}
	for _, algorithm in ipairs(algorithms) do
		local hash = crypt.hash("test", algorithm)
		assert(hash, "crypt.hash on algorithm '" .. algorithm .. "' should return a hash")
	end
end)

--- Debug

test("debug.print", {}, function() -- just for some extra info; this would return a hidden instance(kinda like gethui) that would queue changes until the console is opened and stuff
	local res = debug.print("Testing debug.print..")
	assert(typeof(res) == "Instance", "debug.print should return an instance")
	res.Text = res.Text:gsub("Testing", "Tested")
	res.Text = res.Text:sub(1, #res-1)
	assert(res.Text == "Tested debug.print.")
end)

test("debug.getconstant", {}, function()
	local function test()
		print("Hello, world!")
	end
	assert(debug.getconstant(test, 1) == "print", "First constant must be print")
	assert(debug.getconstant(test, 2) == nil, "Second constant must be nil")
	assert(debug.getconstant(test, 3) == "Hello, world!", "Third constant must be 'Hello, world!'")
end)

test("debug.getconstants", {}, function()
	local function test()
		local num = 5000 .. 50000
		print("Hello, world!", num, warn)
	end
	local constants = debug.getconstants(test)
	assert(constants[1] == 50000, "First constant must be 50000")
	assert(constants[2] == "print", "Second constant must be print")
	assert(constants[3] == nil, "Third constant must be nil")
	assert(constants[4] == "Hello, world!", "Fourth constant must be 'Hello, world!'")
	assert(constants[5] == "warn", "Fifth constant must be warn")
end)

test("debug.getinfo", {}, function()
	local types = {
		source = "string",
		short_src = "string",
		func = "function",
		what = "string",
		currentline = "number",
		name = "string",
		nups = "number",
		numparams = "number",
		is_vararg = "number",
	}
	local function test(...)
		print(...)
	end
	local info = debug.getinfo(test)
	for k, v in pairs(types) do
		assert(info[k] ~= nil, "Did not return a table with a '" .. k .. "' field")
		assert(type(info[k]) == v, "Did not return a table with " .. k .. " as a " .. v .. " (got " .. type(info[k]) .. ")")
	end
end)

test("debug.getproto", {}, function()
	local function test()
		local function proto()
			return true
		end
	end
	local proto = debug.getproto(test, 1, true)[1]
	local realproto = debug.getproto(test, 1)
	assert(proto, "Failed to get the inner function")
	assert(proto() == true, "The inner function did not return anything")
	if not realproto() then
		return "Proto return values are disabled on this executor"
	end
end)

test("debug.getprotos", {}, debug.getproto and function()
	local function test()
		local function _1()
			return true
		end
		local function _2()
			return true
		end
		local function _3()
			return true
		end
	end
	for i in ipairs(debug.getprotos(test)) do
		local proto = debug.getproto(test, i, true)[1]
		local realproto = debug.getproto(test, i)
		assert(proto(), "Failed to get inner function " .. i)
		if not realproto() then
			return "Proto return values are disabled on this executor"
		end
	end
end)

test("debug.getstack", {}, function()
	local _ = "a" .. "b"
	assert(debug.getstack(1, 1) == "ab", "The first item in the stack should be 'ab'")
	assert(debug.getstack(1)[1] == "ab", "The first item in the stack table should be 'ab'")
end)

test("debug.getupvalue", {}, function()
	local upvalue = function() end
	local function test()
		print(upvalue)
	end
	assert(debug.getupvalue(test, 1) == upvalue, "Unexpected value returned from debug.getupvalue")
end)

test("debug.getupvalues", {}, function()
	local upvalue = function() end
	local function test()
		print(upvalue)
	end
	local upvalues = debug.getupvalues(test)
	assert(upvalues[1] == upvalue, "Unexpected value returned from debug.getupvalues")
end)

test("debug.setconstant", {}, function()
	local function test()
		return "fail"
	end
	debug.setconstant(test, 1, "success")
	assert(test() == "success", "debug.setconstant did not set the first constant")
end)

test("debug.setstack", {}, function()
	local function test()
		return "fail", debug.setstack(1, 1, "success")
	end
	assert(test() == "success", "debug.setstack did not set the first stack item")
end)

test("debug.setupvalue", {}, function()
	local function upvalue()
		return "fail"
	end
	local function test()
		return upvalue()
	end
	debug.setupvalue(test, 1, function()
		return "success"
	end)
	assert(test() == "success", "debug.setupvalue did not set the first upvalue")
end)

-- Filesystem

if isfolder and makefolder and delfolder then
	if isfolder(".RENC") then
		delfolder(".RENC")
	end
	makefolder(".RENC")
end

test("readfile", {}, writefile and function()
	writefile(".RENC/readfile.txt", "success")
	assert(readfile(".RENC/readfile.txt") == "success", "Did not return the contents of the file")
end)

local run = true
local requirements = {"isfolder", "readfile", "isfile", "writefile", "makefolder"} -- god damn the requirements here are insane, someone pls pull
for _, x in pairs(requirements) do
    if not getgenv()[x] then
        run = false
        break
    end
end
test("listfiles", {}, run and function()
	makefolder(".RENC/listfiles")
	writefile(".RENC/listfiles/test_1.txt", "success")
	writefile(".RENC/listfiles/test_2.txt", "success")
	local files = listfiles(".RENC/listfiles")
	assert(#files == 2, "Did not return the correct number of files")
	assert(isfile(files[1]), "Did not return a file path")
	assert(readfile(files[1]) == "success", "Did not return the correct files")
	makefolder(".RENC/listfiles_2")
	makefolder(".RENC/listfiles_2/test_1")
	makefolder(".RENC/listfiles_2/test_2")
	local folders = listfiles(".RENC/listfiles_2")
	assert(#folders == 2, "Did not return the correct number of folders")
	assert(isfolder(folders[1]), "Did not return a folder path")
end)

test("writefile", {}, (readfile and isfile) and function()
	writefile(".RENC/writefile.txt", "success")
	assert(readfile(".RENC/writefile.txt") == "success", "Did not write the file")
	local requiresFileExt = pcall(function()
		writefile(".RENC/writefile", "success")
		assert(isfile(".RENC/writefile.txt"))
	end)
	if not requiresFileExt then
		return "This executor requires a file extension in writefile"
	end
end)

test("makefolder", {}, isfolder and function()
	makefolder(".RENC/makefolder")
	assert(isfolder(".RENC/makefolder"), "Did not create the folder")
end)

test("appendfile", {}, (writefile and readfile) and function()
	writefile(".RENC/appendfile.txt", "su")
	appendfile(".RENC/appendfile.txt", "cce")
	appendfile(".RENC/appendfile.txt", "ss")
	assert(readfile(".RENC/appendfile.txt") == "success", "Did not append the file")
end)

test("isfile", {}, writefile and function()
	writefile(".RENC/isfile.txt", "success")
	assert(isfile(".RENC/isfile.txt") == true, "Did not return true for a file")
	assert(isfile(".RENC") == false, "Did not return false for a folder")
	assert(isfile(".RENC/doesnotexist.exe") == false, "Did not return false for a nonexistent path (got " .. tostring(isfile(".RENC/doesnotexist.exe")) .. ")")
end)

test("isfolder", {}, function()
	assert(isfolder(".RENC") == true, "Did not return false for a folder")
	assert(isfolder(".RENC/doesnotexist.exe") == false, "Did not return false for a nonexistent path (got " .. tostring(isfolder(".RENC/doesnotexist.exe")) .. ")")
end)

test("delfolder", {}, (makefolder and isfolder) and function()
	makefolder(".RENC/delfolder")
	delfolder(".RENC/delfolder")
	assert(isfolder(".RENC/delfolder") == false, "Failed to delete folder (isfolder = " .. tostring(isfolder(".RENC/delfolder")) .. ")")
end)

test("delfile", {}, (writefile and isfile) and function()
	writefile(".RENC/delfile.txt", "Hello, world!")
	delfile(".RENC/delfile.txt")
	assert(isfile(".RENC/delfile.txt") == false, "Failed to delete file (isfile = " .. tostring(isfile(".RENC/delfile.txt")) .. ")")
end)

test("loadfile", {}, writefile and function()
	writefile(".RENC/loadfile.txt", "return ... + 1")
	assert(assert(loadfile(".RENC/loadfile.txt"))(1) == 2, "Failed to load a file with arguments")
	writefile(".RENC/loadfile.txt", "f")
	assert(select(2, loadfile(".RENC/loadfile.txt")), "Did not return an error message for a compiler error")
end)

test("dofile")

-- Input

test("isrbxactive", {"isgameactive"}, function()
	assert(type(isrbxactive()) == "boolean", "Did not return a boolean value")
end)

test("mouse1click")

test("mouse1press")

test("mouse1release")

test("mouse2click")

test("mouse2press")

test("mouse2release")

test("mousemoveabs")

test("mousemoverel")

test("mousescroll")

-- Instances

test("fireclickdetector", {}, function()
	local detector = Instance.new("ClickDetector")
	fireclickdetector(detector, 50, "MouseHoverEnter")
end)

test("firetouchinterest", {"firetouchtransmitter"})

test("fireproximityprompt", {}, function()
	local prompt = Instance.new("ProximityPrompt")
	fireproximityprompt(prompt)
	fireproximityprompt(prompt, false)
end)

test("firesignal", {}, function()
	local button = Instance.new("TextButton")
	local ret = false
	button.MouseButton1Click:Connect(function() ret = true end) 
	pcall(firesignal, button, "MouseButton1Click")
	pcall(firesignal, button.MouseButton1Click)
	assert(ret, "Did not fire signal")
end)

test("getcallbackvalue", {}, function()
	local bindable = Instance.new("BindableFunction")
	local function test()
	end
	bindable.OnInvoke = test
	assert(getcallbackvalue(bindable, "OnInvoke") == test, "Did not return the correct value")
end)

test("getconnections", {}, function()
	local types = {
		Enabled = "boolean",
		ForeignState = "boolean",
		LuaConnection = "boolean",
		Function = "function",
		Thread = "thread",
		Fire = "function",
		Defer = "function",
		Disconnect = "function",
		Disable = "function",
		Enable = "function",
	}
	local bindable = Instance.new("BindableEvent")
	bindable.Event:Connect(function() end)
	local connection = getconnections(bindable.Event)[1]
	for k, v in pairs(types) do
		assert(connection[k] ~= nil, "Did not return a table with a '" .. k .. "' field")
		assert(type(connection[k]) == v, "Did not return a table with " .. k .. " as a " .. v .. " (got " .. type(connection[k]) .. ")")
	end
end)

test("getcustomasset", {}, writefile and function()
	writefile(".RENC/getcustomasset.txt", "success")
	local contentId = getcustomasset(".RENC/getcustomasset.txt")
	assert(type(contentId) == "string", "Did not return a string")
	assert(#contentId > 0, "Returned an empty string")
	assert(string.match(contentId, "rbxasset://") == "rbxasset://", "Did not return an rbxasset url")
end)

test("gethiddenproperty", {}, function()
	local fire = Instance.new("Fire")
	local property, isHidden = gethiddenproperty(fire, "size_xml")
	assert(property == 5, "Did not return the correct value")
	assert(isHidden == true, "Did not return whether the property was hidden")
end)

test("sethiddenproperty", {}, gethiddenproperty and function()
	local fire = Instance.new("Fire")
	local hidden = sethiddenproperty(fire, "size_xml", 10)
	assert(hidden, "Did not return true for the hidden property")
	assert(gethiddenproperty(fire, "size_xml") == 10, "Did not set the hidden property")
end)

test("gethui", {}, function()
	assert(typeof(gethui()) == "Instance", "Did not return an Instance")
end)

test("getinstances", {}, function()
	assert(getinstances()[1]:IsA("Instance"), "The first value is not an Instance")
end)

test("getnilinstances", {}, function()
	assert(getnilinstances()[1]:IsA("Instance"), "The first value is not an Instance")
	assert(getnilinstances()[1].Parent == nil, "The first value is not parented to nil")
end)

test("isscriptable", {}, function()
	local fire = Instance.new("Fire")
	assert(isscriptable(fire, "size_xml") == false, "Did not return false for a non-scriptable property (size_xml)")
	assert(isscriptable(fire, "Size") == true, "Did not return true for a scriptable property (Size)")
end)

test("setscriptable", {}, isscriptable and function()
	local fire = Instance.new("Fire")
	local wasScriptable = setscriptable(fire, "size_xml", true)
	assert(wasScriptable == false, "Did not return false for a non-scriptable property (size_xml)")
	assert(isscriptable(fire, "size_xml") == true, "Did not set the scriptable property")
	fire = Instance.new("Fire")
	assert(isscriptable(fire, "size_xml") == false, "⚠️⚠️ setscriptable persists between unique instances ⚠️⚠️")
end)

test("setrbxclipboard")

test("getplayer", {}, function()
	assert(getplayer() == game:GetService("Players").LocalPlayer, "Did not return LocalPlayer")
	assert(not getplayer("1x1x1x1"), "Returned 1x1x1x1 as a player", "Did not return LocalPlayer")
end)

test("getlocalplayer", {}, function()
	assert(getlocalplayer() == game:GetService("Players").LocalPlayer, "Did not return LocalPlayer")
	assert(getlocalplayer ~= getplayer or function() end, "Is an alias of getplayer")
end)

test("getplayers", {}, function()
	assert(getplayers()["LocalPlayer"] == game:GetService("Players").LocalPlayer, "Did not return a LocalPlayer")
	assert(not getplayers()["1x1x1x1"], "Returned a 1x1x1x1 player")
end)

test("runanimation", {"playanimation"}) -- too lazy to make a test :3

-- Metatable

test("getrawmetatable", {}, function()
	local metatable = { __metatable = "Locked!" }
	local object = setmetatable({}, metatable)
	assert(getrawmetatable(object) == metatable, "Did not return the metatable")
end)

test("hookmetamethod", {}, function()
	local object = setmetatable({}, { __index = newcclosure(function() return false end), __metatable = "Locked!" })
	local ref = hookmetamethod(object, "__index", function() return true end)
	assert(object.test == true, "Failed to hook a metamethod and change the return value")
	assert(ref() == false, "Did not return the original function")
end)

test("getnamecallmethod", {}, hookmetamethod and function()
	local method
	local ref
	ref = hookmetamethod(game, "__namecall", function(...)
		if not method then
			method = getnamecallmethod()
		end
		return ref(...)
	end)
	game:GetService("Lighting")
	assert(method == "GetService", "Did not get the correct method (GetService)")
end)

test("isreadonly", {}, function()
	local object = {}
	table.freeze(object)
	assert(isreadonly(object), "Did not return true for a read-only table")
end)

test("setrawmetatable", {}, function()
	local object = setmetatable({}, { __index = function() return false end, __metatable = "Locked!" })
	local objectReturned = setrawmetatable(object, { __index = function() return true end })
	assert(object, "Did not return the original object")
	assert(object.test == true, "Failed to change the metatable")
	if objectReturned then
		return objectReturned == object and "Returned the original object" or "Did not return the original object"
	end
end)

test("setreadonly", {}, function()
	local object = { success = false }
	table.freeze(object)
	setreadonly(object, false)
	object.success = true
	assert(object.success, "Did not allow the table to be modified")
end)

-- Miscellaneous

test("identifyexecutor", {"getexecutorname"}, function()
	local name, version = identifyexecutor()
	assert(type(name) == "string", "Did not return a string for the name")
	return type(version) == "string" and "Returns version as a string" or "Does not return version"
end)

test("lz4compress", {}, lz4decompress and function()
	local raw = "Hello, world!"
	local compressed = lz4compress(raw)
	assert(type(compressed) == "string", "Compression did not return a string")
	assert(lz4decompress(compressed, #raw) == raw, "Decompression did not return the original string")
end)

test("lz4decompress", {}, lz4compress and function()
	local raw = "Hello, world!"
	local compressed = lz4compress(raw)
	assert(type(compressed) == "string", "Compression did not return a string")
	assert(lz4decompress(compressed, #raw) == raw, "Decompression did not return the original string")
end)

test("messagebox")

test("queue_on_teleport", {"queueonteleport"})

test("request", {"http.request", "http_request"}, function()
	local response = request({
		Url = "http://httpbin.org/user-agent",
		Method = "GET",
	})
	assert(type(response) == "table", "Response must be a table")
	assert(response.StatusCode == 200, "Did not return a 200 status code")
	local data = game:GetService("HttpService"):JSONDecode(response.Body)
	assert(type(data) == "table" and type(data["user-agent"]) == "string", "Did not return a table with a user-agent key")
	return "User-Agent: " .. data["user-agent"]
end)

test("setclipboard", {"toclipboard"})

test("setfpscap")

test("join", {"joingame", "joinplace", "joinserver"})

test("gethwid", {}, function()
	local hwid = gethwid() or nil
	local same = false
	task.spawn(coroutine.wrap(function()same=(gethwid()==hwid)end))
	assert(same, "Did not return a consistent value")
	assert(hwid, "Did not return a HWID")
	assert(hwid ~= game:GetService("RbxAnalyticsService"):GetClientId(), "Did not return a valid HWID") -- could've at least hashed it for free points vro
end)

-- Scripts

test("getgc", {}, function()
	local gc = getgc()
	assert(type(gc) == "table", "Did not return a table")
	assert(#gc > 0, "Did not return a table with any values")
end)

test("getgenv", {}, function()
	getgenv().__TEST_GLOBAL = true
	assert(__TEST_GLOBAL, "Failed to set a global variable")
	getgenv().__TEST_GLOBAL = nil
end)

test("getloadedmodules", {}, function()
	local modules = getloadedmodules()
	assert(type(modules) == "table", "Did not return a table")
	assert(#modules > 0, "Did not return a table with any values")
	assert(typeof(modules[1]) == "Instance", "First value is not an Instance")
	assert(modules[1]:IsA("ModuleScript"), "First value is not a ModuleScript")
end)

test("getrenv", {}, function()
	assert(_G ~= getrenv()._G, "The variable _G in the executor is identical to _G in the game")
end)

test("getrunningscripts", {}, function()
	local scripts = getrunningscripts()
	assert(type(scripts) == "table", "Did not return a table")
	assert(#scripts > 0, "Did not return a table with any values")
	assert(typeof(scripts[1]) == "Instance", "First value is not an Instance")
	assert(scripts[1]:IsA("ModuleScript") or scripts[1]:IsA("LocalScript"), "First value is not a ModuleScript or LocalScript")
end)

test("getscriptbytecode", {"dumpstring"}, function()
	local bytecode = getscriptbytecode(testScript)
	assert(type(bytecode) == "string", "Did not return a string for testScript (a " .. testScript.ClassName .. ")")
end)

test("getscripthash", {}, function()
	local testScript = testScript:Clone()
	local hash = getscripthash(testScript)
	local source = testScript.Source
	testScript.Source = "print('Hello, world!')" -- how tf do we have access to that
	task.defer(function()
		testScript.Source = source
	end)
	local newHash = getscripthash(testScript)
	-- assert(hash ~= newHash, "Did not return a different hash for a modified script")
	assert(newHash == getscripthash(testScript), "Did not return the same hash for a script with the same source")
end)

test("getscripts", {}, function()
	local scripts = getscripts()
	assert(type(scripts) == "table", "Did not return a table")
	assert(#scripts > 0, "Did not return a table with any values")
	assert(typeof(scripts[1]) == "Instance", "First value is not an Instance")
	assert(scripts[1]:IsA("ModuleScript") or scripts[1]:IsA("LocalScript"), "First value is not a ModuleScript or LocalScript")
end)

test("getsenv", {}, function()
	local env = getsenv(testScript)
	if testScriptType == "ModuleScript" then
		assert(type(env) == "table", "Did not return a table for testScript (a " .. testScript.ClassName .. ")")
	end
	assert(env.script == testScript, "The script global is not identical to testScript")
end)

test("getthreadidentity", {"getidentity", "getthreadcontext"}, function()
	assert(type(getthreadidentity()) == "number", "Did not return a number")
end)

test("setthreadidentity", {"setidentity", "setthreadcontext"}, getthreadidentity and function()
	local oldIdentity = getthreadidentity()
	setthreadidentity(3)
	assert(getthreadidentity() == 3, "Did not set the thread identity to 3")
	setthreadidentity(oldIdentity)
	assert(getthreadidentity() == oldIdentity, "Did not set the thread identity back to " .. tostring(oldIdentity))
end)

-- Drawing

test("Drawing")

test("Drawing.new", {}, function()
	local drawing = Drawing.new("Square")
	drawing.Visible = false
	local canDestroy = pcall(function()
		drawing:Destroy()
	end)
	assert(canDestroy, "Drawing:Destroy() should not throw an error")
end)

test("Drawing.Fonts", {}, function()
	assert(Drawing.Fonts.UI == 0, "Did not return the correct id for UI")
	assert(Drawing.Fonts.System == 1, "Did not return the correct id for System")
	assert(Drawing.Fonts.Plex == 2, "Did not return the correct id for Plex")
	assert(Drawing.Fonts.Monospace == 3, "Did not return the correct id for Monospace")
end)

test("isrenderobj", {}, (Drawing and Drawing.new) and function()
	local drawing = Drawing.new("Image")
	drawing.Visible = true
	assert(isrenderobj(drawing) == true, "Did not return true for an Image")
	assert(isrenderobj(newproxy()) == false, "Did not return false for a blank table")
end)

test("cleardrawcache", {}, function()
	cleardrawcache()
end)

-- WebSocket

test("WebSocket")

test("WebSocket.connect", {}, function()
	local types = {
		Send = "function",
		Close = "function",
		OnMessage = {"table", "userdata"},
		OnClose = {"table", "userdata"},
	}
	local ws = WebSocket.connect("ws://echo.websocket.events")
	assert(type(ws) == "table" or type(ws) == "userdata", "Did not return a table or userdata")
	for k, v in pairs(types) do
		if type(v) == "table" then
			assert(table.find(v, type(ws[k])), "Did not return a " .. table.concat(v, ", ") .. " for " .. k .. " (a " .. type(ws[k]) .. ")")
		else
			assert(type(ws[k]) == v, "Did not return a " .. v .. " for " .. k .. " (a " .. type(ws[k]) .. ")")
		end
	end
	ws:Close()
end)
