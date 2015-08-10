
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Authors : Jonas Gros and J. Samuel Arey.
% See license terms stated in file:
% LICENSE.txt
% 
% Please cite the following articles when publishing any results obtained
% by use of this software. 
% 
% Eilers, P. H. C., "Parametric time warping", Anal. Chem. 2004, vol 76, 
% p 404?411.
% 
% Gros, J.; Reddy, C. M.; Aeppli, C.; Nelson, R. K.; Carmichael, C. A.; 
% Arey J. S., "Resolving biodegradation patterns of persistent saturated 
% hydrocarbons in weathered oil samples from the Deepwater Horizon disaster", 
% Environ. Sci. Technol. 2014, vol 48, num 3, p 1628-1637.
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

% -----------------------------------------------------------------------------
% ALL PROGRAM PARAMETERS THAT SHOULD BE SET BY THE USER ARE SHOWN HERE.

% INSTRUMENT PARAMETERS

    % Set the modulation period (units of seconds)
    modulation_period = 12.5;

    % Set the detector acquisition rate (units of Hertz)
    acquisition_rate = 200; 

% MODEL CHOICE PARAMETERS

    % Parameters for the Eilers baseline 1-D code: 
    lambda = 4.5; % usually between 4 and 8.
    p = 0.001; % usually 0.02 or 0.001.
    d = 2; % Do not change it.

% INPUT/OUTPUT PARAMETERS

    % Set plot_flag to a value of 0 to suppress plots.
    % Set to a value of 1 to see "normal" level of plotting (DEFAULT).
    plot_flag = 1;

    % Set the output file path
    output_path = 'users/output/';

    % Set the input file path
    input_path = 'users/input/';

    % Name of input-output file:
        % Chromatogram file:
        Reference_chromatogram_file = 'Grane_crude_oil.csv';

    % Set Matlab console output level. Choose: 'minimal', 'normal', or 'verbose'.
    prompt_output = 'normal';

% -----------------------------------------------------------------------------
% Do not modify the lines below.

cd('..');

addpath model_code

cd('model_code')

run main_code;

cd('../users');



