-- Cola no seu executor (KRNL, Synapse, Fluxus etc) e roda. 100% funcional e arrastável em PC/Mobile

local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("unicMenu") then CoreGui.unicMenu:Destroy() end

-- CORES E CONFIGS
local color_bg = Color3.fromRGB(17,18,20)
local color_border = Color3.fromRGB(32,33,38)
local color_accent = Color3.fromRGB(125,125,252)
local color_tab_sel = Color3.fromRGB(173,177,255)
local color_tab = Color3.fromRGB(125,125,252)
local color_sidebar = Color3.fromRGB(20,21,24)
local color_sidebar_sel = Color3.fromRGB(99,102,241)
local color_panel = Color3.fromRGB(19,19,22)
local color_panelborder = Color3.fromRGB(35,36,42)
local color_text = Color3.fromRGB(188,188,188)

local sizes = {
    ["Pequeno"] = Vector2.new(380,240),
    ["Médio"] = Vector2.new(500,330),
    ["Grande"] = Vector2.new(620,410)
}
local sizeNames = {"Pequeno","Médio","Grande"}
local sizeIndex = 3

-- ÍCONES SIDEBAR DARK/EMO (só 4)
local sidebarIcons = {
    {img="rbxassetid://6031075938", tip="Main"},     -- Página main 6031094678 (x)
    {img="rbxassetid://6031763426", tip="Visual"},   -- visual 
    {img="rbxassetid://6031280882", tip="Config"},   -- engrenagem
    {img="rbxassetid://6031071050", tip="Extra"},    -- extra
}
local minimizeIcon = "rbxassetid://6031094678" -- x
local minimizeIcon2 = "rbxassetid://6031763426" -- olho

local gui = Instance.new("ScreenGui")
gui.Name = "unicMenu"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = CoreGui

local function round(obj, amt)
    local c = Instance.new("UICorner", obj)
    c.CornerRadius = amt or UDim.new(0,8)
    return c
end
local function stroke(obj, color, thick)
    local s = Instance.new("UIStroke", obj)
    s.Color = color or color_border
    s.Thickness = thick or 2
    return s
end

-- ========== MENU PRINCIPAL ==========
local menu = Instance.new("Frame")
menu.Name = "MenuMain"
menu.Size = UDim2.new(0, sizes[sizeNames[sizeIndex]].X, 0, sizes[sizeNames[sizeIndex]].Y)
menu.Position = UDim2.new(0.5, -menu.Size.X.Offset/2, 0.5, -menu.Size.Y.Offset/2)
menu.BackgroundColor3 = color_bg
menu.BorderSizePixel = 0
menu.Active = true
menu.Parent = gui
round(menu)
stroke(menu)

-- ========== HEADER ==========
local header = Instance.new("Frame", menu)
header.Name = "Header"
header.Size = UDim2.new(1,0,0,32)
header.Position = UDim2.new(0,0,0,0)
header.BackgroundColor3 = color_bg
header.BorderSizePixel = 0
header.Active = true
round(header)

local headerText = Instance.new("TextLabel", header)
headerText.BackgroundTransparency = 1
headerText.Text = "unic"
headerText.Size = UDim2.new(0,120,1,0)
headerText.Position = UDim2.new(0,17,0,0)
headerText.Font = Enum.Font.GothamSemibold
headerText.TextColor3 = color_text
headerText.TextSize = 18
headerText.TextXAlignment = Enum.TextXAlignment.Left

local headerV1 = Instance.new("TextLabel", header)
headerV1.BackgroundTransparency = 1
headerV1.Text = "v1"
headerV1.Size = UDim2.new(0,32,1,0)
headerV1.Position = UDim2.new(0,100,0,1)
headerV1.Font = Enum.Font.Gotham
headerV1.TextColor3 = color_accent
headerV1.TextSize = 15
headerV1.TextXAlignment = Enum.TextXAlignment.Left

-- BOTÃO DE MINIMIZAR (esconde tudo e mostra botão dark móvel)
local btnMin = Instance.new("ImageButton", header)
btnMin.Size = UDim2.new(0,28,0,28)
btnMin.Position = UDim2.new(1,-60,0,2)
btnMin.BackgroundColor3 = color_panel
btnMin.BorderSizePixel = 0
btnMin.Image = minimizeIcon
btnMin.ImageColor3 = color_accent
round(btnMin, UDim.new(1,0))

