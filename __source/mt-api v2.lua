if not getgenv().MTAPIDebug and getgenv().MTAPIMutex ~= nil then return end
local a = {}
local b = {}
local c = {}
local d = {}
local e = {}
local f = {}
local g = {}
local h = {}
local i = {}
local j = 0
local k = 0
local l = 0
local function m()
	if not getrawmetatable then error("mt-api: Exploit not supported") end
	local o = checkcaller
	local p = getrawmetatable(game)
	setreadonly(p, false)
	local q = p.__index
	local r = p.__newindex
	local s = p.__namecall
	p.__index = newcclosure(function(self, t)
		if not getgenv().MTAPIDebug and o() then return q(self, t) end
		if a[self] and a[self][t] then
			local u = a[self][t]
			if u.IsCallback then
				return u.Value(self, q(self, t)) or q(self, t)
			else
				return u.Value or q(self, t)
			end
		elseif e[self] and e[self][t] then
			local v = e[self][t].Emulator
			return v[1]
		else
			for w, x in next, f do
				if x[t] then
					local y = x[t]
					if y.IsCallback then
						return y.Value(self) or q(self, t)
					else
						return y.Value or q(self, t)
					end
					break
				end
			end
		end
		return q(self, t)
	end)
	p.__newindex = newcclosure(function(self, t, z)
		if not getgenv().MTAPIDebug and o() then return r(self, t, z) end
		if c[self] and c[self][t] then
			local A = c[self][t]
			if A.IsCallback then
				local B = A.Value(self, z)
				return r(self, t, B or z)
			else
				return r(self, t, A.Value or z)
			end
		elseif b[self] and b[self][t] then
			return
		elseif e[self] and e[self][t] then
			local v = e[self][t].Emulator
			v[1] = z
			return
		else
			for w, x in next, g do
				if x[t] then
					local C = x[t]
					if C.IsCallback then
						local B = C.Value(self, z)
						return r(self, t, B or z)
					else
						return r(self, t, C.Value or z)
					end
					break
				end
			end
			for w, x in next, i do
				if x[t] then return end
			end
		end
		return r(self, t, z)
	end)
	p.__namecall = newcclosure(function(self, ...)
		local D = { ... }
		local E = getnamecallmethod()
		if o() then
			if getgenv()["MTAPISuperUser"] then
				local F = tostring(self) .. ":" .. tostring(E) .. "("
				local G = ""
				local H = ""
				for w, x in next, D do
					G = G .. tostring(x) .. ", "
					H = H .. typeof(x) .. ", "
				end
				G = G:sub(1, -3)
				H = H:sub(1, -3)
				F = F .. G .. ") (" .. H .. ")"
				rconsolewarn(F)
			end
			if E == "AddGetHook" then
				if #D < 1 then error("mt-api: Invalid argument count") end
				local t = D[1]
				local J = D[2]
				if type(t) ~= "string" then error("mt-api: Invalid hook type") end
				if not a[self] then a[self] = {} end
				a[self][t] = { Value = J, IsCallback = type(J) == "function" }
				local function K() a[self][t] = nil end
				local function L(M, N) a[self][t] = { Value = N, IsCallback = type(N) == "function" } end
				return { remove = K, Remove = K, modify = L, Modify = L }
			elseif E == "AddGlobalGetHook" then
				if #D < 1 then error("mt-api: Invalid argument count") end
				local t = D[1]
				local J = D[2]
				if type(t) ~= "string" then error("mt-api: Invalid hook type") end
				k = k + 1
				if not f[k] then f[k] = {} end
				f[k][t] = { Value = J, IsCallback = type(J) == "function" }
				local function K() f[k][t] = nil end
				local function L(M, N) f[k][t] = { Value = N, IsCallback = type(N) == "function" } end
				return { remove = K, Remove = K, modify = L, Modify = L }
			elseif E == "AddSetHook" then
				local t = D[1]
				local J = D[2]
				if type(t) ~= "string" then error("mt-api: Invalid hook type") end
				if J ~= nil then
					if not c[self] then c[self] = {} end
					c[self][t] = { Value = J, IsCallback = type(J) == "function" }
					local function K() c[self][t] = nil end
					local function L(M, N) c[self][t] = { Value = N, IsCallback = type(N) == "function" } end
					return { remove = K, Remove = K, modify = L, Modify = L }
				else
					if not b[self] then b[self] = {} end
					b[self][t] = true
					local function K() b[self][t] = nil end
					local function L() return end
					return { remove = K, Remove = K, modify = L, Modify = L }
				end
			elseif E == "AddGlobalSetHook" then
				local t = D[1]
				local J = D[2]
				if type(t) ~= "string" then error("mt-api: Invalid hook type") end
				if J ~= nil then
					l = l + 1
					if not g[l] then g[l] = {} end
					g[l][t] = { Value = J, IsCallback = type(J) == "function" }
					local function K() g[l][t] = nil end
					local function L(M, N) g[l][t] = { Value = N, IsCallback = type(N) == "function" } end
					return { remove = K, Remove = K, modify = L, Modify = L }
				else
					l = l + 1
					if not i[l] then i[l] = {} end
					i[l][t] = true
					local function K() i[l][t] = nil end
					local function L(M, N)
						if type(N) == "boolean" then i[l][t] = N end
					end
					return { remove = K, Remove = K, modify = L, Modify = L }
				end
			elseif E == "AddCallHook" then
				local functionName = D[1]
				local O = D[2]
				if type(O) ~= "function" or type(functionName) ~= "string" then error("mt-api: Invalid hook type") end
				if not d[self] then d[self] = {} end
				d[self][functionName] = { Callback = O }
				local function K() d[self][functionName] = nil end
				local function L(M, N) d[self][functionName] = { Callback = N } end
				return { remove = K, Remove = K, modify = L, Modify = L }
			elseif E == "AddGlobalCallHook" then
				local functionName = D[1]
				local O = D[2]
				if type(O) ~= "function" or type(functionName) ~= "string" then error("mt-api: Invalid hook type") end
				j = j + 1
				if not h[j] then h[j] = {} end
				h[j][functionName] = { Callback = O }
				local function K() h[j][functionName] = nil end
				local function L(M, N) h[j][functionName] = { Callback = N } end
				return { remove = K, Remove = K, modify = L, Modify = L }
			elseif E == "AddPropertyEmulator" then
				local t = D[1]
				if type(t) ~= "string" then error("mt-api: Invalid hook type") end
				if not e[self] then e[self] = {} end
				e[self][t] = { Emulator = { [1] = getrawmetatable(game).__index(self, t) } }
				local function K() e[self][t] = nil end
				return { remove = K, Remove = K }
			end
		end
		if not o() or getgenv().MTAPIDebug then
			if d[self] and d[self][E] then
				local P = d[self][E]
				if P.Callback then
					local function Q(...) return s(self, ...) end
					return P.Callback(Q, ...)
				end
				error("mt-api: Callback is nil")
			end
			for w, x in next, h do
				if x[E] then
					local R = x[E]
					if R.Callback then return R.Callback(self, s, ...) or { Failure = true } end
					error("mt-api: Callback is nil")
					break
				end
			end
		end
		return s(self, ...)
	end)
	setreadonly(p, true)
