classdef main_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                   matlab.ui.Figure
        SetNameButton              matlab.ui.control.Button
        Lamp2                      matlab.ui.control.Lamp
        Lamp                       matlab.ui.control.Lamp
        Label                      matlab.ui.control.Label
        ScoreBreakdownLabel        matlab.ui.control.Label
        Image                      matlab.ui.control.Image
        five                       matlab.ui.control.Image
        six                        matlab.ui.control.Image
        four                       matlab.ui.control.Image
        three                      matlab.ui.control.Image
        two                        matlab.ui.control.Image
        one                        matlab.ui.control.Image
        Player2nameEditField       matlab.ui.control.EditField
        Player2nameEditFieldLabel  matlab.ui.control.Label
        Player1nameEditField       matlab.ui.control.EditField
        Player1nameEditFieldLabel  matlab.ui.control.Label
        RollDiceButton             matlab.ui.control.Button
        RestartButton              matlab.ui.control.Button
        BankPointsButton           matlab.ui.control.Button
        RulesButton                matlab.ui.control.Button
        UITable                    matlab.ui.control.Table
        OnlineButton               matlab.ui.control.Button
        LocalButton                matlab.ui.control.Button
    end

    
    properties (Access = public)
        game      Game % Description
        dice 
        currentMeld
        rolls
        validDice
        triples
        numSelected
        turn

        p1name
        p2name
        p1score
        p2score
    end
    
    methods (Access = public)
        function app = updateTable(app)
            app.UITable.Data = [app.p1name app.p1score; app.p2name app.p2score];
        end

        function app = updateDiceImages(app, arr)
            app.one.ImageSource = string(fullfile('images','dice', char("dice" + arr(1) + ".png")));
            app.two.ImageSource = string(fullfile('images','dice', char("dice" + arr(2) + ".png")));
            app.three.ImageSource = string(fullfile('images','dice', char("dice" + arr(3) + ".png")));
            app.four.ImageSource = string(fullfile('images','dice', char("dice" + arr(4) + ".png")));
            app.five.ImageSource = string(fullfile('images','dice', char("dice" + arr(5) + ".png")));
            app.six.ImageSource = string(fullfile('images','dice', char("dice" + arr(6) + ".png")));

            % TO DO: Update selection background highlight.
            if (app.dice.isSelected(1)); app.one.BackgroundColor = 'r'; else; app.one.BackgroundColor = 'none'; end
            if (app.dice.isSelected(2)); app.two.BackgroundColor = 'r'; else; app.two.BackgroundColor = 'none'; end
            if (app.dice.isSelected(3)); app.three.BackgroundColor = 'r'; else; app.three.BackgroundColor = 'none'; end
            if (app.dice.isSelected(4)); app.four.BackgroundColor = 'r'; else; app.four.BackgroundColor = 'none'; end
            if (app.dice.isSelected(5)); app.five.BackgroundColor = 'r'; else; app.five.BackgroundColor = 'none'; end
            if (app.dice.isSelected(6)); app.six.BackgroundColor = 'r'; else; app.six.BackgroundColor = 'none'; end
        end
        
        function app = farkle(app)
            app.Label.Text = "Farkle!";
            pause(1);
            app.changeTurn();
            app.Label.Text = "Play";
            
        end
        
        function app = changeTurn(app)
            app.turn = app.turn*-1;
            app.dice = app.dice.unselectAll();
            app.dice = app.dice.updateValues(randi(6, 1, 6));
            app.rollDice();
            app.updateDiceImages(app.dice.allValues());
            app.RollDiceButton.Enable = 'on';
            if (app.turn == 1)
                app.Lamp.Enable = 'on';
                app.Lamp2.Enable = 'off';
            else
                app.Lamp2.Enable = 'on';
                app.Lamp.Enable = 'off';
            end
            app.BankPointsButton.Enable = 'off';
        end
        
        function app = hotDice(app)
            app.Label.Text = "Hot Dice";
            app.changeTurn();
        end

        function rollDice(app)
            selected = app.dice.selectedIndices();
            %app.Label.Text = num2str(selected);
            
            for i = 1:6
               if ~ismember(i, selected)
                   app.rolls(i) = randi(6);           
                end
                pause(0.1);
            end
            app.updateDiceImages(app.rolls);
            
            % Update the DiceArray
            app.dice = app.dice.updateValues(app.rolls);

            % Generate melds.   
            [score, app.triples] = app.dice.generateMelds(app.dice.unselectedValues());
            app.validDice = [app.validDice, app.triples, 1, 5]; %Update validDice
            app.RollDiceButton.Enable = 'off';

            if score == 0
                app.farkle();
            end

            app.updateTable();
            app.BankPointsButton.Enable = 'on';
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.p1name = "p1";
            app.p2name = "p2"; 
            app.p1score = 0;
            app.p2score = 0;
            app.dice = DiceArray();
            app.updateTable();
            app.rolls = randi(6, 1, 6);
            app.updateDiceImages(app.rolls);
            app.validDice = [];
            app.numSelected = 0;
            app.turn = 1;
            app.Lamp.Enable = 'on';
            app.Lamp2.Enable = 'off';
            app.BankPointsButton.Enable = 'off';
        end

        % Button pushed function: RulesButton
        function RulesButtonPushed(app, event)
            rules
        end

        % Button pushed function: RollDiceButton
        function RollDiceButtonPushed(app, event)

            %filepathAudio = fileparts(mfilename('ENG006FinalProject'));
            %[read_audio, speed_audio] = audioread(fullfile(filepathAudio, 'Audio','rolling_dice_audio.mp3'));
            %play_Audio = audioplayer(read_audio, speed_audio);
            %play(app.play_Audio);
            
            %app.selectDice();
            %app.RollDiceButton.Enable = 'off';
            % Important: unselected dice roll after one roll of all dice

            % Rolling the unselected dice:
            app.rollDice();
            
        end

        % Image clicked function: one
        function oneImageClicked(app, event)
            if (ismember(app.dice.getValue(1), app.validDice) && ~app.dice.isSelected(1))
                app.dice = app.dice.changeSelection(1);
                if (app.dice.isSelected(1)); app.one.BackgroundColor = 'r'; else; app.one.BackgroundColor = 'none'; end
                if (ismember(app.dice.getValue(1), app.triples))
                    if numel(find(app.dice.selectedValues() == app.dice.getValue(1))) == 3
                        app.RollDiceButton.Enable = 'on';
                    end
                else
                    app.RollDiceButton.Enable = 'on';
                end
            end
        end

        % Image clicked function: two
        function twoImageClicked(app, event)
            if (ismember(app.dice.getValue(2), app.validDice) && ~app.dice.isSelected(2))
            app.dice = app.dice.changeSelection(2);
            if (app.dice.isSelected(2)); app.two.BackgroundColor = 'r'; else; app.two.BackgroundColor = 'none'; end
                if (ismember(app.dice.getValue(2), app.triples))
                    if numel(find(app.dice.selectedValues() == app.dice.getValue(2))) == 3
                        app.RollDiceButton.Enable = 'on';
                    end
                else
                    app.RollDiceButton.Enable = 'on';
                end
            end
        end

        % Image clicked function: three
        function threeImageClicked(app, event)
            if (ismember(app.dice.getValue(3), app.validDice) && ~app.dice.isSelected(3))
            app.dice = app.dice.changeSelection(3);
            if (app.dice.isSelected(3)); app.three.BackgroundColor = 'r'; else; app.three.BackgroundColor = 'none'; end
                if (ismember(app.dice.getValue(3), app.triples))
                    if numel(find(app.dice.selectedValues() == app.dice.getValue(3))) == 3
                        app.RollDiceButton.Enable = 'on';
                    end
                else
                    app.RollDiceButton.Enable = 'on';
                end
            end
        end

        % Image clicked function: four
        function fourImageClicked(app, event)
            if (ismember(app.dice.getValue(4), app.validDice) && ~app.dice.isSelected(4))
            app.dice = app.dice.changeSelection(4);
            if (app.dice.isSelected(4)); app.four.BackgroundColor = 'r'; else; app.four.BackgroundColor = 'none'; end
                if (ismember(app.dice.getValue(4), app.triples))
                    if numel(find(app.dice.selectedValues() == app.dice.getValue(4))) == 3
                        app.RollDiceButton.Enable = 'on';
                    end
                else
                    app.RollDiceButton.Enable = 'on';
                end
            end
        end

        % Image clicked function: five
        function fiveImageClicked(app, event)
            if (ismember(app.dice.getValue(5), app.validDice) && ~app.dice.isSelected(5))
            app.dice = app.dice.changeSelection(5);
            if (app.dice.isSelected(5)); app.five.BackgroundColor = 'r'; else; app.five.BackgroundColor = 'none'; end
                if (ismember(app.dice.getValue(5), app.triples))
                    if numel(find(app.dice.selectedValues() == app.dice.getValue(5))) == 3
                        app.RollDiceButton.Enable = 'on';
                    end
                else
                    app.RollDiceButton.Enable = 'on';
                end
            end
        end

        % Image clicked function: six
        function sixImageClicked(app, event)
            if (ismember(app.dice.getValue(6), app.validDice) && ~app.dice.isSelected(6))
            app.dice = app.dice.changeSelection(6);
            if (app.dice.isSelected(6)); app.six.BackgroundColor = 'r'; else; app.six.BackgroundColor = 'none'; end
                if (ismember(app.dice.getValue(6), app.triples))
                    if numel(find(app.dice.selectedValues() == app.dice.getValue(6))) == 3
                        app.RollDiceButton.Enable = 'on';
                    end
                else
                    app.RollDiceButton.Enable = 'on';
                end
            end
        end

        % Button pushed function: BankPointsButton
        function BankPointsButtonPushed(app, event)

            [score] = app.dice.generateMelds(app.dice.allValues());
            % Update score ?? ..no .score?
            if app.turn == 1
                app.p1score = app.p1score + score;
            else
                app.p2score = app.p2score + score;
            end
            app.updateTable();
            app.RollDiceButton.Enable = 'on';
            app.changeTurn();

        end

        % Button pushed function: RestartButton
        function RestartButtonPushed(app, event)
            app.game = Game();
            app.dice = DiceArray();
            app.updateTable();
        end

        % Button pushed function: SetNameButton
        function SetNameButtonPushed(app, event)
            app.p1name = string(app.Player1nameEditField.Value);
            app.p2name = string(app.Player2nameEditField.Value);
            app.updateTable();
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.9098 0.6784 0.4627];
            colormap(app.UIFigure, 'prism');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create LocalButton
            app.LocalButton = uibutton(app.UIFigure, 'push');
            app.LocalButton.BackgroundColor = [0.0627 0.702 0.5843];
            app.LocalButton.Position = [367 317 100 23];
            app.LocalButton.Text = 'Local';

            % Create OnlineButton
            app.OnlineButton = uibutton(app.UIFigure, 'push');
            app.OnlineButton.BackgroundColor = [0.0627 0.702 0.5843];
            app.OnlineButton.Position = [524 317 100 23];
            app.OnlineButton.Text = 'Online';

            % Create UITable
            app.UITable = uitable(app.UIFigure);
            app.UITable.BackgroundColor = [0.102 0.7882 0.851;0.851 0.3255 0.098];
            app.UITable.ColumnName = {'Player Name'; 'Score'};
            app.UITable.RowName = {};
            app.UITable.Position = [365 367 259 80];

            % Create RulesButton
            app.RulesButton = uibutton(app.UIFigure, 'push');
            app.RulesButton.ButtonPushedFcn = createCallbackFcn(app, @RulesButtonPushed, true);
            app.RulesButton.BackgroundColor = [0.3922 0.8314 0.0745];
            app.RulesButton.Position = [271 53 100 23];
            app.RulesButton.Text = 'Rules';

            % Create BankPointsButton
            app.BankPointsButton = uibutton(app.UIFigure, 'push');
            app.BankPointsButton.ButtonPushedFcn = createCallbackFcn(app, @BankPointsButtonPushed, true);
            app.BankPointsButton.BackgroundColor = [0.5529 0.9882 0.5922];
            app.BankPointsButton.Position = [206 93 100 23];
            app.BankPointsButton.Text = 'Bank Points';

            % Create RestartButton
            app.RestartButton = uibutton(app.UIFigure, 'push');
            app.RestartButton.ButtonPushedFcn = createCallbackFcn(app, @RestartButtonPushed, true);
            app.RestartButton.BackgroundColor = [0.5529 0.9882 0.5922];
            app.RestartButton.Position = [331 93 100 23];
            app.RestartButton.Text = 'Restart';

            % Create RollDiceButton
            app.RollDiceButton = uibutton(app.UIFigure, 'push');
            app.RollDiceButton.ButtonPushedFcn = createCallbackFcn(app, @RollDiceButtonPushed, true);
            app.RollDiceButton.BackgroundColor = [0.9294 0.4745 0.4745];
            app.RollDiceButton.FontSize = 18;
            app.RollDiceButton.Position = [241 133 159 31];
            app.RollDiceButton.Text = 'Roll Dice';

            % Create Player1nameEditFieldLabel
            app.Player1nameEditFieldLabel = uilabel(app.UIFigure);
            app.Player1nameEditFieldLabel.HorizontalAlignment = 'right';
            app.Player1nameEditFieldLabel.Position = [25 416 85 22];
            app.Player1nameEditFieldLabel.Text = 'Player 1 name:';

            % Create Player1nameEditField
            app.Player1nameEditField = uieditfield(app.UIFigure, 'text');
            app.Player1nameEditField.Position = [125 416 100 22];

            % Create Player2nameEditFieldLabel
            app.Player2nameEditFieldLabel = uilabel(app.UIFigure);
            app.Player2nameEditFieldLabel.HorizontalAlignment = 'right';
            app.Player2nameEditFieldLabel.Position = [25 382 85 22];
            app.Player2nameEditFieldLabel.Text = 'Player 2 name:';

            % Create Player2nameEditField
            app.Player2nameEditField = uieditfield(app.UIFigure, 'text');
            app.Player2nameEditField.Position = [125 382 100 22];

            % Create one
            app.one = uiimage(app.UIFigure);
            app.one.ImageClickedFcn = createCallbackFcn(app, @oneImageClicked, true);
            app.one.Position = [28 163 64 66];
            app.one.ImageSource = fullfile(pathToMLAPP, 'images', 'dice', 'dice1.png');

            % Create two
            app.two = uiimage(app.UIFigure);
            app.two.ImageClickedFcn = createCallbackFcn(app, @twoImageClicked, true);
            app.two.Position = [107 163 74 66];
            app.two.ImageSource = fullfile(pathToMLAPP, 'images', 'dice', 'dice2.png');

            % Create three
            app.three = uiimage(app.UIFigure);
            app.three.ImageClickedFcn = createCallbackFcn(app, @threeImageClicked, true);
            app.three.Position = [27 78 63 78];
            app.three.ImageSource = fullfile(pathToMLAPP, 'images', 'dice', 'dice3.png');

            % Create four
            app.four = uiimage(app.UIFigure);
            app.four.ImageClickedFcn = createCallbackFcn(app, @fourImageClicked, true);
            app.four.Position = [112 75 65 81];
            app.four.ImageSource = fullfile(pathToMLAPP, 'images', 'dice', 'dice4.png');

            % Create six
            app.six = uiimage(app.UIFigure);
            app.six.ImageClickedFcn = createCallbackFcn(app, @sixImageClicked, true);
            app.six.Position = [111 11 63 65];
            app.six.ImageSource = fullfile(pathToMLAPP, 'images', 'dice', 'dice6.png');

            % Create five
            app.five = uiimage(app.UIFigure);
            app.five.ImageClickedFcn = createCallbackFcn(app, @fiveImageClicked, true);
            app.five.Position = [25 15 60 61];
            app.five.ImageSource = fullfile(pathToMLAPP, 'images', 'dice', 'dice5.png');

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [449 15 175 241];
            app.Image.ImageSource = fullfile(pathToMLAPP, 'images', 'scoring.png');

            % Create ScoreBreakdownLabel
            app.ScoreBreakdownLabel = uilabel(app.UIFigure);
            app.ScoreBreakdownLabel.FontSize = 16;
            app.ScoreBreakdownLabel.FontWeight = 'bold';
            app.ScoreBreakdownLabel.Position = [466 263 141 22];
            app.ScoreBreakdownLabel.Text = 'Score Breakdown';

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.HorizontalAlignment = 'center';
            app.Label.FontSize = 24;
            app.Label.Position = [34 243 140 31];
            app.Label.Text = '';

            % Create Lamp
            app.Lamp = uilamp(app.UIFigure);
            app.Lamp.Position = [335 397 20 20];
            app.Lamp.Color = [0.302 0.7451 0.9333];

            % Create Lamp2
            app.Lamp2 = uilamp(app.UIFigure);
            app.Lamp2.Position = [335 367 20 20];
            app.Lamp2.Color = [0.302 0.7451 0.9333];

            % Create SetNameButton
            app.SetNameButton = uibutton(app.UIFigure, 'push');
            app.SetNameButton.ButtonPushedFcn = createCallbackFcn(app, @SetNameButtonPushed, true);
            app.SetNameButton.BackgroundColor = [1 0.4118 0.1608];
            app.SetNameButton.Position = [78 345 100 23];
            app.SetNameButton.Text = 'Set Name';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = main_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end