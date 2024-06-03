function Uocv = evaluate_Uocv(SOC, Battery)
    % Linear interpolation using current SOC
    Uocv = interp1(Battery.OCV.SOC, Battery.OCV.U, SOC);
end