%--------------------------------------------------
% Script Name: DNA_ThermoProp_AutoFormatter
% Description: This script calculates the thermodynamic properties for a given set of DNA sequences using oligoprop.
%              The script is divided into three parts:
%              Part 1: Display thermodynamic properties by Sequence.
%              Part 2: Display thermodynamic properties by Reference.
%              Part 3: Display thermodynamic properties by Properties.
% How to use: Change the sequences in the sequences array, run the script, and get the formatted output in the Command Window. 
%             Copy and paste to Excel for easier calculation.
% Author: Yi Zeng
% Date: June 10, 2024
% Reference: https://www.mathworks.com/help/bioinfo/ref/oligoprop.html
%--------------------------------------------------

function main()
    % Define the sequences
    sequences = {'TTTTTTTTT', 'AAAAAAAA', 'ACGGGGGGG', 'GATCCAAA', 'GTGTCAAA'};

    % Part 1
    thermoProps_part1 = calculateThermoProperties(sequences);

    % Display thermodynamic properties for each sequence
    displayThermoProperties(sequences, thermoProps_part1, 'Part 1 - Thermodynamic Properties arranged by: Sequence');

    % Part 2
    finalResults_part2 = organizeResultsByReference(sequences, thermoProps_part1);

    % Display results for part 2
    displayResults(finalResults_part2, 'Part 2 - Thermodynamic Properties arranged by: Reference');

    % Display separator between Part 2 and Part 3 output
    disp('-----------------------------------');

    % Part 3
    finalResults_part3 = organizeResultsByProperties(sequences);

    % Display results for part 3
    displayResults(finalResults_part3, 'Part 3 - Thermodynamic Properties arranged by: Properties(HSG)');
end

function thermoProps = calculateThermoProperties(sequences)
    thermoProps = cell(size(sequences));
    for i = 1:length(sequences)
        S = oligoprop(sequences{i});
        thermoProps{i} = S.Thermo;
    end
end

function displayThermoProperties(sequences, thermoProps, title)
    disp(title);
    for i = 1:length(sequences)
        disp(['Thermodynamic Properties of Sequence ', num2str(i), ':']);
        disp(['Sequence: ', sequences{i}]);
        colTitles = {'deltaH(kcal/mol)', 'deltaS(cal/(K)(mol))', 'deltaG(kcal/mol)'};
        disp(['             ', colTitles{1}, '        ', colTitles{2}, '        ', colTitles{3}]);
        rowTitles = {'Breslauer1986', 'SantaLucia1996', 'SantaLucia1998', 'Sugimoto1996'};
        for j = 1:size(thermoProps{i}, 1)
            disp([rowTitles{j}, ': ', num2str(thermoProps{i}(j, :))]);
        end
        disp('-----------------------------------');
    end
end

function finalResults = organizeResultsByReference(sequences, thermoProps)
    finalResults = cell(length(sequences) + 2, 1 + 1 + 12);
    % Add titles for thermodynamic properties in the desired order
    titles = {'deltaH(kcal/mol)', 'deltaS(cal/(K)(mol))', 'deltaG(kcal/mol)'};
    titles = repmat(titles, 1, 4); % Repeat each title four times

    % Define reference titles
    referenceTitles = {'Breslauer1986', 'SantaLucia1996', 'SantaLucia1998', 'Sugimoto1996'};

    % Repeat each reference title three times and arrange them in the desired order
    arrangedReferenceTitles = repelem(referenceTitles, 3);

    % Add arranged reference titles to the cell array
    finalResults{1, 1} = 'References';
    finalResults{1, 2} = '/';
    for i = 1:numel(arrangedReferenceTitles)
        finalResults{1, 2+i} = arrangedReferenceTitles{i};
    end

    % Adding titles for thermodynamic properties
    finalResults{2, 1} = 'Name';
    finalResults{2, 2} = 'Sequence';
    finalResults(2, 3:14) = titles;

    % Looping through sequences and adding corresponding data
    for i = 1:length(sequences)
        thermoProp = thermoProps{i};
        finalResults{i + 2, 1} = sprintf('sequence%d', i);
        finalResults{i + 2, 2} = sequences{i};
        for j = 1:size(thermoProp, 1)
            for k = 1:size(thermoProp, 2)
                idx = (j - 1) * size(thermoProp, 2) + k;
                finalResults{i + 2, 2 + idx} = thermoProp(j, k);
            end
        end
    end
end

function finalResults = organizeResultsByProperties(sequences)
    % Initialize a matrix to store unfolded properties
    unfoldedProps = zeros(length(sequences), 12);

    % Calculate thermodynamic properties and unfold each matrix
    for i = 1:length(sequences)
        S = oligoprop(sequences{i});
        matrix = S.Thermo;
        unfoldedRow = [];
        
        % Unfold the matrix column by column
        for col = 1:size(matrix, 2)
            unfoldedRow = [unfoldedRow, matrix(:, col)'];
        end
        
        % Store the unfolded row in the matrix
        unfoldedProps(i, :) = unfoldedRow;
    end

    % Initialize the cell array to store final results with titles
    finalResults = cell(length(sequences) + 2, 1 + 1 + 12); % 1 for row title, 1 for sequence, 12 for thermo properties

    % Add titles for "Name" and "Sequence"
    finalResults{1, 1} = 'References';
    finalResults{1, 2} = '/';
    finalResults{2, 1} = 'Name';
    finalResults{2, 2} = 'Sequence';
    finalResults(2, 3:6) = {'deltaH(kcal/mol)', 'deltaH(kcal/mol)', 'deltaH(kcal/mol)', 'deltaH(kcal/mol)'};
    finalResults(2, 7:10) = {'deltaS(cal/(K)(mol))', 'deltaS(cal/(K)(mol))', 'deltaS(cal/(K)(mol))', 'deltaS(cal/(K)(mol))'};
    finalResults(2, 11:14) = {'deltaG(kcal/mol)', 'deltaG(kcal/mol)', 'deltaG(kcal/mol)', 'deltaG(kcal/mol)'};

    % Add titles for the thermodynamic properties in the desired order
    titles = {'Breslauer1986', 'SantaLucia1996', 'SantaLucia1998', 'Sugimoto1996'};

    % Repeat each title four times
    for i = 1:3
        for j = 1:numel(titles)
            idx = (i - 1) * numel(titles) + j;
            finalResults{1, 2 + idx} = titles{j};
        end
    end

    % Stack the rows of unfoldedProps in order
    for i = 1:length(sequences)
        unfoldedRow = unfoldedProps(i, :);
        finalResults{i + 2, 1} = sprintf('sequence%d', i); % Store the row title without spaces
        finalResults{i + 2, 2} = sequences{i}; % Store the sequence
        finalResults(i + 2, 3:end) = num2cell(unfoldedRow); % Store the unfolded thermodynamic properties
    end
end

function displayResults(finalResults, title)
    disp(title);
    for i = 1:size(finalResults, 1)
        for j = 1:size(finalResults, 2)
            if ~isempty(finalResults{i, j})
                if isnumeric(finalResults{i, j})
                    fprintf('%-30f', finalResults{i, j});
                else
                    fprintf('%-30s', finalResults{i, j});
                end
            else
                fprintf('%-30s', '');
            end
        end
        fprintf('\n');
    end
end