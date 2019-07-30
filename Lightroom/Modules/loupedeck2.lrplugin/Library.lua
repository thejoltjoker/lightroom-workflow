-----------------------------------------------------------------------------------------------------------------------
-- Develop adjustments

local function setDefaultVignetteValues()
	local LrDevelopController = import 'LrDevelopController'

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

function changeAdjustmentValue(adjustment, delta)
    trace(adjustment .. ': ' .. tostring(delta))
    import 'LrApplicationView'.switchToModule('develop')

	if "PostCropVignetteAmount" == adjustment then -- see LSW-90
		setDefaultVignetteValues()
	end

    local LrDevelopController = import 'LrDevelopController'
    LrDevelopController.revealPanel(adjustment)

    local value = (LrDevelopController.getValue(adjustment) or 0) + delta

    local min, max = LrDevelopController.getRange(adjustment)
	value = math.max(value, min);
	value = math.min(value, max);

    LrDevelopController.setValue(adjustment, value)
end

function changeLogarithmicAdjustmentValue(adjustment, delta)
    trace(adjustment .. ': ' .. tostring(delta))
    import 'LrApplicationView'.switchToModule('develop')

    local LrDevelopController = import 'LrDevelopController'
    LrDevelopController.revealPanel(adjustment)

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

	local LrDevelopController = import 'LrDevelopController'
    LrDevelopController.revealPanel(adjustment)

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

-----------------------------------------------------------------------------------------------------------------------
-- Develop settings

developSettingsToPaste = {}
  	
function copyDevelopSettings()
	local settingsToIgnore =
	{
	  CircularGradientBasedCorrections = false,
	  ChromaticAberrationB = false,
	  ChromaticAberrationR = false,
	  CropAngle = false,
	  CropBottom = false, 
	  CropLeft = false, 
	  CropRight = false, 
	  CropTop = false, 
	  EnableCircularGradientBasedCorrections = false,
	  EnableGradientBasedCorrections = false,
	  EnablePaintBasedCorrections = false,
	  EnableRedEye = false,
	  EnableRetouch = false,
	  EnableTransform = false,
	  GradientBasedCorrections = false,
	  LensManualDistortionAmount = false,
	  LensProfileChromaticAberrationScale = false,
	  LensProfileDigest = false,
	  LensProfileDistortionScale = false,
	  LensProfileEnable = false,
	  LensProfileFilename = false,
	  LensProfileName = false,
	  LensProfileSetup = false,
	  LensProfileVignettingScale = false,
	  PaintBasedCorrections = false,
	  PerspectiveAspect = false,
	  PerspectiveHorizontal = false,
	  PerspectiveRotate = false,
	  PerspectiveScale = false,
	  PerspectiveUpright = false,
	  PerspectiveVertical = false,
	  PerspectiveX = false,
	  PerspectiveY = false,
	  RedEyeInfo = false,
	  RetouchAreas = false,
	  RetouchInfo = false,
	  UprightTransformCount = false,
	  UprightTransform_0 = false,
	  UprightTransform_1 = false,
	  UprightTransform_2 = false,
	  UprightTransform_3 = false,
	  UprightTransform_4 = false,
	  UprightTransform_5 = false,
	}
	
	local photo = import 'LrApplication'.activeCatalog():getTargetPhoto()
	if null == photo then return end
	
	developSettingsToPaste = {}

    local settings = photo:getDevelopSettings()

  	for key, value in pairs(settings) do
      if null == settingsToIgnore[key] then
	      developSettingsToPaste[key] = value
      end
    end

	showBezel('Develop settings copied')
end

function pasteDevelopSettings(value)
    if nil == next(developSettingsToPaste) then
        showBezel('Please first copy develop settings')
        return
    end
    
    local activeCatalog = import 'LrApplication'.activeCatalog()

    local photos = activeCatalog:getTargetPhotos()

    activeCatalog:withWriteAccessDo("Paste develop settings", function(context)
        for _, photo in ipairs(photos) do
            if photo ~= nil then photo:applyDevelopSettings(developSettingsToPaste) end
        end
    end)

    showBezel('Develop settings pasted')
end

-----------------------------------------------------------------------------------------------------------------------
-- Crop

function rotateCropArea(diff)
	local LrDevelopController = import 'LrDevelopController'
    LrDevelopController.revealPanel('straightenAngle')
    local angle = LrDevelopController.getValue('straightenAngle')
    LrDevelopController.setValue('straightenAngle', angle + diff)
end

-----------------------------------------------------------------------------------------------------------------------
