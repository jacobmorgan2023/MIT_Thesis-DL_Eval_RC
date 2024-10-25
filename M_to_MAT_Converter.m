% This script is used to convert CESMD data files, which are initially 
% converted as .m files, to .mat files which can be easily imported 
% and manipulated.

% Define the directory where your .m files are stored
sourceDir = 'C:\Users\you\Documents\Project\Input M files'; % Change this to your directory
targetDir = 'C:\Users\you\Documents\Project\Output MAT files'; % Change this to your desired output directory

% Get a list of all .m files in the directory
mFiles = dir(fullfile(sourceDir, '*.m'));

% Loop through each file
for k = 1:length(mFiles)
    oldFileName = mFiles(k).name;
    
    % Parse the old file name to extract channel number and measurement type
    % Adjusted regex to match your file naming convention more closely
    tokens = regexp(oldFileName, 'Ch(\d)_(\w)\.m$', 'tokens');
    if isempty(tokens)
        % If the file name does not match the expected pattern, try another pattern
        tokens = regexp(oldFileName, '_Ch(\d)_(\w)\.m$', 'tokens');
        if isempty(tokens)
            continue; % Skip if the file name does not match any expected pattern
        end
    end
    channelNum = tokens{1}{1};
    measurementType = tokens{1}{2}; % 'D', 'V', or 'A'
    
    % Define the new file name based on your specified naming convention
    newFileName = sprintf('LomaLinda_08Oct2016_Ch%s_%s.mat', channelNum, measurementType);
    %%%% CHANGE THIS FOR EACH EARTHQUAKE %%%%
    
    % Load the .m file
    % Since we know the variable of interest is 'yy', we directly run the .m file
    try
        run(fullfile(sourceDir, oldFileName));
    catch ME
        warning('Failed to run %s due to error: %s', oldFileName, ME.message);
        continue;
    end
    
    % Check if 'yy' exists after running the .m file
    if exist('yy', 'var')
        % Save the 'yy' variable into a new .mat file with the new naming convention
        save(fullfile(targetDir, newFileName), 'yy');
    else
        warning('%s did not define the variable ''yy''. Skipping...', oldFileName);
    end
end