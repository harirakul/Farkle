
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
                    arr = [arr, i];
                end
            end
        end

        function arr = unselectedValues(obj)
            arr = [];
            for i = 1:6
                if (~obj.dice(i).selected)
                    arr = [arr, obj.dice(i).value];
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
            % Deal with quadruple, quintuple, and 6-of-a-kind

            sixes = find(counts == 6);
            for i = 1:length(sixes)
                score = score + 3500;
                counts(sixes(i)) = counts(sixes(i)) - 6;
            end

            quints = find(counts == 5);
            for i = 1:length(quints)
                score = score + 2000;
                counts(quints(i)) = counts(quints(i)) - 5;
            end

            quads = find(counts == 4);
            for i = 1:length(quads)
                score = score + 1000;
                counts(quads(i)) = counts(quads(i)) - 4;
            end
            
            triples = find(counts == 3);

            %Deal with triple combos:
            while numel(counts(counts == 3)) > 0
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

        function d = getValue(obj, idx)
            d = obj.dice(idx).value
        end

        function obj = unselectAll(obj)
            for i = 1:6
                obj.dice(i).selected = false;
            end
        end
    end
end
