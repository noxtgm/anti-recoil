local weapon_table = {Horizontal = 0, Vertical = 9, FireDelay = 10}
local toggle_key   = "numlock"
local fire_key     = 1

local is_active = true

function Volatility(_range, _impact)
    local volatility = _range * (1 + _impact * math.random())
    return volatility
end

function Move_x(_horizontal_recoil)
    MoveMouseRelative(math.floor(Volatility(0.8, 1) * _horizontal_recoil), 0)
end

function Move_y(_vertical_recoil)
    MoveMouseRelative(0, math.floor(Volatility(0.8, 1) * _vertical_recoil))
end

function Fire()
    local horizontal_recoil = weapon_table["Horizontal"]
    local vertical_recoil = weapon_table["Vertical"]

    local float_x = math.abs(horizontal_recoil) - math.floor(math.abs(horizontal_recoil))
    local float_y = math.abs(vertical_recoil) - math.floor(math.abs(vertical_recoil))

    local i = 0
    local j = 0

    repeat
        if horizontal_recoil ~= 0  then
            if horizontal_recoil < 0 then
                Move_x(horizontal_recoil + float_x)
            else
                Move_x(vertical_recoil - float_x)
            end
        end

        if vertical_recoil ~= 0  then
            if vertical_recoil < 0 then
                Move_y(vertical_recoil + float_y)
            else
                Move_y(vertical_recoil - float_y)
            end
        end

        if float_x ~= 0 then
            i = i + float_x
            if i >= 1 * Volatility(0.7, 1) then
                if horizontal_recoil > 0 then
                    Move_x(1)
                else
                    Move_x(-1)
                end

                i = 0
            end
        end

        if float_y ~= 0 then
            j = j + float_y
            if j >= 1 * Volatility(0.7, 1)  then
                if vertical_recoil > 0 then
                    Move_y(1)
                else
                    Move_y(-1)
                end

                j = 0
            end
        end

        Sleep(math.floor(Volatility(0.8, 0.5) * weapon_table["FireDelay"]))
    until not IsMouseButtonPressed(fire_key)
end

function OnEvent(event, arg)
    if event == "PROFILE_ACTIVATED" then
        EnablePrimaryMouseButtonEvents(true)
    elseif event == "PROFILE_DEACTIVATED" then
        ReleaseMouseButton(fire_key)
    end

    if IsKeyLockOn(toggle_key) then
        if is_active == false then
            is_active = true
        end

        if event == "MOUSE_BUTTON_PRESSED" and arg == fire_key then
            Fire()
        end        
    else
        if is_active == true then
            is_active = false
        end
    end
end

function Initialize()
    ClearLog()

    if IsKeyLockOn(toggle_key) then
        is_active = true
    else
        is_active = false
    end
end

Initialize()
