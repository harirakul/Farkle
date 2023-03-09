classdef Game
    properties
        p1 = struct("name", "P1", "score", 0);
        p2 = struct("name", "P2", "score", 0);
        currPlayer = "P1";
        gameOver = false;  
    end
    methods
        function obj = Game(name1, name2)
            if nargin == 2
                obj.p1 = struct("name", name1, "score", 0);
                obj.p2 = struct("name", name2, "score", 0);
                obj.currPlayer = "p1";
                obj.gameOver = false;
            end
        end

        function changeplayerturn = changeTurn(obj)
            if strcmp(currPlayer, "P1")
                obj.currPlayer = "P2";
            else
                obj.currPlayer = "P1";
            end
        end

        function gamestatus = playerStatus(obj)
            if strcmp(currPlayer, "P1")
                gamestatus = sprintf("Game status: %s's turn", obj.p1.name);
            else
                gamestatus = sprintf("Game status: %s's turn", obj.p2.name);
            end
        end
        
    end
end
