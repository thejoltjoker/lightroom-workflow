-----------------------------------------------------------------------------------------------------------------------
-- Develop adjustments

local LrDevelopController = import'LrDevelopController'
revealOSSpecificPanel = string.find(import 'LrSystemInfo'.osVersion(), 'Windows') and LrDevelopController.revealPanel or  LrDevelopController.revealPanelIfVisible

function changeAdjustmentValue(adjustment, delta)
    trace(adjustment .. ': ' .. tostring(delta))
    import 'LrApplicationView'.switchToModule('develop')

	if "PostCropVignetteAmount" == adjustment then -- see LSW-90
		setDefaultVignetteValues()
	end

    revealOSSpecificPanel(adjustment)

    local value = (LrDevelopController.getValue(adjustment) or 0) + delta

    local min, max = LrDevelopController.getRange(adjustment)
	value = math.max(value, min);
	value = math.min(value, max);

    LrDevelopController.setValue(adjustment, value)
end

function setDefaultVignetteValues()
    local amount = LrDevelopController.getValue("PostCropVignetteAmount")
    local midpoint = LrDevelopController.getValue("PostCropVignetteMidpoint")
    local roundness = LrDevelopController.getValue("PostCropVignetteRoundness")
    local feather = LrDevelopController.getValue("PostCropVignetteFeather")
    local highlights = LrDevelopController.getValue("PostCropVignetteHighlightContrast")

	if (0 == amount) and (50 == midpoint) and (0 == roundness) and (50 == feather) and (0 == highlights) then
		LrDevelopController.setValue("PostCropVignetteMidpoint", 33)
		LrDevelopController.setValue("PostCropVignetteRoundness", 0)
		LrDevelopController.setValue("PostCropVignetteFeather", 73)
		LrDevelopController.setValue("PostCropVignetteHighlightContrast", 23)
    end
end

lastTargetPhotoId = ''

function changeColorGradingHueAdjustmentValue(adjustment, delta)
 trace(adjustment .. ': ' .. tostring(delta))
	local targetPhoto = import 'LrApplication'.activeCatalog():getTargetPhoto() 
	if targetPhoto == nil then return end
	lastTargetPhotoId = targetPhoto.localIdentifier
	
    import 'LrApplicationView'.switchToModule('develop')

	revealOSSpecificPanel(adjustment)

    local value = (LrDevelopController.getValue(adjustment) or 0) + delta

    local min, max = LrDevelopController.getRange(adjustment)

	if(value > max) then
		LrDevelopController.setValue(adjustment, min + delta)
		return
	end

	if(value < min) then
		LrDevelopController.setValue(adjustment, max + delta)
		return
	end	
	
	value = math.max(value, min);
	value = math.min(value, max);

    LrDevelopController.setValue(adjustment, value)
end

function changeColorGradingAdjustmentValue(adjustment, delta)
 trace(adjustment .. ': ' .. tostring(delta))
	local targetPhoto = import 'LrApplication'.activeCatalog():getTargetPhoto() 
	if targetPhoto == nil then return end
	lastTargetPhotoId = targetPhoto.localIdentifier
	
    import 'LrApplicationView'.switchToModule('develop')

	revealOSSpecificPanel(adjustment)

    local value = (LrDevelopController.getValue(adjustment) or 0) + delta

    local min, max = LrDevelopController.getRange(adjustment)
	
	value = math.max(value, min);
	value = math.min(value, max);

    LrDevelopController.setValue(adjustment, value)
end

function changeSplitToningLegacyAdjustmentValue(adjustment, delta)

	local targetPhoto = import 'LrApplication'.activeCatalog():getTargetPhoto() 
	if targetPhoto == nil then return end

	if lastTargetPhotoId ~= targetPhoto.localIdentifier then
		setDefaultSplitToningLegacyValues()
		lastTargetPhotoId = targetPhoto.localIdentifier
	end
	changeAdjustmentValue(adjustment,delta)

end

function setDefaultSplitToningLegacyValues()
	if	LrDevelopController.getValue('ColorGradeMidtoneHue') == 0 
		and LrDevelopController.getValue('ColorGradeMidtoneSat') == 0  
		and LrDevelopController.getValue('ColorGradeMidtoneLum') == 0 
		and LrDevelopController.getValue('ColorGradeBlending') == 50 then

		LrDevelopController.setValue('ColorGradeBlending', 100)
	end
end


function changeLogarithmicAdjustmentValue(adjustment, delta)
    trace(adjustment .. ': ' .. tostring(delta))
    import 'LrApplicationView'.switchToModule('develop')

    revealOSSpecificPanel(adjustment)

    local value = LrDevelopController.getValue(adjustment) or 0
	
	value = math.exp(math.log(value) + delta)

    local min, max = LrDevelopController.getRange(adjustment)
	value = math.max(value, min);
	value = math.min(value, max);

    LrDevelopController.setValue(adjustment, value)
end

