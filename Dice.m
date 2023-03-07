% FIX: issue with selection not changing.
classdef Dice
    properties
        value
        selected
    end
    methods
        function obj = Dice()
            obj.value = randi(6);
            obj.selected = false;
        end

        function obj = roll(obj)
            obj.value = randi(6);
        end

        function obj = changeSelection(obj)
            if obj.selected
                obj.selected = false;
            else
                obj.selected = true
            end
        end

        function obj = setValue(value)
            obj.value = value
        end

        function d = double(obj)
            d = obj.value;
        end

    end
end