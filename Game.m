classdef Game
    properties
        p1 = struct("name", "P1", "score", 0);
        p2 = struct("name", "P2", "score", 0);
        gameOver    logical
    end
    methods
        function obj = Game(name1, name2)
            if nargin == 2
                obj.p1 = struct("name", name1, "score", 0);
                obj.p2 = struct("name", name2, "score", 0);
                obj.gameOver = false;
            end
        end
    end
end