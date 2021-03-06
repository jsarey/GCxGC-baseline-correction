% main_code.m script called from "main.m" by user.
% 
% *** Do not modify this file. Normally the user should not need to adjust *** 
% *** anything in this script.                                             ***
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Authors : Jonas Gros and J. Samuel Arey.
% See license terms stated in file:
% LICENSE.txt
% 
% Please cite the following articles when publishing any results obtained
% by use of this software. 
% 
% Eilers, P. H. C., "Parametric time warping", Anal. Chem. 2004, vol 76, 
% p 404-411.
% 
% Gros, J.; Reddy, C. M.; Aeppli, C.; Nelson, R. K.; Carmichael, C. A.; 
% Arey J. S., "Resolving biodegradation patterns of persistent saturated 
% hydrocarbons in weathered oil samples from the Deepwater Horizon disaster", 
% Environ. Sci. Technol. 2014, vol 48, num 3, p 1628-1637.
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%

% Display some text for the user:

disp(' ')
disp(' ')
disp('---------------------------------------------------------')
disp(' ')
disp('Please cite the following articles when publishing any results')
disp('obtained by use of this software:')
disp(' ')
disp('Eilers, P. H. C., "Parametric time warping", Anal. Chem. 2004, vol 76, p 404-411.')
disp('<a href = "http://pubs.acs.org/doi/abs/10.1021/ac034800e">(hyperlink)</a>');
disp(' ')
disp('and')
disp(' ')
disp('Gros, J.; Reddy, C. M.; Aeppli, C.; Nelson, R. K.; Carmichael, C. A.; Arey J. S.,')
disp('"Resolving biodegradation patterns of persistent saturated hydrocarbons in weathered ')
disp('oil samples from the Deepwater Horizon disaster", Environ. Sci. Technol. 2014, vol 48, ')
disp('num 3, p 1628-1637.')
disp('<a href = "http://pubs.acs.org/doi/abs/10.1021/es4042836">(hyperlink)</a>');
disp(' ')
disp(' ')
disp('---------------------------------------------------------')
disp(' ')
disp(' ')

% A few error checks:
if ~exist(['../',input_path,Reference_chromatogram_file],'file')
    error(['Chromatogram file (',['../users/input/',Reference_chromatogram_file],' ) does not exist.'])
end
if ~exist(['../',output_path],'dir')
    warning(['Indicated output directory, ''',...
        output_path,''' does not exist... Creating it.'])
    mkdir(['../',output_path])
end
% Check if allowed to write to the output_path:
[stat,CcC] = fileattrib(['../',output_path]); 
if ~CcC.UserWrite
    error(['Matlab is not allowed to write to the output_path folder...',...
        ' Try displacing the folder! (e.g. to ''Desktop'' on a Windows computer)'])
end

% To insure that the code would still work without leading to errors if a
% user attempts to run his main.m file from versions 1.0.1 or lower with
% the new code:
if ~exist('acquisition_delay','var')
    acquisition_delay = 0; % this was the bahavior up to version 1.0.1
    warning(['Note that starting on version 1.0.2, ''acquisition_delay'' ',...
             'was added to main.m. Not specified by user, set to zero.'])
end

% Import chromatograms:

[Ref,Ref_file_type] = importChromato([strrep(pwd,'model_code',''),input_path,...
    Reference_chromatogram_file],...
    'SR',acquisition_rate,'MP',modulation_period,'struct',0);

if strcmpi(prompt_output,'verbose')
    disp(['Chromatogram file assumed of the type:   ',Ref_file_type])
    disp(['( ',Reference_chromatogram_file,' )'])
    disp(' ')
end

[Corrected,bsler] = BaselineCorr(Ref,'p',p,'d',d,'lambda',lambda);

if plot_flag 
    set(figure,'name',['GCxGC chromatograms, lambda = ',num2str(lambda),', d = ', num2str(d),', p = ',num2str(p)])
    subplot(3,1,1); plotChromato(Ref,'MP',modulation_period,'SR',acquisition_rate,'acquisition_delay',acquisition_delay);
    c_a_xis = caxis; title('\bfOriginal chromatogram');
    ylabel(''); xlabel('');
    min_min = min(min(Ref));
    
    subplot(3,1,2); plotChromato(Corrected,'MP',modulation_period,'SR',acquisition_rate,'acquisition_delay',acquisition_delay);
    caxis(c_a_xis); title('\bfBaseline-corrected chromatogram');
    xlabel('');
    c_axis = caxis;
    colorbar
     
    subplot(3,1,1);
    caxis(min_min + c_axis);
    colorbar
    
    subplot(3,1,3); plotChromato(bsler,'MP',modulation_period,'SR',acquisition_rate,'acquisition_delay',acquisition_delay);
    caxis(c_a_xis); title('\bfBaseline');
    ylabel(''); 
    caxis(min_min + c_axis);
    colorbar

end

if strcmpi(prompt_output,'minimal')
    save_flag = 1;
else
    disp('Save baseline-corrected chromatogram? (1 = yes, 0 = no)')
    save_flag = input('');
end

if save_flag
    
    % Saving is slow (big matrix). Display an estimated time to completion:
    disp(' ')
    disp('Saving baseline-corrected chromatogram...')
    To_Save = Corrected(:);
    dot_indices = strfind(Reference_chromatogram_file,'.');
    Output_file_name = [strrep(pwd,'model_code',''),output_path,...
        Reference_chromatogram_file(1:dot_indices(end)-1),'_BSLN_CORR.csv'];
    if length(To_Save)>50000
        tic
        dlmwrite(Output_file_name,To_Save(1:10000),'precision','%20.20f')
        zu = toc; % seconds (to write 1e4 pixels to the file)
        Speed = zu/10000; % seconds per pixel.
        disp(['(estimated time to completion: ',...
        num2str(length(To_Save)*Speed),' seconds)'])
        dlmwrite(Output_file_name,To_Save(10001:end),'-append','precision','%20.20f')
    else
        disp('(estimated time to completion: fast.)')
        dlmwrite(Output_file_name,To_Save,'precision','%20.20f')
    end

    zu = toc;
    disp(' ')
    disp(['Done in ',num2str(zu),' seconds.'])
    disp(' ')
    
end