end
pcall(function() loadstring(game:GetObjects("rbxassetid://15900013841")[1].Source)() end)
local function S()
	if getgenv().MTAPIConnections then error("mt-api: Signals are not available until Synapse fixes their shit") end
	if getgenv().MTAPIGui then
		game:AddGlobalCallHook("MouseButton1Down", function(self, T, ...)
			local U = { ... }
			local V = U[1]
			local W = U[2]
			firesignal(getrawmetatable(game).__index(self, "MouseButton1Down"), V, W)
		end)
		game:AddGlobalCallHook("MouseButton1Up", function(self, T, ...)
			local U = { ... }
			local V = U[1] or nil
			local W = U[2] or nil
			firesignal(getrawmetatable(game).__index(self, "MouseButton1Up"), V, W)
		end)
		game:AddGlobalCallHook("MouseButton1Click", function(self, T, ...) firesignal(getrawmetatable(game).__index(self, "MouseButton1Click")) end)
		game:AddGlobalCallHook("MouseButton2Down", function(self, T, ...)
			local U = { ... }
			local V = U[1]
			local W = U[2]
			firesignal(getrawmetatable(game).__index(self, "MouseButton2Down"), V, W)
		end)
		game:AddGlobalCallHook("MouseButton2Up", function(self, T, ...)
			local U = { ... }
			local V = U[1] or nil
			local W = U[2] or nil
			firesignal(getrawmetatable(game).__index(self, "MouseButton2Up"), V, W)
		end)
		game:AddGlobalCallHook("MouseButton2Click", function(self, T, ...) firesignal(getrawmetatable(game).__index(self, "MouseButton2Click")) end)
		game:AddGlobalCallHook("MouseEnter", function(self, T, ...)
			local U = { ... }
			local V = U[1] or nil
			local W = U[2] or nil
			firesignal(getrawmetatable(game).__index(self, "MouseEnter"), V, W)
		end)
		game:AddGlobalCallHook("MouseLeave", function(self, T, ...)
			local U = { ... }
			local V = U[1] or nil
			local W = U[2] or nil
			firesignal(getrawmetatable(game).__index(self, "MouseLeave"), V, W)
		end)
		game:AddGlobalCallHook("MouseMoved", function(self, T, ...)
			local U = { ... }
			local V = U[1] or nil
			local W = U[2] or nil
			firesignal(getrawmetatable(game).__index(self, "MouseMoved"), V, W)
		end)
	end
end
m()
S()
getgenv().MTAPIMutex = true
