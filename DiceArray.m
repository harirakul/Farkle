% TO DO
% Restrict selection, such that user can only set aside dice that are part of a meld
% Grey out or restrict Roll Dice button until User selects atleast 1 more dice per turn.
% Farkle - discard selections, 0 points, switch turn
% Bank Points - automatically get highest score, even if unselected.
% End Game when 10,000 pts reached.

% EXTRA
% Make the dice selection background frame thingy look better.


classdef DiceArray
    properties
        dice = struct();
       % selectedDice = 0;
    end
    methods
        
        function obj = DiceArray()
            rolls = randi(6, 1, 6);
            for i = 1:6
                obj.dice(i).value = rolls(i);
                obj.dice(i).selected = false;
            end
        end

        % function obj = rollSelected(obj)
        %     rolls = randi(6, 1, 6);
        %     for i = 1:6
        %         if obj.dice(i).selected == true
        %             obj.dice(i).value = rolls(i);
        %         end
        %     end
        % end

        % Select or unselect a die at the specified index accordingly.
        function obj = changeSelection(obj, idx)
            obj.dice(idx).selected = ~obj.dice(idx).selected;
        end

        % Return a logical value if the die at the input idx is selected
        function L = isSelected(obj, idx)
            L = obj.dice(idx).selected;
        end

        % Set dice values to values in valueArr
        function obj = updateValues(obj, valueArr)
            for i = 1:6
                obj.dice(i).value = valueArr(i);
            end
        end

        % Return an array of values that are selected
        function arr = selectedValues(obj)
            arr = [];
            for i = 1:6
                if (obj.dice(i).selected)
                    arr = [arr, obj.dice(i).value];
                end
            end
        end

        function arr = selectedIndices(obj)
            arr = [];
            for i = 1:6
                if (obj.dice(i).selected) 
                    %& ((obj.dice(i).value == 1) | ((obj.dice(i).value == 5)) | ((obj.dice(i).selected == obj.dice(i).generateMelds().triples))) 
                    arr = [arr, i]
                end
            end
        end

        function arr = unselectedValues(obj)
            arr = [];
            for i = 1:6
                if (~obj.dice(i).selected)
                    arr = [arr, obj.dice(i).value]
                end
            end
        end

        function arr = allValues(obj)
            arr = [];
            for i = 1:6
                arr = [arr, obj.dice(i).value];
            end
        end  

        % Generate melds.
        function [score, triples, numFives, numOnes, hasMeld] = generateMelds(obj, vals)
            score = 0;
            triples = [];

            counts = [];
            for i = 1:6
                counts = [counts, numel(find(vals == i))];
            end

            initialCounts = counts;
            triples = find(counts >= 3);

            %Deal with combos:
            while numel(counts(counts >= 3)) > 0
                idxs = find(counts >= 3); %Indexes where there are combos

                % Update combo scores
                for i = 1:length(idxs)
                    counts(idxs(i)) = counts(idxs(i)) - 3;
                    if (idxs(i) == 1)
                        score = score + 1000;
                    else 
                        score = score + idxs(i)*100;
                    end
                end
            end

            numFives = counts(5);
            score = score + 50*numFives;
            numOnes = counts(1);
            score = score + 100*numOnes;
            hasMeld = score > 0;
        end  
    end
end
