
classdef DiceArray
    properties
        dice = struct();
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
        function L = selected(obj, idx)
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
            for i = 1:6
                if (obj.dice(i).selected)
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
        function [score, combos] = generateMelds(obj)
            score = 0;
            combos = [];

            vals = obj.allValues();
            counts = [];
            for i = 1:6
                counts = [counts, numel(find(vals == i))];
            end

            initialCounts =  counts;
            combos = find(counts >= 3);

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
        end  
        
        % return value of dice selected 
        function valueselected = getValue(obj)
            
        % section out values to count score properly
        function
    end
end
