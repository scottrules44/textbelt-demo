--var
local turnOffTouch = false
--require plugin
local textbelt = require("plugin.textbelt")
textbelt.init("key")
local widget = require("widget")
--layout
local scale0= ((display.actualContentWidth- display.contentWidth)*.5)
local scale0Y= ((display.actualContentHeight- display.contentHeight)*.5)*-1

local bg = display.newRect( display.contentCenterX, display.contentCenterY, display.actualContentWidth,  display.actualContentHeight )
bg:setFillColor( 0,.8, 0 )

local icon = display.newImageRect( "messaging.png", 50, 50 )
icon.x, icon.y = 30-scale0, scale0Y+ 40

local title = display.newText( "Textbelt Plugin", display.contentCenterX,  scale0Y+ 40, native.systemFont, 30 )

--number
local numberText = display.newText( "Phone Number(no dashes)", display.contentCenterX, display.contentCenterY-130, native.systemFont, 18 )
local numberTextBox = native.newTextField( display.contentCenterX, display.contentCenterY-100, display.actualContentWidth, 30 )
--message
local messageText = display.newText( "Message", display.contentCenterX, display.contentCenterY-50, native.systemFont, 18 )
local messageTextBox = native.newTextField( display.contentCenterX, display.contentCenterY-20, display.actualContentWidth, 30 )
--button
local rect = display.newRect( display.contentCenterX, display.actualContentHeight+scale0Y-30, display.actualContentWidth, 60 )
local buttonText = display.newText( "Send",rect.x, rect.y, native.systemFontBold, 20  )
buttonText:setFillColor( 0 )
local shouldSend = 0
--listener
function textLis( e )
    local tempText = title.text
    if (e.isError) then
        print( e.error )
        title.text = "Unable to send"
        timer.performWithDelay( 2000, function (  )
            title.text = tempText
            turnOffTouch = false
            rect:setFillColor( 1 )
        end )
    else
        title.text = "Message sent"
        timer.performWithDelay( 2000, function (  )
            title.text = tempText
            turnOffTouch = false
            rect:setFillColor( 1 )
        end )
    end
end
--
rect:addEventListener( "touch", function ( e )
    if (turnOffTouch == true) then
        return true
    end
    if (e.phase == "began") then
        rect:setFillColor( .5 )
    elseif (e.phase == "ended") then
        textbelt.sendMessage(numberTextBox.text, messageTextBox.text, textLis)
        rect:setFillColor( 1 )
        shouldSend = 0
    end
end )
--disable keyboard on enter
local function textFieldLis(e)
    if ( e.phase == "ended" or e.phase == "submitted" ) then
        native.setKeyboardFocus( nil )
    end
end 
numberTextBox:addEventListener( "userInput", textFieldLis )
messageTextBox:addEventListener( "userInput", textFieldLis )
