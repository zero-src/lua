local ui_lib = (function() local function a(b,c,d,e)c=c or""d=d or 1;e=e or#b;local f=""for g=d,e do f=f..c..tostring(b[g])end;return f end;local function h(b,i)for g=1,#b do if b[g]==i then return true end end;return false end;local function j(k,...)if not k then error(a({...}),3)end end;local function l(b)local m,n=false,false;for o,k in pairs(b)do if type(o)=="number"then m=true else n=true end end;return m,n end;local p=globals.realtime()local q={}local r={}local s={}local function t(b)local u=false;for o,k in pairs(b)do if getmetatable(k)==s then u=true end end;return u end;local function v(k,w)return k~=q[w].default end;local function x(k)return#k>0 end;function s.__index(w,o)if q[w]~=nil and type(o)=="string"and o:sub(1,1)~="_"then return q[w][o]or r[o]end end;function s.__call(w,...)local y={...}if globals.realtime()==p and#y==1 and type(y[1])=="table"then local z={}local A=y[1]local B=false;local C=false;local D={}for o,k in pairs(A)do if type(o)~="number"then D[o]=k;C=true end end;if A[1]~=nil and(type(A[1])~="table"or not t(A[1]))then D[1]=A[1]B=true;if type(D[1])~="table"then D[1]={D[1]}end end;if C then table.insert(z,D)end;for g=B and 2 or 1,#A do if t(A[g])then table.insert(z,A[g])end end;for g=1,#z do local E=z[g]local k;if E[1]~=nil then k=E[1]end;for o,F in pairs(E)do if o~=1 then w:add_children(F,k,o)end end end;return w end;if#y==0 then return w:get()else local G,H=pcall(ui.set,y[1].reference,select(2,unpack(y)))j(G,string.format("Cannot set menu item values: '%s'",H))end end;function s.__tostring(w)return w.tab.." - "..w.container.." - "..w.name end;function r.new(I,J,K,L,...)local y={...}local M,N;local O;if type(I)=="function"and I~=ui.reference then for o,k in pairs(ui)do if k==I and o:sub(1,4)=="new_"then O=o:sub(5,-1)end end;M=I(J,K,L,unpack(y))N=I==ui.reference else M=I;N=true end;if O==nil then local k={pcall(ui.get,M)}if k[1]==false then O="button"else k={select(2,unpack(k))}if#k==1 then local P=type(k[1])if P=="string"then local G=pcall(ui.set,M,nil)ui.set(M,k[1])O=G and"textbox"or"combobox"elseif P=="number"then local G=pcall(ui.set,M,-9999999999999999)ui.set(M,k[1])O=G and"listbox"or"slider"elseif P=="boolean"then O="checkbox"elseif P=="table"then O="multiselect"end elseif#k==2 then if type(k[1])=="boolean"then O="hotkey"end elseif#k==4 then if type(k[1])=="number"and type(k[2])=="number"and type(k[3])=="number"and type(k[4])=="number"then O="color_picker"end end end end;local Q;if N==false and O~=nil then if O=="slider"then Q=y[3]or y[1]elseif O=="combobox"then Q=y[1][1]elseif O=="checkbox"then Q=false end end;local w={}q[w]={tab=J,container=K,name=L,reference=M,type=O,default=Q,visible=true,ui_callback=nil,callbacks={},is_gamesense_reference=N,children_values={},children_callbacks={}}if N==false and O~=nil then if O=="slider"then q[w].min=y[1]q[w].max=y[2]elseif O=="combobox"or O=="multiselect"or O=="listbox"then q[w].values=y[1]end end;return setmetatable(w,s)end;function r:set(...)local R={...}local S=q[self]local T={pcall(ui.set,S.reference,unpack(R))}j(T[1]==true,string.format("Cannot set menu item values: '%s'",T[2]))end;function r:get()local S=q[self]return ui.get(S.reference)end;function r:contains(k)local S=q[self]if S.type=="multiselect"then return h(ui.get(S.reference),k)elseif S.type=="combobox"then return ui.get(S.reference)==k else error(string.format("Invalid type %s for contains",S.type),2)end end;function r:set_visible(U)local S=q[self]ui.set_visible(S.reference,U)S.visible=U end;function r:set_default(k)j(globals.realtime()==p,"Cannot set default menu item value inside callbacks. This must be done during script load.")q[self].default=k;self:set(k)end;function r:add_children(V,W,o)local S=q[self]local X=type(W)=="function"if W==nil then W=true;if S.type=="boolean"then W=true elseif S.type=="combobox"then X=true;W=v elseif S.type=="multiselect"then X=true;W=x end end;if getmetatable(V)==s then V={V}end;for Y,F in pairs(V)do j(getmetatable(F)==s,"Cannot add a child to menu item: Child must be a menu_item object. Make sure you are not using a UI reference.")j(F.reference~=self.reference,"Cannot parent a menu item to itself.")if X then q[F].parent_visible_callback=W else q[F].parent_visible_value=W end;self[o or F.reference]=F end;r._process_callbacks(self)end;function r:add_callback(Z)local S=q[self]j(S.is_gamesense_reference==false,"Cannot create children of, parent, or add callbacks to built-in menu references.")table.insert(S.callbacks,Z)r._process_callbacks(self)end;function r:_process_callbacks()local S=q[self]if S.ui_callback==nil then local Z=function(M,_)local k=self:get()local a0=S.combo_elements;if a0~=nil and#a0>0 then local a1;for g=1,#a0 do local a2=a0[g]if#a2>0 then local a3={}for g=1,#a2 do if h(k,a2[g])then table.insert(a3,a2[g])end end;if#a3>1 then a1=a1 or k;for g=#a3,1,-1 do if h(S.value_prev,a3[g])and#a3>1 then table.remove(a3,g)end end;local a4=a3[1]for g=#a1,1,-1 do if a1[g]~=a4 and h(a2,a1[g])then table.remove(a1,g)end end elseif#a3==0 and not(a2.required==false)then a1=a1 or k;if S.value_prev~=nil then for g=1,#S.value_prev do if h(a2,S.value_prev[g])then table.insert(a1,S.value_prev[g])break end end end end end end;if a1~=nil then self:set(a1)end;S.value_prev=k;k=a1 or k end;for o,F in pairs(self)do local a5=q[F]local a6=false;if S.visible then if a5.parent_visible_callback~=nil then a6=a5.parent_visible_callback(k,self,F)elseif S.type=="multiselect"then local a7=type(a5.parent_visible_value)for g=1,#k do if a7 and h(a5.parent_visible_value,k[g])or a5.parent_visible_value==k[g]then a6=true;break end end elseif type(a5.parent_visible_value)=="table"then a6=a5.parent_visible_value[k]or h(a5.parent_visible_value,k)else a6=k==a5.parent_visible_value end end;ui.set_visible(a5.reference,a6)a5.visible=a6;if a5.ui_callback~=nil then a5.ui_callback(F)end end;for g=1,#S.callbacks do S.callbacks[g]()end end;ui.set_callback(S.reference,Z)S.ui_callback=Z end;S.ui_callback()end;local a8={}local a9={__index=function(Y,o)if a8[o]then return a8[o]end;local aa=o;if aa:sub(1,4)~="new_"then aa="new_"..aa end;if ui[aa]~=nil then local ab=ui[aa]return function(self,L,...)local y={...}local a0={}local ac=aa:sub(5,-1)local ad="Cannot create a "..ac..": "local w;if ab==ui.new_textbox and L==nil then L="\n"end;L=(self.prefix or"")..L..(self.suffix or"")j(type(L)=="string"and L~="",ad,"Cannot create a menu item with a name that is not a string, or is empty.")if ab==ui.new_slider then local ae,af,ag,ah,ai,aj,ak=unpack(y)j(type(ae)=="number",ad,"the minimum value must be a number.")j(type(af)=="number",ad,"the maximum value must be a number.")j(ae<af,ad,"the minimum value must be lower than the maximum")if type(ag)=="table"then local al=ag;ag=al.default;ah=al.show_tooltip;ai=al.unit;aj=al.scale;ak=al.tooltips end;j(type(ag)=="number"or type(ag)=="nil",ad,"the default value must be a number")if ag~=nil then j(ag>=ae and ag<=af,ad,"the default value must be between the minimum and maximum values.")end;j(type(ah)=="boolean"or type(ah)=="nil",ad,"the show_tooltip value must be a boolean")j(type(ai)=="string"or type(ai)=="nil",ad,"the unit must be a string or nil.")if ai~=nil then j(ai:len()>=0 and ai:len()<3,ad,"the unit must be 1 or 2 characters in length.")end;j(type(aj)=="number"or type(aj)=="nil",ad,"the scale must be a number or nil.")j(type(ak)=="table"or type(ak)=="nil",ad,"the tooltips must be a table or nil.")ag=ag or nil;ah=ah or true;ai=ai or nil;aj=aj or 1;ak=ak or nil;w=r.new(ui.new_slider,self.tab,self.container,L,ae,af,ag,ah,ai,aj,ak)elseif ab==ui.new_combobox or ab==ui.new_multiselect or ab==ui.new_listbox then local am={...}if#am==1 and type(am[1])=="table"then am=am[1]end;if ab==ui.new_multiselect then local an={}for g=1,#am do local I=am[g]if type(I)=="table"then table.insert(a0,I)for ao=1,#I do table.insert(an,I[ao])end else table.insert(an,I)end end;am=an end;for g=1,#am do local I=am[g]j(type(I)=="string"or type(I)=="number",ad,"menu element #",g," must be a string or number.")end;if ab==ui.new_multiselect then w=r.new(ui.new_multiselect,self.tab,self.container,L,am)end elseif ab==ui.new_hotkey then if y[1]==nil then y[1]=false end;local ap=unpack(y)j(type(ap)=="boolean",ad,"the inline parameter is not a boolean value.")elseif ab==ui.new_button then local Z=unpack(y)j(type(Z)=="function",ad,"the callback value given is not a function.")elseif ab==ui.new_color_picker then local aq,ar,as,at=unpack(y)j(type(aq)=="number",ad,"its red channel value is not a number.")j(type(ar)=="number",ad,"its green channel value is not a number.")j(type(as)=="number",ad,"its blue channel value is not a number.")j(type(at)=="number",ad,"its alpha channel value is not a number.")j(aq>=0 and aq<=255,ad,"its red channel value is not between 0-255.")j(ar>=0 and ar<=255,ad,"its green channel value is not between 0-255.")j(as>=0 and as<=255,ad,"its blue channel value is not between 0-255.")j(at>=0 and at<=255,ad,"its alpha channel value is not between 0-255.")end;if w==nil then w=r.new(ab,self.tab,self.container,L,...)end;self[q[w].reference]=w;if#a0>0 then q[w].combo_elements=a0;local au={}for g=1,#a0 do table.insert(au,a0[g][1])end;w:set(au)q[w].value_prev=au;r._process_callbacks(w)end;return w end end end}local av={RAGE={"Aimbot","Other"},AA={"Anti-aimbot angles","Fake lag","Other"},LEGIT={"Weapon type","Aimbot","Triggerbot","Other"},VISUALS={"Player ESP","Other ESP","Colored models","Effects"},MISC={"Miscellaneous","Settings","Movement"},SKINS={"Weapon skin","Knife options","Glove options"},PLAYERS={"Players","Adjustments"},CONFIG={"Lua", "Presets"},LUA={"A","B"}}for J,aw in pairs(av)do av[J]={}for g=1,#aw do av[J][aw[g]:lower()]=true end end;function a8.new(J,K)j(type(J)=="string"and J~="","Cannot create a menu item with a tab that is not a string, or is empty.")j(type(K)=="string"and K~="","Cannot create a menu item with a container that is not a string, or is empty.")J=J:upper()j(av[J]~=nil,string.format("Cannot create a menu with the tab name '%s' as it is not a valid tab.",J))j(av[J][K:lower()]~=nil,string.format("Cannot create a menu with the container name '%s' as it is not a valid name for the tab '%s'.",K,J))return setmetatable({tab=J,container=K,items={}},a9)end;function a8.reference(J,K,L)if L==nil and type(J)=="table"and getmetatable(J)==a9 then L=K;J,K=J.tab,J.container end;local ax={pcall(ui.reference,J,K,L)}j(ax[1]==true,"Cannot reference a Gamesense menu item: the menu item does not exist.")local ay={select(2,unpack(ax))}local az={}for g=1,#ay do local M=ay[g]local w=r.new(M,J,K,L)table.insert(az,w)end;return unpack(az)end;function a8:create(b)return b end;return setmetatable(a8,{__call=function(Y,...)return a8.new(...)end}) end)()
--------------------------------------------------------------------------------
-- HTTP functions
--------------------------------------------------------------------------------
local http = loadstring("local a=require(\"ffi\")a.cdef(\"typedef uint32_t request_handle_t; typedef uint64_t steam_api_call_t; typedef struct { void* __pad[11]; void* steam_http; }steam_ctx_t; typedef uint32_t(__thiscall* create_http_request_t)(void*, uint32_t, const char*); typedef bool(__thiscall* send_http_request_t)(void* _this, request_handle_t handle, steam_api_call_t call_handle); typedef bool(__thiscall* get_http_response_header_size_t)( void* _this, request_handle_t hRequest, const char *pchHeaderName, uint32_t *unResponseHeaderSize ); typedef bool(__thiscall* get_http_response_header_value_t)(void* _this, request_handle_t hRequest, const char *pchHeaderName, char *pHeaderValueBuffer, uint32_t unBufferSize); typedef bool(__thiscall* get_http_response_body_size_t)(void* _this, request_handle_t hRequest, uint32_t *unBodySize ); typedef bool(__thiscall* get_http_response_body_data_t)(void* _this, request_handle_t hRequest, char *pBodyDataBuf, uint32_t unBufferSize ); typedef bool(__thiscall* set_http_request_param_t)(void* _this, request_handle_t hRequest, const char* pchParamName, const char* pchParamValue); typedef bool(__thiscall* release_http_request_t)(void* _this, request_handle_t hRequest);\")local b=client.find_signature(\"client_panorama.dll\",\"\\xFF\\x15\\xCC\\xCC\\xCC\\xCC\\xB9\\xCC\\xCC\\xCC\\xCC\\xE8\\xCC\\xCC\\xCC\\xCC\\x6A\")or error(\"steam_ctx\")local c=a.cast(\"steam_ctx_t**\",a.cast(\"char*\",b)+7)[0]or error(\"steam_ctx not found\")local d=a.cast(\"void*\",c.steam_http)or error(\"steam_http error\")local e=a.cast(\"void***\",d)or error(\"steam_http_ptr error\")local f=e[0]or error(\"steam_http_ptr was null\")local g=a.cast('create_http_request_t',f[0])local h=a.cast('send_http_request_t',f[5])local i=a.cast('get_http_response_header_size_t',f[9])local j=a.cast('get_http_response_header_value_t',f[10])local k=a.cast('get_http_response_body_size_t',f[11])local l=a.cast('get_http_response_body_data_t',f[12])local m=a.cast('set_http_request_param_t',f[4])local n=a.cast('release_http_request_t',f[14])local o={}local p={__index=o}function o.new(q,r,s)local t={handle=q,url=r,callback=s,ticks=0}local u=setmetatable(t,p)return u end;local v={}local w={__index=v}function v.new(x,y,z)local t={state=x,body=y,header={content_type=z.content_type}}local A=setmetatable(t,w)return A end;function v:success()return self.state==0 end;local B={state={ok=0,no_response=1,timed_out=2,unknown=3}}local C={__index=B}function B.new(D)local D=D or{}local t={requests={},task_interval=D.task_interval or 0.5,enable_debug=false,timeout=D.timeout or 10}local E=setmetatable(t,C)E:_process_tasks()return E end;function B:get(r,s)local q=g(d,1,r)if h(d,q,0)==false then return end;local u=o.new(q,r,s)self:_debug(\"[HTTP] New GET request to: %s\",r)table.insert(self.requests,u)end;function B:post(r,F,s)local q=g(d,3,r)for G,H in pairs(F)do m(d,q,G,H)end;if h(d,q,0)==false then return end;local u=o.new(q,r,s)self:_debug(\"[HTTP] New POST request to: %s\",r)table.insert(self.requests,u)end;function B:_process_tasks()for I,u in ipairs(self.requests)do local J=a.new(\"uint32_t[1]\")self:_debug(\"--------------------\")self:_debug(\"[HTTP] Processing request #%s\",I)if k(d,u.handle,J)==true then local K=J[0]if K>0 then local y=a.new(\"char[?]\",K)if l(d,u.handle,y,K)==true then self:_debug(\"[HTTP] Request #%s finished. Invoking callback.\",I)table.remove(self.requests,I)n(d,u.handle)u.callback(v.new(B.state.ok,a.string(y,K),{content_type=B._get_header(u,\"Content-Type\")}))end else table.remove(self.requests,I)n(d,u.handle)u.callback(v.new(B.state.no_response,nil,{}))end end;local L=u.ticks+1;if L>=self.timeout then table.remove(self.requests,I)n(d,u.handle)u.callback(v.new(B.state.timed_out,nil,{}))else u.ticks=L end end;client.delay_call(self.task_interval,B._bind(self,'_process_tasks'))end;function B:_debug(...)if self.enable_debug==true then client.log(string.format(...))end end;function B._get_header(u,M)local N=a.new(\"uint32_t[1]\")if i(d,u.handle,M,N)then local O=N[0]local P=a.new(\"char[?]\",O)if j(d,u.handle,M,P,O)then return a.string(P,O)end end;return nil end;function B._bind(Q,G)return function(...)return Q[G](Q,...)end end;return B")().new()
local json = (function()local a={_version="0.1.2"}local b;local c={["\\"]="\\\\",["\""]="\\\"",["\b"]="\\b",["\f"]="\\f",["\n"]="\\n",["\r"]="\\r",["\t"]="\\t"}local d={["\\/"]="/"}for e,f in pairs(c)do d[f]=e end;local function g(h)return c[h]or string.format("\\u%04x",h:byte())end;local function i(j)return"null"end;local function k(j,l)local m={}l=l or{}if l[j]then error("circular reference")end;l[j]=true;if rawget(j,1)~=nil or next(j)==nil then local n=0;for e in pairs(j)do if type(e)~="number"then error("invalid table: mixed or invalid key types")end;n=n+1 end;if n~=#j then error("invalid table: sparse array")end;for o,f in ipairs(j)do table.insert(m,b(f,l))end;l[j]=nil;return"["..table.concat(m,",").."]"else for e,f in pairs(j)do if type(e)~="string"then error("invalid table: mixed or invalid key types")end;table.insert(m,b(e,l)..":"..b(f,l))end;l[j]=nil;return"{"..table.concat(m,",").."}"end end;local function p(j)return'"'..j:gsub('[%z\1-\31\\"]',g)..'"'end;local function q(j)if j~=j or j<=-math.huge or j>=math.huge then error("unexpected number value '"..tostring(j).."'")end;return string.format("%.14g",j)end;local r={["nil"]=i,["table"]=k,["string"]=p,["number"]=q,["boolean"]=tostring}b=function(j,l)local s=type(j)local t=r[s]if t then return t(j,l)end;error("unexpected type '"..s.."'")end;function a.encode(j)return b(j)end;local u;local function v(...)local m={}for o=1,select("#",...)do m[select(o,...)]=true end;return m end;local w=v(" ","\t","\r","\n")local x=v(" ","\t","\r","\n","]","}",",")local y=v("\\","/",'"',"b","f","n","r","t","u")local z=v("true","false","null")local A={["true"]=true,["false"]=false,["null"]=nil}local function B(C,D,E,F)for o=D,#C do if E[C:sub(o,o)]~=F then return o end end;return#C+1 end;local function G(C,D,H)local I=1;local J=1;for o=1,D-1 do J=J+1;if C:sub(o,o)=="\n"then I=I+1;J=1 end end;error(string.format("%s at line %d col %d",H,I,J))end;local function K(n)local t=math.floor;if n<=0x7f then return string.char(n)elseif n<=0x7ff then return string.char(t(n/64)+192,n%64+128)elseif n<=0xffff then return string.char(t(n/4096)+224,t(n%4096/64)+128,n%64+128)elseif n<=0x10ffff then return string.char(t(n/262144)+240,t(n%262144/4096)+128,t(n%4096/64)+128,n%64+128)end;error(string.format("invalid unicode codepoint '%x'",n))end;local function L(M)local N=tonumber(M:sub(3,6),16)local O=tonumber(M:sub(9,12),16)if O then return K((N-0xd800)*0x400+O-0xdc00+0x10000)else return K(N)end end;local function P(C,o)local Q=false;local R=false;local S=false;local T;for U=o+1,#C do local V=C:byte(U)if V<32 then G(C,U,"control character in string")end;if T==92 then if V==117 then local W=C:sub(U+1,U+5)if not W:find("%x%x%x%x")then G(C,U,"invalid unicode escape in string")end;if W:find("^[dD][89aAbB]")then R=true else Q=true end else local h=string.char(V)if not y[h]then G(C,U,"invalid escape char '"..h.."' in string")end;S=true end;T=nil elseif V==34 then local M=C:sub(o+1,U-1)if R then M=M:gsub("\\u[dD][89aAbB]..\\u....",L)end;if Q then M=M:gsub("\\u....",L)end;if S then M=M:gsub("\\.",d)end;return M,U+1 else T=V end end;G(C,o,"expected closing quote for string")end;local function X(C,o)local V=B(C,o,x)local M=C:sub(o,V-1)local n=tonumber(M)if not n then G(C,o,"invalid number '"..M.."'")end;return n,V end;local function Y(C,o)local V=B(C,o,x)local Z=C:sub(o,V-1)if not z[Z]then G(C,o,"invalid literal '"..Z.."'")end;return A[Z],V end;local function _(C,o)local m={}local n=1;o=o+1;while 1 do local V;o=B(C,o,w,true)if C:sub(o,o)=="]"then o=o+1;break end;V,o=u(C,o)m[n]=V;n=n+1;o=B(C,o,w,true)local a0=C:sub(o,o)o=o+1;if a0=="]"then break end;if a0~=","then G(C,o,"expected ']' or ','")end end;return m,o end;local function a1(C,o)local m={}o=o+1;while 1 do local a2,j;o=B(C,o,w,true)if C:sub(o,o)=="}"then o=o+1;break end;if C:sub(o,o)~='"'then G(C,o,"expected string for key")end;a2,o=u(C,o)o=B(C,o,w,true)if C:sub(o,o)~=":"then G(C,o,"expected ':' after key")end;o=B(C,o+1,w,true)j,o=u(C,o)m[a2]=j;o=B(C,o,w,true)local a0=C:sub(o,o)o=o+1;if a0=="}"then break end;if a0~=","then G(C,o,"expected '}' or ','")end end;return m,o end;local a3={['"']=P,["0"]=X,["1"]=X,["2"]=X,["3"]=X,["4"]=X,["5"]=X,["6"]=X,["7"]=X,["8"]=X,["9"]=X,["-"]=X,["t"]=Y,["f"]=Y,["n"]=Y,["["]=_,["{"]=a1}u=function(C,D)local a0=C:sub(D,D)local t=a3[a0]if t then return t(C,D)end;G(C,D,"unexpected character '"..a0 .."'")end;function a.decode(C)if type(C)~="string"then error("expected argument of type string, got "..type(C))end;local m,D=u(C,B(C,1,w,true))D=B(C,D,w,true)if D<=#C then G(C,D,"trailing garbage")end;return m end;return a end)()

-- Creating a database files
local user_db = database.read('bytemode_db') or {}
local db = database.read('s_bytemode') or {}
user_db.active = false

-- Colored console logs
local log_color = { r = 255, g = 222, b = 5 } 

local client_log = function(text)
    client.color_log(log_color.r, log_color.g, log_color.b, "[bytemode]\0")
	client.color_log(163, 163, 163, " ", text)
end

-- To/From hex functions
function string.tohex(str) 
    return (str:gsub('.', function (c) return string.format('%02X', string.byte(c)) end)) 
end
function string.fromhex(str) 
    return (str:gsub('..', function (cc) return string.char(tonumber(cc, 16)) end)) 
end

-- Generating key for getting stuff
http:get('https://ipv4.icanhazip.com/', function(response)
    local current_ip = response.body
        local current_key = string.tohex(current_ip)

    http:get('PRIVATE', function(response) 
        local web_info = json.decode(response.body)
        for i, user in pairs(web_info.users) do

            if current_key == user.key and current_key ~= nil then
                user_db.active = true
                user_db.username = user.username
                user_db.status = user.status
                database.write("bytemode_db", user_db)
            end

            if user_db.key ~= nil then
                if user_db.key == user.key then user_db.active = true return else user_db.active = false
                end
            end
        end
	if user_db.active == nil or user_db.active == false or current_key == nil then
        	user_db.username = "-"
        	user_db.status = "-"
        	client_log('PM administrator. Your key is: ' .. current_key) 
    	end
    end)
end)

--------------------------------------------------------------------------------
-- Define elements
--------------------------------------------------------------------------------
local dragging = (function()local a={}local b,c,d,e,f,g,h,i,j,k,l,m,n,o;local p={__index={drag=function(self,...)local q,r=self:get()local s,t=a.drag(q,r,...)if q~=s or r~=t then self:set(s,t)end;return s,t end,set=function(self,q,r)local j,k=client.screen_size()ui.set(self.x_reference,q/j*self.res)ui.set(self.y_reference,r/k*self.res)end,get=function(self)local j,k=client.screen_size()return ui.get(self.x_reference)/self.res*j,ui.get(self.y_reference)/self.res*k end}}function a.new(u,v,w,x)x=x or 10000;local j,k=client.screen_size()local y=ui.new_slider("LUA","A",u.." window position",0,x,v/j*x)local z=ui.new_slider("LUA","A","\n"..u.." window position y",0,x,w/k*x)ui.set_visible(y,false)ui.set_visible(z,false)return setmetatable({name=u,x_reference=y,y_reference=z,res=x},p)end;function a.drag(q,r,A,B,C,D,E)if globals.framecount()~=b then c=ui.is_menu_open()f,g=d,e;d,e=ui.mouse_position()i=h;h=client.key_state(0x01)==true;m=l;l={}o=n;n=false;j,k=client.screen_size()end;if c and i~=nil then if(not i or o)and h and f>q and g>r and f<q+A and g<r+B then n=true;q,r=q+d-f,r+e-g;if not D then q=math.max(0,math.min(j-A,q))r=math.max(0,math.min(k-B,r))end end end;table.insert(l,{q,r,A,B})return q,r,A,B end;return a end)()
local assert, bit_band, client_delay_call, client_userid_to_entindex, entity_get_local_player, entity_get_player_weapon, get_prop, entity_is_alive, ipairs, get, ui_new_checkbox, ui_new_combobox, ui_new_label, ui_reference, set, set_callback, set_visible, unpack = assert, bit.band, client.delay_call, client.userid_to_entindex, entity.get_local_player, entity.get_player_weapon, entity.get_prop, entity.is_alive, ipairs, ui.get, ui.new_checkbox, ui.new_combobox, ui.new_label, ui.reference, ui.set, ui.set_callback, ui.set_visible, unpack

local entity_is_enemy, entity_get_all, entities = entity.is_enemy, entity.get_all, entity.get_players
local min, max, abs, sqrt, floor = math.min, math.max, math.abs, math.sqrt, math.floor

local me = entity.get_local_player()
local weapon = entity.get_player_weapon(me)

local ui_dragging = dragging.new("UI", 262, 162)

--------------------------------------------------------------------------------
-- Constants and variables
--------------------------------------------------------------------------------
local screen = { x, y, }
local saved_enable = { }
local targeted = 0
local updates = 0
local cache = { }
local misses = 0
local alpha = 0
local hits = 0


local gif_decoder = require "gamesense/gif_decoder"
local scripts_reloaded = true

screen.x, screen.y = client.screen_size()
local display = ui_lib.new('config', 'lua')
local menu = ui_lib.new('aa', 'other')

--------------------------------------------------------------------------------
-- Script functions
--------------------------------------------------------------------------------
local script = {
    variable = { '-', 'Automatic', 'Manual[beta]'},
    global_dtap = nil,
    var_cached = nil,
    
    active = false,
    
    time = -0.26,
    max_time = 0,
}
--------------------------------------------------------------------------------
-- Menu functions
--------------------------------------------------------------------------------
local is_active = menu:checkbox('Enable lua script') {
    mode = menu:combobox('\n player fixes', {'-', 'Automatic', 'Manual[beta]'}){
        {
            'Manual[beta]', custom_velocity = menu:slider('velocity',  0, 300, 100, true, "", 1)
        }
    },
    force_body = menu:checkbox('Prefer baim'),
    reduce_points = menu:checkbox('Reduce useless points'),
    hcfix = menu:checkbox('Increase hitchance precision'),
    dtcorrections = menu:checkbox('DT manipulations'),
    fix_opposits = menu:checkbox('Opposits with fast dt'),
    fix_opposits_hk = menu:hotkey('Opposits hotkey', true),
}

local draw_display = display:checkbox('Display menu'){
    display_color = display:color_picker("text", 255, 255, 255, 255),
    disable_overlay = display:checkbox('Disable overlay'),
}

-- ragebot features
local rage_enabled = { ui_lib.reference('rage', 'aimbot', 'enabled') }
local hitchance = ui.reference('rage', 'aimbot', 'minimum hit chance')
local rage_boost = ui_lib.reference('rage', 'other', 'accuracy boost')
local delay = ui_lib.reference('rage', 'other', 'delay shot')
local f_duck = ui_lib.reference('rage', 'other', 'duck peek assist')
local doubletap = { ui_lib.reference('rage', 'other', 'double tap') }

-- legit features
local triggerbot = { ui_lib.reference('legit', 'triggerbot', 'enabled') }
local legit_track_box = ui_lib.reference('legit', 'other', 'accuracy boost')
local legit_track = ui_lib.reference('legit', 'other', 'accuracy boost range')

-- aa features
local antiaim = ui_lib.reference('aa', 'anti-aimbot angles', 'enabled')
local fake_lag = ui_lib.reference('aa', 'fake lag', 'enabled')
local fake_lag_lim = ui_lib.reference('aa', 'fake lag', 'limit')

-- misc features
local knifebot = ui_lib.reference('misc', 'miscellaneous', 'knifebot')
local taserbot = ui_lib.reference('misc', 'miscellaneous', 'zeusbot')
local safe_move = ui_lib.reference('misc', 'movement', 'standalone quick stop')
local menu_color = ui_lib.reference('misc', 'settings', 'menu color')

local ticks_to_process = ui.reference('misc', 'settings', 'sv_maxusrcmdprocessticks')
local command_holdaim = ui.reference('misc', 'settings', 'sv_maxusrcmdprocessticks_holdaim')

-- playerlist features
local player_list = ui.reference('players', 'players', 'player list')
--local boost = ui_lib.reference('players', 'adjustments', 'override accuracy boost')
local baim = ui_lib.reference('players', 'adjustments', 'override prefer body aim')
local safe_point = ui_lib.reference('players', 'adjustments', 'override safe point')

--------------------------------------------------------------------------------
-- Local new functions
--------------------------------------------------------------------------------
local function cache_process(condition, should_call, a, b)
    local name = tostring(condition)
    cache[name] = cache[name] ~= nil and cache[name] or get(condition)
 
    if should_call then
        if type(a) == "function" then a() else
            set(condition, a)
        end
    else
        if cache[name] ~= nil then
            if b ~= nil and type(b) == "function" then
                b(cache[name])
            else
                set(condition, cache[name])
            end
 
            cache[name] = nil
        end
    end
end

local function players_in_dormant(enemy_only, alive_only)
    local enemy_only = enemy_only ~= nil and enemy_only or false
    local alive_only = alive_only ~= nil and alive_only or true
    local result = {}
 
    local player_resource = entity_get_all("CCSPlayerResource")[1]
    for player=1, globals.maxplayers() do
        if get_prop(player_resource, "m_bConnected", player) == 1 then
            local local_player_team, is_enemy, is_alive = nil, true, true
            if enemy_only then local_player_team = get_prop(entity.get_local_player(), "m_iTeamNum") end
            if enemy_only and get_prop(player, "m_iTeamNum") == local_player_team then is_enemy = false end
            if is_enemy then
                if alive_only and get_prop(player_resource, "m_bAlive", player) ~= 1 then is_alive = false end
                if is_alive then table.insert(result, player) end
            end
        end
    end
 
    return result
end

local function get_velocity(entindex)
 
    local vx, vy = get_prop(entindex, "m_vecVelocity")
    local speed = sqrt(vx*vx + vy*vy)
 
    if speed ~= nil then
        return floor(speed)
    end
 
end

local function on_player_hurt(e)
    local attacker_id = client_userid_to_entindex(e.attacker)
    if attacker_id == nil then
        return
    end
 
    if attacker_id ~= entity_get_local_player() then
        return
    end
 
    hits = hits + 1
   
end
 
local function hex_to_bin(hex)
    return (hex:gsub('..', function(cc)
        return string.char(tonumber(cc, 16))
    end))
end

local function on_aim_miss(e)
    misses = misses + 1
end

--------------------------------------------------------------------------------
-- More functions/callbacks
--------------------------------------------------------------------------------
local function a_container(ctx, x, y, w, h)
    local c = {10, 60, 40, 40, 40, 60, 20}
    for i = 0, 6, 1 do
        client.draw_rectangle(ctx, x + i, y + i, w - (i * 2), h - (i * 2), c[i + 1], c[i + 1], c[i + 1], alpha)
    end
    for i = 1, w - 12 do
        if i % 4 == 0 then
            for k = 1, h - 14 do
                if k % 4 == 0 then
                    client.draw_rectangle(ctx, x + i + 4, y + k + 3, 1, 3, 15, 15, 15, alpha)
                end
            end
        end
       
        if i % 4 == 2 then
            for k = 1, h - 14 do
                if k % 4 == 0 then
                    client.draw_rectangle(ctx, x + i + 4, y + k + 5, 1, 3, 15, 15, 15, alpha)
                end
            end
        end
    end
end

local function s_container(ctx, x, y, w, h)
    local c = {10, 60, 40, 40, 40, 60, 20}
    for i = 0,6,1 do
        client.draw_rectangle(ctx, x+i, y+i, w-(i*2), h-(i*2), c[i+1], c[i+1], c[i+1], 255)
    end
end

local function draw_ind(entindex)
    local vx, vy = get_prop(entindex, "m_vecVelocity")
    local speed = sqrt(vx*vx + vy*vy)
 
    if speed ~= nil then
        if 250 < speed or (speed > 5 and speed < 70) then
            return 'LOW'
        elseif (225 < speed and speed <= 250) or (50 < speed and 70 > speed) then
            return 'HIGHT'
        else return 'AUTO'
        end
    end
end

local function check_accuracy()
    if legit_track_box:get() == 'Low' then
        return ' LOW'
    elseif legit_track_box:get() == 'High' then
        return ' HIGH'
    else return ''
    end
 
end

client.set_event_callback('player_hurt', on_player_hurt)
client.set_event_callback('aim_miss', on_aim_miss)
client.set_event_callback("player_connect_full", function(e)
    if client.userid_to_entindex(e.userid) ~= entity.get_local_player() then
        return
    end
    misses = 0
    hits = 0
end)
--------------------------------------------------------------------------------
-- Watermark
--------------------------------------------------------------------------------
local flazze_jpg = 0
local image = 0

local function draw_avatar()
    if user_db.username == 'HIDDEN' then
        return flazze_jpg

    elseif user_db.username == 'Death' then
        return image

    else 
        return

    end
end

local function load_watermark()
    local r, g, b = menu_color:get()

    local pos = { x, y,}
          pos.x, pos.y = ui.menu_position()
    local size_x, size_y = ui.menu_size()

    local fade_factor = ((1 / (135 / 1000)) * globals.frametime()) * 255
    if ui.is_menu_open() and alpha < 255  then
        alpha = math.min(alpha + fade_factor, 255)
    end
    if not ui.is_menu_open() and alpha > 0 then
        alpha = math.max(alpha - fade_factor, 0)
    end

    if ui.is_menu_open() then 
        s_container(ctx, pos.x, pos.y - 80, 78, 78)
        s_container(ctx, pos.x + 83, pos.y - 42, size_x - 83, 40)
    end

    -- Watermark notice 
    local latency = floor(client.latency()*1000+0.5)
    local hh, mm, ss = client.system_time()

    local max_lim = get(ticks_to_process) - 2
    local cur_lim = fake_lag_lim:get()

    if user_db.username ~= nil and user_db.status ~= nil then
        renderer.text(pos.x + 92, pos.y - 29, 255, 255, 255, alpha, "", 0, 'Username: ')
            renderer.text(pos.x + 92 + renderer.measure_text(nil, 'Username: '), pos.y - 29, r, g, b, alpha, "", 0, user_db.username)

        local simple_width = pos.x + 92 + renderer.measure_text(nil, 'Username: ') + renderer.measure_text(nil, user_db.username)
        renderer.text(simple_width, pos.y - 29, 255, 255, 255, alpha, "", 0, ' | bytemode[' .. user_db.status .. '] | fake lag: ')

        local simple_width2 = simple_width + renderer.measure_text(nil, ' | bytemode[' .. user_db.status .. '] | fake lag: ')
        local w_fakelags = cur_lim .. ' of ' .. max_lim .. ' '

        renderer.text(simple_width2, pos.y - 29, r, g, b, alpha, "", 0, fake_lag:get() and w_fakelags or 'nil')
        renderer.texture(draw_avatar(), pos.x + 7, pos.y - 73, 64, 64, 255, 255, 255, alpha )
    end

end
--------------------------------------------------------------------------------
-- Computer display
--------------------------------------------------------------------------------
local gif1 = gif_decoder.load_gif(readfile("4NB4.gif") or error("file 4NB4.gif doesn't exist"))
local gif2 = gif_decoder.load_gif(readfile("csgo.gif") or error("file csgo.gif doesn't exist"))
local start_time = globals.realtime()
local function local_velocity()
    local me = entity.get_local_player()
    local vx, vy = get_prop(me, "m_vecVelocity")
    local speed = sqrt(vx*vx + vy*vy)
 
    if speed ~= nil then
        return floor(speed)
    end
 
end

local function display_mode() 
    if rage_enabled[1]:get() and rage_enabled[2]:get() then
        return ' rage' else return ' legit'
    end
end

local function computer_display()
        local is_active_flag = false
        local reduce_points_flag = false
        local hcfix_flag = false
        local dtcorrections_flag = false
        local fix_opposits_flag = false
     
        local x, y = ui_dragging:get()
        local r, g, b = menu_color:get()
        local cr, cg, cb, ca = draw_display.display_color:get()
        local me = entity.get_local_player()
        local local_name = entity.get_player_name(me)
     
        local bar_x, bar_y, bar_w, bar_h = x + 6, y + 6, 5, 91
        local hp = get_prop(me, 'm_iHealth') ~= nil and get_prop(me, 'm_iHealth') or 0
        local h_bar_h = bar_y + 43
        local n = 'computer'
     
        local health_bar = (max(0, min(96, hp))) / 100
        local display_hp = string.format('%d', hp)
     
        local total = misses + hits
        if total == 0 then total = 1 end
        local hitPercent = hits / total
        local fixed = 0
        if (hitPercent > 0)  then
        fixed = hitPercent * 100
        fixed = string.format("%2.1f", fixed)
        end
       
        if get_prop(me, 'm_iHealth') == nil or me == nil then
            return
        end

        if draw_display:get() then
            if ui.is_menu_open() then
                s_container(ctx, x, y, 262, 162)
            end
     
            gif1:draw(globals.realtime()-start_time, x + 6, y + 6, 250, 150, 180, 180, 180, 255) -- background
            gif2:draw(globals.realtime()-start_time, x + 22, y + 14, 320, 150, 255, 255, 255, 255) -- ct model
     
            renderer.text(x + 10, y + 9, cr, cg, cb, ca, "", 0, n)
            renderer.rectangle(bar_x + 145, bar_y + 40, bar_w, bar_h, 30, 30, 30, 180)
           
            renderer.rectangle(bar_x + 146, bar_y + 130, bar_w-2, bar_h*(-health_bar)-2, 25, 200, 25, 255)
            renderer.text(bar_x - renderer.measure_text(nil, get_prop(me, 'm_iHealth') % 10) + 140, bar_y + 44, 255, 255, 255, 255, "c-", 0, display_hp)
            renderer.text(bar_x - renderer.measure_text(nil, 'name') + 262/2 + 70, bar_y + 30, cr, cg, cb, ca, "c", 0, 'name')
           
            renderer.text(x + 10, y + 44, cr, cg, cb, ca, "", 0, 'mode:')
     
            if rage_enabled[1]:get() and rage_enabled[2]:get() then
                renderer.text(x + 10 + renderer.measure_text(nil, 'mode:'), y + 44, r, g, b, 255, "", 0, display_mode())
                renderer.text(x + 10, y + 58, cr, cg, cb, ca, "", 0, 'velocity: ' .. local_velocity())
                renderer.text(x + 10, y + 74, cr, cg, cb, ca, "", 0, 'misses: ' .. misses)
                renderer.text(x + 10, y + 86, cr, cg, cb, ca, "", 0, 'accuracy: ' .. fixed)
                renderer.text(x + 10, y + 100, cr, cg, cb, ca, "", 0, 'safe movement: ')
                if safe_move:get() then renderer.text(x + 10 + renderer.measure_text(nil, 'safe movement: '), y + 100, 60, 255, 60, 255, "", 0, 'on') else renderer.text(x + 10 + renderer.measure_text(nil, 'safe movement: '), y + 100, 255, 60, 60, 255, "", 0, 'nil') end
            else
                renderer.text(x + 10 + renderer.measure_text(nil, 'mode:'), y + 44, 60, 255, 60, 255, "", 0, display_mode())
                renderer.text(x + 10, y + 58, cr, cg, cb, ca, "", 0, 'velocity: ' .. local_velocity())
                renderer.text(x + 10, y + 72, cr, cg, cb, ca, "", 0, 'knifebot: ')
                renderer.text(x + 10, y + 86, cr, cg, cb, ca, "", 0, 'taserbot: ')
                renderer.text(x + 10, y + 100, cr, cg, cb, ca, "", 0, 'antiaim: ')
                renderer.text(x + 10, y + 114, cr, cg, cb, ca, "", 0, 'fakelag: ')
                renderer.text(x + 10, y + 128, cr, cg, cb, ca, "", 0, 'safe movement: ')
                if knifebot:get() then renderer.text(x + 10 + renderer.measure_text(nil, 'knifebot: '), y + 72, 60, 255, 60, 255, "", 0, 'on') else renderer.text(x + 10 + renderer.measure_text(nil, 'knifebot: '), y + 72, 255, 60, 60, 255, "", 0, 'nil') end
                if taserbot:get() then renderer.text(x + 10 + renderer.measure_text(nil, 'taserbot: '), y + 86, 60, 255, 60, 255, "", 0, 'on') else renderer.text(x + 10 + renderer.measure_text(nil, 'taserbot: '), y + 86, 255, 60, 60, 255, "", 0, 'nil') end
                if antiaim:get() then renderer.text(x + 10 + renderer.measure_text(nil, 'antiaim: '), y + 100, 60, 255, 60, 255, "", 0, 'on') else renderer.text(x + 10 + renderer.measure_text(nil, 'antiaim: '), y + 100, 255, 60, 60, 255, "", 0, 'nil') end
                if fake_lag:get() then renderer.text(x + 10 + renderer.measure_text(nil, 'fakelag: '), y + 114, 60, 255, 60, 255, "", 0, 'on') else renderer.text(x + 10 + renderer.measure_text(nil, 'fakelag: '), y + 114, 255, 60, 60, 255, "", 0, 'nil') end
                if safe_move:get() then renderer.text(x + 10 + renderer.measure_text(nil, 'safe movement: '), y + 128, 60, 255, 60, 255, "", 0, 'on') else renderer.text(x + 10 + renderer.measure_text(nil, 'safe movement: '), y + 128, 255, 60, 60, 255, "", 0, 'nil') end
                renderer.text(bar_x + 173, h_bar_h - 24, 97, 193, 161, 255, "c-", 0, string.format('%d', legit_track:get()) .. check_accuracy())
            end
     
            if is_active:get() then
                renderer.text(bar_x + 202, h_bar_h, r, g, b, 255, "c-", 0, 'ON')
                is_active_flag = true else is_active_flag = false
            end
     
            if triggerbot[1]:get() and triggerbot[2]:get() and not (rage_enabled[1]:get() and rage_enabled[2]:get()) then
                renderer.text(bar_x + 202, h_bar_h, r, g, b, 255, "c-", 0, '[X]')
            end
     
            if is_active:get() and is_active.force_body:get() and (is_active.mode:get() == script.variable[2] or is_active.mode:get() == script.variable[3]) and rage_enabled[1]:get() and rage_enabled[2]:get() then
                renderer.text(bar_x + 173, h_bar_h - 24, 97, 193, 161, 255, "c-", 0, 'BAIM')
            end
     
            if is_active:get() and is_active.reduce_points:get() then
                renderer.text(bar_x + 204, h_bar_h + 10, 255, 255, 255, 255, "c-", 0, 'RUP')
                reduce_points_flag = true else reduce_points_flag = false
            end
     
            if is_active:get() and is_active.hcfix:get() then
                if reduce_points_flag then
                    renderer.text(bar_x + 201, h_bar_h + 20, 255, 255, 255, 255, "c-", 0, 'HF')
                elseif reduce_points_flag == false then
                    renderer.text(bar_x + 201, h_bar_h + 10, 255, 255, 255, 255, "c-", 0, 'HF')
                end
                hcfix_flag = true else hcfix_flag = false
            end
     
            if is_active:get() and is_active.dtcorrections:get() then
                if reduce_points_flag and hcfix_flag then
                    renderer.text(bar_x + 201, h_bar_h + 30, 255, 255, 255, 255, "c-", 0, 'DT')
                elseif (reduce_points_flag == false and hcfix_flag == true) or (reduce_points_flag == true and hcfix_flag == false) then
                    renderer.text(bar_x + 201, h_bar_h + 20, 255, 255, 255, 255, "c-", 0, 'DT')
                elseif reduce_points_flag == false and hcfix_flag == false then
                    renderer.text(bar_x + 201, h_bar_h + 10, 255, 255, 255, 255, "c-", 0, 'DT')
                end
                dtcorrections_flag = true else dtcorrections_flag = false
            end
     
            if is_active:get() and is_active.fix_opposits:get() and is_active.fix_opposits_hk:get() then
                if reduce_points_flag and hcfix_flag and dtcorrections_flag then
                    renderer.text(bar_x + 202, h_bar_h + 40, 255, 255, 255, 255, "c-", 0, 'OP')
                elseif (reduce_points_flag == false and hcfix_flag == true and dtcorrections_flag == true) or (reduce_points_flag == true and hcfix_flag == true and dtcorrections_flag == false) or (reduce_points_flag == true and hcfix_flag == false and dtcorrections_flag == true) then
                    renderer.text(bar_x + 202, h_bar_h + 30, 255, 255, 255, 255, "c-", 0, 'OP')
                elseif (reduce_points_flag == false and hcfix_flag == false and dtcorrections_flag == true) or (reduce_points_flag == false and hcfix_flag == true and dtcorrections_flag == false) or (reduce_points_flag == true and hcfix_flag == false and dtcorrections_flag == false) then
                    renderer.text(bar_x + 202, h_bar_h + 20, 255, 255, 255, 255, "c-", 0, 'OP')
                elseif reduce_points_flag == false and hcfix_flag == false and dtcorrections_flag == false then
                    renderer.text(bar_x + 202, h_bar_h + 10, 255, 255, 255, 255, "c-", 0, 'OP')
                end
                fix_opposits_flag = true else fix_opposits_flag = false
            end
        end
     
        ui_dragging:drag(262, 162)

end
--------------------------------------------------------------------------------
-- Callbacks
--------------------------------------------------------------------------------
ui.set_callback(player_list, function()
    is_active:set( saved_enable[get(player_list)] or false )
end)

is_active:add_callback( function()
    local plist = get(player_list)
    if plist then
        saved_enable[plist] = is_active:get()
    end
end)

client.set_event_callback("predict_command", function()
    script.active = is_active:get()
    script.time = -0.26
 
    local me = entity.get_local_player()
    local weapon = entity.get_player_weapon(me)
 
    script.var_cached = script.var_cached ~= nil and script.var_cached or fake_lag_lim:get()
    local m_flNextAttack = get_prop(me, "m_flNextAttack")
    local next_attack = get_prop(weapon, "m_flNextPrimaryAttack")
 
    if next_attack == nil then
        script.active = false
        return
    end
 
    local max_time = 0.69
    local current_time = globals.curtime()
    local m_flAttackTime = next_attack + 0.5
 
    local m_flNextAttack = m_flNextAttack + 0.5
    local shift_time = m_flAttackTime - current_time
 
    if m_flAttackTime < m_flNextAttack then
        max_time = 1.52
        shift_time = m_flNextAttack - current_time
    end
 
    script.time = shift_time
    script.max_time = max_time
 
    local is_safe = max_time ~= 1.52 and shift_time > 0.1
    local fd_active = f_duck:get()
 
    if fd_active then
        fake_lag_lim:set(14)
    else
        if script.var_cached ~= nil then
            fake_lag_lim:set(script.var_cached) 
            script.var_cached = nil
        end
    end
 
    if is_active.hcfix:get() then
        local shots_fired = get_prop(me, "m_iShotsFired")
 
        cache_process(hitchance, script.active and is_safe and shots_fired > 0 and shift_time >= (max_time - 0.1), 0) ------------------
    end
 
end)

client.set_event_callback("setup_command", function(cmd)
    if is_active.dtcorrections:get() and is_active:get() then
        set(ticks_to_process, 18)
        cvar.cl_clock_correction:set_int(0)
    end
 
    if is_active.fix_opposits:get() and is_active.fix_opposits_hk:get() and is_active:get() then
        if script.global_dtap ~= nil then
            doubletap[1]:set(script.global_dtap)
            script.global_dtap = nil
        end
 
        local m_vecvel = { entity.get_prop(me, 'm_vecVelocity') }
        local velocity = math.floor(math.sqrt(m_vecvel[1]^2 + m_vecvel[2]^2))
 
        script.global_dtap = velocity <= 1 and doubletap[1]:get() or script.global_dtap
 
        if script.global_dtap ~= nil then
            doubletap[1]:set(false) 
        end
    end
end)

client.set_event_callback("run_command", function() 
    if not ui.is_menu_open() then 
        client.update_player_list()  
        if is_active:get() then
            for k, v in pairs(saved_enable) do
            
                if entity.is_enemy(k) then    
                    set(player_list, k)
                
                if v then
                    local x, y = entity.get_prop(k, "m_vecVelocity")
                        local ent_speed = math.abs(math.sqrt(x^2 + y^2))

                        if is_active.mode:get() == 'Automatic' then -- auto
    
                            if 5 < ent_speed and 70 > ent_speed and is_active.force_body:get() then
                                baim:set('force') 
                            else
                                baim:set('-') 
                            end
    
                            if (ent_speed > 5 and ent_speed < 70) and is_active.reduce_points:get() or (ent_speed > 260) then
                                safe_point:set('on') 
                            else
                                safe_point:set('-') 
                            end
    
                        elseif is_active.mode:get() == 'Manual[beta]' then
                            --------------------------------
                            if is_active.custom_velocity:get() < ent_speed then
                                boost:set('low') 
                            else
                                boost:set('-') 
                            end
    
                            if 5 < ent_speed and 50 > ent_speed and is_active.force_body:get() then
                                baim:set('force') 
                            else
                                baim:set('-') 
                            end
    
                            if (ent_speed >= 0 and ent_speed < 50) and is_active.reduce_points:get() or (ent_speed > 260) then
                                safe_point:set('on') 
                            else
                                safe_point:set('on') 
                            end
                            --------------------------------
                        else
                            return
                        end
                else
                    baim:set('-')                
                end        
    
                end        
            end
        else return
        end
    end
    if script.global_dtap ~= nil and is_active.fix_opposits:get() and is_active.fix_opposits_hk:get() and is_active:get() then
        doubletap[1]:set(script.global_dtap)
        script.global_dtap = nil
    end
end)

client.set_event_callback("paint", function()
    if draw_display:get() and draw_display.disable_overlay:get() then
        if ui.is_menu_open() then
            computer_display()
        else
            computer_display()
        end
    end

    local hp = get_prop(me, 'm_iHealth') ~= nil and get_prop(me, 'm_iHealth') or 0
    local ingame_players = players_in_dormant(true, true)
    if #ingame_players == 0 then return end

    if hp ~= 0 and me ~= nil and hp ~= nil and is_active:get() then
        for i=1, #ingame_players do

            local name = entity.get_player_name(ingame_players[i])
            local y_additional = name == "" and -8 or 0
            local x1, y1, x2, y2, a_multiplier = entity.get_bounding_box(c, ingame_players[i])

            if x1 ~= nil and entity.is_alive(ingame_players[i]) and a_multiplier > 0 then
                local x_center = x1 + (x2-x1)/2
                if x_center ~= nil then
                    if is_active.mode:get() == script.variable[2] and is_active:get() then
                        client.draw_text(c, x_center - 2, y1 + y_additional - 16, 69, 133, 196, 180, "c-", 0, draw_ind(ingame_players[i]))
                    end
                    if is_active.mode:get() == script.variable[3] and is_active:get() then
                        client.draw_text(c, x_center - 1, y1 + y_additional - 16, 97, 193, 161, 180, "c-", 0, 'MANUAL')
                    end
                end
 
            end
 
        end
    else return
    end

end)

client.set_event_callback("paint_ui", function()
    if scripts_reloaded then
        is_active:set(db.is_active)
        is_active.mode:set(db.mode)
        is_active.force_body:set(db.force_body)
        is_active.reduce_points:set(db.reduce_points)
        is_active.hcfix:set(db.hcfix)
        is_active.dtcorrections:set(db.dtcorrections)
        is_active.fix_opposits:set(db.fix_opposits)

        draw_display:set(db.draw_display)
        draw_display.disable_overlay:set(db.disable_overlay)
        scripts_reloaded = false
    else
        db.is_active = is_active:get()
        db.mode = is_active.mode:get()
        db.force_body = is_active.force_body:get()
        db.reduce_points = is_active.reduce_points:get()
        db.hcfix = is_active.hcfix:get()
        db.dtcorrections = is_active.dtcorrections:get()
        db.fix_opposits = is_active.fix_opposits:get()

        db.draw_display = draw_display:get()
        db.disable_overlay = draw_display.disable_overlay:get()
        database.write('s_bytemode', db)
    end

    if draw_display:get() and not draw_display.disable_overlay:get() then
        computer_display()
    else return
    end
end)

client.set_event_callback("paint_ui", load_watermark)

client.set_event_callback("player_connect_full", function(c)
    if client.userid_to_entindex(c) == entity.get_local_player() then
        saved_enable = { }
    end
end)