-- BOTÃO DE REDIMENSIONAR
local btnResize = Instance.new("TextButton", header)
btnResize.Size = UDim2.new(0,28,0,28)
btnResize.Position = UDim2.new(1,-28,0,2)
btnResize.BackgroundColor3 = color_panel
btnResize.BorderSizePixel = 0
btnResize.Text = "⧉"
btnResize.Font = Enum.Font.GothamBold
btnResize.TextSize = 18
btnResize.TextColor3 = color_tab
round(btnResize, UDim.new(1,0))

-- ========== SIDEBAR ==========
local sidebar = Instance.new("Frame", menu)
sidebar.Name = "Sidebar"
sidebar.Position = UDim2.new(0,0,0,32)
sidebar.Size = UDim2.new(0, 60, 1, -32)
sidebar.BackgroundColor3 = color_sidebar
sidebar.BorderSizePixel = 0
round(sidebar)

local sidebarBtns, sidebarFrames = {}, {}
local selectedSidebar = 1

for i,dat in ipairs(sidebarIcons) do
    local icon = Instance.new("ImageButton")
    icon.Name = "Icon"..i
    icon.Size = UDim2.new(0,32,0,32)
    icon.Position = UDim2.new(0,14,0, 20 + (i-1)*48)
    icon.BackgroundColor3 = i == selectedSidebar and color_sidebar_sel or color_sidebar
    icon.BorderSizePixel = 0
    icon.Image = dat.img
    icon.ImageColor3 = color_accent
    icon.Parent = sidebar
    round(icon, UDim.new(1,0))
    sidebarBtns[i] = icon
end

-- ========== LINHA VERTICAL DIVISÓRIA ==========
local splitLine = Instance.new("Frame", menu)
splitLine.Size = UDim2.new(0, 1, 1, -32)
splitLine.Position = UDim2.new(0, 60, 0, 32)
splitLine.BackgroundColor3 = color_border
splitLine.BorderSizePixel = 0

-- ========== ABA DA SIDEBAR (PAINÉIS ÚNICOS POR ICONE) ==========
local function makeSidebarFrame(num)
    local frame = Instance.new("Frame", menu)
    frame.BackgroundTransparency = 1
    frame.Position = UDim2.new(0, 68, 0, 32)
    frame.Size = UDim2.new(1, -68, 1, -32)
    frame.Visible = (num == 1)
    frame.Name = "SidebarFrame"..num
    return frame
end
for i=1,4 do sidebarFrames[i] = makeSidebarFrame(i) end

-- ========== EXEMPLO DE CONTEÚDO DINÂMICO EM CADA ABA ==========
local function fillSidebarFrame(frame, title, color)
    frame:ClearAllChildren()
    local label = Instance.new("TextLabel", frame)
    label.Text = title
    label.Size = UDim2.new(1,0,0,32)
    label.Position = UDim2.new(0,0,0,0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamSemibold
    label.TextColor3 = color or Color3.fromRGB(188,188,188)
    label.TextSize = 22
    label.TextXAlignment = Enum.TextXAlignment.Left
end
fillSidebarFrame(sidebarFrames[1], "Main", Color3.fromRGB(188,188,188))
fillSidebarFrame(sidebarFrames[2], "Visual", Color3.fromRGB(125,125,252))
fillSidebarFrame(sidebarFrames[3], "Config", Color3.fromRGB(186,186,186))
fillSidebarFrame(sidebarFrames[4], "Extra", Color3.fromRGB(255, 50, 255))

-- ========== SIDEBAR LOGIC ==========
for i,icon in ipairs(sidebarBtns) do
    icon.MouseButton1Click:Connect(function()
        for j,btn in ipairs(sidebarBtns) do
            btn.BackgroundColor3 = color_sidebar
            if sidebarFrames[j] then sidebarFrames[j].Visible = false end
        end
        icon.BackgroundColor3 = color_sidebar_sel
        if sidebarFrames[i] then sidebarFrames[i].Visible = true end
    end)
end

-- ========== ARRÁSTAVEL unic (PC/Mobile) ==========
local UIS = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos
local function dragify(frame)
    local inputBeganConn, inputChangedConn
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = menu.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            menu.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
dragify(header)
dragify(menu)

-- ========== MINIMIZAR: ESCONDE TUDO, MOSTRA SÓ UM BOTÃO DARK ARRÁSTAVEL ==========
local restoreBtn
local restoreDragStart, restoreStartPos, restoreDragging
local function restoreDragify(btn)
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            restoreDragging = true
            restoreDragStart = input.Position
            restoreStartPos = btn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then restoreDragging = false end
            end)
        end
    end)
    btn.InputChanged:Connect(function(input)
        if restoreDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - restoreDragStart
            btn.Position = UDim2.new(restoreStartPos.X.Scale, restoreStartPos.X.Offset + delta.X, restoreStartPos.Y.Scale, restoreStartPos.Y.Offset + delta.Y)
        end
    end)
