classdef Dice
    properties
        value        numeric
        selected     logical
    end
    methods
        function dice = Dice()
            obj.value = randi([1, 6]);
        end

        function rolldice()
            obj.value = randi([1, 6]);
        end

        % function score = comparison(multipledice)
        %     number_of_dice = numel(multipledice);
        %     score = zeros(multipledice, multipledice);
        %     for (i = 1:number_of_dice)
        %         for (j = i+1:number_of_dice)
        %             if (multipledice()

    end
end