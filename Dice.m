classdef Dice
    properties
        value
    end
    methods
        function dice = Dice()
            dice.value = randi([1, 6]);
        end
        function rolldice = Dice(dice)
            dice.value = randi([1, 6]);
        end
        function score = comparison(multipledice)
            number_of_dice = numel(multipledice);
            score = zeros(multipledice, multipledice);
            for (i = 1:number_of_dice)
                for (j = i+1:number_of_dice)
                    if (multipledice()

            end
        end
end