end

btnMin.MouseButton1Click:Connect(function()
    menu.Visible = false
    restoreBtn = Instance.new("ImageButton", gui)
    restoreBtn.Size = UDim2.new(0,48,0,48)
    restoreBtn.Position = UDim2.new(0,30,0,30)
    restoreBtn.BackgroundColor3 = color_bg
    restoreBtn.Image = minimizeIcon2
    restoreBtn.ImageColor3 = color_accent
    round(restoreBtn, UDim.new(1,0))
    stroke(restoreBtn)
    restoreDragify(restoreBtn)
    restoreBtn.MouseButton1Click:Connect(function()
        menu.Visible = true
        restoreBtn:Destroy()
        restoreBtn = nil
    end)
end)

-- ========== REDIMENSIONAR ==========
btnResize.MouseButton1Click:Connect(function()
    sizeIndex = sizeIndex%3 + 1
    local newSize = sizes[sizeNames[sizeIndex]]
    menu.Size = UDim2.new(0, newSize.X, 0, newSize.Y)
    -- Reposiciona para centralizar na tela
    menu.Position = UDim2.new(0.5, -newSize.X/2, 0.5, -newSize.Y/2)
end)

----------------------------------------------------------------------------------------
-- ==================== TOGGLES UNIC (3 tipos bonitos já integrados) ==================
----------------------------------------------------------------------------------------
local color_toggle_on = Color3.fromRGB(125,125,252)
local color_toggle_off = Color3.fromRGB(30,30,30)
local color_slide = Color3.fromRGB(173,177,255)
local color_box_on = Color3.fromRGB(125,125,252)
local color_box_off = Color3.fromRGB(38,38,48)
local color_name = Color3.fromRGB(188,188,188)

-- 1. Toggle Switch clássico com círculo deslizante
function criaToggleSwitch(parent, nome, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(0, 220, 0, 38)
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0, 130, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = nome
    label.Font = Enum.Font.Gotham
    label.TextColor3 = color_name
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextSize = 18

    local toggle = Instance.new("Frame", frame)
    toggle.Size = UDim2.new(0, 48, 0, 22)
    toggle.Position = UDim2.new(0, 150, 0.5, -11)
    toggle.BackgroundColor3 = color_toggle_off
    toggle.BorderSizePixel = 0
    toggle.Name = "SwitchBG"
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1,0)
    Instance.new("UIStroke", toggle).Color = color_toggle_on

    local circle = Instance.new("Frame", toggle)
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.Position = UDim2.new(0, 2, 0, 2)
    circle.BackgroundColor3 = color_toggle_on
    circle.BorderSizePixel = 0
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)
    circle.Name = "SwitchCircle"

    local ativado = false
    local function update()
        if ativado then
            toggle.BackgroundColor3 = color_toggle_on
            circle.Position = UDim2.new(1, -20, 0, 2)
            circle.BackgroundColor3 = color_slide
        else
            toggle.BackgroundColor3 = color_toggle_off
            circle.Position = UDim2.new(0, 2, 0, 2)
            circle.BackgroundColor3 = color_toggle_on
        end
    end
    update()

    toggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            ativado = not ativado
            update()
            if callback then callback(ativado) end
        end
    end)
    -- Mobile suporte
    circle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            ativado = not ativado
            update()
            if callback then callback(ativado) end
        end
    end)
    return frame
