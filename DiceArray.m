classdef DiceArray
    properties
        dice = struct();
    end
    methods
        function obj = DiceArray()
            rolls = randi(6, 1, 6);
            for i = 1:6
                dice(i).value = rolls(i);
                dice(i).selected = false;
            end
        end

        function obj = rollSelected(obj)
            rolls = randi(6, 1, 6);
            for i = 1:6
                if dice(i).selected == true
                    dice(i).value = rolls(i);
                end
            end
        end

        function obj = select(obj, idx)
            obj.dice(idx).selected = true;
        end

        function obj = deselect(obj, idx)
            obj.dice(idx).selected = false;
        end

    end
end
