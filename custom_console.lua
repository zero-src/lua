local ui_lib = (function() local function a(b,c,d,e)c=c or""d=d or 1;e=e or#b;local f=""for g=d,e do f=f..c..tostring(b[g])end;return f end;local function h(b,i)for g=1,#b do if b[g]==i then return true end end;return false end;local function j(k,...)if not k then error(a({...}),3)end end;local function l(b)local m,n=false,false;for o,k in pairs(b)do if type(o)=="number"then m=true else n=true end end;return m,n end;local p=globals.realtime()local q={}local r={}local s={}local function t(b)local u=false;for o,k in pairs(b)do if getmetatable(k)==s then u=true end end;return u end;local function v(k,w)return k~=q[w].default end;local function x(k)return#k>0 end;function s.__index(w,o)if q[w]~=nil and type(o)=="string"and o:sub(1,1)~="_"then return q[w][o]or r[o]end end;function s.__call(w,...)local y={...}if globals.realtime()==p and#y==1 and type(y[1])=="table"then local z={}local A=y[1]local B=false;local C=false;local D={}for o,k in pairs(A)do if type(o)~="number"then D[o]=k;C=true end end;if A[1]~=nil and(type(A[1])~="table"or not t(A[1]))then D[1]=A[1]B=true;if type(D[1])~="table"then D[1]={D[1]}end end;if C then table.insert(z,D)end;for g=B and 2 or 1,#A do if t(A[g])then table.insert(z,A[g])end end;for g=1,#z do local E=z[g]local k;if E[1]~=nil then k=E[1]end;for o,F in pairs(E)do if o~=1 then w:add_children(F,k,o)end end end;return w end;if#y==0 then return w:get()else local G,H=pcall(ui.set,y[1].reference,select(2,unpack(y)))j(G,string.format("Cannot set menu item values: '%s'",H))end end;function s.__tostring(w)return w.tab.." - "..w.container.." - "..w.name end;function r.new(I,J,K,L,...)local y={...}local M,N;local O;if type(I)=="function"and I~=ui.reference then for o,k in pairs(ui)do if k==I and o:sub(1,4)=="new_"then O=o:sub(5,-1)end end;M=I(J,K,L,unpack(y))N=I==ui.reference else M=I;N=true end;if O==nil then local k={pcall(ui.get,M)}if k[1]==false then O="button"else k={select(2,unpack(k))}if#k==1 then local P=type(k[1])if P=="string"then local G=pcall(ui.set,M,nil)ui.set(M,k[1])O=G and"textbox"or"combobox"elseif P=="number"then local G=pcall(ui.set,M,-9999999999999999)ui.set(M,k[1])O=G and"listbox"or"slider"elseif P=="boolean"then O="checkbox"elseif P=="table"then O="multiselect"end elseif#k==2 then if type(k[1])=="boolean"then O="hotkey"end elseif#k==4 then if type(k[1])=="number"and type(k[2])=="number"and type(k[3])=="number"and type(k[4])=="number"then O="color_picker"end end end end;local Q;if N==false and O~=nil then if O=="slider"then Q=y[3]or y[1]elseif O=="combobox"then Q=y[1][1]elseif O=="checkbox"then Q=false end end;local w={}q[w]={tab=J,container=K,name=L,reference=M,type=O,default=Q,visible=true,ui_callback=nil,callbacks={},is_gamesense_reference=N,children_values={},children_callbacks={}}if N==false and O~=nil then if O=="slider"then q[w].min=y[1]q[w].max=y[2]elseif O=="combobox"or O=="multiselect"or O=="listbox"then q[w].values=y[1]end end;return setmetatable(w,s)end;function r:set(...)local R={...}local S=q[self]local T={pcall(ui.set,S.reference,unpack(R))}j(T[1]==true,string.format("Cannot set menu item values: '%s'",T[2]))end;function r:get()local S=q[self]return ui.get(S.reference)end;function r:contains(k)local S=q[self]if S.type=="multiselect"then return h(ui.get(S.reference),k)elseif S.type=="combobox"then return ui.get(S.reference)==k else error(string.format("Invalid type %s for contains",S.type),2)end end;function r:set_visible(U)local S=q[self]ui.set_visible(S.reference,U)S.visible=U end;function r:set_default(k)j(globals.realtime()==p,"Cannot set default menu item value inside callbacks. This must be done during script load.")q[self].default=k;self:set(k)end;function r:add_children(V,W,o)local S=q[self]local X=type(W)=="function"if W==nil then W=true;if S.type=="boolean"then W=true elseif S.type=="combobox"then X=true;W=v elseif S.type=="multiselect"then X=true;W=x end end;if getmetatable(V)==s then V={V}end;for Y,F in pairs(V)do j(getmetatable(F)==s,"Cannot add a child to menu item: Child must be a menu_item object. Make sure you are not using a UI reference.")j(F.reference~=self.reference,"Cannot parent a menu item to itself.")if X then q[F].parent_visible_callback=W else q[F].parent_visible_value=W end;self[o or F.reference]=F end;r._process_callbacks(self)end;function r:add_callback(Z)local S=q[self]j(S.is_gamesense_reference==false,"Cannot create children of, parent, or add callbacks to built-in menu references.")table.insert(S.callbacks,Z)r._process_callbacks(self)end;function r:_process_callbacks()local S=q[self]if S.ui_callback==nil then local Z=function(M,_)local k=self:get()local a0=S.combo_elements;if a0~=nil and#a0>0 then local a1;for g=1,#a0 do local a2=a0[g]if#a2>0 then local a3={}for g=1,#a2 do if h(k,a2[g])then table.insert(a3,a2[g])end end;if#a3>1 then a1=a1 or k;for g=#a3,1,-1 do if h(S.value_prev,a3[g])and#a3>1 then table.remove(a3,g)end end;local a4=a3[1]for g=#a1,1,-1 do if a1[g]~=a4 and h(a2,a1[g])then table.remove(a1,g)end end elseif#a3==0 and not(a2.required==false)then a1=a1 or k;if S.value_prev~=nil then for g=1,#S.value_prev do if h(a2,S.value_prev[g])then table.insert(a1,S.value_prev[g])break end end end end end end;if a1~=nil then self:set(a1)end;S.value_prev=k;k=a1 or k end;for o,F in pairs(self)do local a5=q[F]local a6=false;if S.visible then if a5.parent_visible_callback~=nil then a6=a5.parent_visible_callback(k,self,F)elseif S.type=="multiselect"then local a7=type(a5.parent_visible_value)for g=1,#k do if a7 and h(a5.parent_visible_value,k[g])or a5.parent_visible_value==k[g]then a6=true;break end end elseif type(a5.parent_visible_value)=="table"then a6=a5.parent_visible_value[k]or h(a5.parent_visible_value,k)else a6=k==a5.parent_visible_value end end;ui.set_visible(a5.reference,a6)a5.visible=a6;if a5.ui_callback~=nil then a5.ui_callback(F)end end;for g=1,#S.callbacks do S.callbacks[g]()end end;ui.set_callback(S.reference,Z)S.ui_callback=Z end;S.ui_callback()end;local a8={}local a9={__index=function(Y,o)if a8[o]then return a8[o]end;local aa=o;if aa:sub(1,4)~="new_"then aa="new_"..aa end;if ui[aa]~=nil then local ab=ui[aa]return function(self,L,...)local y={...}local a0={}local ac=aa:sub(5,-1)local ad="Cannot create a "..ac..": "local w;if ab==ui.new_textbox and L==nil then L="\n"end;L=(self.prefix or"")..L..(self.suffix or"")j(type(L)=="string"and L~="",ad,"Cannot create a menu item with a name that is not a string, or is empty.")if ab==ui.new_slider then local ae,af,ag,ah,ai,aj,ak=unpack(y)j(type(ae)=="number",ad,"the minimum value must be a number.")j(type(af)=="number",ad,"the maximum value must be a number.")j(ae<af,ad,"the minimum value must be lower than the maximum")if type(ag)=="table"then local al=ag;ag=al.default;ah=al.show_tooltip;ai=al.unit;aj=al.scale;ak=al.tooltips end;j(type(ag)=="number"or type(ag)=="nil",ad,"the default value must be a number")if ag~=nil then j(ag>=ae and ag<=af,ad,"the default value must be between the minimum and maximum values.")end;j(type(ah)=="boolean"or type(ah)=="nil",ad,"the show_tooltip value must be a boolean")j(type(ai)=="string"or type(ai)=="nil",ad,"the unit must be a string or nil.")if ai~=nil then j(ai:len()>=0 and ai:len()<3,ad,"the unit must be 1 or 2 characters in length.")end;j(type(aj)=="number"or type(aj)=="nil",ad,"the scale must be a number or nil.")j(type(ak)=="table"or type(ak)=="nil",ad,"the tooltips must be a table or nil.")ag=ag or nil;ah=ah or true;ai=ai or nil;aj=aj or 1;ak=ak or nil;w=r.new(ui.new_slider,self.tab,self.container,L,ae,af,ag,ah,ai,aj,ak)elseif ab==ui.new_combobox or ab==ui.new_multiselect or ab==ui.new_listbox then local am={...}if#am==1 and type(am[1])=="table"then am=am[1]end;if ab==ui.new_multiselect then local an={}for g=1,#am do local I=am[g]if type(I)=="table"then table.insert(a0,I)for ao=1,#I do table.insert(an,I[ao])end else table.insert(an,I)end end;am=an end;for g=1,#am do local I=am[g]j(type(I)=="string"or type(I)=="number",ad,"menu element #",g," must be a string or number.")end;if ab==ui.new_multiselect then w=r.new(ui.new_multiselect,self.tab,self.container,L,am)end elseif ab==ui.new_hotkey then if y[1]==nil then y[1]=false end;local ap=unpack(y)j(type(ap)=="boolean",ad,"the inline parameter is not a boolean value.")elseif ab==ui.new_button then local Z=unpack(y)j(type(Z)=="function",ad,"the callback value given is not a function.")elseif ab==ui.new_color_picker then local aq,ar,as,at=unpack(y)j(type(aq)=="number",ad,"its red channel value is not a number.")j(type(ar)=="number",ad,"its green channel value is not a number.")j(type(as)=="number",ad,"its blue channel value is not a number.")j(type(at)=="number",ad,"its alpha channel value is not a number.")j(aq>=0 and aq<=255,ad,"its red channel value is not between 0-255.")j(ar>=0 and ar<=255,ad,"its green channel value is not between 0-255.")j(as>=0 and as<=255,ad,"its blue channel value is not between 0-255.")j(at>=0 and at<=255,ad,"its alpha channel value is not between 0-255.")end;if w==nil then w=r.new(ab,self.tab,self.container,L,...)end;self[q[w].reference]=w;if#a0>0 then q[w].combo_elements=a0;local au={}for g=1,#a0 do table.insert(au,a0[g][1])end;w:set(au)q[w].value_prev=au;r._process_callbacks(w)end;return w end end end}local av={RAGE={"Aimbot","Other"},AA={"Anti-aimbot angles","Fake lag","Other"},LEGIT={"Weapon type","Aimbot","Triggerbot","Other"},VISUALS={"Player ESP","Other ESP","Colored models","Effects"},MISC={"Miscellaneous","Settings","Movement"},SKINS={"Weapon skin","Knife options","Glove options"},PLAYERS={"Players","Adjustments"},CONFIG={"Lua", "Presets"},LUA={"A","B"}}for J,aw in pairs(av)do av[J]={}for g=1,#aw do av[J][aw[g]:lower()]=true end end;function a8.new(J,K)j(type(J)=="string"and J~="","Cannot create a menu item with a tab that is not a string, or is empty.")j(type(K)=="string"and K~="","Cannot create a menu item with a container that is not a string, or is empty.")J=J:upper()j(av[J]~=nil,string.format("Cannot create a menu with the tab name '%s' as it is not a valid tab.",J))j(av[J][K:lower()]~=nil,string.format("Cannot create a menu with the container name '%s' as it is not a valid name for the tab '%s'.",K,J))return setmetatable({tab=J,container=K,items={}},a9)end;function a8.reference(J,K,L)if L==nil and type(J)=="table"and getmetatable(J)==a9 then L=K;J,K=J.tab,J.container end;local ax={pcall(ui.reference,J,K,L)}j(ax[1]==true,"Cannot reference a Gamesense menu item: the menu item does not exist.")local ay={select(2,unpack(ax))}local az={}for g=1,#ay do local M=ay[g]local w=r.new(M,J,K,L)table.insert(az,w)end;return unpack(az)end;function a8:create(b)return b end;return setmetatable(a8,{__call=function(Y,...)return a8.new(...)end}) end)()
--------------------------------------------------------------------------------
-- HTTP functions
--------------------------------------------------------------------------------
--local http = require "gamesense/http"

-- Colored console logs
local log_color = { r = 230, g = 230, b = 230 }
local colored_text = { r = 180, g = 180, b = 255 }

local help_log = function(action, name, c_command)
    client.color_log(38, 255, 168, "-\0")
    client.color_log(log_color.r, log_color.g, log_color.b, " For " .. action .. "\0")
        client.color_log(colored_text.r, colored_text.g, colored_text.b, " ", name .. "\0")
            client.color_log(log_color.r, log_color.g, log_color.b, " use\0")
                client.color_log(colored_text.r, colored_text.g, colored_text.b, " ", c_command .. "\0")
    client.color_log(240, 240, 240, ' ')
end

local note_log = function(text, action)
    client.color_log(38, 255, 168, "-\0")
    client.color_log(log_color.r, log_color.g, log_color.b, " ", text .. "\0")
    client.color_log(colored_text.r, colored_text.g, colored_text.b, " " .. action .. "\0")
    client.color_log(240, 240, 240, ' ')
end

local r_note_log = function(text, action, explane)
    client.color_log(255, 38, 110, "    -\0")
    client.color_log(colored_text.r, colored_text.g, colored_text.b, " ", text .. "\0")
    client.color_log(log_color.r, log_color.g, log_color.b, " " .. action .. "\0")
    client.color_log(colored_text.r, colored_text.g, colored_text.b, " ", explane .. "\0")
    client.color_log(240, 240, 240, ' ')
end

local success_log = function(text)
    client.color_log(38, 255, 168, "-\0")
    client.color_log(log_color.r, log_color.g, log_color.b, " Initializing\0")
    client.color_log(colored_text.r, colored_text.g, colored_text.b, " ", text .. "\0")
    client.color_log(240, 240, 240, ' ')
end
 
-- To/From hex functions
function string.tohex(str)
    return (str:gsub('.', function (c) return string.format('%02X', string.byte(c)) end))
end
function string.fromhex(str)
    return (str:gsub('..', function (cc) return string.char(tonumber(cc, 16)) end))
end

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

local bool_freestand = false
local bool_monitor = false
local bool_auto_fl = false
local bool_a_delay = false
local bool_auto_dmg = false
local bool_load

local gif_decoder = require "gamesense/gif_decoder"
local scripts_reloaded = true
 
screen.x, screen.y = client.screen_size()
local menu = ui_lib.new('aa', 'other')
 
--------------------------------------------------------------------------------
-- Script functions
--------------------------------------------------------------------------------
local script = {
    bind_mode = { 'Always on', 'On hotkey', 'Toggle', 'Off hotkey' },
    variable = { "While standing", "While moving", "While in air" },

    global_dtap = nil,
    cached_freestand = nil,
    cached_fl_limit = nil,
    cached_damage = nil,
    
    active = false,
   
    time = -0.26,
    max_time = 0,
}

function s_container(ctx, x, y, w, h)
    local c = {10, 60, 40, 40, 40, 60, 20}
    for i = 0,6,1 do
        client.draw_rectangle(ctx, x+i, y+i, w-(i*2), h-(i*2), c[i+1], c[i+1], c[i+1], 255)
    end
end
--------------------------------------------------------------------------------
-- Menu functions
--------------------------------------------------------------------------------
local menu = ui_lib.new('aa', 'other')
--------------------------------------------------------------------------------
-- Menu elements
--------------------------------------------------------------------------------
local stand_dis = ui.new_multiselect('aa', 'other', 'Freestanding disablers', script.variable)
local a_delay_slider = ui.new_slider('rage', 'other', 'local speed check', 0, 500, 2, true)
local a_dmg_slider = ui.new_slider('rage', 'other', 'stand damage', 0, 126, 20, true)
local p_dmg_slider = ui.new_slider('rage', 'other', 'move damage', 0, 126, 20, true)

local ref_dmg = ui.reference('rage', 'aimbot', 'minimum damage')
local d_shot = ui.reference('rage', 'other', 'delay shot')
local doubletap, doubletap_key = ui.reference('rage', 'other', 'double tap')
local freestanding, freestanding_key = ui.reference('aa', 'anti-aimbot angles', 'freestanding')
local fakelag_lim = ui.reference('aa', 'fake lag', 'limit')
local slowmotion, slowmotion_key = ui.reference( "AA", "Other", "Slow motion" )

local dt_reserve = ui.reference('misc', 'settings', 'double tap reserve')
local ticks_to_process = ui.reference('misc', 'settings', 'sv_maxusrcmdprocessticks')

ui.set_visible(dt_reserve, false)
ui.set_visible(a_dmg_slider, false)
ui.set_visible(p_dmg_slider, false)
ui.set_visible(a_delay_slider, false)
ui.set_visible(ticks_to_process, false)
--------------------------------------------------------------------------------
-- Script functions
--------------------------------------------------------------------------------
local function loggined_user()
    local x, y = ui_dragging:get()
        s_container(ctx, x, y, 262, 162)

    ui_dragging:drag(262, 162)
end

local function auto_fl()
    set(fakelag_lim, get(ticks_to_process) - 2)
end

local function fstand_disables()
    local options = get( stand_dis )
    if table.getn( options ) >= 0 then
        set(freestanding, 'Default')
        set(freestanding_key, script.bind_mode[1])
    end
    
    local flags = entity.get_prop( entity.get_local_player( ), "m_fFlags" )
    --renderer.text(255, 255, 255, 255, 255, 255, "", 0, flags)
    local vx, vy = entity.get_prop( entity.get_local_player( ), "m_vecVelocity" )
    if vx == nil then return end
    local velocity = math.sqrt( vx * vx + vy * vy )
    
    if velocity == nil then return end

    for i = 1, #options do
        local n = options[ i ]

        if n == "While standing"
        and velocity <= 1.01 then
            set(freestanding, '-')
        end
        
        if n == "While moving"
        and velocity > 1.01 then
            set(freestanding, '-')
        end
        
        if n == "While in air"
        and flags == 256 or flags == 262 then
            set(freestanding, '-')
        end
    end
end

local function auto_delay()
    local vx, vy = get_prop(me, "m_vecVelocity")
    if vx == nil then return end
    local speed = sqrt(vx*vx + vy*vy)
    if speed == nil then return end

    if speed > get(a_delay_slider) then 
        set(d_shot, true) 
    else 
        set(d_shot, false)
    end
end

local function auto_dmg()
    local vx, vy = get_prop(me, "m_vecVelocity")
    if vx == nil then return end
    local speed = sqrt(vx*vx + vy*vy)
    if speed == nil then return end

    if speed < 2.00 then 
        set(ref_dmg, get(a_dmg_slider))
    else 
        set(ref_dmg, get(p_dmg_slider))
    end
end
--------------------------------------------------------------------------------
-- Console functions
--------------------------------------------------------------------------------
client.set_event_callback('console_input', function(e)
    local split = function(pString, pPattern)
        local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
        local fpat = "(.-)" .. pPattern
        local last_end = 1
        local s, e, cap = pString:find(fpat, 1)
    
        while s do
            if s ~= 1 or cap ~= "" then
                table.insert(Table,cap)
            end
            last_end = e+1
            s, e, cap = pString:find(fpat, last_end)
        end
    
        if last_end <= #pString then
            cap = pString:sub(last_end)
            table.insert(Table, cap)
        end
    
        return Table
    end
    
    local console_data = split(e, " ")
    local value = console_data[2]
    local value2 = console_data[3]

    local db_name = value
    local db = database.read(db_name) or {}

    if console_data[1] == "ex" and not bool_load then
        success_log("Console commands")
        bool_load = true
        return true
    end

    if console_data[1] == "!help" then
        client.color_log(240, 240, 240, ' ')

        help_log("increasing count of", "console commands", "ex")
        help_log("loading", "custom config", "load ['name w/o brackets']")
        help_log("saving", "custom config", "save ['name w/o brackets'] \n")

        help_log("changing", "sv_maxusrcmdprocessticks", "ticks")
        help_log("changing", "Double tap reserve", "delay")
        help_log("opening/closing", "Monitor", "monitor")
        help_log("using", "Automatic fake lag", "fake_lag_auto")
        help_log("changing", "Fake lag value", "fake_lag")
        help_log("disabling", "Freestanding", "fstand")
            r_note_log("standing:", "disables freestanding while", "standing")
            r_note_log("moving:", "disables freestanding while", "moving")
            r_note_log("air:", "disables freestanding in", "air")
            r_note_log("all selected:", "disables freestanding", "")
        help_log("enabling", "Automatic delay shot", "a_delay")
        help_log("enabling", "Standalone damage", "a_dmg")

        client.color_log(240, 240, 240, ' ')
        return true
    end

    if bool_load and console_data[1] == "ticks" then -- min 6, max 62
            set(ticks_to_process, value) 
        return true
    end

    if bool_load and console_data[1] == "delay" then -- min 0, max 4
            set(dt_reserve, value)
        return true
    end

    if bool_load and console_data[1] == "monitor" then 
        bool_monitor = not bool_monitor
        return true
    end

    if bool_load and console_data[1] == "fake_lag_auto" then
        bool_auto_fl = not bool_auto_fl
        if bool_auto_fl then
            note_log("Automatic fake lag:", "enabled")
        else 
            note_log("Automatic fake lag:", "disabled")
        end
        return true
    end

    if bool_load and console_data[1] == "fake_lag" then 
        set(fakelag_lim, value)
        return true
    end

    if bool_load and console_data[1] == "fstand" then 
        bool_freestand = not bool_freestand
        if bool_freestand then
            note_log("Freestanding disablers:", "loaded")
        else 
            note_log("Freestanding disablers:", "unloaded")
        end
        return true
    end

    if bool_load and console_data[1] == "a_delay" then
        bool_a_delay = not bool_a_delay
        if value == nil then 
            set(a_delay_slider, 2)
        else 
            set(a_delay_slider, value)
        end
        
        if bool_a_delay then
            note_log("Automatic delay shot:", "enabled")
        else 
            note_log("Automatic delay shot:", "disabled")
        end
        return true
    end

    if bool_load and console_data[1] == "a_dmg" then
        bool_auto_dmg = not bool_auto_dmg
        if console_data[2] == nil and console_data[3] == nil then 
            set(a_dmg_slider, 20)
            set(p_dmg_slider, 20)
        elseif console_data[3] ~= nil then
            set(a_dmg_slider, console_data[2])
            set(p_dmg_slider, console_data[3])
        else
            set(a_dmg_slider, console_data[2])
            set(p_dmg_slider, 24)
        end

        if bool_auto_dmg then
            note_log("Standalone damage:", "enabled")
        else 
            note_log("Standalone damage:", "disabled")
        end
        return true
    end

    if bool_load and console_data[1] == "save" then
        db.ticks = get(ticks_to_process)
        db.delay = get(dt_reserve)
        db.monitor = bool_monitor

        db.fake_lag_auto = bool_auto_fl
        db.fake_lag = get(fakelag_lim)
        db.fstand = bool_freestand

        db.a_delay = bool_a_delay
        db.a_dmg = bool_auto_dmg
        
        db.a_delay_limit = get(a_delay_slider)
        db.a_dmg_limit = get(a_dmg_slider)
        db.p_dmg_limit = get(p_dmg_slider)

        database.write(db_name, db)
        print(db_name .. " saved")
        return true
    end

    if bool_load and console_data[1] == "load" then
        set(ticks_to_process, db.ticks)
        set(dt_reserve, db.delay)
        bool_monitor = db.monitor

        bool_auto_fl = db.fake_lag_auto
        set(fakelag_lim, db.fake_lag)
        bool_freestand = db.fstand

        bool_a_delay = db.a_delay
        bool_auto_dmg = db.a_dmg

        set(a_delay_slider, db.a_delay_limit)
        set(a_dmg_slider, db.a_dmg_limit)
        set(p_dmg_slider, db.p_dmg_limit)

        print(db_name .. " loaded")
        return true
    end
end)

--------------------------------------------------------------------------------
-- Callbacks
--------------------------------------------------------------------------------
client.set_event_callback("paint_ui", function()
    script.cached_fl_limit = script.cached_fl_limit ~= nil and script.cached_fl_limit or get(fakelag_lim) 
    script.cached_damage = script.cached_damage ~= nil and script.cached_damage or get(ref_dmg)

    if bool_auto_fl then 
        auto_fl() 
    else
        if script.cached_fl_limit ~= nil then
            set(fakelag_lim, script.cached_fl_limit)
            script.cached_fl_limit = nil
        end
    end

    if bool_freestand then 
        fstand_disables()
        ui.set_visible(stand_dis, true)  
    else
        ui.set_visible(stand_dis, false) 
    end

    if bool_a_delay then 
        auto_delay() 
    end

    if bool_auto_dmg then     
        auto_dmg()
    else
        if script.cached_damage ~= nil then
            set(ref_dmg, script.cached_damage)
            script.cached_damage = nil
        end
    end

end)

client.set_event_callback("paint_ui", function()
    if bool_monitor then 
        loggined_user() else return
    end
end)