function changeTemperatureValue(adjustment, delta)
    trace(adjustment .. ': ' .. tostring(delta))
    import 'LrApplicationView'.switchToModule('develop')

	local photo = import 'LrApplication'.activeCatalog():getTargetPhoto()
	if nil == photo then return end

	revealOSSpecificPanel(adjustment)

    local value = LrDevelopController.getValue(adjustment) or 0

    local min, max = LrDevelopController.getRange(adjustment)

    if min < 0 then
        -- JPG etc. - linear [-100, 100] range
        value = value + delta
    else
        -- RAW image - logarithmic [2000, 50000] range
        local step = (math.log(max) - math.log(min)) / 400.0
        value = math.exp(math.log(value) + delta * step)
    end

	value = math.max(value, min);
	value = math.min(value, max);

    LrDevelopController.setValue(adjustment, value)
end

function setColorGradingViewOnAdjustment(colorGradingView)
	local activeColorGradingView = LrDevelopController.getActiveColorGradingView();
	if activeColorGradingView == colorGradingView then return end
	if activeColorGradingView == '3-way' and colorGradingView ~= 'global' then return end
	if activeColorGradingView == 'global' then
		LrDevelopController.setActiveColorGradingView('3-way')
	else
		LrDevelopController.setActiveColorGradingView(colorGradingView)
	end
end



-----------------------------------------------------------------------------------------------------------------------
-- Develop settings

developSettingsToPaste = {}
isCopy = false
  	
function copyDevelopSettings(copyAll)
	isCopy = true

	-- local settingsToIgnore =
	-- {
	--   CircularGradientBasedCorrections = false,
	--   ChromaticAberrationB = false,
	--   ChromaticAberrationR = false,
	--   CropAngle = false,
	--   CropBottom = false, 
	--   CropLeft = false, 
	--   CropRight = false, 
	--   CropTop = false, 
	--   EnableCircularGradientBasedCorrections = false,
	--   EnableGradientBasedCorrections = false,
	--   EnablePaintBasedCorrections = false,
	--   EnableRedEye = false,
	--   EnableRetouch = false,
	--   EnableTransform = false,
	--   EnableMaskGroupBasedCorrections = false,
	--   MaskGroupBasedCorrections = {},
	--   GradientBasedCorrections = false,
	--   LensManualDistortionAmount = false,
	--   LensProfileChromaticAberrationScale = false,
	--   LensProfileDigest = false,
	--   LensProfileDistortionScale = false,
	--   LensProfileEnable = false,
	--   LensProfileFilename = false,
	--   LensProfileName = false,
	--   LensProfileSetup = false,
	--   LensProfileVignettingScale = false,
	--   PaintBasedCorrections = false,
	--   PerspectiveAspect = false,
	--   PerspectiveHorizontal = false,
	--   PerspectiveRotate = false,
	--   PerspectiveScale = false,
	--   PerspectiveUpright = false,
	--   PerspectiveVertical = false,
	--   PerspectiveX = false,
	--   PerspectiveY = false,
	--   RedEyeInfo = false,
	--   RetouchAreas = false,
	--   RetouchInfo = false,
	--   UprightTransformCount = false,
	--   UprightTransform_0 = false,
	--   UprightTransform_1 = false,
	--   UprightTransform_2 = false,
	--   UprightTransform_3 = false,
	--   UprightTransform_4 = false,
	--   UprightTransform_5 = false,
	-- }
	
	local photo = import 'LrApplication'.activeCatalog():getTargetPhoto()
	if null == photo then return end
	
	developSettingsToPaste = {}

	if copyAll then
		local settings = photo:getDevelopSettings()
		for key, value in pairs(settings) do
			developSettingsToPaste[key] = value
		end
	else
		photo:copySettings()
	end

	showBezel(copyAll and 'All settings copied'  or 'Develop settings copied')
end

function pasteDevelopSettings(pasteAll)
	if isCopy == false then
        showBezel(pasteAll and 'Please first copy All settings' or 'Please first copy develop settings')
        return
    end
    
    local activeCatalog = import 'LrApplication'.activeCatalog()

    local photos = activeCatalog:getTargetPhotos()

    activeCatalog:withWriteAccessDo(pasteAll and 'Paste All settings' or 'Paste develop settings', function(context)
        for _, photo in ipairs(photos) do
            if photo ~= nil then 
				if pasteAll then
					photo:applyDevelopSettings(developSettingsToPaste)
				else
					photo:pasteSettings()
				end
			end
        end
    end)

    showBezel(pasteAll and 'All settings pasted' or 'Develop settings pasted')
end

-----------------------------------------------------------------------------------------------------------------------
-- Crop

function rotateCropArea(diff)
	revealOSSpecificPanel('straightenAngle')
    local angle = LrDevelopController.getValue('straightenAngle')
    LrDevelopController.setValue('straightenAngle', angle + diff)
end

-----------------------------------------------------------------------------------------------------------------------