end

-- 2. Toggle Slide - animação de slide personalizado
function criaToggleSlide(parent, nome, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(0, 220, 0, 38)
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0, 130, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = nome
    label.Font = Enum.Font.Gotham
    label.TextColor3 = color_name
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextSize = 18

    local toggle = Instance.new("Frame", frame)
    toggle.Size = UDim2.new(0, 48, 0, 22)
    toggle.Position = UDim2.new(0, 150, 0.5, -11)
    toggle.BackgroundColor3 = color_toggle_off
    toggle.BorderSizePixel = 0
    toggle.Name = "SlideBG"
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1,0)
    Instance.new("UIStroke", toggle).Color = color_toggle_on

    local fill = Instance.new("Frame", toggle)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = color_slide
    fill.BorderSizePixel = 0
    fill.Name = "SlideFill"
    fill.BackgroundTransparency = 0.4
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

    local ativado = false
    local function update()
        if ativado then
            fill:TweenSize(UDim2.new(1,0,1,0), "Out", "Sine", 0.18, true)
            toggle.BackgroundColor3 = color_toggle_on
        else
            fill:TweenSize(UDim2.new(0,0,1,0), "Out", "Sine", 0.18, true)
            toggle.BackgroundColor3 = color_toggle_off
        end
    end
    update()

    toggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            ativado = not ativado
            update()
            if callback then callback(ativado) end
        end
    end)
    -- Mobile suporte
    fill.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            ativado = not ativado
            update()
            if callback then callback(ativado) end
        end
    end)

    return frame
end

-- 3. Toggle Box - caixinha customizada (roxo/transparent)
function criaToggleBox(parent, nome, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(0, 220, 0, 38)
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0, 130, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = nome
    label.Font = Enum.Font.Gotham
    label.TextColor3 = color_name
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextSize = 18

    local box = Instance.new("Frame", frame)
    box.Size = UDim2.new(0, 22, 0, 22)
    box.Position = UDim2.new(0, 150, 0.5, -11)
    box.BackgroundColor3 = color_box_off
    box.BorderSizePixel = 0
    Instance.new("UICorner", box).CornerRadius = UDim.new(0.4,0)
    Instance.new("UIStroke", box).Color = color_box_on

    local check = Instance.new("Frame", box)
    check.Size = UDim2.new(1, -8, 1, -8)
    check.Position = UDim2.new(0, 4, 0, 4)
    check.BackgroundColor3 = color_box_on
    check.BackgroundTransparency = 1
    check.BorderSizePixel = 0
    Instance.new("UICorner", check).CornerRadius = UDim.new(0.4,0)

    local ativado = false
    local function update()
        if ativado then
            box.BackgroundColor3 = color_box_on
            check.BackgroundTransparency = 0
        else
            box.BackgroundColor3 = color_box_off
            check.BackgroundTransparency = 1
        end
    end
    update()

    box.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            ativado = not ativado
            update()
            if callback then callback(ativado) end
        end
    end)
    -- Mobile suporte
    check.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            ativado = not ativado
            update()
            if callback then callback(ativado) end
        end
    end)
    return frame
end

-- ===================== EXEMPLO DE USO NA ABA MAIN =============================
-- Adicione os toggles na aba Main (sidebarFrames[1])
do
    local y = 44 -- posição vertical inicial abaixo do título
    local t1 = criaToggleSwitch(sidebarFrames[1], "Aimbot Animais", function(on) _G.AimbotAnimais = on end) t1.Position = UDim2.new(0, 20, 0, y)
    y = y + 42
    local t2 = criaToggleSlide(sidebarFrames[1], "Aimbot Players", function(on) _G.AimbotPlayers = on end) t2.Position = UDim2.new(0, 20, 0, y)
    y = y + 42
    local t3 = criaToggleBox(sidebarFrames[1], "FireRate Hack", function(on) _G.FireRateHack = on end) t3.Position = UDim2.new(0, 20, 0, y)
end

----------------------------------------------------------------------------------------

-- Agora, você pode usar _G.AimbotAnimais, _G.AimbotPlayers, _G.FireRateHack no seu script para saber se cada função está ativa!

-- FIM
